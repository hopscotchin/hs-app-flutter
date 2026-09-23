import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_events.dart';
import '../constants/analytics_properties.dart';
import '../events/analytics_helper.dart';

/// Turns the impression journey (a set of visible-component indices
/// collected on the scroll frame) into enriched Segment
/// `tile_impression` / `banner_impression` events.
///
/// Runs on the main isolate; every event goes through the injected
/// [AnalyticsHelper] — the same code path every other single-event
/// caller (PLP click, PDP view, wishlist toggle) already uses. QA has
/// validated that path end-to-end.
///
/// Immutable per-flush context — every field is captured on the main
/// isolate at [JourneyWorker.flushImpressions] call time and travels
/// with the message. Record type = cheap to send across isolate ports.
typedef JourneySeed = ({
  bool fromHomePage,
  String sortBarName,
  String? landingPageId,
  String? landingPageName,
});

/// Isolate-transferable projection of a [PageComponent] — just the raw
/// JSON blob + type + position. `parsedData` is intentionally omitted
/// (the walk only reads `data`).
typedef ComponentSnapshot = ({
  String type,
  int position,
  Map<String, dynamic> data,
});

/// One dispatched event ready for `AnalyticsHelper.logEvent` /
/// `_segment.track`: the event name plus its fully assembled props map.
typedef EmitEntry = (String event, Map<String, Object?> props);

/// LP-variant prefix. Shared with the click path in
/// `HomeTrackAnalyticManager`. Kept top-level so both isolate sides can
/// see the same constant.
const String lpPrefix = 'lp_';

// ─── Inline implementation (tests + main-isolate fallback) ────────────

@lazySingleton
class JourneyWorker {
  JourneyWorker(this._analytics);

  final AnalyticsHelper _analytics;
  List<ComponentSnapshot> _components = const <ComponentSnapshot>[];

  /// Ship the latest raw page components to the worker. Called at data
  /// load / pagination / refresh — the user is already in a loading
  /// state, so any per-call cost is masked. Held until the next call
  /// replaces the snapshot.
  Future<void> setComponents(List<PageComponent> components) async {
    _components = snapshotComponents(components);
  }

  /// Walk the cached snapshot at [indices], build every enriched event,
  /// dispatch each to Segment via [AnalyticsHelper]. The [seed] captures
  /// tracker state (sortbar, HP/LP flag, LP identity) at flush time so
  /// state changes between call and dispatch can't mis-attribute events.
  ///
  /// `Future.wait` so the returned future resolves only after every
  /// event has been handed to the transport — tests assert right after
  /// `await flushJourney()`, and `HomeBloc.close` avoids a race between
  /// destroy and dispatch.
  Future<void> flushImpressions({
    required List<int> indices,
    required JourneySeed seed,
  }) async {
    if (indices.isEmpty || _components.isEmpty) return;
    final events = buildImpressions(_components, indices, seed);
    await Future.wait(
      events.map((entry) => _analytics.logEvent(entry.$1, entry.$2)),
    );
  }
}

// ─── Pure builders (shared with the isolate worker) ───────────────────

/// Compact the live entity list down to the fields the walk actually
/// reads. Also drops components whose `type` has no walk descriptor —
/// they wouldn't produce impressions anyway, and dropping them here
/// shrinks the isolate transfer payload.
List<ComponentSnapshot> snapshotComponents(List<PageComponent> components) {
  final out = <ComponentSnapshot>[];
  for (final c in components) {
    if (c.type.isEmpty || c.data == null) continue;
    if (!tilePaths.containsKey(c.type)) continue;
    out.add((type: c.type, position: c.position, data: c.data!));
  }
  return out;
}

/// Build every enriched event for the given [indices]. Pure — no
/// analytics-helper access, no globals; can run on any isolate.
List<EmitEntry> buildImpressions(
  List<ComponentSnapshot> snapshots,
  List<int> indices,
  JourneySeed seed,
) {
  final out = <EmitEntry>[];
  final bannerEvent = seed.fromHomePage
      ? AnalyticsEvents.bannerImpression
      : AnalyticsEvents.lpBannerImpression;
  final tileEvent = seed.fromHomePage
      ? AnalyticsEvents.tileImpression
      : AnalyticsEvents.lpTileImpression;

  for (final i in indices) {
    if (i < 0 || i >= snapshots.length) continue;
    final snap = snapshots[i];
    final path = tilePaths[snap.type];
    if (path == null) continue;

    final rootMeta = snap.data['trackingMeta'];
    final rootMetaMap = rootMeta is Map<String, dynamic>
        ? rootMeta
        : const <String, dynamic>{};

    final banner = buildSeed(snap, seed);
    if (rootMetaMap.isNotEmpty) banner.addAll(rootMetaMap);
    out.add((bannerEvent, banner));

    for (final chain in _walkTileChains(snap.data, path)) {
      final props = buildSeed(snap, seed);
      for (final meta in chain) {
        props.addAll(meta);
      }
      out.add((tileEvent, props));
    }
  }
  return out;
}

/// Per-impression seed: shared base (funnel/sortbar OR lp_id/lp_name)
/// plus the component's `type` + `position`. Same shape both isolates
/// need for both banner and tile events.
Map<String, Object?> buildSeed(ComponentSnapshot snap, JourneySeed seed) {
  final out = buildBaseSeed(
    fromHomePage: seed.fromHomePage,
    sortBarName: seed.sortBarName,
    landingPageId: seed.landingPageId,
    landingPageName: seed.landingPageName,
  );
  out[AnalyticsProperties.type] = snap.type;
  out[AnalyticsProperties.position] = snap.position;
  return out;
}

/// Shared base used by the impression builder AND by the click / carousel
/// paths on the main isolate. HP flavour stamps `funnel = Discover`; LP
/// flavour stamps `lp_id` / `lp_name` — never both (`funnel` on LP would
/// mis-classify the event as HP).
Map<String, Object?> buildBaseSeed({
  required bool fromHomePage,
  required String sortBarName,
  String? landingPageId,
  String? landingPageName,
}) {
  final seed = <String, Object?>{
    AnalyticsProperties.sortbar: sortBarName,
  };
  if (fromHomePage) {
    seed[AnalyticsProperties.funnel] = AnalyticsDefaults.discover;
    return seed;
  }
  seed['$lpPrefix${AnalyticsProperties.id}'] = landingPageId;
  seed['$lpPrefix${AnalyticsProperties.name}'] = landingPageName;
  return seed;
}

/// Strip any `lp_*`-prefixed keys. Used only on the CLICK path — once an
/// LP tile is tapped, its `lp_*` keys are promoted onto the LP-attribution
/// deque and re-emitted as `lp1_*` / `lp2_*`. Leaving the bare `lp_*` on
/// the click event too would double-count on the wire.
Map<String, dynamic> stripLpPrefixed(Map<String, dynamic> meta) {
  final out = <String, dynamic>{};
  for (final entry in meta.entries) {
    if (entry.key.startsWith(lpPrefix)) continue;
    out[entry.key] = entry.value;
  }
  return out;
}

// ─── Walk internals ───────────────────────────────────────────────────

/// Per-type walk descriptor. Each step is a list of alternate JSON keys
/// (accept both camelCase and snake_case). Last entry is the innermost
/// tile level; deeper `trackingMeta` wins.
const Map<String, List<List<String>>> tilePaths = {
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
