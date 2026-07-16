import '../../../../core/network/models/action_response.dart';
import 'cart_item_entity.dart';
import 'delivery_pincode_entity.dart';
import 'order_summary_entity.dart';
import 'promotion_data_entity.dart';
import 'shipping_fee_info_entity.dart';

class CartEntity extends ActionResponse {
  final bool isCartEmpty;
  final List<CartItemEntity> items;
  final OrderSummaryEntity? orderSummary;
  final PromotionDataEntity? promotionData;
  final DeliveryPincodeEntity? deliveryPincode;
  final ShippingFeeInfoEntity? shippingFeeInfo;
  final String? checkoutMethod;
  final bool isCartItemExistInTemp;

  const CartEntity({
    super.action,
    super.message,
    super.messageBars,
    this.isCartEmpty = true,
    this.items = const [],
    this.orderSummary,
    this.promotionData,
    this.deliveryPincode,
    this.shippingFeeInfo,
    this.checkoutMethod,
    this.isCartItemExistInTemp = false,
  });

  CartEntity.fromJson(
    super.json, {
    this.isCartEmpty = true,
    this.items = const [],
    this.orderSummary,
    this.promotionData,
    this.deliveryPincode,
    this.shippingFeeInfo,
    this.checkoutMethod,
    this.isCartItemExistInTemp = false,
  }) : super.fromJson();

  @override
  List<Object?> get props => [
    action,
    isCartEmpty,
    items,
    orderSummary,
    promotionData,
    deliveryPincode,
    shippingFeeInfo,
    messageBars,
    checkoutMethod,
    isCartItemExistInTemp,
  ];
}
