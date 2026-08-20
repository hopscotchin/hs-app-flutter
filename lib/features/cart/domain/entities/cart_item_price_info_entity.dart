import 'package:equatable/equatable.dart';

/// Fully preformatted price strings from the backend (e.g. `"MRP:₹1,349"`,
/// `"56% OFF"`) — display them as-is, don't reformat.
class CartItemPriceInfoEntity extends Equatable {
  final String? sellingPrice;
  final String? mrp;
  final String? discount;
  final int? absoluteValue;
  final String? callout;

  const CartItemPriceInfoEntity({
    this.sellingPrice,
    this.mrp,
    this.discount,
    this.absoluteValue,
    this.callout,
  });

  bool get hasDiscount => mrp != null && mrp!.isNotEmpty;

  @override
  List<Object?> get props => [
    sellingPrice,
    mrp,
    discount,
    absoluteValue,
    callout,
  ];
}
