// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_variants_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorVariantModel _$ColorVariantModelFromJson(Map<String, dynamic> json) =>
    ColorVariantModel(
      productId: (json['productId'] as num?)?.toInt(),
      mediaUrl: json['mediaUrl'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
      isStockAvailable: json['isStockAvailable'] as bool? ?? false,
    );
