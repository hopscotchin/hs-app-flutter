import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';
import 'delivery_pincode_model.dart';
import 'order_summary_model.dart';
import 'promotion_data_model.dart';
import 'shipping_fee_info_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    super.isCartEmpty,
    super.items,
    super.orderSummary,
    super.promotionData,
    super.deliveryPincode,
    super.shippingFeeInfo,
    super.messageBars,
    super.checkoutMethod,
    super.isCartItemExistInTemp,
  });

  CartModel.fromJson(super.json)
    : super.fromJson(
        isCartEmpty: json['isCartEmpty'] as bool? ?? _parseItems(json).isEmpty,
        items: _parseItems(json),
        orderSummary: _parseSummary(json),
        promotionData: _parsePromotion(json),
        deliveryPincode: _parsePincode(json),
        shippingFeeInfo: _parseShippingInfo(json),
        checkoutMethod: json['checkoutMethod'] as String?,
        isCartItemExistInTemp: json['isCartItemExistInTemp'] as bool? ?? false,
      );

  static List<CartItemModel> _parseItems(Map<String, dynamic> json) {
    final rawItems =
        json['reviewCartItems'] as List<dynamic>? ??
        json['cartItems'] as List<dynamic>? ??
        json['items'] as List<dynamic>? ??
        [];
    return rawItems
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static OrderSummaryModel? _parseSummary(Map<String, dynamic> json) {
    final summaryJson =
        json['orderSummary'] as Map<String, dynamic>? ??
        json['priceSummary'] as Map<String, dynamic>?;
    if (summaryJson == null) return null;

    // itemCount and payAmount live in sibling orderDetails, not inside orderSummary
    final orderDetails = json['orderDetails'] as Map<String, dynamic>?;
    return OrderSummaryModel.fromJson(
      summaryJson,
      itemCount: orderDetails?['itemCount'] as int?,
      totalAmount: (orderDetails?['payAmount'] as num?)?.toInt(),
    );
  }

  static PromotionDataModel? _parsePromotion(Map<String, dynamic> json) {
    final promoJson = json['promotionData'] as Map<String, dynamic>?;
    return promoJson != null ? PromotionDataModel.fromJson(promoJson) : null;
  }

  static DeliveryPincodeModel? _parsePincode(Map<String, dynamic> json) {
    final pincodeJson = json['deliveryPincode'] as Map<String, dynamic>?;
    return pincodeJson != null
        ? DeliveryPincodeModel.fromJson(pincodeJson)
        : null;
  }

  static ShippingFeeInfoModel? _parseShippingInfo(Map<String, dynamic> json) {
    final shippingJson = json['shippingFeeInfo'] as Map<String, dynamic>?;
    return shippingJson != null
        ? ShippingFeeInfoModel.fromJson(shippingJson)
        : null;
  }
}
