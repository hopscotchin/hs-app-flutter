import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/color_variants_entity.dart';

part 'color_variants_model.g.dart';

@JsonSerializable(createToJson: false)
class ColorVariantModel {
  const ColorVariantModel({
    this.productId,
    this.mediaUrl,
    this.isSelected = false,
    this.isStockAvailable = false,
  });

  @JsonKey(defaultValue: null)
  final int? productId;
  @JsonKey(defaultValue: null)
  final String? mediaUrl;
  @JsonKey(defaultValue: false)
  final bool isSelected;
  @JsonKey(defaultValue: false)
  final bool isStockAvailable;

  factory ColorVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ColorVariantModelFromJson(json);
}

extension ColorVariantModelX on ColorVariantModel {
  ColorVariantEntity toEntity() => ColorVariantEntity(
    productId: productId,
    mediaUrl: mediaUrl,
    isSelected: isSelected,
    isStockAvailable: isStockAvailable,
  );
}
