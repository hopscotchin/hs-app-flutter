// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailModel _$ProductDetailModelFromJson(Map<String, dynamic> json) =>
    ProductDetailModel(
      action: json['action'] as String?,
      message: json['message'] as String?,
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      product: _productFromJson(json['product']),
      offersList: json['offersList'] == null
          ? null
          : OffersListModel.fromJson(
              json['offersList'] as Map<String, dynamic>,
            ),
      recentlyViewed: _recentlyViewedFromJson(json['recentlyViewed']),
    );
