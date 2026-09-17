import '../../../../core/models/visual_cue_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/order_confirmation_item_entity.dart';

class OrderConfirmationItemMessageModel extends OrderConfirmationItemMessageEntity {
  const OrderConfirmationItemMessageModel({
    super.alertMessage,
    super.hasIcon,
    super.messageType,
    super.actionLink,
  });

  factory OrderConfirmationItemMessageModel.fromJson(Map<String, dynamic> json) {
    return OrderConfirmationItemMessageModel(
      alertMessage: json['alertMessage'] as String?,
      hasIcon: json['hasIcon'] as bool? ?? false,
      messageType: json['messageType'] as String?,
      actionLink: json['actionLink'] as String?,
    );
  }
}

class OrderConfirmationItemModel extends OrderConfirmationItemEntity {
  const OrderConfirmationItemModel({
    super.productId,
    super.sku,
    super.shoppingCartItemId,
    super.brandName,
    super.hsBrandLabel,
    super.productName,
    super.imgSrc,
    super.size,
    super.color,
    super.quantity,
    super.selectMaxValue,
    super.price,
    super.regularPrice,
    super.discount,
    super.discountPercentage,
    super.isSoldOut,
    super.isSizeSoldOut,
    super.isSingleSize,
    super.lowInventoryText,
    super.productTileText,
    super.promoDiscountMessage,
    super.visualCues,
    super.isPresale,
    super.categoryName,
    super.message,
    super.orderPrice,
  });

  factory OrderConfirmationItemModel.fromJson(Map<String, dynamic> json) {
    final rawMessage = json['message'];
    final messageJson = rawMessage is Map<String, dynamic> ? rawMessage : null;
    return OrderConfirmationItemModel(
      productId: parseToIntOrNull(json['productId']),
      sku: json['sku'] as String?,
      shoppingCartItemId: parseToIntOrNull(json['shoppingCartItemId']),
      brandName: json['brandName'] as String?,
      hsBrandLabel: json['hsBrandLabel'] as String?,
      productName: json['productName'] as String? ?? json['name'] as String?,
      imgSrc: json['imgSrc'] as String? ?? json['imageUrl'] as String?,
      size: json['size'] as String?,
      color: json['color'] as String?,
      quantity: parseToIntOrNull(json['quantity']),
      selectMaxValue: parseToIntOrNull(json['selectMaxValue']),
      price: parseToIntOrNull(json['price']),
      regularPrice: parseToIntOrNull(json['regularPrice']),
      discount: json['discount'] as String?,
      discountPercentage: parseToIntOrNull(json['discountPercentage']),
      isSoldOut: json['isSoldOut'] as bool?,
      isSizeSoldOut: json['isSizeSoldOut'] as bool?,
      isSingleSize: json['isSingleSize'] as bool?,
      lowInventoryText: json['lowInventoryText'] as String?,
      productTileText: json['productTileText'] as String?,
      promoDiscountMessage: json['promoDiscountMessage'] as String?,
      visualCues:
          (json['visualCues'] as List<dynamic>?)
              ?.map((e) => VisualCueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isPresale: json['isPresale'] as bool?,
      categoryName: json['categoryName'] as String? ?? json['category'] as String?,
      message: messageJson != null ? OrderConfirmationItemMessageModel.fromJson(messageJson) : null,
      orderPrice: parseToIntOrNull(json['orderPrice']),
    );
  }
}
