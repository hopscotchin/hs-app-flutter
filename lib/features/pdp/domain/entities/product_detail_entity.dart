import 'package:freezed_annotation/freezed_annotation.dart';

import 'banner_entity.dart';
import 'offer_entity.dart';
import 'product_entity.dart';
import 'recently_viewed_entity.dart';

part 'product_detail_entity.freezed.dart';

@freezed
abstract class ProductDetailEntity with _$ProductDetailEntity {
  const factory ProductDetailEntity({
    String? action,
    String? message,
    @Default([]) List<BannerEntity> banners,
    ProductEntity? product,
    @Default([]) List<OfferEntity> offersList,
    RecentlyViewedEntity? recentlyViewed,
  }) = _ProductDetailEntity;
}

extension ProductDetailEntityX on ProductDetailEntity {
  bool get isSuccessful => action?.toLowerCase() == 'success';
}
