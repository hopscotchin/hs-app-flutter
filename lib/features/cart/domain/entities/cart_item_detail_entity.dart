import 'package:equatable/equatable.dart';

import '../../../../core/entities/backend_action_entity.dart';

/// One row in a cart item's dynamic detail list (`cartItemDetails`) — e.g.
/// "Price dropped by ₹100", "Non returnable & non exchangeable" (with a
/// tooltip action), "₹199 saved from BUY5 coupon". Replaces the old
/// fixed fields (`priceDropText`, `appliedPromo`, `itemMessageBar`), which
/// only ever supported one row each in a fixed order.
class CartItemDetailEntity extends Equatable {
  final String? title;
  final String? titleColor;
  final BackendActionEntity? action;

  const CartItemDetailEntity({this.title, this.titleColor, this.action});

  @override
  List<Object?> get props => [title, titleColor, action];
}
