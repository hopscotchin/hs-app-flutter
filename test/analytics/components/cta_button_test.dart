import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/home/home_component_click_handlers.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/analytics/home/journey_worker.dart';
import 'package:hs_app_flutter/features/discover/data/models/component_models.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/analytics_test_harness.dart';

/// CTA-button tap → `tile_clicked` (or `lp_tile_clicked` on an LP).
/// Chain is `root.trackingMeta → cta.trackingMeta`; deepest key wins.
///
/// The two components that ship a `ctaButton` block today (CustomTiles,
/// ProductGrid) both flow through the same `onCtaButtonTapped` handler,
/// so we exercise the handler directly rather than pinning a fixture.
void main() {
  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    h.orderAttribution.setFunnel(Funnel.discover);
    tracker = HomeTrackAnalyticManager(
      analytics: h.analytics,
      orderAttribution: h.orderAttribution,
      lpAttribution: h.lpAttribution,
      prefs: h.prefs,
      journeyWorker: JourneyWorker(h.analytics),
    );
    tracker.sortBarName = AnalyticsDefaults.sortBarAll;
  });
  tearDown(() => h.tearDown());

  test('CTA parser lifts trackingMeta off the ctaButton JSON verbatim', () {
    final cta = ComponentDataParser.parseCustomTiles(<String, dynamic>{
      'tiles': <dynamic>[],
      'ctaButton': <String, dynamic>{
        'label': 'Explore all',
        'actionUri': 'hopscotch://plp?category=cta',
        'trackingMeta': <String, dynamic>{
          'funnel_tile': 'CT_9001',
          'banner_name': 'Summer picks',
        },
      },
    }).ctaButton;

    expect(cta, isNotNull);
    expect(cta!.trackingMeta, {
      'funnel_tile': 'CT_9001',
      'banner_name': 'Summer picks',
    });
  });

  group('HP path — tile_clicked', () {
    setUp(() => tracker.extraData = const ExtraData(fromHomePage: true));

    test('emits with root ∪ cta.trackingMeta (deepest wins)', () async {
      const root = <String, dynamic>{
        'banner_name': 'Summer Sale',
        'funnel_row': 1,
        'slice_id': 'sl-root',
      };
      const cta = CtaButton(
        label: 'View all',
        actionUri: 'hopscotch://plp',
        trackingMeta: <String, dynamic>{
          // Overrides root — deepest wins.
          'banner_name': 'CTA banner',
          // Adds a key root didn't ship.
          'funnel_tile': 'CT_CTA',
        },
      );

      await tracker.onCtaButtonTapped(rootTrackingMeta: root, cta: cta);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expect(payload['banner_name'], 'CTA banner',
          reason: 'cta.trackingMeta overwrites root on collision');
      expect(payload['funnel_tile'], 'CT_CTA');
      expect(payload['funnel_row'], 1,
          reason: 'root keys survive when cta does not override them');
      expect(payload['slice_id'], 'sl-root');
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });

    test('cta trackingMeta writes into OrderAttribution → next event carries it',
        () async {
      const root = <String, dynamic>{'banner_name': 'Root'};
      const cta = CtaButton(
        trackingMeta: <String, dynamic>{
          'banner_name': 'CTA',
          'funnel_tile': 'CT_42',
        },
      );

      await tracker.onCtaButtonTapped(rootTrackingMeta: root, cta: cta);
      h.clear();

      await h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        const <String, Object?>{},
      );
      final downstream = h.singleEvent(AnalyticsEvents.productViewed);
      expect(downstream['banner_name'], 'CTA',
          reason: 'HP branch writes to OrderAttribution → PDP inherits');
      expect(downstream['funnel_tile'], 'CT_42');
    });

    test('null cta.trackingMeta → still emits with root only', () async {
      const root = <String, dynamic>{'banner_name': 'Only root'};
      const cta = CtaButton(label: 'View all');

      await tracker.onCtaButtonTapped(rootTrackingMeta: root, cta: cta);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expect(payload['banner_name'], 'Only root');
    });
  });

  group('LP path — lp_tile_clicked', () {
    test('routes to lp_tile_clicked when fromHomePage=false', () async {
      tracker.extraData = const ExtraData(
        fromHomePage: false,
        landingPageName: 'LP1',
        landingPageId: '100',
      );
      // `pushLp` reserves the LP stack slot (in production the observer
      // does this on LP didPush). Needed so `updateTopMeta` — fired inside
      // `logTileClick`'s LP branch — has a top to activate.
      h.lpAttribution.pushLp(landingPageName: 'LP1', landingPageId: '100');

      const root = <String, dynamic>{'banner_name': 'LP root'};
      const cta = CtaButton(
        trackingMeta: <String, dynamic>{'banner_name': 'LP cta'},
      );

      await tracker.onCtaButtonTapped(rootTrackingMeta: root, cta: cta);

      final payload = h.singleEvent(AnalyticsEvents.lpTileClicked);
      expect(payload['banner_name'], 'LP cta',
          reason: 'LP branch also merges deepest-wins');
      // LP-attribution updateTopMeta fired → lp1_* shipped on the click.
      expect(payload['lp1_banner_name'], 'LP cta');
      expect(payload['lp1_name'], 'LP1');
      expect(payload['lp1_id'], '100');
    });
  });
}
