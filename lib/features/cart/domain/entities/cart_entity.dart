import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/entities/service_guarantee_entity.dart';
import '../../../../core/network/models/action_response.dart';
import 'cart_item_entity.dart';
import 'cart_tracking_meta_entity.dart';
import 'delivery_pincode_entity.dart';
import 'gift_card_item_entity.dart';
import 'order_details_entity.dart';
import 'order_summary_entity.dart';
import 'promotion_data_entity.dart';

class CartEntity extends ActionResponse {
  final List<CartItemEntity> items;
  final OrderSummaryEntity? orderSummary;

  /// Raw numeric totals (`orderDetails`). Its `itemCount` is the cart-wide
  /// unit count and drives the bag badge.
  final OrderDetailsEntity? orderDetails;
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

  /// The response's root-level `trackingMeta`, parsed into its flat analytics
  /// keys plus the two nested objects it carries. See
  /// [CartTrackingMetaEntity] — its `analyticsProps` is the `cart_viewed`
  /// payload; `orderDetails` and `itemLevelTrackingData` are read by other
  /// consumers and never reach a cart event.
  final CartTrackingMetaEntity? trackingMeta;

  /// `orderAttributionData` — the same per-SKU attribution under its own
  /// top-level node in the newer response shape. Raw JSON; the client only
  /// forwards it.
  final Map<String, dynamic>? orderAttributionData;

  /// Per-SKU attribution, from wherever this response carries it.
  ///
  /// Two response shapes put it in two places — nested in `trackingMeta`, and
  /// under a top-level `orderAttributionData` — so the lookup prefers the
  /// parsed block and falls back to the node. One accessor means callers
  /// (`product_ordered` at order time) do not care which shape they were given.
  Map<String, dynamic> get itemLevelTrackingData {
    final fromBlock = trackingMeta?.itemLevelTrackingData ?? const {};
    if (fromBlock.isNotEmpty) return fromBlock;
    final fromNode = orderAttributionData?['itemLevelTrackingData'] as Map<String, dynamic>?;
    return fromNode ?? const {};
  }

  const CartEntity({
    super.action,
    super.message,
    super.messageBars,
    this.items = const [],
    this.orderSummary,
    this.orderDetails,
    this.promotionData,
    this.deliveryPincode,
    this.isCartItemExistInTemp = false,
    this.serviceLevelGuarantee = const [],
    this.bottomMessageBars = const [],
    this.giftCardItem,
    this.trackingMeta,
    this.orderAttributionData,
  });

  CartEntity.fromJson(
    super.json, {
    this.items = const [],
    this.orderSummary,
    this.orderDetails,
    this.promotionData,
    this.deliveryPincode,
    this.isCartItemExistInTemp = false,
    this.serviceLevelGuarantee = const [],
    this.bottomMessageBars = const [],
    this.giftCardItem,
    this.trackingMeta,
    this.orderAttributionData,
  }) : super.fromJson();

  CartEntity copyWith({
    List<CartItemEntity>? items,
    OrderSummaryEntity? orderSummary,
    OrderDetailsEntity? orderDetails,
    PromotionDataEntity? promotionData,
    DeliveryPincodeEntity? deliveryPincode,
    bool? isCartItemExistInTemp,
    List<ServiceGuaranteeEntity>? serviceLevelGuarantee,
    List<MessageBarEntity>? bottomMessageBars,
    GiftCardItemEntity? giftCardItem,
    List<MessageBarEntity>? messageBars,
    CartTrackingMetaEntity? trackingMeta,
    Map<String, dynamic>? orderAttributionData,
  }) {
    return CartEntity(
      action: action,
      message: message,
      messageBars: messageBars ?? this.messageBars,
      items: items ?? this.items,
      orderSummary: orderSummary ?? this.orderSummary,
      orderDetails: orderDetails ?? this.orderDetails,
      promotionData: promotionData ?? this.promotionData,
      deliveryPincode: deliveryPincode ?? this.deliveryPincode,
      isCartItemExistInTemp: isCartItemExistInTemp ?? this.isCartItemExistInTemp,
      serviceLevelGuarantee: serviceLevelGuarantee ?? this.serviceLevelGuarantee,
      bottomMessageBars: bottomMessageBars ?? this.bottomMessageBars,
      giftCardItem: giftCardItem ?? this.giftCardItem,
      trackingMeta: trackingMeta ?? this.trackingMeta,
      orderAttributionData: orderAttributionData ?? this.orderAttributionData,
    );
  }

  @override
  List<Object?> get props => [
    action,
    items,
    orderSummary,
    orderDetails,
    promotionData,
    deliveryPincode,
    messageBars,
    isCartItemExistInTemp,
    serviceLevelGuarantee,
    bottomMessageBars,
    giftCardItem,
    trackingMeta,
    orderAttributionData,
  ];
}
