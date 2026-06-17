import 'package:equatable/equatable.dart';

import 'color_variants_entity.dart';
import 'detail_entity.dart';
import 'edd_info_entity.dart';
import 'media_entity.dart';
import 'price_entity.dart';
import 'service_guarantee_entity.dart';
import 'sku_entity.dart';
import 'visual_cue_entity.dart';
import 'visual_product_info_entity.dart';
import 'wish_list_entity.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? productName;
  final String? collectionName;
  final PriceEntity? price;
  final List<MediaEntity> media;
  final List<SkuEntity> skus;
  final List<DetailEntity> details;
  final EddInfoEntity? eddInfo;
  final bool? hasSizeChart;
  final bool? soldOut;
  final bool? isServiceable;
  final bool? isEddDifferentForSKUs;
  final bool? isReturnInfoDifferentForSKUs;
  final List<ServiceGuaranteeEntity> serviceGuarantee;
  final List<VisualCueEntity> visualCues;
  final ColorVariantsEntity? colorVariants;
  final VisualProductInfoEntity? visualProductInfo;
  final WishListEntity? wishList;
  final String? pinCode;

  const ProductEntity({
    this.id,
    this.productName,
    this.collectionName,
    this.price,
    this.media = const [],
    this.skus = const [],
    this.details = const [],
    this.eddInfo,
    this.hasSizeChart,
    this.soldOut,
    this.isServiceable,
    this.isEddDifferentForSKUs,
    this.isReturnInfoDifferentForSKUs,
    this.serviceGuarantee = const [],
    this.visualCues = const [],
    this.colorVariants,
    this.visualProductInfo,
    this.wishList,
    this.pinCode,
  });

  ProductEntity copyWith({
    List<SkuEntity>? skus,
    EddInfoEntity? eddInfo,
    bool? isServiceable,
    List<ServiceGuaranteeEntity>? serviceGuarantee,
    List<VisualCueEntity>? visualCues,
    WishListEntity? wishList,
    String? pinCode,
  }) {
    return ProductEntity(
      id: id,
      productName: productName,
      collectionName: collectionName,
      price: price,
      media: media,
      skus: skus ?? this.skus,
      details: details,
      eddInfo: eddInfo ?? this.eddInfo,
      hasSizeChart: hasSizeChart,
      soldOut: soldOut,
      isServiceable: isServiceable ?? this.isServiceable,
      isEddDifferentForSKUs: isEddDifferentForSKUs,
      isReturnInfoDifferentForSKUs: isReturnInfoDifferentForSKUs,
      serviceGuarantee: serviceGuarantee ?? this.serviceGuarantee,
      visualCues: visualCues ?? this.visualCues,
      colorVariants: colorVariants,
      visualProductInfo: visualProductInfo,
      wishList: wishList ?? this.wishList,
      pinCode: pinCode ?? this.pinCode,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productName,
    collectionName,
    price,
    media,
    skus,
    details,
    eddInfo,
    hasSizeChart,
    soldOut,
    isServiceable,
    isEddDifferentForSKUs,
    isReturnInfoDifferentForSKUs,
    serviceGuarantee,
    visualCues,
    colorVariants,
    visualProductInfo,
    wishList,
    pinCode,
  ];
}
