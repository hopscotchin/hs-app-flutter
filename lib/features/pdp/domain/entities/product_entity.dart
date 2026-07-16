import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../features/plp/domain/entities/product_price_entity.dart';
import '../../../../features/plp/domain/entities/wishlist_info_entity.dart';
import 'color_variants_entity.dart';
import 'detail_entity.dart';
import 'edd_info_entity.dart';
import 'media_entity.dart';
import 'service_guarantee_entity.dart';
import 'sku_entity.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    int? id,
    String? name,
    ProductPriceEntity? priceInfo,
    @Default(false) bool soldOut,
    @Default([]) List<MediaEntity> media,
    @Default([]) List<SkuEntity> skus,
    @Default([]) List<DetailEntity> details,
    EddInfoEntity? eddInfo,
    bool? hasSizeChart,
    bool? isServiceable,
    bool? isEddDifferentForSKUs,
    bool? isReturnInfoDifferentForSKUs,
    @Default([]) List<ServiceGuaranteeEntity> serviceGuarantee,
    VisualCueEntity? visualCue,
    @Default([]) List<ColorVariantEntity> colorVariants,
    WishlistInfoEntity? wishlistInfo,
    @Default(false) bool isGift,
  }) = _ProductEntity;
}
