import 'package:equatable/equatable.dart';

class PromotionDataEntity extends Equatable {
  final String? sectionTitle;
  final String? promoCode;
  final String? message;
  final int? discountAmount;
  final bool isApplied;

  /// Backend-authored "<CODE> applied" label + its color — preferred over
  /// building `'$promoCode applied'` locally.
  final String? appliedCouponText;
  final String? appliedCouponTextColor;

  /// Backend-authored "Your savings ₹X" label + its color — preferred over
  /// building `'Your savings ₹$discountAmount'` locally.
  final String? savingsText;
  final String? savingsTextColor;

  const PromotionDataEntity({
    this.sectionTitle,
    this.promoCode,
    this.message,
    this.discountAmount,
    this.isApplied = false,
    this.appliedCouponText,
    this.appliedCouponTextColor,
    this.savingsText,
    this.savingsTextColor,
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    promoCode,
    message,
    discountAmount,
    isApplied,
    appliedCouponText,
    appliedCouponTextColor,
    savingsText,
    savingsTextColor,
  ];
}
