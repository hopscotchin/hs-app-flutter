import '../../../../core/models/message_bar_model.dart';
import '../../../../core/models/service_guarantee_model.dart';
import '../../domain/entities/cart_entity.dart';
import 'cart_item_model.dart';
import 'delivery_pincode_model.dart';
import 'gift_card_item_model.dart';
import 'order_summary_model.dart';
import 'promotion_data_model.dart';

class CartModel extends CartEntity {
  const CartModel({
    super.items,
    super.orderSummary,
    super.promotionData,
    super.deliveryPincode,
    super.messageBars,
    super.isCartItemExistInTemp,
    super.serviceLevelGuarantee,
    super.bottomMessageBars,
    super.giftCardItem,
    super.trackingMeta,
  });

  CartModel.fromJson(super.json)
    : super.fromJson(
        items: _parseItems(json),
        orderSummary: _parseSummary(json),
        promotionData: _parsePromotion(json),
        deliveryPincode: _parsePincode(json),
        isCartItemExistInTemp: json['isCartItemExistInTemp'] as bool? ?? false,
        serviceLevelGuarantee: ServiceGuaranteeModel.listFromJson(
          json['serviceGuarantee'] as List<dynamic>?,
        ),
        bottomMessageBars:
            (json['bottomMessageBars'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(MessageBarModel.fromJson)
                .toList() ??
            const [],
        giftCardItem: _parseGiftCardItem(json),
        trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
      );

  static GiftCardItemModel? _parseGiftCardItem(Map<String, dynamic> json) {
    final giftJson = json['giftCardItem'] as Map<String, dynamic>?;
    return giftJson != null ? GiftCardItemModel.fromJson(giftJson) : null;
  }

  static List<CartItemModel> _parseItems(Map<String, dynamic> json) {
    final rawItems = json['cartItems'] as List<dynamic>? ?? const [];
    return rawItems.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static OrderSummaryModel? _parseSummary(Map<String, dynamic> json) {
    final summaryJson = json['orderSummary'] as Map<String, dynamic>?;
    return summaryJson != null ? OrderSummaryModel.fromJson(summaryJson) : null;
  }

  static PromotionDataModel? _parsePromotion(Map<String, dynamic> json) {
    final promoJson = json['promotionData'] as Map<String, dynamic>?;
    return promoJson != null ? PromotionDataModel.fromJson(promoJson) : null;
  }

  static DeliveryPincodeModel? _parsePincode(Map<String, dynamic> json) {
    final pincodeJson = json['deliveryPincode'] as Map<String, dynamic>?;
    return pincodeJson != null ? DeliveryPincodeModel.fromJson(pincodeJson) : null;
  }
}
