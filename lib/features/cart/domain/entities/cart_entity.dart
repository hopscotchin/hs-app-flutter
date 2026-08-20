import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/entities/service_guarantee_entity.dart';
import '../../../../core/network/models/action_response.dart';
import 'cart_item_entity.dart';
import 'delivery_pincode_entity.dart';
import 'gift_card_item_entity.dart';
import 'order_summary_entity.dart';
import 'promotion_data_entity.dart';

class CartEntity extends ActionResponse {
  final List<CartItemEntity> items;
  final OrderSummaryEntity? orderSummary;
  final PromotionDataEntity? promotionData;
  final DeliveryPincodeEntity? deliveryPincode;

  /// True when the signed-out/other-device ("temp") cart still holds items
  /// that haven't been merged in yet. With no [items] of its own the cart is
  /// visually empty, but it must still render the backend's merge message bar
  /// ("Update bag to see them here") instead of the empty state — otherwise
  /// there's no way left to trigger the merge.
  final bool isCartItemExistInTemp;

  final List<ServiceGuaranteeEntity> serviceLevelGuarantee;
  final List<MessageBarEntity> bottomMessageBars;
  final GiftCardItemEntity? giftCardItem;

  /// Analytics-only metadata — sent verbatim to tracking, never parsed or
  /// rendered. Keep it as raw JSON rather than a typed entity so new backend
  /// fields flow straight to analytics without app changes.
  final Map<String, dynamic>? trackingMeta;

  const CartEntity({
    super.action,
    super.message,
    super.messageBars,
    this.items = const [],
    this.orderSummary,
    this.promotionData,
    this.deliveryPincode,
    this.isCartItemExistInTemp = false,
    this.serviceLevelGuarantee = const [],
    this.bottomMessageBars = const [],
    this.giftCardItem,
    this.trackingMeta,
  });

  CartEntity.fromJson(
    super.json, {
    this.items = const [],
    this.orderSummary,
    this.promotionData,
    this.deliveryPincode,
    this.isCartItemExistInTemp = false,
    this.serviceLevelGuarantee = const [],
    this.bottomMessageBars = const [],
    this.giftCardItem,
    this.trackingMeta,
  }) : super.fromJson();

  CartEntity copyWith({
    List<CartItemEntity>? items,
    OrderSummaryEntity? orderSummary,
    PromotionDataEntity? promotionData,
    DeliveryPincodeEntity? deliveryPincode,
    bool? isCartItemExistInTemp,
    List<ServiceGuaranteeEntity>? serviceLevelGuarantee,
    List<MessageBarEntity>? bottomMessageBars,
    GiftCardItemEntity? giftCardItem,
    List<MessageBarEntity>? messageBars,
    Map<String, dynamic>? trackingMeta,
  }) {
    return CartEntity(
      action: action,
      message: message,
      messageBars: messageBars ?? this.messageBars,
      items: items ?? this.items,
      orderSummary: orderSummary ?? this.orderSummary,
      promotionData: promotionData ?? this.promotionData,
      deliveryPincode: deliveryPincode ?? this.deliveryPincode,
      isCartItemExistInTemp: isCartItemExistInTemp ?? this.isCartItemExistInTemp,
      serviceLevelGuarantee: serviceLevelGuarantee ?? this.serviceLevelGuarantee,
      bottomMessageBars: bottomMessageBars ?? this.bottomMessageBars,
      giftCardItem: giftCardItem ?? this.giftCardItem,
      trackingMeta: trackingMeta ?? this.trackingMeta,
    );
  }

  @override
  List<Object?> get props => [
    action,
    items,
    orderSummary,
    promotionData,
    deliveryPincode,
    messageBars,
    isCartItemExistInTemp,
    serviceLevelGuarantee,
    bottomMessageBars,
    giftCardItem,
    trackingMeta,
  ];
}
