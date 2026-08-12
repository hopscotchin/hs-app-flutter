import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/common_props_matchers.dart';
import '../support/home_analytics_harness.dart';

/// PRODUCT_GRID — one banner_impression at root level. tile_clicked is
/// exercised via `logTileClick` directly (the `onProductGridTileTapped`
/// extension requires a real `ListingProductEntity`; we avoid coupling
/// this file to PLP entity construction).
void main() {
  final skipReason =
      HomeAnalyticsHarness.skipReasonFor(PageComponentType.productGrid);
  late HomeAnalyticsHarness harness;

  setUp(() async {
    harness = await HomeAnalyticsHarness.setUp(PageComponentType.productGrid);
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
      expect(payload[AnalyticsProperties.type], PageComponentType.productGrid);
      expect(payload[AnalyticsProperties.position], ctx.position);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
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

  group('tile_clicked', () {
    test('fires with merged root + tile chain (no null fields)', () async {
      final ctx = harness;
      final tile =
          (ctx.component.data!['tiles'] as List).first as Map<String, dynamic>;

      await ctx.tracker.logTileClick(trackingMetaChain: [
        ctx.component.data!['trackingMeta'] as Map<String, dynamic>?,
        tile['trackingMeta'] as Map<String, dynamic>?,
      ]);

      final payload = ctx.h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
      expectRootMerged(payload, ctx.rootMeta);
    }, skip: skipReason);
  });

}
