import 'package:injectable/injectable.dart';

import 'lp_attribution_data.dart';

/// Bounded deque (max 5) of LP clicks — **in-memory only**. Newest at
/// front. Cleared when a funnel-owning shell tab becomes active again
/// (matches Android `CollectionsFragment.onResume` +
/// `BottombarNavigationActivity.onCreate`).
///
/// Each entry stores the opaque merged `trackingMeta` blob from the tile
/// tap made INSIDE an LP, plus the SOURCE LP's name/id from `ExtraData`
/// (the LP the click was made from — matches Android's
/// `LPAttributionHelper.addLPAttributionData` call sites which pass
/// `extraData.landingPageName` / `extraData.landingPageId`).
///
/// Emission maps 5 keys out of the blob + 2 sidecar keys into the 7-key
/// wire format (`lp{n}_slice_id, lp{n}_property_type, lp{n}_banner_name,
/// lp{n}_funnel_row, lp{n}_funnel_tile, lp{n}_name, lp{n}_id`) — one
/// whitelist site, matches Android exactly. Composed with
/// `OrderAttributionHelper.segmentParams` in
/// `AnalyticsHelper._commonEventProperties` (two-store attribution).
@lazySingleton
class LpAttributionHelper {
  LpAttributionHelper();

  static const int _maxEntries = 5;

  final List<LpAttributionEntry> _entries = <LpAttributionEntry>[];

  /// Wipe the deque. Called when Discover becomes active again.
  void clear() => _entries.clear();

  /// Push a new LP visit onto the front of the deque. Evicts the oldest
  /// when at capacity. Called from [HomeTrackAnalyticManager.logTileClick]
  /// when a tile is tapped from within an LP screen.
  void pushTileMeta({
    required Map<String, dynamic> meta,
    String? landingPageName,
    String? landingPageId,
  }) {
    _entries.insert(
      0,
      LpAttributionEntry(
        meta: meta,
        landingPageName: landingPageName,
        landingPageId: landingPageId,
      ),
    );
    if (_entries.length > _maxEntries) _entries.removeLast();
  }

  /// Segment payload — the 7 Android keys per entry. Whitelisted at emit
  /// time; other keys inside `meta` (image_url, action_uri, cbt_id, …) are
  /// intentionally not forwarded to keep the wire format Android-identical.
  ///
  /// **Key coalescing** — some backend components (LP-variant `CustomTiles`)
  /// ship their trackingMeta with `lp_`-prefixed keys (`lp_banner_name`,
  /// `lp_funnel_tile`, …) instead of the plain form. Regular components use
  /// the unprefixed form. Since the merged blob can contain either, we
  /// coalesce — `lp_<key>` first (LP-variant), then `<key>` (regular). This
  /// mirrors Android where the call site EXTRACTS the seven fields per
  /// component type; we normalise at the reader instead.
  Map<String, Object?> get segmentParams {
    if (_entries.isEmpty) return const <String, Object?>{};
    final params = <String, Object?>{};
    for (var i = 0; i < _entries.length; i++) {
      final prefix = 'lp${i + 1}';
      final entry = _entries[i];
      _putIfNotNull(params, '${prefix}_slice_id', _pickLp(entry.meta, 'slice_id'));
      _putIfNotNull(params, '${prefix}_property_type', _pickLp(entry.meta, 'property_type'));
      _putIfNotNull(params, '${prefix}_banner_name', _pickLp(entry.meta, 'banner_name'));
      _putIfNotNull(params, '${prefix}_funnel_row', _pickLp(entry.meta, 'funnel_row'));
      _putIfNotNull(params, '${prefix}_funnel_tile', _pickLp(entry.meta, 'funnel_tile'));
      _putIfNotNull(params, '${prefix}_name', entry.landingPageName);
      _putIfNotNull(params, '${prefix}_id', entry.landingPageId);
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
}
