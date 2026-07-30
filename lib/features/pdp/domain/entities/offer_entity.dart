import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_entity.freezed.dart';

/// Represents a single coupon/offer on the PDP.
@freezed
abstract class OfferEntity with _$OfferEntity {
  const factory OfferEntity({
    /// Promo/coupon code, e.g. "10OFF".
    String? couponCode,

    /// Bold headline text, e.g. "Get flat 10% off".
    String? header,

    /// Body description, e.g. "Add this promo code to get flat 10% off upto ₹100".
    String? description,

    /// Whether to show the coupon code chip.
    @Default(true) bool displayCoupon,

    /// Whether the Copy button is active.
    @Default(true) bool copyCoupon,
  }) = _OfferEntity;
}
