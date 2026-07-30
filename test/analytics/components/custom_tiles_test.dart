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

/// CustomTiles — tiles list of rows, each with a `tileGrid` of leaves. Chain
/// per leaf: root.trackingMeta + leaf.trackingMeta (rows typically have no
/// trackingMeta). Looked up by `type == 'CustomTiles'`.
void main() {
  final fx = HomeFixture.load();
  final skipIfMissing = fx.firstOfType(PageComponentType.customTiles) == null
      ? 'no CustomTiles component in current fixture'
      : null;

  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;
  late PageComponent ct;
  late int ctIndex;

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

    // Random CustomTiles per test — exercises different backend instances.
    ctIndex = fx.randomIndexOfType(PageComponentType.customTiles);
    ct = fx.components[ctIndex];
    printOnFailure('picked CustomTiles at index=$ctIndex, position=${ct.position}');
    // Homepage contract: no lp_*-prefixed keys anywhere in root trackingMeta.
    // An LP-variant CustomTiles that leaks into the home feed fails here
    // with a clear reason.
    expectNoLpPrefixedTrackingMetaKeys(fx.rootTrackingMetaAt(ctIndex));

    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
    await h.orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);
  });
  tearDown(() => h.tearDown());

  // Sum of leaves across all rows for the first CustomTiles component.
  int totalLeaves(PageComponent c) {
    var n = 0;
    for (final row in c.data!['tiles'] as List) {
      n += ((row as Map<String, dynamic>)['tileGrid'] as List).length;
    }
    return n;
  }

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + root trackingMeta (no null fields)',
        () async {
      await tracker.notifyVisible(ctIndex);

      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.type], PageComponentType.customTiles);
      expect(payload[AnalyticsProperties.position], ct.position);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);

      final root = fx.rootTrackingMetaAt(ctIndex);
      for (final entry in root.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'root.${entry.key} lost');
      }
    }, skip: skipIfMissing);

    test('required keys are all present, non-null, non-empty (home context)',
        () async {
      await tracker.notifyVisible(ctIndex);
      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectRequiredNonEmpty(payload, requiredKeysBannerImpressionHome);
    }, skip: skipIfMissing);
  });

  // ─── tile_impression ────────────────────────────────────────────────

  group('tile_impression', () {
    test('fires one tile_impression per leaf across all rows (no null fields)',
        () async {
      await tracker.notifyVisible(ctIndex);

      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      // Fixture leaves may include title-only rows that have no
      // trackingMeta (isTitleItem: true). The tracker still walks them, so
      // count all leaves regardless.
      expect(events.length, totalLeaves(ct));
      for (final e in events) {
        expectNoNullFields(e);
        expect(e[AnalyticsProperties.type], PageComponentType.customTiles);
        expect(e[AnalyticsProperties.position], ct.position);
      }
    }, skip: skipIfMissing);

    test('each tile_impression merges root + leaf trackingMeta verbatim', () async {
      await tracker.notifyVisible(ctIndex);

      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      final root = fx.rootTrackingMetaAt(ctIndex);

      final leaves = <Map<String, dynamic>>[];
      for (final row in ct.data!['tiles'] as List) {
        for (final leaf in (row as Map<String, dynamic>)['tileGrid'] as List) {
          final meta = (leaf as Map<String, dynamic>)['trackingMeta'];
          leaves.add(meta is Map<String, dynamic> ? meta : const {});
        }
      }
      expect(events.length, leaves.length);

      const attributionOwned = {
        AnalyticsProperties.funnel,
        AnalyticsProperties.sortbar,
      };
      for (var i = 0; i < events.length; i++) {
        for (final entry in root.entries) {
          if (attributionOwned.contains(entry.key)) continue;
          if (leaves[i].containsKey(entry.key)) continue;
          expect(events[i][entry.key], entry.value,
              reason: 'leaf[$i] lost root.${entry.key}');
        }
        for (final entry in leaves[i].entries) {
          if (attributionOwned.contains(entry.key)) continue;
          expect(events[i][entry.key], entry.value,
              reason: 'leaf[$i] lost leaf.${entry.key}');
        }
      }
    }, skip: skipIfMissing);

    test('required keys on every tile_impression with a real leaf (home context)',
        () async {
      await tracker.notifyVisible(ctIndex);
      // Skip events derived from title-only leaves — those have no
      // trackingMeta at the leaf level so slice_id / funnel_tile don't get
      // supplied.
      final leavesWithMeta = <int>[];
      var i = 0;
      for (final row in ct.data!['tiles'] as List) {
        for (final leaf in (row as Map<String, dynamic>)['tileGrid'] as List) {
          if ((leaf as Map<String, dynamic>)['trackingMeta'] != null) {
            leavesWithMeta.add(i);
          }
          i++;
        }
      }
      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      for (final idx in leavesWithMeta) {
        expectRequiredNonEmpty(events[idx], requiredKeysTileImpressionHome);
      }
    }, skip: skipIfMissing);
  });

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked (via onCustomTileTapped)', () {
    test('fires with root + row + leaf chain (no null fields)', () async {
      final data = ComponentDataParser.parseCustomTiles(ct.data!);
      // Find a row whose first leaf has real trackingMeta (skip title rows).
      final row = data.tiles.firstWhere(
        (t) => t.tileGrid.isNotEmpty && t.tileGrid.first.trackingMeta != null,
      );
      final leaf = row.tileGrid.first;

      await tracker.onCustomTileTapped(data, row, leaf);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);

      final root = fx.rootTrackingMetaAt(ctIndex);
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
      final data = ComponentDataParser.parseCustomTiles(ct.data!);
      final row = data.tiles.firstWhere(
        (t) => t.tileGrid.isNotEmpty && t.tileGrid.first.trackingMeta != null,
      );
      await tracker.onCustomTileTapped(data, row, row.tileGrid.first);
      h.clear();

      await h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        <String, Object?>{AnalyticsProperties.productId: 999},
        attribution: true,
      );
      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      // Root banner_name / funnel_tile must survive the trip.
      final root = fx.rootTrackingMetaAt(ctIndex);
      if (root['banner_name'] != null) {
        expect(payload['banner_name'], root['banner_name']);
      }
      if (root['funnel_tile'] != null) {
        expect(payload['funnel_tile'], root['funnel_tile']);
      }
    }, skip: skipIfMissing);
  });

}
