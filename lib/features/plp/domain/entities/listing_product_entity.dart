import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import 'product_price_entity.dart';

part 'listing_product_entity.freezed.dart';

@freezed
abstract class ListingProductEntity with _$ListingProductEntity {
  const factory ListingProductEntity({
    required int id,
    required String name,
    String? brandName,
    @Default(false) bool isWishlisted,
    @Default(false) bool canWishlist,
    String? wishlistId,
    @Default(0) int quantity,
    @Default(false) bool soldOut,
    @Default(false) bool isXLTile,
    @Default(false) bool isCPT,
    @Default([]) List<String> imageUrls,
    ProductPriceEntity? price,
    String? colorVariants,
    String? actionUri,
    @Default([]) List<VisualCueEntity> visualCues,
    Map<String, dynamic>? trackingMeta,
  }) = _ListingProductEntity;
}

extension ListingProductEntityX on ListingProductEntity {
  String? get displayImage => imageUrls.isNotEmpty ? imageUrls.first : null;
  bool get isSoldOut => soldOut;
}
