// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingProductModel _$ListingProductModelFromJson(
  Map<String, dynamic> json,
) => ListingProductModel(
  id: parseToInt(json['id']),
  name: parseToString(json['name']),
  brandName: parseToStringOrNull(json['brandName']),
  quantity: json['quantity'] == null ? 0 : parseToInt(json['quantity']),
  soldOut: json['soldOut'] == null ? false : parseToBool(json['soldOut']),
  isXLTile: json['isXLTile'] == null ? false : parseToBool(json['isXLTile']),
  isCPT: json['isCPT'] == null ? false : parseToBool(json['isCPT']),
  wishlistInfo: json['wishlistInfo'] == null
      ? null
      : WishlistInfoModel.fromJson(
          json['wishlistInfo'] as Map<String, dynamic>,
        ),
  media:
      (json['media'] as List<dynamic>?)
          ?.map((e) => MediaItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  priceInfo: json['priceInfo'] == null
      ? null
      : ProductPriceModel.fromJson(json['priceInfo'] as Map<String, dynamic>),
  colorVariants: parseToStringOrNull(json['colorVariants']),
  actionUri: parseToStringOrNull(json['actionUri']),
  visualCue: json['visualCue'] as Map<String, dynamic>?,
  trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
);
