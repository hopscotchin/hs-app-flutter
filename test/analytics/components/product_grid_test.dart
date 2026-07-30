import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';
import '../support/fixture_loader.dart';

/// PRODUCT_GRID — flat `tiles` list of products. Chain per tile:
/// root.trackingMeta + tile.trackingMeta. Looked up by `type == 'PRODUCT_GRID'`.
void main() {
  final fx = HomeFixture.load();
  final skipIfMissing = fx.firstOfType(PageComponentType.productGrid) == null
      ? 'no PRODUCT_GRID component in current fixture'
      : null;

  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;
  late PageComponent pg;
  late int pgIndex;

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

    // Random PRODUCT_GRID per test.
    pgIndex = fx.randomIndexOfType(PageComponentType.productGrid);
    pg = fx.components[pgIndex];
    printOnFailure('picked PRODUCT_GRID at index=$pgIndex, position=${pg.position}');
    expectNoLpPrefixedTrackingMetaKeys(fx.rootTrackingMetaAt(pgIndex));

    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
    await h.orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);
  });
  tearDown(() => h.tearDown());

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + root trackingMeta (no null fields)',
        () async {
      await tracker.notifyVisible(pgIndex);

      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.type], PageComponentType.productGrid);
      expect(payload[AnalyticsProperties.position], pg.position);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);

      final root = fx.rootTrackingMetaAt(pgIndex);
      for (final entry in root.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'root.${entry.key} lost');
      }
    }, skip: skipIfMissing);

    test('required keys are all present, non-null, non-empty (home context)',
        () async {
      await tracker.notifyVisible(pgIndex);
      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectRequiredNonEmpty(payload, requiredKeysBannerImpressionHome);
    }, skip: skipIfMissing);
  });

  // ─── tile_impression ────────────────────────────────────────────────

  group('tile_impression', () {
    test('fires one tile_impression per product tile (no null fields)', () async {
      await tracker.notifyVisible(pgIndex);

      final tileCount = (pg.data!['tiles'] as List).length;
      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      expect(events, hasLength(tileCount));
      for (final e in events) {
        expectNoNullFields(e);
        expect(e[AnalyticsProperties.type], PageComponentType.productGrid);
        expect(e[AnalyticsProperties.position], pg.position);
      }
    }, skip: skipIfMissing);

    test('each tile_impression carries root + tile trackingMeta verbatim', () async {
      await tracker.notifyVisible(pgIndex);

      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      final tiles = pg.data!['tiles'] as List;
      final root = fx.rootTrackingMetaAt(pgIndex);

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
      await tracker.notifyVisible(pgIndex);
      for (final e in h.eventsNamed(AnalyticsEvents.tileImpression)) {
        expectRequiredNonEmpty(e, requiredKeysTileImpressionHome);
      }
    }, skip: skipIfMissing);

    test('product_id + slice_id are unique per tile', () async {
      await tracker.notifyVisible(pgIndex);
      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      expect(events.map((e) => e['product_id']).toSet(),
          hasLength(events.length));
      expect(events.map((e) => e['slice_id']).toSet(),
          hasLength(events.length));
    }, skip: skipIfMissing);
  });

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked', () {
    // The extension `onProductGridTileTapped(root, item)` requires a real
    // ListingProductEntity. To avoid coupling to PLP entity construction
    // in this file, exercise the same chain shape via logTileClick.

    test('fires with merged root + tile chain (no null fields)', () async {
      final tile = (pg.data!['tiles'] as List).first as Map<String, dynamic>;

      await tracker.logTileClick(trackingMetaChain: [
        pg.data!['trackingMeta'] as Map<String, dynamic>?,
        tile['trackingMeta'] as Map<String, dynamic>?,
      ]);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);

      final root = fx.rootTrackingMetaAt(pgIndex);
      const attributionOwned = {
        AnalyticsProperties.funnel,
        AnalyticsProperties.sortbar,
      };
      for (final entry in root.entries) {
        if (attributionOwned.contains(entry.key)) continue;
        if (entry.value == null) continue;
        expect(payload[entry.key], entry.value,
            reason: 'click lost root.${entry.key}');
      }
    }, skip: skipIfMissing);

    test('attribution carries forward to next-screen event', () async {
      final tile = (pg.data!['tiles'] as List).first as Map<String, dynamic>;
      await tracker.logTileClick(trackingMetaChain: [
        pg.data!['trackingMeta'] as Map<String, dynamic>?,
        tile['trackingMeta'] as Map<String, dynamic>?,
      ]);
      h.clear();

      await h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        <String, Object?>{AnalyticsProperties.productId: 42},
        attribution: true,
      );

      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      final tileMeta = tile['trackingMeta'] as Map<String, dynamic>;
      for (final entry in tileMeta.entries) {
        if (entry.value == null) continue;
        expect(payload[entry.key], entry.value,
            reason: 'attribution.${entry.key} lost home→PDP');
      }
    }, skip: skipIfMissing);
  });

}
