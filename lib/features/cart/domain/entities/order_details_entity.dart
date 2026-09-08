import 'package:equatable/equatable.dart';

/// Raw numeric totals sent alongside the display-formatted [OrderSummaryEntity]
/// (`orderDetails` at the top level of the cart response).
///
/// [OrderSummaryEntity] carries the strings the price summary renders ("₹4898",
/// "-₹670"); this carries the same figures as numbers, for anything that has to
/// compute rather than display. [itemCount] is the one field the UI depends on:
/// it is the cart-wide **unit** count (quantities summed), which is what the
/// nav-bar badge shows — distinct from `items.length`, the number of lines.
///
/// The identically-named object nested inside `trackingMeta` is analytics-only
/// and deliberately left as raw JSON; this parses the top-level one.
class OrderDetailsEntity extends Equatable {
  /// Amount actually payable — total minus credits, plus shipping/fees.
  final double? payAmount;
  final double? shipping;
  final double? totalCredit;
  final double? totalAmount;

  /// Pre-discount sum of all line items.
  final double? productAmount;
  final double? discount;
  final double? platformFee;

  /// Discount as a whole-number percentage (e.g. `12` for 12%).
  final int? discountPercentage;

  /// Cart-wide unit count — the source of truth for the bag badge.
  final int? itemCount;

  const OrderDetailsEntity({
    this.payAmount,
    this.shipping,
    this.totalCredit,
    this.totalAmount,
    this.productAmount,
    this.discount,
    this.platformFee,
    this.discountPercentage,
    this.itemCount,
  });

  @override
  List<Object?> get props => [
    payAmount,
    shipping,
    totalCredit,
    totalAmount,
    productAmount,
    discount,
    platformFee,
    discountPercentage,
    itemCount,
  ];
}
