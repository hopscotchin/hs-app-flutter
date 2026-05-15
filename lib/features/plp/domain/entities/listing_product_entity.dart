import 'package:equatable/equatable.dart';

import '../../../../core/entities/visual_cue_entity.dart';

class ListingProductEntity extends Equatable {
  final int id;
  final String name;
  final String? hsBrandLabel;
  final String? smallImg;
  final String? mediumImg;
  final String? largeImg;
  final int quantity;
  final String? brandName;
  final double retailPrice;
  final double regularPrice;
  final String? saleType;
  final int discount;
  final bool isWishlisted;
  final String? wishlistId;
  final String? sku;
  final String? categoryId;
  final String? subCategoryId;
  final String? categoryName;
  final String? subCategoryName;
  final List<String> productImageUrls;
  final List<String> colourHexCodes;
  final List<VisualCueEntity> visualCues;
  final VisualCueEntity? visualCue;

  const ListingProductEntity({
    required this.id,
    required this.name,
    this.hsBrandLabel,
    this.smallImg,
    this.mediumImg,
    this.largeImg,
    this.quantity = 0,
    this.brandName,
    this.retailPrice = 0,
    this.regularPrice = 0,
    this.saleType,
    this.discount = 0,
    this.isWishlisted = false,
    this.wishlistId,
    this.sku,
    this.categoryId,
    this.subCategoryId,
    this.categoryName,
    this.subCategoryName,
    this.productImageUrls = const [],
    this.colourHexCodes = const [],
    this.visualCues = const [],
    this.visualCue,
  });

  bool get hasDiscount => discount > 5;

  bool get isSoldOut => quantity == 0;

  @override
  List<Object?> get props => [
    id,
    name,
    hsBrandLabel,
    smallImg,
    mediumImg,
    largeImg,
    quantity,
    brandName,
    retailPrice,
    regularPrice,
    saleType,
    discount,
    isWishlisted,
    wishlistId,
    sku,
    categoryId,
    subCategoryId,
    categoryName,
    subCategoryName,
    productImageUrls,
    colourHexCodes,
    visualCues,
    visualCue,
  ];
}
