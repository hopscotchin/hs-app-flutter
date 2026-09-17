import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import 'support/home_analytics_harness.dart';

/// `AppConfig.isHomepageAnalyticsEnabled` gate — mirrors Android
/// `HomeTrackAnalyticManager.pushScrollData` (kt:440):
///
///   if (scrollJourney.isNullOrEmpty() || !isHomepageAnalyticsEnabled) return
///
/// The gate sits BETWEEN the carousel-scroll dispatch and the impression
/// dispatch, so:
///   - `carousel_scrolled` (+ its LP twin) — NOT gated, always fires.
///   - `banner_impression`  (+ its LP twin) — GATED.
///   - `tile_impression` / `lp_tile_impression` — retired in Flutter,
///     so the flag has no other events to touch.
///
/// Tile-click paths (`tile_clicked` / `lp_tile_clicked`) run on their own
/// path and are NEVER gated by this flag — matches Android
/// `logTileClickAnalyticEvent` which sits outside the `pushScrollData`
/// gate.
///
/// The flag is persisted by `SplashRepositoryImpl` from
/// `RemoteConfig.isHomepageAnalyticsEnabled`; default when unset is `true`.
void main() {
  final skipReason =
      HomeAnalyticsHarness.skipReasonFor(PageComponentType.customTiles);
  late HomeAnalyticsHarness harness;

  setUp(() async {
    harness = await HomeAnalyticsHarness.setUp(PageComponentType.customTiles);
  });
  tearDown(() => harness.tearDown());

  test('flag=true (default) → banner_impression dispatches on flush',
      () async {
    // Sanity — the shared harness defaults the flag to true; if this
    // fails, we've regressed the default and every other component test
    // is silently green because impressions still fire for a different
    // reason.
    expect(harness.h.prefs.featureFlagHomeAnalytics, isTrue);

    await harness.makeVisibleAndFlush();

    expect(harness.h.hasEvent(AnalyticsEvents.bannerImpression), isTrue,
        reason: 'baseline: flag on, impression fires — sanity for the '
            'off-branch below');
  }, skip: skipReason);

  test(
      'flag=false → banner_impression is SUPPRESSED even for a visible '
      'component', () async {
    await harness.h.prefs.setFeatureFlagHomeAnalytics(false);
    expect(harness.h.prefs.featureFlagHomeAnalytics, isFalse);

    await harness.makeVisibleAndFlush();

    expect(harness.h.hasEvent(AnalyticsEvents.bannerImpression), isFalse,
        reason: 'flag off → impression must not ship. Matches Android '
            'kt:440 early-return.');
  }, skip: skipReason);

  test('flag=false → carousel_scrolled STILL dispatches (unaffected)',
      () async {
    await harness.h.prefs.setFeatureFlagHomeAnalytics(false);

    // Buffer one carousel-scroll then flush — same code path as production
    // (`PageCarouselView` calls `logCarouselScrolled`; nav / bloc-close
    // triggers `flushCarouselScrolls`).
    harness.tracker.logCarouselScrolled(
      Object(),
      Map<String, dynamic>.of(harness.rootMeta)..['scrolled_tiles'] = '3',
    );
    await harness.tracker.flushCarouselScrolls();

    expect(harness.h.hasEvent(AnalyticsEvents.carouselScrolled), isTrue,
        reason: 'carousel_scrolled fires BEFORE the gate in flushJourney '
            '— matches Android kt:437 where CAROUSEL_SCROLLED emits before '
            'the isHomepageAnalyticsEnabled check');
    expect(harness.h.hasEvent(AnalyticsEvents.bannerImpression), isFalse,
        reason: 'gate still suppresses impressions in the same flush');
  }, skip: skipReason);
}
