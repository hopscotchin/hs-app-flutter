import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_variants_entity.freezed.dart';

@freezed
abstract class ColorVariantEntity with _$ColorVariantEntity {
  const factory ColorVariantEntity({
    int? productId,
    String? mediaUrl,
    @Default(false) bool isSelected,
    @Default(false) bool isStockAvailable,

    /// `colorVariants.variants[].trackingMeta`, forwarded whole. Analytics never reads a key
    /// from it — see docs/analytics/pdp/client/tm-collection.md.
    Map<String, dynamic>? trackingMeta,
  }) = _ColorVariantEntity;
}
