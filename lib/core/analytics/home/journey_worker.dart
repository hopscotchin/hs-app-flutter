import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../features/discover/data/models/component_models.dart';
import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_events.dart';
import '../constants/analytics_properties.dart';
import '../events/analytics_helper.dart';
import 'home_component_click_handlers.dart';

/// Turns the impression journey (a set of visible-component indices
/// collected on the scroll frame) into enriched Segment
/// `banner_impression` events.
///
/// Emission rules:
/// - Hero → one `banner_impression` per tile the user ACTUALLY saw. The
///   Hero widget records tile visibility on VisibilityDetector edges +
///   `onPageChanged`; only recorded (component-index, tile-index) pairs
///   emit — a full-width Hero carousel shows one tile at a time, so
///   emitting all `hero.tiles` when the outer widget crossed the
///   visibility threshold vastly over-reported.
/// - CustomTiles / PageCarousel / ProductGrid → one `banner_impression`
///   per component (root trackingMeta only).
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
    required Map<int, List<int>> heroTiles,
    required JourneySeed seed,
  }) async {
    if (_components.isEmpty) return;
    if (indices.isEmpty && heroTiles.isEmpty) return;
    final events = buildImpressions(_components, indices, heroTiles, seed);
    await Future.wait(
      events.map((entry) => _analytics.logEvent(entry.$1, entry.$2, attribution: !seed.fromHomePage)),
    );
  }
}

// ─── Pure builders (shared with the isolate worker) ───────────────────

/// Compact the live entity list down to the fields the impression builder
/// reads. Also drops components whose `type` isn't tracked as an impression
/// (CTA_BUTTON, etc.) — they wouldn't emit anyway, and dropping them here
/// shrinks the isolate transfer payload.
List<ComponentSnapshot> snapshotComponents(List<PageComponent> components) {
  final out = <ComponentSnapshot>[];
  for (final c in components) {
    if (c.type.isEmpty || c.data == null) continue;
    if (!impressionTypes.contains(c.type)) continue;
    out.add((type: c.type, position: c.position, data: c.data!));
  }
  return out;
}

/// Component types that emit `banner_impression` events.
const Set<String> impressionTypes = <String>{
  PageComponentType.hero,
  PageComponentType.customTiles,
  PageComponentType.pageCarousel,
  PageComponentType.productGrid,
};

/// Build every enriched event for the given [indices]. Pure — no
/// analytics-helper access, no globals; can run on any isolate.
///
/// Hero emits one `banner_impression` PER tile (root + tile meta merged);
/// every other component emits one `banner_impression` at the root level.
/// `tile_impression` was retired — it doubled up with banner_impression on
/// the wire and no dashboard consumed it separately.
List<EmitEntry> buildImpressions(
  List<ComponentSnapshot> snapshots,
  List<int> indices,
  Map<int, List<int>> heroTiles,
  JourneySeed seed,
) {
  final out = <EmitEntry>[];
  final bannerEvent = seed.fromHomePage
      ? AnalyticsEvents.bannerImpression
      : AnalyticsEvents.lpBannerImpression;

  for (final i in indices) {
    if (i < 0 || i >= snapshots.length) continue;
    final snap = snapshots[i];
    // Hero is per-tile — emitted from `heroTiles` below. Component-level
    // visibility is not sufficient because only one tile is visible at a
    // time in the carousel.
    if (snap.type == PageComponentType.hero) continue;

    final rootMeta = snap.data['trackingMeta'];
    final rootMetaMap = rootMeta is Map<String, dynamic>
        ? rootMeta
        : const <String, dynamic>{};
    final props = buildSeed(snap, seed);
    mergeMetaNonNull(props, rootMetaMap);
    out.add((bannerEvent, props));
  }

  heroTiles.forEach((componentIndex, tileIndices) {
    if (componentIndex < 0 || componentIndex >= snapshots.length) return;
    final snap = snapshots[componentIndex];
    if (snap.type != PageComponentType.hero) return;
    // Reuse the click-path chain builder — same code path for both events,
    // no separate JSON walker to keep in sync with entity fields.
    final hero = ComponentDataParser.parseHero(snap.data);
    for (final tileIndex in tileIndices) {
      if (tileIndex < 0 || tileIndex >= hero.tiles.length) continue;
      final tile = hero.tiles[tileIndex];
      final props = buildSeed(snap, seed);
      for (final meta in heroTileTrackingMetaChain(hero, tile)) {
        if (meta == null) continue;
        mergeMetaNonNull(props, meta);
      }
      out.add((bannerEvent, props));
    }
  });

  return out;
}

/// Merge [meta] into [into], skipping null values. `addAll` overwrites with
/// nulls; a deeper level's null shouldn't wipe a parent's non-null value —
/// that's how the wire ended up shipping bare nulls for keys the backend
/// only set on some levels.
void mergeMetaNonNull(
  Map<String, Object?> into,
  Map<String, dynamic> meta,
) {
  for (final entry in meta.entries) {
    if (entry.value == null) continue;
    into[entry.key] = entry.value;
  }
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

