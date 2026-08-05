import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/analytics_test_harness.dart';

/// Observer-driven lifecycle scenarios. Verifies `_applyFunnel` runs on
/// the right routes and NOT on unrecognized fullscreen pushes.
///
/// The observer schedules `setFunnel` / `clearLpAttribution` as unawaited
/// futures — `pumpEventQueue()` drains them before the assertion runs.
void main() {
  late AnalyticsTestHarness h;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
  });
  tearDown(() => h.tearDown());

  test('nameless PageRoute (Talker) push+pop preserves both stores',
      () async {
    // HP click writes to OrderAttribution.
    await h.orderAttribution
        .mergeTrackingMeta({'banner_name': 'HP banner', 'funnel_row': 1});

    // Sim: LP push + LP tile click.
    final lpRoute = _pageRoute('landingPage');
    h.navObserver.didPush(lpRoute, null);
    h.navObserver.setLandingPageContext(name: 'LP1', id: '100');
    await h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile banner', 'funnel_row': 5},
      landingPageName: 'LP1',
      landingPageId: '100',
    );

    _expectStoreState(h, hp: 'HP banner', lp: 'LP tile banner', lpName: 'LP1');

    // Nameless fullscreen push (Talker) — must be a no-op for attribution.
    final talker = _pageRoute(null);
    h.navObserver.didPush(talker, lpRoute);
    await pumpEventQueue();
    _expectStoreState(h, hp: 'HP banner', lp: 'LP tile banner', lpName: 'LP1');

    // Talker pop → back to LP. Still no change.
    h.navObserver.didPop(talker, lpRoute);
    await pumpEventQueue();
    _expectStoreState(h, hp: 'HP banner', lp: 'LP tile banner', lpName: 'LP1');
  });

  test('LP pop → nameless shell prev clears LP + preserves HP', () async {
    await h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
    await h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile'},
      landingPageName: 'LP1',
      landingPageId: '1',
    );

    h.navObserver.didPop(_pageRoute('landingPage'), _pageRoute(null));
    await pumpEventQueue();

    _expectStoreState(h, hp: 'HP', lp: null, lpName: null);
  });

  test('LP pop → shell-branch-named prev (e.g. `home`) hits same path',
      () async {
    // Some GoRouter versions name the shell branch page. `_shellBranchRoutes`
    // treats these as "back to shell" identically to null-name.
    await h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
    await h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile'},
      landingPageName: 'LP1',
      landingPageId: '1',
    );

    h.navObserver.didPop(_pageRoute('landingPage'), _pageRoute('home'));
    await pumpEventQueue();

    _expectStoreState(h, hp: 'HP', lp: null, lpName: null);
  });

  test('HP → LP → back to HP → HP click 2: HP overrides, LP cleared',
      () async {
    // HP click 1 seeds attribution.
    await h.orderAttribution
        .mergeTrackingMeta({'banner_name': 'HP1', 'funnel_row': 1});

    // LP push + LP click.
    h.navObserver.didPush(_pageRoute('landingPage'), null);
    h.navObserver.setLandingPageContext(name: 'LP1', id: '100');
    await h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile'},
      landingPageName: 'LP1',
      landingPageId: '100',
    );

    // Back to shell — LP cleared, HP1 persists.
    h.navObserver.didPop(_pageRoute('landingPage'), _pageRoute(null));
    await pumpEventQueue();
    _expectStoreState(h, hp: 'HP1', lp: null, lpName: null);

    // HP click 2 — overrides banner_name, adds new key, preserves prior.
    await h.orderAttribution
        .mergeTrackingMeta({'banner_name': 'HP2', 'slice_id': 'sl-2'});

    await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
    final payload = h.captured.last.props;
    expect(payload['banner_name'], 'HP2'); // overridden
    expect(payload['funnel_row'], 1); // preserved from HP1
    expect(payload['slice_id'], 'sl-2'); // additive
  });

  test('LP resume (Talker pop back to LP) re-fires impressions for '
      'items still in _currentlyVisible', () async {
    // Real regression scenario: user on LP, opens Talker (nameless
    // PageRoute overlays LP), inspects logs, closes Talker → LP visible
    // again. Without the LP-branch reset, `_currentlyVisible` retains
    // pre-cover entries and `notifyVisible(idx)` returns early → no
    // impression re-fire on resume.
    final tracker = sl<HomeTrackAnalyticManager>();
    // Hero component fires exactly one lp_banner_impression per
    // notifyVisible → unambiguous counting signal.
    tracker.pageComponents = <PageComponent>[
      const PageComponent(
        type: PageComponentType.hero,
        position: 0,
        data: {
          'trackingMeta': {'banner_name': 'LP hero'},
        },
      ),
    ];

    // Initial LP entry.
    final lpRoute = _pageRoute('landingPage');
    h.navObserver.didPush(lpRoute, null);
    h.navObserver.setLandingPageContext(name: 'LP1', id: '100');
    tracker.notifyVisible(0);
    await tracker.flushJourney();

    final firstFire =
        h.eventsNamed(AnalyticsEvents.lpBannerImpression).length;
    expect(firstFire, 1, reason: 'sanity: initial visibility fires once');

    // Talker overlays LP. Nameless push is a no-op for the observer.
    final talker = _pageRoute(null);
    h.navObserver.didPush(talker, lpRoute);

    // Talker pop → observer._onPopBack('landingPage') → LP branch of
    // _onActive → resetVisibilityState clears _currentlyVisible so the
    // next notifyVisible(0) succeeds instead of short-circuiting.
    h.navObserver.didPop(talker, lpRoute);
    tracker.notifyVisible(0);
    await tracker.flushJourney();

    final secondFire =
        h.eventsNamed(AnalyticsEvents.lpBannerImpression).length;
    expect(secondFire, greaterThan(firstFire),
        reason: 'LP resume must clear _currentlyVisible so notifyVisible '
            're-fires the impression (regression: impressions dead on '
            'LP resurface after nameless-PageRoute overlay pops)');
  });
}

Route<Object?> _pageRoute(String? name) => MaterialPageRoute<Object?>(
      settings: RouteSettings(name: name),
      builder: (_) => const SizedBox(),
    );

/// Fire a benign event, then inspect the two-store contribution on wire.
/// [hp] / [lp] / [lpName] are the expected values for `banner_name`,
/// `lp1_banner_name`, `lp1_name` — `null` means the key must be absent.
void _expectStoreState(
  AnalyticsTestHarness h, {
  required String? hp,
  required String? lp,
  required String? lpName,
}) {
  h.clear();
  h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
  final payload = h.singleEvent(AnalyticsEvents.productViewed);

  if (hp == null) {
    expect(payload.containsKey('banner_name'), isFalse,
        reason: 'HP banner_name must be absent');
  } else {
    expect(payload['banner_name'], hp);
  }

  if (lp == null) {
    expect(payload.containsKey('lp1_banner_name'), isFalse,
        reason: 'LP deque must be empty');
  } else {
    expect(payload['lp1_banner_name'], lp);
  }

  if (lpName == null) {
    expect(payload.containsKey('lp1_name'), isFalse);
  } else {
    expect(payload['lp1_name'], lpName);
  }

  // Funnel identity is always Discover in this suite.
  expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
}
