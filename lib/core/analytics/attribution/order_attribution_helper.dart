import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../services/pref_manager.dart';
import '../constants/analytics_properties.dart';
import 'attribution_data.dart';

/// Disk-backed HP-attribution slice. Persists across navigation until
/// either a next HP tile click overwrites specific keys via
/// [mergeTrackingMeta] or the whole record is dropped ([clear]) on cold
/// start / logout.
///
/// **Scope:** HP click chain only. LP click chain lives in
/// `LpAttributionHelper` (deque, emits `lp{n}_*`). Two stores compose
/// their `segmentParams` inside `AnalyticsHelper._commonEventProperties`
/// so events on the wire carry the union.
///
/// **Invariant:** `trackingMeta` is stored opaque — the client never
/// reads keys from it. Only client-owned fields (funnel, sortbar) live
/// as typed setters.
@lazySingleton
class OrderAttributionHelper {
  OrderAttributionHelper(this._prefs);

  final PrefManager _prefs;

  AttributionData? _cached;
  bool _cacheHydrated = false;

  AttributionData? getCurrent() {
    if (_cacheHydrated) return _cached;
    _cacheHydrated = true;
    final raw = _prefs.currentAttributionData;
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _cached = AttributionData.fromJson(decoded);
      }
    } catch (_) {
      // corrupt blob — treat as empty
    }
    return _cached;
  }

  Future<void> setCurrent(AttributionData data) async {
    _cached = data;
    _cacheHydrated = true;
    try {
      await _prefs.setCurrentAttributionData(jsonEncode(data.toJson()));
    } catch (_) {
      await _prefs.setCurrentAttributionData('');
    }
  }

  Future<void> clear() {
    _cached = null;
    _cacheHydrated = true;
    return _prefs.setCurrentAttributionData('');
  }

  /// **HP tile click.** Merge the tile's innermost trackingMeta into the
  /// accumulated attribution — new keys shadow prior same-name keys; other
  /// keys persist. Only called for `_fromHomePage=true` clicks.
  Future<AttributionData> mergeTrackingMeta(Map<String, dynamic> partial) async {
    if (partial.isEmpty) return getCurrent() ?? AttributionData.empty();
    final data = (getCurrent() ?? AttributionData.empty()).mergeTrackingMeta(partial);
    await setCurrent(data);
    return data;
  }

  /// Update the funnel identity (`Discover`, `Search`, `Cart`, …). Does
  /// NOT clear `trackingMeta` — HP attribution persists across funnel
  /// switch. LP click chain clearing is `LpAttributionHelper.clear`'s job.
  Future<AttributionData> setFunnel(String funnel) async {
    final data = (getCurrent() ?? AttributionData.empty()).applyFunnel(funnel);
    await setCurrent(data);
    return data;
  }

  Future<AttributionData> setSortBar(String sortBar) async {
    final data = (getCurrent() ?? AttributionData.empty()).applySortBar(sortBar);
    await setCurrent(data);
    return data;
  }

  /// HTTP request-body keys for ATC / wishlist-add / cart-update. Server
  /// accepts the trackingMeta snake_case keys back verbatim.
  Map<String, Object?> get requestParams {
    final data = getCurrent();
    if (data == null) return const <String, Object?>{};
    final params = <String, Object?>{...data.trackingMeta};
    if (_nonEmpty(data.funnel)) params[AnalyticsProperties.funnel] = data.funnel;
    if (_nonEmpty(data.sortBar)) params[AnalyticsProperties.sortbar] = data.sortBar;
    return params;
  }

  /// Segment event-payload keys. Merged into events fired with `attribution: true`.
  Map<String, Object?> get segmentParams {
    final data = getCurrent();
    if (data == null) return const <String, Object?>{};
    final params = <String, Object?>{...data.trackingMeta};
    if (_nonEmpty(data.funnel)) params[AnalyticsProperties.funnel] = data.funnel;
    if (_nonEmpty(data.sortBar)) params[AnalyticsProperties.sortbar] = data.sortBar;
    return params;
  }

  static bool _nonEmpty(String? s) => s != null && s.isNotEmpty;
}
