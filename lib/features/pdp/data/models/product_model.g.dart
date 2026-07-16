// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  priceInfo: _priceFromJson(json['priceInfo']),
  soldOut: json['soldOut'] as bool? ?? false,
  wishlistInfo: _wishlistFromJson(json['wishlistInfo']),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  skus:
      (json['skus'] as List<dynamic>?)
          ?.map((e) => SkuModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  colorVariants: json['colorVariants'] == null
      ? []
      : _colorVariantsFromJson(json['colorVariants']),
  details:
      (json['details'] as List<dynamic>?)
          ?.map((e) => DetailModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  eddInfo: _eddInfoFromJson(json['eddInfo']),
  hasSizeChart: json['hasSizeChart'] as bool?,
  isServiceable: json['isServiceable'] as bool?,
  isEddDifferentForSKUs: json['isEddDifferentForSKUs'] as bool?,
  isReturnInfoDifferentForSKUs: json['isReturnInfoDifferentForSKUs'] as bool?,
  serviceGuarantee:
      (json['serviceGuarantee'] as List<dynamic>?)
          ?.map(
            (e) => ServiceGuaranteeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  visualCue: json['visualCue'] as Map<String, dynamic>?,
  isGift: json['isGift'] as bool? ?? false,
);
