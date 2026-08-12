import 'package:injectable/injectable.dart';

import '../constants/analytics_properties.dart';
import '../constants/funnel.dart';
import 'attribution_data.dart';

/// HP-attribution slice — **in-memory only**. Lives for the app session;
/// wiped on process death. Cross-session attribution is server-side (the
/// cart API echoes the HP click's tracking blob), so persisting client-side
/// bought us nothing and cost a `SharedPreferences` MethodChannel roundtrip
/// on every hot-path write.
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
  OrderAttributionHelper();

  AttributionData? _cached;

  AttributionData? getCurrent() => _cached;

  void clear() => _cached = null;

  /// **HP tile click.** Wipes the prior click's `trackingMeta` and installs
  /// [partial] as the new blob. Funnel + sortBar (screen-level) are
  /// preserved.
  ///
  /// Why replace, not merge: the map is opaque, so a key absent in
  /// [partial] is indistinguishable from a key the backend intentionally
  /// omitted. Merging preserves stale keys from the previous tile —
  /// e.g. Hero ships `{banner_name, funnel_row, funnel_tile, slice_id}`,
  /// CustomTile ships `{banner_name, funnel_row}`, and post-merge the
  /// CustomTile click looks like it carried Hero's `funnel_tile` +
  /// `slice_id` on the wire.
  AttributionData replaceTrackingMeta(Map<String, dynamic> partial) {
    final base = _cached ?? AttributionData.empty();
    final data = base.copyWith(
      trackingMeta: Map<String, dynamic>.of(partial),
    );
    _cached = data;
    return data;
  }

  /// Additive-merge variant — last-write-wins on collision,
  /// preserve-on-absence. Kept for non-hot-path callers (server-side
  /// trait patches, backfills). **Do not use on the HP click hot path
  /// — that's [replaceTrackingMeta].**
  AttributionData mergeTrackingMeta(Map<String, dynamic> partial) {
    if (partial.isEmpty) return _cached ?? AttributionData.empty();
    final data =
        (_cached ?? AttributionData.empty()).mergeTrackingMeta(partial);
    _cached = data;
    return data;
  }

  /// Building a fresh `AttributionData` (rather than field-by-field
  /// clearing) is deliberate: if `AttributionData` grows a new field
  /// later (any new session-scoped attribution key), it gets defaulted
  /// automatically on funnel change — no per-field wipe list to remember
  /// to update.
  ///
  /// LP chain clearing on back-to-shell is `LpAttributionHelper.clear`'s
  /// job, not this method's.
  void setFunnel(Funnel funnel) {
    if (_cached?.funnel == funnel.wire) return;
    // Reset every field — keep only the new funnel. See method docstring.
    _cached = AttributionData.empty().applyFunnel(funnel.wire);
  }

  void setSortBar(String sortBar) {
    _cached = (_cached ?? AttributionData.empty()).applySortBar(sortBar);
  }

  /// Overwrite the cached slice with [snapshot]. Called by
  /// [AppNavigationObserver] on pop of a funnel-owning route to undo the
  /// funnel-switch wipe that happened on push, so a `PLP → Search → back
  /// → PLP → PDP` flow preserves whatever HP click context the user had
  /// accumulated before opening Search. `null` restores to "nothing cached".
  void restore(AttributionData? snapshot) {
    _cached = snapshot;
  }

  /// HTTP request-body keys for ATC / wishlist-add / cart-update. Server
  /// accepts the trackingMeta snake_case keys back verbatim.
  Map<String, Object?> get requestParams {
    final data = _cached;
    if (data == null) return const <String, Object?>{};
    final params = <String, Object?>{...data.trackingMeta};
    if (_nonEmpty(data.funnel)) params[AnalyticsProperties.funnel] = data.funnel;
    if (_nonEmpty(data.sortBar)) params[AnalyticsProperties.sortbar] = data.sortBar;
    return params;
  }

  /// Segment event-payload keys. Merged into events fired with `attribution: true`.
  Map<String, Object?> get segmentParams {
    final data = _cached;
    if (data == null) return const <String, Object?>{};
    final params = <String, Object?>{...data.trackingMeta};
    if (_nonEmpty(data.funnel)) params[AnalyticsProperties.funnel] = data.funnel;
    if (_nonEmpty(data.sortBar)) params[AnalyticsProperties.sortbar] = data.sortBar;
    return params;
  }

  static bool _nonEmpty(String? s) => s != null && s.isNotEmpty;
}
