import 'package:equatable/equatable.dart';

import '../../../../core/entities/visual_cue_entity.dart';

class CartItemMessageEntity extends Equatable {
  final String? alertMessage;
  final bool hasIcon;
  final String? messageType;
  final String? actionLink;

  const CartItemMessageEntity({
    this.alertMessage,
    this.hasIcon = false,
    this.messageType,
    this.actionLink,
  });

  @override
  List<Object?> get props => [alertMessage, hasIcon, messageType, actionLink];
}

class CartItemEntity extends Equatable {
  final int? productId;
  final String? sku;
  final int? shoppingCartItemId;
  final String? brandName;
  final String? hsBrandLabel;
  final String? productName;
  final String? imgSrc;
  final String? size;
  final String? color;
  final int? quantity;
  final int? selectMaxValue;
  final int? price;
  final int? regularPrice;
  final String? discount;
  final int? discountPercentage;
  final bool? isSoldOut;
  final bool? isSizeSoldOut;
  final bool? isSingleSize;
  final String? lowInventoryText;
  final String? productTileText;
  final String? promoDiscountMessage;
  final List<VisualCueEntity> visualCues;
  final bool? isPresale;
  final String? categoryName;
  final CartItemMessageEntity? message;
  final int? orderPrice;

  const CartItemEntity({
    this.productId,
    this.sku,
    this.shoppingCartItemId,
    this.brandName,
    this.hsBrandLabel,
    this.productName,
    this.imgSrc,
    this.size,
    this.color,
    this.quantity,
    this.selectMaxValue,
    this.price,
    this.regularPrice,
    this.discount,
    this.discountPercentage,
    this.isSoldOut,
    this.isSizeSoldOut,
    this.isSingleSize,
    this.lowInventoryText,
    this.productTileText,
    this.promoDiscountMessage,
    this.visualCues = const [],
    this.isPresale,
    this.categoryName,
    this.message,
    this.orderPrice,
  });

  bool get isCompletelySoldOut =>
      (isSoldOut == true) || (isSizeSoldOut == true);

  bool get isDiscountAvailable =>
      discount != null &&
      discount!.isNotEmpty &&
      regularPrice != null &&
      price != null &&
      regularPrice! > price!;

  @override
  List<Object?> get props => [
    productId,
    sku,
    shoppingCartItemId,
    brandName,
    hsBrandLabel,
    productName,
    imgSrc,
    size,
    color,
    quantity,
    selectMaxValue,
    price,
    regularPrice,
    discount,
    discountPercentage,
    isSoldOut,
    isSizeSoldOut,
    isSingleSize,
    lowInventoryText,
    productTileText,
    promoDiscountMessage,
    visualCues,
    isPresale,
    categoryName,
    message,
    orderPrice,
  ];
}
