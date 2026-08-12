import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
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
    h.orderAttribution.setFunnel(Funnel.discover);
  });
  tearDown(() => h.tearDown());

  test('nameless PageRoute (Talker) push+pop preserves both stores',
      () async {
    // HP click writes to OrderAttribution.
    h.orderAttribution
        .mergeTrackingMeta({'banner_name': 'HP banner', 'funnel_row': 1});

    // Sim: LP push + LP tile click.
    final lpRoute = _pageRoute('landingPage');
    h.navObserver.didPush(lpRoute, null);
    h.navObserver.setLandingPageContext(name: 'LP1', id: '100');
    h.lpAttribution.pushTileMeta(
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
    h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
    h.lpAttribution.pushTileMeta(
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
    h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
    h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile'},
      landingPageName: 'LP1',
      landingPageId: '1',
    );

    h.navObserver.didPop(_pageRoute('landingPage'), _pageRoute('home'));
    await pumpEventQueue();

    _expectStoreState(h, hp: 'HP', lp: null, lpName: null);
  });

  test('HP → LP → back to HP → HP click 2: replace semantics, LP cleared',
      () async {
    // HP click 1 seeds attribution via the production replace path.
    h.orderAttribution
        .replaceTrackingMeta({'banner_name': 'HP1', 'funnel_row': 1});

    // LP push + LP click.
    h.navObserver.didPush(_pageRoute('landingPage'), null);
    h.navObserver.setLandingPageContext(name: 'LP1', id: '100');
    h.lpAttribution.pushTileMeta(
      meta: const {'banner_name': 'LP tile'},
      landingPageName: 'LP1',
      landingPageId: '100',
    );

    // Back to shell — LP cleared, HP1 persists.
    h.navObserver.didPop(_pageRoute('landingPage'), _pageRoute(null));
    await pumpEventQueue();
    _expectStoreState(h, hp: 'HP1', lp: null, lpName: null);

    // HP click 2 — REPLACES HP1's trackingMeta. Keys HP1 shipped but
    // HP2 doesn't (funnel_row) must not leak onto HP2's click. Prevents
    // the Frankenstein-attribution bug where a Hero → CustomTile flow
    // silently ships Hero's keys on the CustomTile click event.
    h.orderAttribution
        .replaceTrackingMeta({'banner_name': 'HP2', 'slice_id': 'sl-2'});

    await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
    final payload = h.captured.last.props;
    expect(payload['banner_name'], 'HP2');
    expect(payload['slice_id'], 'sl-2');
    expect(payload.containsKey('funnel_row'), isFalse,
        reason: 'HP1 funnel_row must NOT leak onto HP2 click');
  });

  test('LP resume (Talker pop back to LP) re-fires impressions for '
      'items still in _currentlyVisible', () async {
    // Real regression scenario: user on LP, opens Talker (nameless
    // PageRoute overlays LP), inspects logs, closes Talker → LP visible
    // again. Without the LP-branch reset, `_currentlyVisible` retains
    // pre-cover entries and `notifyVisible(idx)` returns early → no
    // impression re-fire on resume.
    final tracker = sl<HomeTrackAnalyticManager>();
    // CustomTiles emits ONE lp_banner_impression per component-visibility
    // (Hero is per-tile now, driven by its own VD — not useful here). This
    // test only cares that a second `notifyVisible(idx)` after LP resume
    // re-fires when it would otherwise be blocked by `_currentlyVisible`.
    tracker.pageComponents = <PageComponent>[
      const PageComponent(
        type: PageComponentType.customTiles,
        position: 0,
        data: {
          'trackingMeta': {'banner_name': 'LP tiles'},
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

  group('LIFO attribution snapshot restore', () {
    test('PLP → Search push → back to PLP restores HP click attribution',
        () async {
      // Flagship scenario. Without the snapshot stack, Search's funnel
      // push wipes the HP click keys and the PDP click on the resurfaced
      // PLP ships without HP attribution.
      final plpRoute = _pageRoute(RouteNames.plpName);
      h.navObserver.didPush(plpRoute, null);
      h.orderAttribution.replaceTrackingMeta(
          {'banner_name': 'HP1', 'funnel_row': 1, 'slice_id': 'sl-1'});

      final searchRoute = _pageRoute(RouteNames.searchName);
      h.navObserver.didPush(searchRoute, plpRoute);
      await pumpEventQueue();
      // Sanity: Search's `_applyFunnel` wiped the HP keys.
      expect(h.orderAttribution.segmentParams.containsKey('banner_name'),
          isFalse);
      expect(h.orderAttribution.segmentParams[AnalyticsProperties.funnel],
          Funnel.search.wire);

      // Back to PLP — LIFO restore reinstates the pre-Search snapshot.
      h.navObserver.didPop(searchRoute, plpRoute);
      await pumpEventQueue();

      final params = h.orderAttribution.segmentParams;
      expect(params['banner_name'], 'HP1');
      expect(params['funnel_row'], 1);
      expect(params['slice_id'], 'sl-1');
      expect(params[AnalyticsProperties.funnel], AnalyticsDefaults.discover,
          reason: 'funnel must return to Discover, not stay on Search');
    });

    test('Cart push → back to Discover shell preserves HP click', () async {
      // Common flow. `_onPopBack` fires `_applyFunnel(Discover)` on
      // back-to-shell; because the restored snapshot already has
      // funnel=Discover, `setFunnel` early-returns and the HP data
      // stays intact.
      h.orderAttribution.replaceTrackingMeta({'banner_name': 'HP1'});

      final cartRoute = _pageRoute(RouteNames.cartName);
      h.navObserver.didPush(cartRoute, null);
      await pumpEventQueue();
      expect(h.orderAttribution.segmentParams[AnalyticsProperties.funnel],
          Funnel.cart.wire);

      h.navObserver.didPop(cartRoute, _pageRoute(null));
      await pumpEventQueue();

      final params = h.orderAttribution.segmentParams;
      expect(params['banner_name'], 'HP1');
      expect(params[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });

    test('nested Cart → Search → pop → pop layers restore correctly',
        () async {
      h.orderAttribution.replaceTrackingMeta({'banner_name': 'HP1'});

      final cartRoute = _pageRoute(RouteNames.cartName);
      h.navObserver.didPush(cartRoute, null);
      await pumpEventQueue();

      final searchRoute = _pageRoute(RouteNames.searchName);
      h.navObserver.didPush(searchRoute, cartRoute);
      await pumpEventQueue();
      expect(h.orderAttribution.segmentParams[AnalyticsProperties.funnel],
          Funnel.search.wire);

      // Pop Search → back on Cart funnel (Search's snapshot restored).
      h.navObserver.didPop(searchRoute, cartRoute);
      await pumpEventQueue();
      expect(h.orderAttribution.segmentParams[AnalyticsProperties.funnel],
          Funnel.cart.wire);
      expect(h.orderAttribution.segmentParams.containsKey('banner_name'),
          isFalse,
          reason: 'Cart snapshot itself had no HP keys — funnel wipe was '
              'applied when Cart was pushed');

      // Pop Cart → back on Discover with the original HP click.
      h.navObserver.didPop(cartRoute, _pageRoute(null));
      await pumpEventQueue();
      final params = h.orderAttribution.segmentParams;
      expect(params['banner_name'], 'HP1');
      expect(params[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });

    test('tab switch drops pending snapshots — no restore on later pop',
        () async {
      // User: Discover → HP click → Cart push → taps Categories tab.
      // The tab switch clears the snapshot stack; if GoRouter then pops
      // the Cart route, the missing snapshot must NOT resurrect the
      // Discover attribution — the user's explicit tab intent wins.
      h.orderAttribution.replaceTrackingMeta({'banner_name': 'HP1'});

      final cartRoute = _pageRoute(RouteNames.cartName);
      h.navObserver.didPush(cartRoute, null);
      await pumpEventQueue();

      h.navObserver.setShellFunnel(Funnel.categories);
      await pumpEventQueue();
      expect(h.orderAttribution.segmentParams[AnalyticsProperties.funnel],
          Funnel.categories.wire);

      // Stale pop of the still-mounted Cart route.
      h.navObserver.didPop(cartRoute, _pageRoute(null));
      await pumpEventQueue();

      final params = h.orderAttribution.segmentParams;
      // Back-to-shell logic still fires — applies _currentShellFunnel
      // (Categories) since the user is now on that tab. HP click must
      // NOT be resurrected from the discarded snapshot.
      expect(params[AnalyticsProperties.funnel], Funnel.categories.wire);
      expect(params.containsKey('banner_name'), isFalse,
          reason: 'discarded snapshot must not resurrect HP keys after '
              'tab switch');
    });
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
