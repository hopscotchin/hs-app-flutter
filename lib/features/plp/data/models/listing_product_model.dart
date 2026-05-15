import '../../../../core/models/visual_cue_model.dart';
import '../../domain/entities/listing_product_entity.dart';

class ListingProductModel extends ListingProductEntity {
  const ListingProductModel({
    required super.id,
    required super.name,
    super.hsBrandLabel,
    super.smallImg,
    super.mediumImg,
    super.largeImg,
    super.quantity,
    super.brandName,
    super.retailPrice,
    super.regularPrice,
    super.saleType,
    super.discount,
    super.isWishlisted,
    super.wishlistId,
    super.sku,
    super.categoryId,
    super.subCategoryId,
    super.categoryName,
    super.subCategoryName,
    super.productImageUrls,
    super.colourHexCodes,
    super.visualCues,
    super.visualCue,
  });

  factory ListingProductModel.fromJson(Map<String, dynamic> json) {
    return ListingProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      hsBrandLabel: json['hsBrandLabel'] as String?,
      smallImg: json['smallImg'] as String?,
      mediumImg: json['mediumImg'] as String?,
      largeImg: json['largeImg'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      brandName: json['brandName'] as String?,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0,
      regularPrice: (json['regularPrice'] as num?)?.toDouble() ?? 0,
      saleType: json['saleType'] as String?,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      isWishlisted: json['isWishlisted'] as bool? ?? false,
      wishlistId: json['wishlistId']?.toString(),
      sku: json['sku'] as String?,
      categoryId: json['categoryId']?.toString(),
      subCategoryId: json['subCategoryId']?.toString(),
      categoryName: json['categoryName'] as String?,
      subCategoryName: json['subCategoryName'] as String?,
      productImageUrls:
          (json['productImageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      colourHexCodes:
          (json['colourHexCodes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      visualCues:
          (json['visualCues'] as List<dynamic>?)
              ?.map((e) => VisualCueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      visualCue: json['visualCue'] != null
          ? VisualCueModel.fromJson(json['visualCue'] as Map<String, dynamic>)
          : null,
    );
  }
}
