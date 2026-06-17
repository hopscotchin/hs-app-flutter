import '../../domain/entities/product_entity.dart';
import 'color_variants_model.dart';
import 'detail_model.dart';
import 'edd_info_model.dart';
import 'media_model.dart';
import 'price_model.dart';
import 'service_guarantee_model.dart';
import 'sku_model.dart';
import 'visual_cue_model.dart';
import 'visual_product_info_model.dart';
import 'wish_list_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.productName,
    super.collectionName,
    super.price,
    super.media,
    super.skus,
    super.details,
    super.eddInfo,
    super.hasSizeChart,
    super.soldOut,
    super.isServiceable,
    super.isEddDifferentForSKUs,
    super.isReturnInfoDifferentForSKUs,
    super.serviceGuarantee,
    super.visualCues,
    super.colorVariants,
    super.visualProductInfo,
    super.wishList,
    super.pinCode,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      productName: json['productName'] as String?,
      collectionName: json['collectionName'] as String?,
      price: json['price'] != null
          ? PriceModel.fromJson(json['price'] as Map<String, dynamic>)
          : null,
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skus:
          (json['skus'] as List<dynamic>?)
              ?.map((e) => SkuModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => DetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      eddInfo: json['eddInfo'] != null
          ? EddInfoModel.fromJson(json['eddInfo'] as Map<String, dynamic>)
          : null,
      hasSizeChart: json['hasSizeChart'] as bool?,
      soldOut: json['soldOut'] as bool?,
      isServiceable: json['isServiceable'] as bool?,
      isEddDifferentForSKUs: json['isEddDifferentForSKUs'] as bool?,
      isReturnInfoDifferentForSKUs:
          json['isReturnInfoDifferentForSKUs'] as bool?,
      serviceGuarantee:
          (json['serviceGuarantee'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ServiceGuaranteeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      visualCues:
          (json['visualCues'] as List<dynamic>?)
              ?.map((e) => VisualCueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      colorVariants: json['colorVariants'] != null
          ? ColorVariantsModel.fromJson(
              json['colorVariants'] as Map<String, dynamic>,
            )
          : null,
      visualProductInfo: json['visualProductInfo'] != null
          ? VisualProductInfoModel.fromJson(
              json['visualProductInfo'] as Map<String, dynamic>,
            )
          : null,
      wishList: json['wishList'] != null
          ? WishListModel.fromJson(json['wishList'] as Map<String, dynamic>)
          : null,
      pinCode: json['pinCode'] as String?,
    );
  }
}
