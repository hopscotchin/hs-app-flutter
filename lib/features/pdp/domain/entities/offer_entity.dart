/// Represents a single coupon/offer on the PDP.
class OfferEntity {
  const OfferEntity({
    this.couponCode,
    this.header,
    this.description,
    this.displayCoupon = true,
    this.copyCoupon = true,
  });

  /// Promo/coupon code, e.g. "10OFF".
  final String? couponCode;

  /// Bold headline text, e.g. "Get flat 10% off".
  final String? header;

  /// Body description, e.g. "Add this promo code to get flat 10% off upto ₹100".
  final String? description;

  /// Whether to show the coupon code chip.
  final bool displayCoupon;

  /// Whether the Copy button is active.
  final bool copyCoupon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfferEntity &&
          runtimeType == other.runtimeType &&
          couponCode == other.couponCode &&
          header == other.header &&
          description == other.description &&
          displayCoupon == other.displayCoupon &&
          copyCoupon == other.copyCoupon;

  @override
  int get hashCode =>
      Object.hash(couponCode, header, description, displayCoupon, copyCoupon);
}
