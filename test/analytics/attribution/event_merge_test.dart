import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
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
    h.orderAttribution.setFunnel(Funnel.discover);
    tracker = sl<HomeTrackAnalyticManager>();
  });
  tearDown(() => h.tearDown());

  // ─── composition on the wire ─────────────────────────────────────────

  group('composition (both stores merge on every `attribution: true` event)',
      () {
    test('HP unprefixed + LP lp{n}_* both land on the payload', () async {
      h.orderAttribution.mergeTrackingMeta({
        'banner_name': 'HP banner',
        'funnel_row': 1,
      });
      h.lpAttribution.pushTileMeta(
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
      h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP banner'});

      await h.analytics.logEvent(
        AnalyticsEvents.bannerImpression,
        const <String, Object?>{'banner_name': 'component banner'},
      );

      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expect(payload['banner_name'], 'component banner',
          reason: 'caller props are spread AFTER attribution → they win');
    });

    test('sortBar rides via OrderAttribution', () async {
      h.orderAttribution.setSortBar('Girl');
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expect(payload[AnalyticsProperties.sortbar], 'Girl');
    });
  });

  // ─── funnel switch lifecycle ─────────────────────────────────────────

  group('funnel switch', () {
    test('same-funnel re-set is a no-op — trackingMeta survives', () async {
      // setUp already applied setFunnel(Discover). Add HP data.
      h.orderAttribution.mergeTrackingMeta({'banner_name': 'HP'});
      h.lpAttribution.pushTileMeta(
        meta: const {'banner_name': 'LP1'},
        landingPageName: 'LP1',
        landingPageId: '1',
      );

      // Re-declare the SAME funnel (cold-start / logHomePageViewed pattern).
      h.orderAttribution.setFunnel(Funnel.discover);
      h.lpAttribution.clear();

      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);

      expect(payload['banner_name'], 'HP',
          reason: 'HP trackingMeta must persist when funnel is unchanged');
      expect(payload.containsKey('lp1_banner_name'), isFalse);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    });

    test('cross-funnel change resets EVERYTHING except the new funnel',
        () async {
      // Simulate: user tapped an HP tile (banner_name recorded), the
      // sortbar was set to a value, then navigated to Cart.
      h.orderAttribution.replaceTrackingMeta({
        'banner_name': 'HP tile',
        'funnel_row': 2,
        'slice_id': 'sl-hp',
      });
      h.orderAttribution.setSortBar('Girl');

      // User moves off HP → funnel changes. AppNavigationObserver.
      // _applyFunnel path builds a fresh AttributionData with only the
      // new funnel — every prior field defaults out.
      h.orderAttribution.setFunnel(Funnel.cart);

      // Any downstream event inside the Cart funnel must NOT carry HP
      // identity — the user is no longer on HP; Cart activity is not
      // being driven by the HP tile they tapped earlier.
      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);

      expect(payload[AnalyticsProperties.funnel], Funnel.cart.wire);
      expect(payload.containsKey('banner_name'), isFalse,
          reason:
              'HP tile banner_name must NOT leak into non-Discover funnels');
      expect(payload.containsKey('funnel_row'), isFalse);
      expect(payload.containsKey('slice_id'), isFalse);
      expect(payload.containsKey(AnalyticsProperties.sortbar), isFalse,
          reason: 'sortbar is Discover-only; wiping on funnel change '
              'keeps it out of non-Discover events until re-seeded on '
              'return to Discover');
    });

    test('cross-funnel change back to Discover leaves attribution clean',
        () async {
      // HP → Cart → HP (user taps back to Discover tab).
      h.orderAttribution.replaceTrackingMeta({'banner_name': 'HP1'});
      h.orderAttribution.setFunnel(Funnel.cart);   // wipes HP1
      h.orderAttribution.setFunnel(Funnel.discover);   // still empty

      await h.analytics.logEvent(AnalyticsEvents.productViewed, const {});
      final payload = h.singleEvent(AnalyticsEvents.productViewed);

      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload.containsKey('banner_name'), isFalse,
          reason: 'HP data from before the Cart detour stays wiped');
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

    // ─── Reviewer-flagged regressions: T=0 frozen attribution ──────
    //
    // `logTileClick` defers dispatch until after `await flushJourney()`.
    // Without freezing, that yield lets the store mutate before the
    // click reads it — funnel-change destinations (cart/search) or a
    // rapid tap B corrupt the click event that logically owns T=0.
    // Both cases must ship the ORIGINAL tap's attribution.

    test('T0-frozen: funnel change between tap and dispatch — click keeps '
        'source funnel', () async {
      // HP tap at T=0 with Discover funnel.
      h.orderAttribution.setFunnel(Funnel.discover);
      final future = tracker.logTileClick(
        trackingMetaChain: const [
          {'banner_name': 'HP tile', 'funnel_row': 3},
        ],
      );

      // In-flight: nav landed on cart, funnel switched.
      h.orderAttribution.setFunnel(Funnel.cart);

      // Deferred dispatch runs. Live read would ship funnel=shoppingCart;
      // the frozen snapshot must keep funnel=Discover.
      await future;

      final click = h.singleEvent(AnalyticsEvents.tileClicked);
      expect(click[AnalyticsProperties.funnel], AnalyticsDefaults.discover,
          reason: 'click must carry the funnel that existed at tap time, '
              'not the destination screen\'s funnel');
    });

    test('T0-frozen: rapid HP tap A → B — click A ships A\'s tile identity',
        () async {
      // Tap A. Deferred future kicks off but is not awaited (production
      // behavior — widgets `unawaited(...)` the call).
      final aFuture = tracker.logTileClick(
        trackingMetaChain: const [
          {'banner_name': 'A tile', 'funnel_row': 1, 'slice_id': 'sl-A'},
        ],
      );

      // Tap B moments later — replaces OrderAttribution's trackingMeta
      // with B's keys entirely. Under replace semantics, A's identity is
      // gone from the live store.
      final bFuture = tracker.logTileClick(
        trackingMetaChain: const [
          {'banner_name': 'B tile', 'funnel_row': 2, 'slice_id': 'sl-B'},
        ],
      );

      await Future.wait([aFuture, bFuture]);

      final events = h.eventsNamed(AnalyticsEvents.tileClicked);
      expect(events, hasLength(2), reason: 'both taps must emit');
      expect(events[0]['banner_name'], 'A tile',
          reason: 'tap A frozen snapshot must survive tap B\'s replace');
      expect(events[0]['slice_id'], 'sl-A');
      expect(events[1]['banner_name'], 'B tile');
      expect(events[1]['slice_id'], 'sl-B');
    });
  });
}
