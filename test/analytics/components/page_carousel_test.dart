import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_component_click_handlers.dart';
import 'package:hs_app_flutter/features/discover/data/models/component_models.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/common_props_matchers.dart';
import '../support/home_analytics_harness.dart';

/// PageCarousel — one banner_impression at root level; also owns the
/// carousel_scrolled dispatch path. Skipped when the fixture has no
/// clean PageCarousel.
void main() {
  final skipReason =
      HomeAnalyticsHarness.skipReasonFor(PageComponentType.pageCarousel);
  late HomeAnalyticsHarness harness;

  setUp(() async {
    harness = await HomeAnalyticsHarness.setUp(PageComponentType.pageCarousel);
  });
  tearDown(() => harness.tearDown());

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + full root trackingMeta (no nulls)',
        () async {
      final ctx = harness;
      await ctx.makeVisibleAndFlush();

      final payload = ctx.h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.type], PageComponentType.pageCarousel);
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

  group('tile_clicked (via onPageCarouselTileTapped)', () {
    test('fires with merged root + tile chain (no null fields)', () async {
      final ctx = harness;
      final data = ComponentDataParser.parsePageCarousel(ctx.component.data!);
      await ctx.tracker.onPageCarouselTileTapped(data, data.tiles.first);

      final payload = ctx.h.singleEvent(AnalyticsEvents.tileClicked);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
      expectRootMerged(payload, ctx.rootMeta);
    }, skip: skipReason);

    test('attribution carries forward to next-screen event', () async {
      final ctx = harness;
      final data = ComponentDataParser.parsePageCarousel(ctx.component.data!);
      await ctx.tracker.onPageCarouselTileTapped(data, data.tiles.first);
      ctx.h.clear();

      await ctx.h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        const <String, Object?>{},
        attribution: true,
      );

      final payload = ctx.h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      final tileMeta = (ctx.component.data!['tiles'] as List).first
          ['trackingMeta'] as Map<String, dynamic>;
      expectAttributionCarriedForward(payload, tileMeta);
    }, skip: skipReason);
  });

  // ─── carousel_scrolled (PageCarousel only) ─────────────────────────

  group('carousel_scrolled', () {
    Map<String, dynamic> scrollMetaFor(int targetTile) => {
          ...harness.rootMeta,
          AnalyticsProperties.scrolledTiles: targetTile.toString(),
        };

    test('buffered — nothing fires until flushCarouselScrolls', () async {
      final ctx = harness;
      ctx.tracker.logCarouselScrolled(Object(), scrollMetaFor(2));
      expect(ctx.h.hasEvent(AnalyticsEvents.carouselScrolled), isFalse);
    }, skip: skipReason);

    test('flush emits ONE event per distinct carousel key', () async {
      final ctx = harness;
      ctx.tracker.logCarouselScrolled(Object(), scrollMetaFor(2));
      ctx.tracker.logCarouselScrolled(Object(), scrollMetaFor(3));
      await ctx.tracker.flushCarouselScrolls();
      expect(ctx.h.eventsNamed(AnalyticsEvents.carouselScrolled), hasLength(2));
    }, skip: skipReason);

    test('last-write-wins per carousel key', () async {
      final ctx = harness;
      final k = Object();
      ctx.tracker.logCarouselScrolled(k, scrollMetaFor(1));
      ctx.tracker.logCarouselScrolled(k, scrollMetaFor(6));
      await ctx.tracker.flushCarouselScrolls();
      final payload = ctx.h.singleEvent(AnalyticsEvents.carouselScrolled);
      expect(payload[AnalyticsProperties.scrolledTiles], '6');
    }, skip: skipReason);

    test('flushed payload carries client + root trackingMeta + scrolled_tiles',
        () async {
      final ctx = harness;
      ctx.tracker.logCarouselScrolled(Object(), scrollMetaFor(4));
      await ctx.tracker.flushCarouselScrolls();

      final payload = ctx.h.singleEvent(AnalyticsEvents.carouselScrolled);
      expectTimeBuckets(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
      expectRootMerged(payload, ctx.rootMeta);
      expect(payload[AnalyticsProperties.scrolledTiles], '4');
    }, skip: skipReason);

    test('flush is idempotent (second flush emits nothing)', () async {
      final ctx = harness;
      ctx.tracker.logCarouselScrolled(Object(), scrollMetaFor(1));
      await ctx.tracker.flushCarouselScrolls();
      ctx.h.clear();
      await ctx.tracker.flushCarouselScrolls();
      expect(ctx.h.hasEvent(AnalyticsEvents.carouselScrolled), isFalse);
    }, skip: skipReason);
  });
}
