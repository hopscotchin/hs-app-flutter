import 'package:injectable/injectable.dart';

import 'attribution_store.dart';
import 'lp_attribution_data.dart';

/// Bounded stack (max 5) of LP visits — **in-memory only**. Emission is
/// **reverse-chronological and compacted**: `lp1_*` = the most recent
/// click, `lp2_*` = the one before, and so on. Ungated slots (a freshly
/// pushed LP that hasn't been clicked in yet) are skipped from numbering
/// so `lp1_*` is always the actual last-click's data — matches Android's
/// wire format and every LP dashboard.
///
/// The INTERNAL storage stays chronological — `_entries[0]` is the oldest
/// live visit, `_entries.last` is the current LP — so `pushLp` / `popTop` /
/// `updateTopMeta` work naturally against the stack top. The reversal
/// (and the compaction over gated slots) happens only at emit time in
/// [segmentParams].
///
/// Lifecycle per LP visit — driven by [AppNavigationObserver]:
///   * `didPush` LP route → [pushLp] a fresh entry on top (identity blank).
///   * `LandingPageBloc.setLandingPageContext` → [updateTopIdentity] stamps
///     name/id on the top entry once the LP response arrives.
///   * Tile tap inside the LP → [updateTopMeta] overwrites the top's meta.
///     A second tap in the same LP replaces the first — the slot holds
///     the *most recent* click made from that LP.
///   * `didPop` LP route → [popTop] removes the top entry.
///
/// Trace — journey `LP1 → LP2 → LP3` (each click activates its slot),
/// then land on LP4 (no click yet):
///   internal: `[LP1, LP2, LP3, LP4(empty)]`
///   wire:     `lp1_* = LP3 · lp2_* = LP2 · lp3_* = LP1`
///   (LP4's empty top slot is skipped from numbering so LP3 — the actual
///   last click — sits at `lp1_*`, not `lp2_*`.)
///
/// Emission maps 5 keys out of each entry's blob + 2 sidecar keys into the
/// 7-key wire format (`lp{n}_slice_id, lp{n}_property_type, lp{n}_banner_name,
/// lp{n}_funnel_row, lp{n}_funnel_tile, lp{n}_name, lp{n}_id`). Composed
/// with `OrderAttributionHelper.segmentParams` in
/// `AnalyticsHelper._commonEventProperties` (two-store attribution).
@lazySingleton
class LpAttributionHelper implements AttributionStore {
  LpAttributionHelper();

  static const int _maxEntries = 5;

  final List<LpAttributionEntry> _entries = <LpAttributionEntry>[];

  /// Wipe the stack. Called when Discover becomes active again.
  void clear() => _entries.clear();

  /// Push a fresh LP visit as the new top. Identity fills in later via
  /// [updateTopIdentity] when the LP response lands; meta fills in via
  /// [updateTopMeta] on the first tile tap made from inside this LP.
  ///
  /// Optional identity args are for tests and defensive call sites — the
  /// production caller (`AppNavigationObserver.didPush`) pushes bare.
  ///
  /// Evicts the OLDEST (bottom) entry once the stack exceeds [_maxEntries]
  /// so the top always reflects the current LP.
  void pushLp({String? landingPageName, String? landingPageId}) {
    _entries.add(LpAttributionEntry(
      landingPageName: landingPageName,
      landingPageId: landingPageId,
    ));
    if (_entries.length > _maxEntries) _entries.removeAt(0);
  }

  /// Pop the top LP entry — on back nav out of an LP. No-ops when empty
  /// (defensive: a stray `didPop` after clear should not throw).
  void popTop() {
    if (_entries.isEmpty) return;
    _entries.removeLast();
  }

  /// Stamp the top entry's LP identity — called from
  /// `AppNavigationObserver.setLandingPageContext` once the LP response
  /// arrives with the name/id. No-op if the stack is empty (a defensive
  /// safeguard mirroring the observer's own defensive push).
  void updateTopIdentity({String? landingPageName, String? landingPageId}) {
    if (_entries.isEmpty) return;
    _entries[_entries.length - 1] = _entries.last.copyWith(
      landingPageName: landingPageName,
      landingPageId: landingPageId,
    );
  }

  /// Replace the top entry's meta with the merged tile-click blob —
  /// called from `HomeTrackAnalyticManager.logTileClick` on a click made
  /// from within an LP. Subsequent clicks in the same LP overwrite (the
  /// slot always shows the LATEST click made from that LP).
  void updateTopMeta(Map<String, dynamic> meta) {
    if (_entries.isEmpty) return;
    _entries[_entries.length - 1] = _entries.last.copyWith(meta: meta);
  }

  /// Segment payload — 7 Android keys per activated entry,
  /// **reverse-chronological and compacted**: `lp1_*` = the most recent
  /// click (regardless of which slot in the stack it lives in), `lp2_*` =
  /// second-most-recent, and so on. Ungated slots (current LP freshly
  /// opened but not yet clicked in) are SKIPPED from numbering so `lp1_*`
  /// is always the actual last-click's data — never absent because the
  /// user just landed somewhere new.
  ///
  /// Whitelisted at emit time; other keys inside `meta` (image_url,
  /// action_uri, cbt_id, …) are intentionally not forwarded to keep the
  /// wire format Android-identical.
  ///
  /// **Activation gate** — an entry contributes nothing until its meta is
  /// non-empty. Interpretation: `lp{n}_*` names the click CHAIN, not the
  /// current screen. A fresh LP push (didPush) reserves a slot but the
  /// click that "activates" it hasn't happened yet. Because we compact,
  /// the not-yet-activated top just "disappears" from the wire and every
  /// activated slot below shifts up one position — an activated LP is
  /// always at `lp1_*`, whether or not the user has since landed on a
  /// fresh LP that hasn't received a click yet.
  ///
  /// **Key coalescing** — some backend components (LP-variant `CustomTiles`)
  /// ship their trackingMeta with `lp_`-prefixed keys (`lp_banner_name`,
  /// `lp_funnel_tile`, …) instead of the plain form. Regular components use
  /// the unprefixed form. Since the merged blob can contain either, we
  /// coalesce — `lp_<key>` first (LP-variant), then `<key>` (regular).
  Map<String, Object?> get segmentParams {
    if (_entries.isEmpty) return const <String, Object?>{};
    final params = <String, Object?>{};
    // Walk newest → oldest and assign `lp1_`, `lp2_`, … only to entries
    // that have meta. Empty-meta slots (the "reserved but not clicked in"
    // state) are skipped without consuming a wire index — so the FIRST
    // activated slot from the top always emits as `lp1_*`.
    var wireIndex = 1;
    for (var i = _entries.length - 1; i >= 0; i--) {
      final entry = _entries[i];
      if (entry.meta.isEmpty) continue;
      final prefix = 'lp$wireIndex';
      _putIfNotNull(params, '${prefix}_slice_id', _pickLp(entry.meta, 'slice_id'));
      _putIfNotNull(params, '${prefix}_property_type', _pickLp(entry.meta, 'property_type'));
      _putIfNotNull(params, '${prefix}_banner_name', _pickLp(entry.meta, 'banner_name'));
      _putIfNotNull(params, '${prefix}_funnel_row', _pickLp(entry.meta, 'funnel_row'));
      _putIfNotNull(params, '${prefix}_funnel_tile', _pickLp(entry.meta, 'funnel_tile'));
      _putIfNotNull(params, '${prefix}_name', entry.landingPageName);
      _putIfNotNull(params, '${prefix}_id', entry.landingPageId);
      wireIndex++;
    }
    return params;
  }

  /// Coalesces `lp_<key>` (LP-variant components) with `<key>` (regular).
  /// Returns whichever is non-null, `lp_`-prefixed first.
  static Object? _pickLp(Map<String, dynamic> meta, String key) {
    final prefixed = meta['lp_$key'];
    if (prefixed != null) return prefixed;
    return meta[key];
  }

  /// Skips null values entirely — LP attribution keys with no source value
  /// stay absent from the wire rather than shipping as `"lp1_banner_name":
  /// null`. Nulls on the wire poison dashboards (bucketed as "unknown").
  static void _putIfNotNull(Map<String, Object?> target, String key, Object? value) {
    if (value == null) return;
    target[key] = value;
  }

  /// Order-time enrichment. Reads server-echoed `lp{n}_*` fields off the
  /// per-item cart tracking blob (different envelope from `trackingMeta` —
  /// this is a first-class server-response contract).
  Map<String, Object?> fillWithTrackingData(Map<String, Object?> trackingData) {
    final result = <String, Object?>{};
    for (var n = 1; n <= _maxEntries; n++) {
      final id = trackingData['lp${n}_id'];
      if (id == null || id.toString().isEmpty) continue;
      final prefix = 'lp$n';
      result['${prefix}_slice_id'] = trackingData['lp${n}_slice_id'];
      result['${prefix}_property_type'] = trackingData['lp${n}_property_type'];
      result['${prefix}_banner_name'] = trackingData['lp${n}_banner_name'];
      result['${prefix}_funnel_row'] = trackingData['lp${n}_funnel_row'];
      result['${prefix}_funnel_tile'] = trackingData['lp${n}_funnel_tile'];
      result['${prefix}_name'] = trackingData['lp${n}_name'];
      result['${prefix}_id'] = id;
    }
    return result;
  }

  @override
  Object? snapshot() => List<LpAttributionEntry>.of(_entries);

  @override
  void restore(Object? snapshot) {
    final restored = snapshot as List<LpAttributionEntry>?;
    _entries
      ..clear()
      ..addAll(restored ?? const <LpAttributionEntry>[]);
  }
}