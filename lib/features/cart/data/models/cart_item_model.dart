import '../../../../core/models/visual_cue_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemMessageModel extends CartItemMessageEntity {
  const CartItemMessageModel({
    super.alertMessage,
    super.hasIcon,
    super.messageType,
    super.actionLink,
  });

  factory CartItemMessageModel.fromJson(Map<String, dynamic> json) {
    return CartItemMessageModel(
      alertMessage: json['alertMessage'] as String?,
      hasIcon: json['hasIcon'] as bool? ?? false,
      messageType: json['messageType'] as String?,
      actionLink: json['actionLink'] as String?,
    );
  }
}

class CartItemModel extends CartItemEntity {
  const CartItemModel({
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

  /// Safely parses an int that may arrive as String, int, or double from JSON.
  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final rawMessage = json['message'];
    final messageJson = rawMessage is Map<String, dynamic> ? rawMessage : null;
    return CartItemModel(
      productId: _parseInt(json['productId']),
      sku: json['sku'] as String?,
      shoppingCartItemId: _parseInt(json['shoppingCartItemId']),
      brandName: json['brandName'] as String?,
      hsBrandLabel: json['hsBrandLabel'] as String?,
      productName: json['productName'] as String? ?? json['name'] as String?,
      imgSrc: json['imgSrc'] as String? ?? json['imageUrl'] as String?,
      size: json['size'] as String?,
      color: json['color'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      selectMaxValue: (json['selectMaxValue'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      regularPrice: (json['regularPrice'] as num?)?.toInt(),
      discount: json['discount'] as String?,
      discountPercentage: (json['discountPercentage'] as num?)?.toInt(),
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
      categoryName:
          json['categoryName'] as String? ?? json['category'] as String?,
      message: messageJson != null
          ? CartItemMessageModel.fromJson(messageJson)
          : null,
      orderPrice: (json['orderPrice'] as num?)?.toInt(),
    );
  }
}
