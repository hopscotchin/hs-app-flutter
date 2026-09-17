// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistProductModel _$WishlistProductModelFromJson(
  Map<String, dynamic> json,
) => WishlistProductModel(
  productId: parseToInt(json['id']),
  name: parseToString(json['name']),
  hasSizeChart: json['hasSizeChart'] == null
      ? false
      : parseToBool(json['hasSizeChart']),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  priceInfo: json['priceInfo'] == null
      ? null
      : ProductPriceModel.fromJson(json['priceInfo'] as Map<String, dynamic>),
  wishlistInfo: json['wishlistInfo'] as Map<String, dynamic>?,
  visualCue: json['visualCue'] as Map<String, dynamic>?,
  trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
  skus:
      (json['skus'] as List<dynamic>?)
          ?.map((e) => WishlistSkuModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);
