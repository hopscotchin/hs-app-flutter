// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attribution_data.freezed.dart';
part 'attribution_data.g.dart';

/// Home-page attribution slice. `trackingMeta` is an opaque map that
/// **accumulates** across HP tile clicks — every click merges its keys in
/// via [mergeTrackingMeta] so the most recent HP tap wins on same-name
/// keys and prior keys persist otherwise.
///
/// This store is HP-only. LP click chain lives in a separate helper
/// (`LpAttributionHelper` — deque model, emits `lp{n}_*`) so LP state can
/// be cleared independently on back-to-shell without wiping HP data.
///
/// Funnel and sortBar stay typed — client picks the values. [applyFunnel]
/// only updates the funnel identity; it does NOT wipe `trackingMeta`
/// (matches Android `OrderAttributionHelper.addAttributionData` which
/// null-preserves fields that aren't being set).
@freezed
abstract class AttributionData with _$AttributionData {
  const AttributionData._();

  const factory AttributionData({
    /// HP click-chain attribution blob. Unprefixed keys only
    /// (`banner_name`, `funnel_row`, `funnel_tile`, `slice_id`,
    /// `property_type`, …). LP `lp{n}_*` chains live in
    /// `LpAttributionHelper`, not here.
    @Default(<String, dynamic>{}) Map<String, dynamic> trackingMeta,

    /// Screen-level funnel identity (`Discover`, `Search`, `Cart`, …).
    /// Set on funnel-screen entry / tab switch.
    String? funnel,

    /// Sort chip state — user picks it in the client, so it stays typed.
    String? sortBar,
  }) = _AttributionData;

  factory AttributionData.fromJson(Map<String, dynamic> json) =>
      _$AttributionDataFromJson(json);

  factory AttributionData.empty() => const AttributionData();

  /// **HP tile click.** Merge the tile's innermost trackingMeta into the
  /// accumulated attribution. On key collision the new tile wins; other
  /// keys persist. Matches Android's typed `addAttributionData`
  /// null-preserves behavior modelled onto an opaque map.
  AttributionData mergeTrackingMeta(Map<String, dynamic> partial) {
    if (partial.isEmpty) return this;
    return copyWith(trackingMeta: <String, dynamic>{...trackingMeta, ...partial});
  }

  /// Update the funnel identity ONLY — `trackingMeta` is preserved so the
  /// prior HP click's data continues to flow until the next HP write.
  /// LP chain clearing on back-to-shell is `LpAttributionHelper.clear()`'s
  /// job, not this method's.
  AttributionData applyFunnel(String value) => copyWith(funnel: value);

  AttributionData applySortBar(String? value) => copyWith(sortBar: value);
}
