// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingProductModel _$ListingProductModelFromJson(Map<String, dynamic> json) =>
    ListingProductModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      brandName: json['brandName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      soldOut: json['soldOut'] as bool? ?? false,
      isXLTile: json['isXLTile'] as bool? ?? false,
      isCPT: json['isCPT'] as bool? ?? false,
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
          : ProductPriceModel.fromJson(
              json['priceInfo'] as Map<String, dynamic>,
            ),
      colorVariants: json['colorVariants'] as String?,
      actionUri: json['actionUri'] as String?,
      visualCue: json['visualCue'] as Map<String, dynamic>?,
      trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
    );
