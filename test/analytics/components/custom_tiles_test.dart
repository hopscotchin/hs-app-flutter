import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_component_click_handlers.dart';
import 'package:hs_app_flutter/features/discover/data/models/component_models.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/common_props_matchers.dart';
import '../support/home_analytics_harness.dart';

/// CustomTiles — one banner_impression at root level. Skipped when the
/// fixture has no clean (non-LP-prefixed) CustomTiles component.
void main() {
  final skipReason =
      HomeAnalyticsHarness.skipReasonFor(PageComponentType.customTiles);
  late HomeAnalyticsHarness harness;

  setUp(() async {
    harness = await HomeAnalyticsHarness.setUp(PageComponentType.customTiles);
  });
  tearDown(() => harness.tearDown());

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + root trackingMeta (no null fields)',
        () async {
      final ctx = harness;
      await ctx.makeVisibleAndFlush();

      final payload = ctx.h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.type], PageComponentType.customTiles);
      expect(payload[AnalyticsProperties.position], ctx.position);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expectRootMerged(payload, ctx.rootMeta);
    }, skip: skipReason);

    test('required keys are all present, non-null, non-empty', () async {
      final ctx = harness;
      await ctx.makeVisibleAndFlush();
      final payload = ctx.h.singleEvent(AnalyticsEvents.bannerImpression);
      expectRequiredNonEmpty(payload, requiredKeysBannerImpressionHome);
    }, skip: skipReason);
  });

  // ─── tile_impression: retired ──────────────────────────────────────

  test('tile_impression is retired — never fires',
      () async => harness.expectTileImpressionRetired(),
      skip: skipReason);

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked (via onCustomTileTapped)', () {
    test('fires with root + row + leaf chain (no null fields)', () async {
      final ctx = harness;
      final data = ComponentDataParser.parseCustomTiles(ctx.component.data!);
      // Find a row whose first leaf has real trackingMeta (skip title rows).
      final row = data.tiles.firstWhere(
        (t) => t.tileGrid.isNotEmpty && t.tileGrid.first.trackingMeta != null,
      );
      await ctx.tracker.onCustomTileTapped(data, row, row.tileGrid.first);

      final payload = ctx.h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
      expectRootMerged(payload, ctx.rootMeta);
    }, skip: skipReason);

    test('attribution carries forward to next-screen event', () async {
      final ctx = harness;
      final data = ComponentDataParser.parseCustomTiles(ctx.component.data!);
      final row = data.tiles.firstWhere(
        (t) => t.tileGrid.isNotEmpty && t.tileGrid.first.trackingMeta != null,
      );
      await ctx.tracker.onCustomTileTapped(data, row, row.tileGrid.first);
      ctx.h.clear();

      await ctx.h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        const <String, Object?>{},
        attribution: true,
      );

      final payload = ctx.h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      expectAttributionCarriedForward(payload, ctx.rootMeta);
    }, skip: skipReason);
  });
}
