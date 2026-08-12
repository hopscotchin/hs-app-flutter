import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../attribution/lp_attribution_helper.dart';
import '../attribution/order_attribution_helper.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_events.dart';
import '../events/analytics_helper.dart';
import 'journey_worker.dart';

/// Per-screen impression / scroll / click tracker for Discover + LP.
///
/// **Responsibility split.** This class stays on the main isolate and
/// does only cheap, sub-millisecond work:
///
/// - Scroll bookkeeping — `_currentlyVisible`, direction-change
///   snapshot, and the journey (`_journey`) of indices that entered
///   the viewport since the last flush.
/// - Click events — merged synchronously, attribution updated,
///   `analytics.logEvent(tile_clicked)` fired.
/// - Carousel scroll flush — a handful of events, main-isolate direct.
///
/// The heavy work — walking nested tile JSON, allocating one enriched
/// map per innermost leaf, calling `_segment.track` hundreds of times
/// — is delegated to a [JourneyWorker]. The production worker
/// (`IsolateJourneyWorker`) runs on a dedicated isolate that
/// initialises `BackgroundIsolateBinaryMessenger` and owns its own
/// Segment client, so a `flushJourney` on nav / tab / pause becomes a
/// single `SendPort.send` on the main thread. Tests inject
/// `InlineJourneyWorker` which routes through the mocked
/// `AnalyticsHelper`.
///
/// **Contract with the widget layer.** `notifyVisible` / `notifyInvisible`
/// are cheap synchronous calls safe from any `VisibilityDetector`
/// callback. `flushJourney` (and its alias `flushCarouselScrolls`) is
/// the only method that dispatches to Segment; call it on screen leave
/// — bloc close, nav push/pop, tab switch, `paused` / `hidden`
/// lifecycle. `HomeBloc.close` should also call [destroyFromHomeBloc]
/// to release per-screen buffers; LP blocs must not.
@lazySingleton
class HomeTrackAnalyticManager with WidgetsBindingObserver {
  HomeTrackAnalyticManager({
    required this.analytics,
    required this.orderAttribution,
    required this.lpAttribution,
    required JourneyWorker journeyWorker,
  }) : _worker = journeyWorker {
    WidgetsBinding.instance.addObserver(this);
  }

  final AnalyticsHelper analytics;
  final OrderAttributionHelper orderAttribution;
  final LpAttributionHelper lpAttribution;
  final JourneyWorker _worker;

  // ─── Per-screen state (all main-isolate) ───────────────────────────

  final Set<int> _currentlyVisible = <int>{};

  /// Items visible at the last direction change — excluded from re-add
  /// on the new leg (matches Android per-direction segment start).
  Set<int> _snapshotAtDirectionChange = <int>{};

  /// Indices that crossed the visibility threshold since the last
  /// flush. Bookkeeping-only on the scroll frame; the worker drains it.
  final Set<int> _journey = <int>{};

  /// Hero-tile visibility journey — component-index → ordered list of tile
  /// indices the user actually saw between flushes. Duplicates are kept:
  /// if the user saw tiles 1→10 then swiped back to 1, 2, 3, the list is
  /// [1..10, 1, 2, 3] and flush emits 13 events — each unique VIEW of a
  /// tile is a distinct impression. Populated by [notifyHeroTileVisible]
  /// from the Hero widget on VisibilityDetector rising edge + each
  /// `onPageChanged`. Drained by [flushJourney].
  final Map<int, List<int>> _heroTileJourney = <int, List<int>>{};

  /// Per-carousel key → captured `trackingMeta`. Last-write-wins per
  /// key; events fire on [flushJourney] via [_fireCarouselScrolls].
  final Map<Object, Map<String, dynamic>> _carouselScrollDepth =
      <Object, Map<String, dynamic>>{};

  double _lastScrollPixels = 0;
  _ScrollDir _lastDirection = _ScrollDir.none;
  ScrollPosition? _scrollPosition;

  ExtraData? extraData;
  String sortBarName = AnalyticsDefaults.sortBarAll;

  bool get _fromHomePage => extraData?.fromHomePage ?? true;

  /// Ships the raw component list to the worker, which flattens it into
  /// the compact snapshot the impression walk needs. The tracker itself
  /// doesn't retain a copy — nothing on the tracker reads them; the
  /// walk lives entirely inside the worker. Called at data-load /
  /// pagination / refresh time.
  set pageComponents(List<PageComponent> value) {
    unawaited(_worker.setComponents(value));
  }

  // ─── App lifecycle ─────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Background / iOS-hidden: flush whatever's queued. Nav callbacks
    // don't fire when the app is backgrounded, so without this the
    // journey would sit in memory until return.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      unawaited(flushJourney());
    }
  }

  // ─── Scroll bookkeeping ────────────────────────────────────────────

  /// Idempotent — subscribes to the scrollable so we can pivot the
  /// direction-change snapshot when the user reverses direction.
  void attachScrollPosition(ScrollPosition position) {
    if (identical(_scrollPosition, position)) return;
    _scrollPosition?.removeListener(_onScrollDelta);
    _scrollPosition = position;
    _lastScrollPixels = position.hasPixels ? position.pixels : 0;
    _lastDirection = _ScrollDir.none;
    _snapshotAtDirectionChange = <int>{};
    _scrollPosition?.addListener(_onScrollDelta);
  }

  void _onScrollDelta() {
    final position = _scrollPosition;
    if (position == null || !position.hasPixels) return;
    final delta = position.pixels - _lastScrollPixels;
    _lastScrollPixels = position.pixels;
    if (delta.abs() < 1) return; // ignore sub-pixel jitter
    final newDir = delta > 0 ? _ScrollDir.down : _ScrollDir.up;
    if (newDir == _lastDirection) return;
    // Direction changed → items still in viewport are "already covered"
    // for the new leg. New impressions on this leg only add indices
    // that enter the viewport AFTER the change.
    _snapshotAtDirectionChange = Set<int>.of(_currentlyVisible);
    _lastDirection = newDir;
  }

  /// Records [index] into the pending journey. **Does not emit** — the
  /// worker dispatches on [flushJourney]. Safe to call from any
  /// `VisibilityDetector` callback.
  ///
  /// Scenario: 1→5 forward (journey: {1..5}), then reverse. Items 4
  /// and 5 are in the direction snapshot → not re-added. 3, 2, 1
  /// re-enter fresh and land in the journey.
  void notifyVisible(int index) {
    if (_currentlyVisible.add(index) == false) return;
    if (_snapshotAtDirectionChange.contains(index)) return;
    _journey.add(index);
  }

  /// Called when a component drops below the visibility threshold.
  /// Re-entry after a direction change can add a fresh journey entry.
  void notifyInvisible(int index) {
    _currentlyVisible.remove(index);
  }

  /// Record that Hero tile [tileIndex] inside the component at
  /// [componentIndex] was actually seen (VisibilityDetector rising edge on
  /// the carousel + each `onPageChanged` fires this). NOT deduped —
  /// re-swipes to the same tile emit again on flush (matches the "each
  /// view is a distinct impression" contract). Cleared on [flushJourney]
  /// and [_resetScrollState].
  void notifyHeroTileVisible(int componentIndex, int tileIndex) {
    _heroTileJourney
        .putIfAbsent(componentIndex, () => <int>[])
        .add(tileIndex);
  }

  // ─── Click tracking ────────────────────────────────────────────────

  /// Fires `tile_clicked` / `lp_tile_clicked` AND writes attribution.
  ///
  /// HP click: merged meta lands in `OrderAttributionHelper` — unprefixed
  /// keys accumulate; last click wins on same-name key.
  ///
  /// LP click: merged meta pushes onto `LpAttributionHelper`'s deque
  /// (raw meta preserved; source LP identity stamped on the entry).
  /// Bare `lp_*` keys are stripped from the click payload — they'll
  /// re-emit as `lp1_*` from the deque; leaving them here would
  /// double-count.
  ///
  /// Returns [Future] for tests that need to observe post-dispatch state
  /// (`await tracker.logTileClick(...)` in a test still waits for the
  /// deferred work). Production callers **must not await** — nav has to
  /// start on the same frame as the tap.
  Future<void> logTileClick({
    List<Map<String, dynamic>?> trackingMetaChain = const [],
    String? sortBar,
  }) {
    // ── Sync section: everything the next screen depends on ──
    //
    // Snapshot source-page context before any deferral. `ActionUrlHandler.
    // navigate(...)` runs synchronously right after this returns and drives
    // `AppNavigationObserver.didPush`, which flips `extraData` to the
    // destination screen's context. Reading `_fromHomePage` / `extraData`
    // later would misclassify the click as `lp_tile_clicked`.
    final fromHomePage = _fromHomePage;
    final lpName = extraData?.landingPageName;
    final lpId = extraData?.landingPageId;

    // Build merged chain — root → leaf, deeper keys win, nulls skipped.
    final merged = <String, dynamic>{};
    for (final meta in trackingMetaChain) {
      if (meta == null || meta.isEmpty) continue;
      for (final entry in meta.entries) {
        if (entry.value == null) continue;
        merged[entry.key] = entry.value;
      }
    }

    // In-memory attribution write — the ONLY thing on the click frame.
    // Attribution stores are session-scoped memory only (no disk); the
    // next screen reads `orderAttribution.segmentParams` /
    // `lpAttribution.segmentParams` and sees the merged data immediately.
    //
    // HP branch uses REPLACE (not merge) so keys from a previous Hero
    // click can't leak onto a subsequent CustomTile click whose payload
    // ships a smaller key set. See `OrderAttributionHelper.replaceTrackingMeta`.
    if (fromHomePage) {
      orderAttribution.replaceTrackingMeta(merged);
    } else {
      lpAttribution.pushTileMeta(
        meta: merged,
        landingPageName: lpName,
        landingPageId: lpId,
      );
    }
    if (sortBar != null && sortBar.isNotEmpty) {
      sortBarName = sortBar;
      orderAttribution.setSortBar(sortBar);
    }

    //
    // The click event dispatches inside the deferred block below, AFTER
    // `await flushJourney()`. That yield gives `didPush → _applyFunnel`
    // (cart/search destinations) or a subsequent rapid tap's
    // `replaceTrackingMeta` a chance to mutate the store before the click
    // is composed. A live read at dispatch would ship the destination's
    // funnel or the newer tap's identity on THIS click.
    //
    // Snapshotting here — after this tap's own writes committed — pins
    // the click's payload to the tap that owns it. Passing
    // `attribution: false` to `logEvent` skips the live merge and uses
    // only what we've baked into `props`.
    final attributionSnapShot = <String, Object?>{
      ...orderAttribution.segmentParams,
      ...lpAttribution.segmentParams,
    };

    // Pre-compute the click event's payload NOW. Merge order:
    //   buildBaseSeed (funnel/sortbar/lp_id/lp_name) →
    //   frozenAttribution (T=0 snapshot: trackingMeta + funnel + sortbar
    //     + lp{n}_*) →
    //   clickMeta (client-owned override).
    final clickMeta = fromHomePage ? merged : stripLpPrefixed(merged);
    final props = buildBaseSeed(
      fromHomePage: fromHomePage,
      sortBarName: sortBarName,
      landingPageId: lpId,
      landingPageName: lpName,
    )
      ..addAll(attributionSnapShot)
      ..addAll(clickMeta);
    final event = fromHomePage
        ? AnalyticsEvents.tileClicked
        : AnalyticsEvents.lpTileClicked;

    // Impressions fire first (order-preserving on the wire), then the
    // click with `attribution: false` — payload is frozen at T=0.
    return Future.delayed(Duration.zero, () async {
      await flushJourney();
      await analytics.logEvent(event, props, attribution: false);
    });
  }

  /// Wipe the LP attribution deque. Called when Discover becomes active
  /// again (cold start, tab-tap-to-Discover, back-nav from LP depth N).
  void clearLpAttribution() => lpAttribution.clear();

  // ─── Carousel scroll ───────────────────────────────────────────────

  /// Records the most-recent horizontal scroll state for a carousel.
  /// Last-write-wins per [carouselKey]. Events fire on [flushJourney].
  void logCarouselScrolled(Object carouselKey, Map<String, dynamic> trackingMeta) {
    _carouselScrollDepth[carouselKey] = trackingMeta;
  }

  Future<void> _fireCarouselScrolls(JourneySeed seed) async {
    if (_carouselScrollDepth.isEmpty) return;
    final carouselEvent = seed.fromHomePage
        ? AnalyticsEvents.carouselScrolled
        : AnalyticsEvents.lpCarouselScrolled;
    final entries = _carouselScrollDepth.entries.toList(growable: false);
    _carouselScrollDepth.clear();
    final futures = <Future<void>>[];
    for (final entry in entries) {
      final props = buildBaseSeed(
        fromHomePage: seed.fromHomePage,
        sortBarName: seed.sortBarName,
        landingPageId: seed.landingPageId,
        landingPageName: seed.landingPageName,
      );
      if (entry.value.isNotEmpty) mergeMetaNonNull(props, entry.value);
      futures.add(analytics.logEvent(carouselEvent, props));
    }
    await Future.wait(futures);
  }

  // ─── Flush ─────────────────────────────────────────────────────────

  /// Drains carousel scrolls on main + impression journey on the worker.
  /// Call on screen leave: bloc close, nav observer push/pop, tab
  /// switch, or app paused / hidden.
  Future<void> flushJourney() async {
    // Snapshot & clear the journey SYNCHRONOUSLY before any await. The
    // nav observer's `didPush` fires synchronously right after
    // `unawaited(logTileClick(...))` returns, and its LP-route branch
    // calls `resetVisibilityState()` which wipes `_journey`. If we
    // read `_journey` AFTER the first yield below, that wipe would
    // beat us to it and the source-page impressions would silently
    // drop. Snapshot the seed here too so a mid-flush `extraData`
    // flip can't misclassify impressions as `lp_*` from a different
    // LP than the one they were journey'd on.
    final indices = _journey.toList(growable: false);
    _journey.clear();
    // Snapshot & clear the hero-tile map SYNC too (same rationale as
    // `_journey` above — a mid-flush LP-route push wipes it via
    // `resetVisibilityState`).
    final heroTiles = <int, List<int>>{};
    for (final entry in _heroTileJourney.entries) {
      heroTiles[entry.key] = List<int>.of(entry.value, growable: false);
    }
    _heroTileJourney.clear();
    final seed = _seed();
    await _fireCarouselScrolls(seed);
    if (indices.isEmpty && heroTiles.isEmpty) return;
    await _worker.flushImpressions(
      indices: indices,
      heroTiles: heroTiles,
      seed: seed,
    );
  }

  /// Alias so existing call sites (bloc close, nav observer, tab
  /// switch) don't need to change. Delegates to [flushJourney].
  Future<void> flushCarouselScrolls() => flushJourney();

  JourneySeed _seed() => (
    fromHomePage: _fromHomePage,
    sortBarName: sortBarName,
    landingPageId: extraData?.landingPageId,
    landingPageName: extraData?.landingPageName,
  );

  // ─── Cleanup ───────────────────────────────────────────────────────

  /// Clear per-screen visibility/scroll bookkeeping WITHOUT dropping
  /// [pageComponents], attribution, or sortbar. Called by
  /// `AppNavigationObserver` on funnel switch. Callers must
  /// [flushJourney] first if the pending journey should ship.
  void resetVisibilityState() => _resetScrollState();

  /// Release per-screen buffers. Only Home bloc calls this; LP blocs
  /// share the singleton and must not wipe Home's state.
  ///
  /// The worker's cached components aren't cleared here — the next
  /// screen's `pageComponents = ...` overwrites them, and clearing
  /// them prematurely would drop a legitimate flush if one is still
  /// draining.
  void destroyFromHomeBloc() {
    _resetScrollState();
    sortBarName = AnalyticsDefaults.sortBarAll;
  }

  /// Shared teardown for [resetVisibilityState] + [destroyFromHomeBloc].
  /// Everything wiped here is per-screen scroll state; [pageComponents],
  /// [sortBarName], and attribution snapshots are the caller's problem.
  void _resetScrollState() {
    _scrollPosition?.removeListener(_onScrollDelta);
    _scrollPosition = null;
    _currentlyVisible.clear();
    _snapshotAtDirectionChange = <int>{};
    _lastScrollPixels = 0;
    _lastDirection = _ScrollDir.none;
    _carouselScrollDepth.clear();
    _journey.clear();
    _heroTileJourney.clear();
  }
}

/// Per-screen context. `fromHomePage=false` swaps every event to its
/// `lp_*` variant and seeds `lp_id` / `lp_name`.
class ExtraData {
  const ExtraData({
    this.fromHomePage = true,
    this.landingPageName,
    this.landingPageId,
  });

  final bool fromHomePage;
  final String? landingPageName;
  final String? landingPageId;
}

enum _ScrollDir { none, up, down }
