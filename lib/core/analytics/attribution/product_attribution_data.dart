// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_attribution_data.freezed.dart';
part 'product_attribution_data.g.dart';

/// One PLP tile click. `trackingMeta` is the opaque per-product blob
/// (`records[clickedPosition].trackingMeta`) captured at tap time. Shape
/// mirrors the `trackingMeta` field on `AttributionData`.
@freezed
abstract class ProductAttributionData with _$ProductAttributionData {
  const factory ProductAttributionData({
    @Default(<String, dynamic>{}) Map<String, dynamic> trackingMeta,
  }) = _ProductAttributionData;

  factory ProductAttributionData.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributionDataFromJson(json);
}
