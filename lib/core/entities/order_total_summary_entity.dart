import 'package:equatable/equatable.dart';

/// Cart's preformatted order-total strings — the backend sends these ready to
/// render ("22 items", "₹16,352", "You saved ₹2986 on this order").
class OrderTotalSummaryEntity extends Equatable {
  final String? itemCountText;
  final String? totalPrice;
  final String? orderSavings;

  const OrderTotalSummaryEntity({
    this.itemCountText,
    this.totalPrice,
    this.orderSavings,
  });

  @override
  List<Object?> get props => [itemCountText, totalPrice, orderSavings];
}
