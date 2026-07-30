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

/// Hero — chain per tile: root.trackingMeta + tile.trackingMeta +
/// tileDetail.trackingMeta (may be absent) + tileGrid[0].trackingMeta.
/// Component looked up by `type == 'Hero'` — no position hardcoded.
///
/// If the current `home_page_all.json` fixture doesn't contain a Hero, every
/// test in this file skips gracefully with a clear reason. Capture a
/// Hero-bearing response into the fixture to enable them.
void main() {
  final fx = HomeFixture.load();
  final skipIfMissing = fx.firstOfType(PageComponentType.hero) == null
      ? 'no Hero component in current fixture — capture a Hero-bearing '
          'homepage response into home_page_all.json'
      : null;

  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;
  late PageComponent hero;
  late int heroIndex;

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

    // Random Hero per test.
    heroIndex = fx.randomIndexOfType(PageComponentType.hero);
    hero = fx.components[heroIndex];
    printOnFailure('picked Hero at index=$heroIndex, position=${hero.position}');
    expectNoLpPrefixedTrackingMetaKeys(fx.rootTrackingMetaAt(heroIndex));

    await h.orderAttribution.setFunnel(AnalyticsDefaults.discover);
    await h.orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);
  });
  tearDown(() => h.tearDown());

  // ─── banner_impression ─────────────────────────────────────────────

  group('banner_impression', () {
    test('fires once with client keys + full root trackingMeta (no nulls)', () async {
      await tracker.notifyVisible(heroIndex);

      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectTimeBuckets(payload);
      expectTimestamp(payload);
      expectNoNullFields(payload);

      expect(payload[AnalyticsProperties.type], PageComponentType.hero);
      expect(payload[AnalyticsProperties.position], hero.position);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);

      final root = fx.rootTrackingMetaAt(heroIndex);
      for (final entry in root.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'root trackingMeta.${entry.key} lost');
      }
    }, skip: skipIfMissing);

    test('required keys are all present, non-null, non-empty (home context)',
        () async {
      await tracker.notifyVisible(heroIndex);
      final payload = h.singleEvent(AnalyticsEvents.bannerImpression);
      expectRequiredNonEmpty(payload, requiredKeysBannerImpressionHome);
    }, skip: skipIfMissing);
  });

  // ─── tile_impression ────────────────────────────────────────────────

  group('tile_impression', () {
    test('fires one tile_impression per Hero tile (no null fields)', () async {
      await tracker.notifyVisible(heroIndex);

      final events = h.eventsNamed(AnalyticsEvents.tileImpression);
      final tileCount = (hero.data!['tiles'] as List).length;
      expect(events, hasLength(tileCount));
      for (final e in events) {
        expectNoNullFields(e);
        expect(e[AnalyticsProperties.type], PageComponentType.hero);
        expect(e[AnalyticsProperties.position], hero.position);
        expect(e[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      }
    }, skip: skipIfMissing);

    test('funnel_tile values are unique per tile', () async {
      await tracker.notifyVisible(heroIndex);
      final funnelTiles = h
          .eventsNamed(AnalyticsEvents.tileImpression)
          .map((e) => e['funnel_tile'])
          .toList();
      expect(funnelTiles.toSet(), hasLength(funnelTiles.length),
          reason: 'each hero tile must have a unique funnel_tile');
    }, skip: skipIfMissing);

    test('required keys on every tile_impression (home context)', () async {
      await tracker.notifyVisible(heroIndex);
      for (final e in h.eventsNamed(AnalyticsEvents.tileImpression)) {
        expectRequiredNonEmpty(e, requiredKeysTileImpressionHome);
      }
    }, skip: skipIfMissing);
  });

  // ─── tile_clicked ──────────────────────────────────────────────────

  group('tile_clicked (via onHeroTileTapped)', () {
    test('fires with root + tile + first-detail + first-image chain', () async {
      final heroData = ComponentDataParser.parseHero(hero.data!);
      await tracker.onHeroTileTapped(heroData, heroData.tiles.first);

      final payload = h.singleEvent(AnalyticsEvents.tileClicked);
      expectTimestamp(payload);
      expectNoNullFields(payload);
      expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
      expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
    }, skip: skipIfMissing);

    test('attribution carries forward to next-screen event', () async {
      final heroData = ComponentDataParser.parseHero(hero.data!);
      await tracker.onHeroTileTapped(heroData, heroData.tiles.first);
      h.clear();

      await h.analytics.logEvent(
        AnalyticsEvents.productViewed,
        <String, Object?>{AnalyticsProperties.productId: 12115},
        attribution: true,
      );

      final payload = h.singleEvent(AnalyticsEvents.productViewed);
      expectNoNullFields(payload);
      // Whatever tile keys landed on the click should reappear on PDP event.
      final firstTileJson =
          (hero.data!['tiles'] as List).first as Map<String, dynamic>;
      final tileMeta =
          firstTileJson['trackingMeta'] as Map<String, dynamic>? ?? {};
      for (final entry in tileMeta.entries) {
        expect(payload[entry.key], entry.value,
            reason: 'attribution.${entry.key} lost between click and PDP');
      }
    }, skip: skipIfMissing);
  });

}
