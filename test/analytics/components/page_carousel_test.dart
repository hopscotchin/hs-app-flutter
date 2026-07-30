import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_component_click_handlers.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/features/discover/data/models/component_models.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';
import '../support/fixture_loader.dart';

/// PageCarousel — flat `tiles` list. Chain per tile: root.trackingMeta +
/// tile.trackingMeta (+ product.trackingMeta if the leaf tile is a Map with
/// a `product` child). Looked up by `type == 'PageCarousel'` — no position
/// hardcoded.
void main() {
  final fx = HomeFixture.load();
  final skipIfMissing = fx.firstOfType(PageComponentType.pageCarousel) == null
      ? 'no PageCarousel component in current fixture'
      : null;

  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;
  late PageComponent pc;
  late int pcIndex;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    tracker = HomeTrackAnalyticManager(
      analytics: h.analytics,
      orderAttribution: h.orderAttribution,
      lpAttribution: h.lpAttribution,
    );
    tracker.extraData = const ExtraData(fromHomePage: true);
    tracker.sortBarName = AnalyticsDefaults.sortBarAll;
    tracker.pageComponents = fx.components;

    // Pick a random PageCarousel per test — different runs exercise
    // different backend instances of the same component type. Logs the
    // pick on failure so any regression is reproducible.
    pcIndex = fx.randomIndexOfType(PageComponentType.pageCarousel);
    pc = fx.components[pcIndex];
    printOnFailure('picked PageCarousel at index=$pcIndex, position=${pc.position}');
    expectNoLpPrefixedTrackingMetaKeys(fx.rootTrackingMetaAt(pcIndex));

    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
    await h.orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);
  });
  tearDown(() => h.tearDown());

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + full root trackingMeta (no nulls)', () async {
      await tracker.notifyVisible(pcIndex);

      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.type], PageComponentType.pageCarousel);

      final root = fx.rootTrackingMetaAt(pcIndex);
      for (final entry in root.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'root.${entry.key} lost');
      }
    }, skip: skipIfMissing);

    test('required keys are all present, non-null, non-empty (home context)',
        () async {
      await tracker.notifyVisible(pcIndex);
      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectRequiredNonEmpty(payload, requiredKeysBannerImpressionHome);
    }, skip: skipIfMissing);
  });

  // ─── tile_impression ────────────────────────────────────────────────

  group('tile_impression', () {
    test('fires one tile_impression per tile (no null fields)', () async {
      await tracker.notifyVisible(pcIndex);

      final tiles = pc.data!['tiles'] as List;
      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      expect(events, hasLength(tiles.length));

      // NOTE: PageCarousel's tile trackingMeta ships its own `position` key
      // (1, 2, 3, ...) which OVERRIDES the client-seeded component.position
      // via the verbatim merge. So on the wire, tile_impression.position is
      // the TILE's index within the carousel — NOT the component's slot on
      // the page. Backend should rename the key (e.g. `tile_position`) if the
      // component's slot needs to survive.
      for (var i = 0; i < events.length; i++) {
        expectNoNullFields(events[i]);
        expect(events[i][AnalyticsProperties.type], PageComponentType.pageCarousel);
        final tileMeta =
            (tiles[i] as Map<String, dynamic>)['trackingMeta'] as Map<String, dynamic>;
        expect(events[i][AnalyticsProperties.position], tileMeta['position'],
            reason: 'tile[$i] position = tile trackingMeta.position (backend wins)');
      }
    }, skip: skipIfMissing);

    test('each tile_impression carries root + tile trackingMeta verbatim', () async {
      await tracker.notifyVisible(pcIndex);

      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      final tiles = pc.data!['tiles'] as List;
      final root = fx.rootTrackingMetaAt(pcIndex);

      // Attribution-owned keys land on top of tile trackingMeta via the
      // logEvent(attribution:true) merge — skip them in pass-through.
      const attributionOwned = {
        AnalyticsProperties.funnel,
        AnalyticsProperties.sortbar,
      };

      for (var i = 0; i < tiles.length; i++) {
        final tileMeta =
            (tiles[i] as Map<String, dynamic>)['trackingMeta'] as Map<String, dynamic>;
        final payload = events[i];
        for (final entry in root.entries) {
          if (tileMeta.containsKey(entry.key)) continue;
          if (attributionOwned.contains(entry.key)) continue;
          expect(payload[entry.key], entry.value,
              reason: 'tile[$i] lost root.${entry.key}');
        }
        for (final entry in tileMeta.entries) {
          if (attributionOwned.contains(entry.key)) continue;
          expect(payload[entry.key], entry.value,
              reason: 'tile[$i] lost tile.${entry.key}');
        }
      }
    }, skip: skipIfMissing);

    test('required keys on every tile_impression (home context)', () async {
      await tracker.notifyVisible(pcIndex);
      for (final e in h.eventsNamed(AnalyticsEvents.tileImpression)) {
        expectRequiredNonEmpty(e, requiredKeysTileImpressionHome);
      }
    }, skip: skipIfMissing);

    test('tile_detail_id + slice_id are unique per tile', () async {
      await tracker.notifyVisible(pcIndex);
      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      expect(events.map((e) => e['tile_detail_id']).toSet(),
          hasLength(events.length));
      expect(events.map((e) => e['slice_id']).toSet(),
          hasLength(events.length));
    }, skip: skipIfMissing);
  });

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked (via onPageCarouselTileTapped)', () {
    test('fires with merged root + tile chain (no null fields)', () async {
      final data = ComponentDataParser.parsePageCarousel(pc.data!);
      await tracker.onPageCarouselTileTapped(data, data.tiles.first);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);

      // Root-level backend keys must land on the click event.
      final root = fx.rootTrackingMetaAt(pcIndex);
      const attributionOwned = {
        AnalyticsProperties.funnel,
        AnalyticsProperties.sortbar,
      };
      for (final entry in root.entries) {
        if (attributionOwned.contains(entry.key)) continue;
        if (entry.value == null) continue; // covered by expectNoNullFields
        expect(payload[entry.key], entry.value,
            reason: 'click lost root.${entry.key}');
      }
    }, skip: skipIfMissing);

    test('attribution carries forward to next-screen event', () async {
      final data = ComponentDataParser.parsePageCarousel(pc.data!);
      await tracker.onPageCarouselTileTapped(data, data.tiles.first);
      h.clear();

      await h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        <String, Object?>{AnalyticsProperties.productId: 999},
        attribution: true,
      );

      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      // Every non-null tile trackingMeta key must reappear on the PDP event.
      final tileMeta = (pc.data!['tiles'] as List).first
          ['trackingMeta'] as Map<String, dynamic>;
      const attributionOwned = {
        AnalyticsProperties.funnel,
        AnalyticsProperties.sortbar,
      };
      for (final entry in tileMeta.entries) {
        if (attributionOwned.contains(entry.key)) continue;
        if (entry.value == null) continue;
        expect(payload[entry.key], entry.value,
            reason: 'attribution.${entry.key} lost home→PDP');
      }
    }, skip: skipIfMissing);
  });

  // ─── carousel_scrolled (PageCarousel only) ─────────────────────────

  group('carousel_scrolled', () {
    Map<String, dynamic> scrollMetaFor(int targetTile) => {
          ...fx.rootTrackingMetaAt(pcIndex),
          AnalyticsProperties.scrolledTiles: targetTile.toString(),
        };

    test('buffered — nothing fires until flushCarouselScrolls', () async {
      tracker.logCarouselScrolled(Object(), scrollMetaFor(2));
      expect(h.hasEvent(AnalyticsEvents.carouselScrolled), isFalse);
    }, skip: skipIfMissing);

    test('flush emits ONE event per distinct carousel key', () async {
      tracker.logCarouselScrolled(Object(), scrollMetaFor(2));
      tracker.logCarouselScrolled(Object(), scrollMetaFor(3));
      await tracker.flushCarouselScrolls();
      expect(h.eventsNamed(AnalyticsEvents.carouselScrolled), hasLength(2));
    }, skip: skipIfMissing);

    test('last-write-wins per carousel key', () async {
      final k = Object();
      tracker.logCarouselScrolled(k, scrollMetaFor(1));
      tracker.logCarouselScrolled(k, scrollMetaFor(6));
      await tracker.flushCarouselScrolls();
      final payload = h.singleEvent(AnalyticsEvents.carouselScrolled);
      expect(payload[AnalyticsProperties.scrolledTiles], '6');
    }, skip: skipIfMissing);

    test('flushed payload carries client + root trackingMeta + scrolled_tiles (no nulls)',
        () async {
      tracker.logCarouselScrolled(Object(), scrollMetaFor(4));
      await tracker.flushCarouselScrolls();

      final payload = h.singleEvent(AnalyticsEvents.carouselScrolled);
      expectTimeBuckets(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
      final root = fx.rootTrackingMetaAt(pcIndex);
      for (final entry in root.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'carousel_scrolled dropped root.${entry.key}');
      }
      expect(payload[AnalyticsProperties.scrolledTiles], '4');
    }, skip: skipIfMissing);

    test('flush is idempotent (second flush emits nothing)', () async {
      tracker.logCarouselScrolled(Object(), scrollMetaFor(1));
      await tracker.flushCarouselScrolls();
      h.clear();
      await tracker.flushCarouselScrolls();
      expect(h.hasEvent(AnalyticsEvents.carouselScrolled), isFalse);
    }, skip: skipIfMissing);
  });

}
