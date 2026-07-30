import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../attribution/lp_attribution_helper.dart';
import '../attribution/order_attribution_helper.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_events.dart';
import '../constants/analytics_properties.dart';
import '../events/analytics_helper.dart';

/// Per-screen impression / scroll / click tracker for Discover + LP.
/// Fires `tile_impression` / `banner_impression` / `carousel_scrolled` /
/// `tile_clicked` (or their `lp_*` variants when [ExtraData.fromHomePage] is
/// false). Call [destroy] on bloc close.
@lazySingleton
class HomeTrackAnalyticManager {
  HomeTrackAnalyticManager({
    required this.analytics,
    required this.orderAttribution,
    required this.lpAttribution,
  });

  final AnalyticsHelper analytics;
  final OrderAttributionHelper orderAttribution;
  final LpAttributionHelper lpAttribution;

  // ─── State (per screen instance) ────────────────────────────────────

  /// Per-carousel key → captured `trackingMeta` for `carousel_scrolled`.
  /// Key is any stable per-widget identifier (e.g. identityHashCode) —
  /// used only for dedup; `carousel_id` on the wire comes from the value blob.
  final Map<Object, Map<String, dynamic>> _carouselScrollDepth =
      <Object, Map<String, dynamic>>{};

  final Set<int> _currentlyVisible = <int>{};

  /// Items already visible at the last direction change — excluded from
  /// re-fire on the new leg (matches Android per-direction segment start
  /// at `firstVisible - 1` / `lastVisible + 1`).
  Set<int> _snapshotAtDirectionChange = <int>{};

  double _lastScrollPixels = 0;
  _ScrollDir _lastDirection = _ScrollDir.none;
  ScrollPosition? _scrollPosition;

  List<PageComponent> _pageComponents = <PageComponent>[];
  set pageComponents(List<PageComponent> value) {
    _pageComponents = List<PageComponent>.of(value);
  }

  List<PageComponent> get pageComponents =>
      List<PageComponent>.unmodifiable(_pageComponents);

  ExtraData? extraData;
  String sortBarName = AnalyticsDefaults.sortBarAll;

  bool get _fromHomePage => extraData?.fromHomePage ?? true;

  // ─── Impression emission ────────────────────────────────────────────

  /// Idempotent — subscribes the manager to the scrollable's position so
  /// it can pivot the direction-change snapshot.
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
    // Direction changed → snapshot current visible items as "already
    // covered" for the new leg. New impressions on this leg only fire for
    // items NOT in this snapshot (i.e. items that enter the viewport
    // AFTER the direction change).
    _snapshotAtDirectionChange = Set<int>.of(_currentlyVisible);
    _lastDirection = newDir;
  }

  /// Fires an impression when a component enters the viewport, unless it
  /// was already visible at the last direction change.
  ///
  /// Scenario: user scrolls 1→5 forward (fires 1..5), then reverses. Items
  /// 4 and 5 are still in the viewport at the direction change → snapshot
  /// contains {4, 5}. As the user scrolls up, item 5 exits then re-enters
  /// — but 5 is in the snapshot, so no re-fire. Same for 4. Items 3, 2, 1
  /// enter fresh (not in snapshot) → fire. Result: 3, 2, 1 on reverse.
  Future<void> notifyVisible(int index) async {
    if (_currentlyVisible.add(index) == false) return; // already tracked
    if (_snapshotAtDirectionChange.contains(index)) return;
    await _emitImpression(index);
  }

  /// Called when a component drops below the visibility threshold. Later
  /// re-entry (after a direction change) can fire another impression.
  void notifyInvisible(int index) {
    _currentlyVisible.remove(index);
  }

  Future<void> _emitImpression(int index) async {
    if (index < 0 || index >= _pageComponents.length) return;
    final tileEvent = _fromHomePage
        ? AnalyticsEvents.tileImpression
        : AnalyticsEvents.lpTileImpression;
    try {
      final propertyList = _identifyPageComponents(index);
      for (final props in propertyList) {
        await analytics.logEvent(tileEvent, props);
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[HomeTrack] impression emit failed at $index: $e\n$st');
      }
    }
  }

  /// Prefix for LP-variant attribution keys (`lp_funnel_row`, …).
  static const String _lpPrefix = 'lp_';

  // ─── Click tracking ─────────────────────────────────────────────────

  /// Fires `tile_clicked` / `lp_tile_clicked` AND writes attribution to
  /// the appropriate store.
  ///
  /// **HP click** (`_fromHomePage=true`): the tile's merged trackingMeta
  /// merges into `OrderAttributionHelper.trackingMeta` (unprefixed keys
  /// accumulate; last click wins on same-name key).
  ///
  /// **LP click**: the tile's merged trackingMeta gets pushed onto the
  /// `LpAttributionHelper` deque (raw meta preserved; `_pickLp` at emit
  /// time coalesces `lp_<key>` → `<key>` for LP-variant components).
  /// SOURCE LP's identity (`extraData.landingPageName` / `.landingPageId`)
  /// is stamped on the entry. Downstream events pick up the deque via
  /// `_lpAttribution.segmentParams` → `lp1_*` (newest), `lp2_*`, … up to
  /// `lp5_*`. OrderAttribution is untouched, so HP attribution keeps
  /// flowing until a next HP click writes fresh keys.
  Future<void> logTileClick({
    List<Map<String, dynamic>?> trackingMetaChain = const [],
    String? sortBar,
  }) async {
    final merged = <String, dynamic>{};
    for (final meta in trackingMetaChain) {
      if (meta == null || meta.isEmpty) continue;
      merged.addAll(meta);
    }

    if (_fromHomePage) {
      await orderAttribution.mergeTrackingMeta(merged);
    } else {
      await lpAttribution.pushTileMeta(
        meta: merged,
        landingPageName: extraData?.landingPageName,
        landingPageId: extraData?.landingPageId,
      );
    }

    if (sortBar != null && sortBar.isNotEmpty) {
      sortBarName = sortBar;
      await orderAttribution.setSortBar(sortBar);
    }

    // Click event payload: on LP, strip bare `lp_*` from the click's own
    // spread — those keys are LP-variant aliases the deque reads via
    // `_pickLp` and re-emits as `lp1_*`. Keeping bare `lp_*` on the wire
    // too would double-emit alongside `lp1_*`. HP components ship no
    // `lp_*` keys, so strip is a no-op there.
    final clickMeta = _fromHomePage ? merged : _stripLpPrefixed(merged);
    final props = _baseSeed()..addAll(clickMeta);
    final event = _fromHomePage
        ? AnalyticsEvents.tileClicked
        : AnalyticsEvents.lpTileClicked;
    await analytics.logEvent(event, props, attribution: true);
  }

  /// Wipe the LP attribution deque. Called when Discover becomes active
  /// again (cold start, tab-tap-to-Discover, back-nav from LP depth N).
  Future<void> clearLpAttribution() => lpAttribution.clear();

  // ─── Carousel scroll ────────────────────────────────────────────────

  /// Records the most-recent horizontal scroll state for a carousel. Last-
  /// write-wins per [carouselKey] — subsequent ticks overwrite. Batched;
  /// events flush on [flushCarouselScrolls].
  ///
  /// [carouselKey] is any stable per-carousel identifier for dedup within
  /// the screen session (e.g. `identityHashCode(carouselData)`). The wire
  /// `carousel_id` comes from the [trackingMeta] blob, not from this key.
  void logCarouselScrolled(Object carouselKey, Map<String, dynamic> trackingMeta) {
    _carouselScrollDepth[carouselKey] = trackingMeta;
  }

  /// Drain the carousel-scroll buffer into `carousel_scrolled` /
  /// `lp_carousel_scrolled` events. Called on bloc close.
  Future<void> flushCarouselScrolls() async {
    if (_carouselScrollDepth.isEmpty) return;
    final carouselEvent = _fromHomePage
        ? AnalyticsEvents.carouselScrolled
        : AnalyticsEvents.lpCarouselScrolled;
    for (final entry in _carouselScrollDepth.entries) {
      final props = _baseSeed();
      _mergeTrackingMeta(props, entry.value);
      await analytics.logEvent(carouselEvent, props);
    }
    _carouselScrollDepth.clear();
  }

  /// Fires the single `banner_impression` (once per component) and returns
  /// the list of `tile_impression` payloads for each innermost leaf.
  ///
  /// - Banner: seed + root `trackingMeta`.
  /// - Tile: seed + every `trackingMeta` on the root→leaf chain (deepest wins),
  ///   one impression per innermost tile.
  ///
  /// Client owns only the seed (`funnel`, `type`, `position`); everything else
  /// is verbatim from `trackingMeta`.
  List<Map<String, Object?>> _identifyPageComponents(int index) {
    if (index < 0 || index >= _pageComponents.length) return const [];
    final component = _pageComponents[index];
    if (component.type.isEmpty) return const [];
    final data = component.data;
    if (data == null) return const [];
    final tilePath = _tilePaths[component.type];
    if (tilePath == null) return const [];

    final rootMeta = data['trackingMeta'];
    final rootMetaMap = rootMeta is Map<String, dynamic>
        ? rootMeta
        : const <String, dynamic>{};

    // Banner impression (once per component): seed + root trackingMeta.
    final banner = _seedProps(component);
    _mergeTrackingMeta(banner, rootMetaMap);
    final bannerEvent = _fromHomePage
        ? AnalyticsEvents.bannerImpression
        : AnalyticsEvents.lpBannerImpression;
    unawaited(analytics.logEvent(bannerEvent, banner));

    // Tile impressions (one per leaf): seed + full trackingMeta chain.
    final result = <Map<String, Object?>>[];
    for (final chain in _walkTileChains(data, tilePath)) {
      final props = _seedProps(component);
      for (final meta in chain) {
        _mergeTrackingMeta(props, meta);
      }
      result.add(props);
    }
    return result;
  }

  /// Per-impression seed: `type` + `position` + [_baseSeed].
  Map<String, Object?> _seedProps(PageComponent component) {
    final seed = _baseSeed();
    seed[AnalyticsProperties.type] = component.type;
    seed[AnalyticsProperties.position] = component.position;
    return seed;
  }

  /// Shared base: `sortbar` always; `funnel = Discover` on home;
  /// `lp_id` / `lp_name` + captured attribution snapshot on LP.
  Map<String, Object?> _baseSeed() {
    final seed = <String, Object?>{
      AnalyticsProperties.sortbar: sortBarName,
    };
    if (_fromHomePage) {
      seed[AnalyticsProperties.funnel] = AnalyticsDefaults.discover;
      return seed;
    }
    seed['$_lpPrefix${AnalyticsProperties.id}'] = extraData?.landingPageId;
    seed['$_lpPrefix${AnalyticsProperties.name}'] = extraData?.landingPageName;
    return seed;
  }

  /// Per-type path descriptor for [_walkTileChains]. Each step is a list of
  /// alternate JSON keys (accept both camelCase + snake_case). The last
  /// entry is the innermost tile level. Deeper `trackingMeta` wins.
  static const Map<String, List<List<String>>> _tilePaths = {
    PageComponentType.hero: [
      ['tiles'],
      ['tile_details', 'tileDetails'],
      ['tileGrid'],
    ],
    PageComponentType.customTiles: [
      ['tiles', 'tile_details', 'tileDetails'],
      ['tileGrid'],
    ],
    PageComponentType.pageCarousel: [
      ['tiles'],
    ],
    PageComponentType.productGrid: [
      ['tiles'],
    ],
  };

  /// Yields root-first chains of `trackingMeta` per innermost leaf. At the
  /// leaf, absorbs `trackingMeta` from immediate Map children too (e.g.
  /// `tile.product.trackingMeta`) but not from intermediate-level peers
  /// like `ctaButton` / `title` (those own their own analytics).
  Iterable<List<Map<String, dynamic>>> _walkTileChains(
    Map<String, dynamic> data,
    List<List<String>> path,
  ) sync* {
    final chain = <Map<String, dynamic>>[];
    final selfMeta = data['trackingMeta'];
    if (selfMeta is Map<String, dynamic>) chain.add(selfMeta);

    if (path.isEmpty) {
      for (final entry in data.entries) {
        if (entry.key == 'trackingMeta') continue;
        final v = entry.value;
        if (v is Map<String, dynamic>) {
          final childMeta = v['trackingMeta'];
          if (childMeta is Map<String, dynamic>) chain.add(childMeta);
        }
      }
      yield chain;
      return;
    }

    final keys = path.first;
    final rest = path.sublist(1);
    List<dynamic>? list;
    for (final k in keys) {
      final v = data[k];
      if (v is List) {
        list = v;
        break;
      }
    }
    if (list == null) return;
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      for (final subChain in _walkTileChains(item, rest)) {
        yield <Map<String, dynamic>>[...chain, ...subChain];
      }
    }
  }

  /// Verbatim merge — backend keys win over anything already in `target`.
  /// Used by impression + scroll paths: LP-variant components ship keys like
  /// `lp_banner_name` as their per-tile trackingMeta, which are the wire
  /// keys for `lp_tile_impression` / `lp_banner_impression`. Stripping them
  /// here would zero out the impression payload.
  void _mergeTrackingMeta(
    Map<String, Object?> target,
    Map<String, dynamic>? trackingMeta,
  ) {
    if (trackingMeta == null || trackingMeta.isEmpty) return;
    target.addAll(trackingMeta);
  }

  /// Returns a copy of `meta` without any `lp_*`-prefixed keys. Used only in
  /// the CLICK path — once a tile is tapped in an LP, its `lp_*` keys have
  /// been "promoted" onto the LP-attribution deque and will emit as
  /// `lp1_*` / `lp2_*` on subsequent events. Leaving the bare `lp_*` on
  /// the click event too would double-count them on the wire. This also
  /// gets stored in `OrderAttributionHelper.trackingMeta` so downstream
  /// events (PDP / ATC / checkout) inherit the clean shape.
  static Map<String, dynamic> _stripLpPrefixed(Map<String, dynamic> meta) {
    final out = <String, dynamic>{};
    for (final entry in meta.entries) {
      if (entry.key.startsWith(_lpPrefix)) continue;
      out[entry.key] = entry.value;
    }
    return out;
  }

  // ─── Cleanup ────────────────────────────────────────────────────────

  /// Clear the per-screen visibility/scroll bookkeeping (visible set,
  /// direction-change snapshot, carousel scroll depth) without touching
  /// [pageComponents], [extraData], attribution snapshots, or sortbar name.
  ///
  /// Called by `AppNavigationObserver` on funnel switch so the incoming
  /// screen starts with a fresh impression-tracking slate. `pageComponents`
  /// is intentionally preserved — the incoming screen re-sets it before
  /// its widgets fire `notifyVisible`.
  void resetVisibilityState() {
    _scrollPosition?.removeListener(_onScrollDelta);
    _scrollPosition = null;
    _currentlyVisible.clear();
    _snapshotAtDirectionChange = <int>{};
    _lastScrollPixels = 0;
    _lastDirection = _ScrollDir.none;
    _carouselScrollDepth.clear();
  }

  /// Release per-screen buffers. Call from the bloc's `close` **when the
  /// owning screen actually goes away** — i.e. `HomeBloc.close`. Landing
  /// pages must NOT call this: the tracker is a shared singleton and LP's
  /// destroy would wipe Home's state (`pageComponents`, `sortBarName`),
  /// silencing Home's impressions on back-nav.
  void destroyFromHomeBloc() {
    _scrollPosition?.removeListener(_onScrollDelta);
    _scrollPosition = null;
    _currentlyVisible.clear();
    _snapshotAtDirectionChange = <int>{};
    _lastScrollPixels = 0;
    _lastDirection = _ScrollDir.none;
    _pageComponents = <PageComponent>[];
    _carouselScrollDepth.clear();
    sortBarName = AnalyticsDefaults.sortBarAll;
  }
}

/// Per-screen context. `fromHomePage=false` swaps every event to its
/// `lp_*` variant and seeds `lp_id` / `lp_name`.
class ExtraData {
  const ExtraData({
    this.fromHomePage = true,
    this.landingPageName,
    this.landingPageId,
    this.funnelSection,
  });

  final bool fromHomePage;
  final String? landingPageName;
  final String? landingPageId;
  final String? funnelSection;
}

/// Vertical scroll direction. First non-`none` transition triggers a
/// direction-change snapshot.
enum _ScrollDir { none, up, down }
