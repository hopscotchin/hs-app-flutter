import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_component_click_handlers.dart';
import 'package:hs_app_flutter/features/discover/data/models/component_models.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import '../support/common_props_matchers.dart';
import '../support/home_analytics_harness.dart';

/// Hero — one `banner_impression` per tile the user ACTUALLY saw. A Hero
/// carousel shows a single tile at a time, so emitting all `hero.tiles` on
/// component-visibility (the pre-fix behaviour) massively over-reported.
/// The Hero widget now records tile visibility through
/// `notifyHeroTileVisible` on its own VisibilityDetector rising edge and
/// each `onPageChanged`; the tracker emits one event per recorded tile.
/// Payload: root.trackingMeta + tile.trackingMeta merged (non-null).
/// Skipped when the fixture has no clean Hero component.
void main() {
  final skipReason = HomeAnalyticsHarness.skipReasonFor(PageComponentType.hero);
  late HomeAnalyticsHarness harness;

  setUp(() async {
    harness = await HomeAnalyticsHarness.setUp(PageComponentType.hero);
  });
  tearDown(() => harness.tearDown());

  // ─── banner_impression (per Hero tile) ─────────────────────────────

  group('banner_impression', () {
    test('component-visibility ALONE emits nothing — tile visibility required',
        () async {
      // Regression pin. Before the fix, Hero flushed one event per
      // fixture tile the moment the outer widget became visible; the
      // user would only see one at a time and the rest were phantoms.
      // Now `notifyVisible(componentIndex)` alone must emit zero.
      final ctx = harness;
      ctx.tracker.notifyVisible(ctx.componentIndex);
      await ctx.tracker.flushJourney();

      expect(ctx.h.hasEvent(AnalyticsEvents.bannerImpression), isFalse,
          reason: 'Hero must not emit until specific tiles are recorded '
              'as visible via notifyHeroTileVisible');
    }, skip: skipReason);

    test('one banner_impression per recorded tile — no more, no less',
        () async {
      // User swipes tile 0 → tile 1 (or auto-scrolls the same). Only
      // those two tiles are seen; only those two should ship.
      final ctx = harness;
      final tileCount = (ctx.component.data!['tiles'] as List).length;
      if (tileCount < 2) return; // skip on single-tile fixture
      ctx.tracker.notifyHeroTileVisible(ctx.componentIndex, 0);
      ctx.tracker.notifyHeroTileVisible(ctx.componentIndex, 1);
      await ctx.tracker.flushJourney();

      expect(ctx.h.eventsNamed(AnalyticsEvents.bannerImpression), hasLength(2));
    }, skip: skipReason);

    test('re-recorded tile emits again — each view is its own impression',
        () async {
      // User cycles the whole carousel (say 10 tiles) then swipes back to
      // 1, 2, 3 → 13 recorded views → 13 events on flush. Auto-scroll
      // wrap counts too.
      final ctx = harness;
      final tileCount = (ctx.component.data!['tiles'] as List).length;
      // Full pass 0..N-1, plus a partial re-visit of 0..2 (or as many as
      // fit — single-tile fixture short-circuits).
      final revisit = tileCount >= 3 ? 3 : tileCount;
      for (var i = 0; i < tileCount; i++) {
        ctx.tracker.notifyHeroTileVisible(ctx.componentIndex, i);
      }
      for (var i = 0; i < revisit; i++) {
        ctx.tracker.notifyHeroTileVisible(ctx.componentIndex, i);
      }
      await ctx.tracker.flushJourney();

      expect(ctx.h.eventsNamed(AnalyticsEvents.bannerImpression),
          hasLength(tileCount + revisit));
    }, skip: skipReason);

    test('every recorded tile ships with root+tile merged and required keys',
        () async {
      // Simulates the exhaustive "user cycled through every tile" case —
      // the same coverage the old always-emit-everything path had.
      final ctx = harness;
      await ctx.makeAllHeroTilesVisibleAndFlush();

      final events = ctx.h.eventsNamed(AnalyticsEvents.bannerImpression);
      final tiles = ctx.component.data!['tiles'] as List;
      expect(events, hasLength(tiles.length));
      for (var i = 0; i < tiles.length; i++) {
        final e = events[i];
        expectNoNullFields(e);
        expectTimeBuckets(e);
        expectTimestamp(e);
        expectRequiredNonEmpty(e, requiredKeysBannerImpressionHome);
        expect(e[AnalyticsProperties.type], PageComponentType.hero);
        expect(e[AnalyticsProperties.position], ctx.position);
        expect(e[AnalyticsProperties.funnel], AnalyticsDefaults.discover);

        final tileMeta =
            (tiles[i] as Map<String, dynamic>)['trackingMeta'] as Map<String, dynamic>? ??
                const <String, dynamic>{};
        expectRootMerged(e, ctx.rootMeta, override: tileMeta.keys.toSet());
        for (final entry in tileMeta.entries) {
          if (entry.value == null) continue;
          if (attributionOwnedKeys.contains(entry.key)) continue;
          expect(e[entry.key], entry.value,
              reason: 'tile[$i] lost tile.${entry.key}');
        }
      }
    }, skip: skipReason);
  });

  // ─── tile_impression: retired ──────────────────────────────────────

  test('tile_impression is retired — never fires',
      () async => harness.expectTileImpressionRetired(),
      skip: skipReason);

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked (via onHeroTileTapped)', () {
    test('fires with root + tile + first-detail + first-image chain', () async {
      final ctx = harness;
      final heroData = ComponentDataParser.parseHero(ctx.component.data!);
      await ctx.tracker.onHeroTileTapped(heroData, heroData.tiles.first);

      final payload = ctx.h.singleEvent(AnalyticsEvents.tileClicked);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
    }, skip: skipReason);

    test('attribution carries forward to next-screen event', () async {
      final ctx = harness;
      final heroData = ComponentDataParser.parseHero(ctx.component.data!);
      await ctx.tracker.onHeroTileTapped(heroData, heroData.tiles.first);
      ctx.h.clear();

      await ctx.h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        const <String, Object?>{},
        attribution: true,
      );

      final payload = ctx.h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      final tileMeta =
          (ctx.component.data!['tiles'] as List).first['trackingMeta']
              as Map<String, dynamic>? ??
              const <String, dynamic>{};
      expectAttributionCarriedForward(payload, tileMeta);
    }, skip: skipReason);
  });
}
