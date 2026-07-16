import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product_detail_entity.dart';
import 'banner_model.dart';
import 'offer_model.dart';
import 'product_model.dart';
import 'recently_viewed_model.dart';

part 'product_detail_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductDetailModel {
  const ProductDetailModel({
    this.action,
    this.message,
    this.banners = const [],
    this.product,
    this.offersList,
    this.recentlyViewed,
  });

  @JsonKey(defaultValue: null) final String? action;
  @JsonKey(defaultValue: null) final String? message;
  @JsonKey(defaultValue: []) final List<BannerModel> banners;
  @JsonKey(defaultValue: null, fromJson: _productFromJson)
  final ProductModel? product;
  @JsonKey(defaultValue: null) final OffersListModel? offersList;
  @JsonKey(defaultValue: null, fromJson: _recentlyViewedFromJson)
  final RecentlyViewedModel? recentlyViewed;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);
}

ProductModel? _productFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductModel.fromJson(json) : null;

RecentlyViewedModel? _recentlyViewedFromJson(Object? json) =>
    json is Map<String, dynamic> ? RecentlyViewedModel.fromJson(json) : null;

extension ProductDetailModelX on ProductDetailModel {
  ProductDetailEntity toEntity() => ProductDetailEntity(
    action: action,
    message: message,
    banners: banners.map((b) => b.toEntity()).toList(),
    product: product?.toEntity(),
    offersList: offersList?.data.map((o) => o.toEntity()).toList() ?? [],
    recentlyViewed: recentlyViewed?.toEntity(),
  );
}
