import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/di/injection.dart';

import '../support/analytics_test_harness.dart';

/// Composition + merge-order at the event level. Two entry points:
///
/// - Direct state writes (`h.orderAttribution.mergeTrackingMeta` /
///   `h.lpAttribution.pushTileMeta`) → fire a probe event → inspect payload.
///   Pins the wire-format contract of `_commonEventProperties`.
///
/// - Real click flow via `HomeTrackAnalyticManager.logTileClick` — verifies
///   HP click writes reach OrderAttribution, LP click writes reach the
///   LpAttribution deque with source-LP identity, and the click event's
///   own payload strips bare `lp_*` before spread.
void main() {
  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
    tracker = sl<HomeTrackAnalyticManager>();
  });
  tearDown(() => h.tearDown());

  // ─── composition on the wire ─────────────────────────────────────────

  group('composition (both stores merge on every `attribution: true` event)',
      () {
    test('HP unprefixed + LP lp{n}_* both land on the payload', () async {
      await h.orderAttribution.mergeTrackingMeta({
        'banner_name': 'HP banner',
        'funnel_row': 1,
      });
      await h.lpAttribution.pushTileMeta(
        meta: const {'banner_name': 'LP banner', 'slice_id': 'sl-lp'},
        landingPageName: 'LP1',
        landingPageId: '100',
      );

      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);

      expect(payload['banner_name'], 'HP banner');
      expect(payload['funnel_row'], 1);
      expect(payload['lp1_banner_name'], 'LP banner');
      expect(payload['lp1_slice_id'], 'sl-lp');
      expect(payload['lp1_name'], 'LP1');
      expect(payload['lp1_id'], '100');
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });

    test('caller props override attribution on same-key collision', () async {
      await h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP banner'});

      await h.analytics.logEvent(
        AnalyticsEvents.tileImpression,
        const <String, Object?>{'banner_name': 'component banner'},
      );

      final payload = h.singleEvent(AnalyticsEvents.tileImpression);
      expect(payload['banner_name'], 'component banner',
          reason: 'caller props are spread AFTER attribution → they win');
    });

    test('sortBar rides via OrderAttribution', () async {
      await h.orderAttribution.setSortBar('Girl');
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expect(payload[AnalyticsProperties.sortbar], 'Girl');
    });
  });

  // ─── funnel switch lifecycle ─────────────────────────────────────────

  group('funnel switch: HP preserved, LP wiped', () {
    test('setFunnel keeps trackingMeta; LpAttribution.clear drops lp{n}_',
        () async {
      await h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
      await h.lpAttribution.pushTileMeta(
        meta: const {'banner_name': 'LP1'},
        landingPageName: 'LP1',
        landingPageId: '1',
      );
      await h.lpAttribution.pushTileMeta(
        meta: const {'banner_name': 'LP2'},
        landingPageName: 'LP2',
        landingPageId: '2',
      );

      // Funnel switch signal — matches AppNavigationObserver._applyFunnel.
      await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
      await h.lpAttribution.clear();

      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);

      expect(payload['banner_name'], 'HP',
          reason: 'HP unprefixed persists across funnel switch');
      expect(payload.containsKey('lp1_banner_name'), isFalse);
      expect(payload.containsKey('lp2_banner_name'), isFalse);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });
  });

  // ─── real click flow through the tracker ─────────────────────────────

  group('HomeTrackAnalyticManager.logTileClick (integration)', () {
    test('HP click writes into OrderAttribution — subsequent event carries it',
        () async {
      // `extraData` default → fromHomePage = true.
      await tracker.logTileClick(
        trackingMetaChain: const [
          {'banner_name': 'HP tile', 'funnel_row': 2, 'slice_id': 'sl-hp'},
        ],
      );

      // Fires tile_clicked. Also verifies OrderAttribution state via a
      // follow-up event, which is what downstream screens see.
      h.clear();
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final downstream = h.singleEvent(AnalyticsEvents.productViewed);

      expect(downstream['banner_name'], 'HP tile');
      expect(downstream['funnel_row'], 2);
      expect(downstream['slice_id'], 'sl-hp');
      // OrderAttribution wrote directly — LP deque untouched by HP click.
      expect(downstream.containsKey('lp1_banner_name'), isFalse);
    });

    test('LP click writes into LpAttribution deque with source identity',
        () async {
      tracker.extraData = const ExtraData(
        fromHomePage: false,
        landingPageName: 'LP1',
        landingPageId: '100',
      );

      await tracker.logTileClick(
        trackingMetaChain: const [
          {
            'banner_name': 'LP tile',
            'funnel_row': 3,
            'slice_id': 'sl-lp',
            'property_type': 'CT',
            'funnel_tile': 'CT-5',
          },
        ],
      );

      // LP click writes to the deque — NOT OrderAttribution.trackingMeta.
      h.clear();
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final downstream = h.singleEvent(AnalyticsEvents.productViewed);

      expect(downstream['lp1_banner_name'], 'LP tile');
      expect(downstream['lp1_funnel_row'], 3);
      expect(downstream['lp1_slice_id'], 'sl-lp');
      expect(downstream['lp1_name'], 'LP1');
      expect(downstream['lp1_id'], '100');
      // HP unprefixed slot untouched (no HP click yet).
      expect(downstream.containsKey('banner_name'), isFalse);
    });

    test('lp_tile_clicked payload strips bare `lp_*` (deque emits lp1_*)',
        () async {
      tracker.extraData = const ExtraData(
        fromHomePage: false,
        landingPageName: 'LP1',
        landingPageId: '100',
      );

      // LP-variant component — ships `lp_`-prefixed keys as its own meta.
      await tracker.logTileClick(
        trackingMetaChain: const [
          {'lp_banner_name': 'LP variant tile', 'lp_funnel_row': '3'},
        ],
      );

      final click = h.singleEvent(AnalyticsEvents.lpTileClicked);
      // Bare `lp_*` MUST NOT ride the wire — deque promotes to lp1_* instead.
      expect(click.containsKey('lp_banner_name'), isFalse,
          reason: 'bare lp_* stripped from click payload');
      expect(click.containsKey('lp_funnel_row'), isFalse);
      // Deque contribution.
      expect(click['lp1_banner_name'], 'LP variant tile');
      expect(click['lp1_funnel_row'], '3');
    });

    test('sortBar arg on click writes into OrderAttribution.setSortBar',
        () async {
      await tracker.logTileClick(
        trackingMetaChain: const [
          {'banner_name': 'HP tile'},
        ],
        sortBar: 'Girl',
      );

      h.clear();
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final downstream = h.singleEvent(AnalyticsEvents.productViewed);
      expect(downstream[AnalyticsProperties.sortbar], 'Girl');
    });
  });
}
