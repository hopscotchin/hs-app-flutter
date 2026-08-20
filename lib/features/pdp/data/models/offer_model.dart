import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/offer_entity.dart';

part 'offer_model.g.dart';

/// Wrapper matching the real API shape:
/// `"offersList": { "data": [...], "trackingMeta": {...} }`
@JsonSerializable(createToJson: false)
class OffersListModel {
  const OffersListModel({this.data = const [], this.trackingMeta});

  @JsonKey(defaultValue: [])
  final List<OfferModel> data;

  /// Analytics-only. Supplies `coupon_applicable` on `product_viewed`.
  ///
  /// Kept a plain map, like every other `trackingMeta` block — the analytics
  /// layer reads it via `pdpCouponApplicable`. A typed DTO here could only carry
  /// fields someone has declared, so a new promo dimension would need a release.
  @JsonKey(defaultValue: null, fromJson: _mapOrNull)
  final Map<String, dynamic>? trackingMeta;

  factory OffersListModel.fromJson(Map<String, dynamic> json) =>
      _$OffersListModelFromJson(json);
}

Map<String, dynamic>? _mapOrNull(Object? json) =>
    json is Map<String, dynamic> ? json : null;

@JsonSerializable(createToJson: false)
class OfferModel {
  const OfferModel({
    this.promoCode,
    this.header,
    this.description,
    this.features,
  });

  /// Coupon/promo code, e.g. "10OFF".
  @JsonKey(defaultValue: null)
  final String? promoCode;

  /// Bold headline shown in the card, e.g. "Get flat 10% off".
  @JsonKey(defaultValue: null)
  final String? header;

  /// Description text shown below the headline.
  @JsonKey(defaultValue: null)
  final String? description;

  /// Controls chip/copy button visibility: {displayCoupon: bool, copyCoupon: bool}.
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? features;

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);
}

extension OfferModelX on OfferModel {
  OfferEntity toEntity() => OfferEntity(
    couponCode: promoCode,
    header: header,
    description: description,
    displayCoupon: features?['displayCoupon'] as bool? ?? true,
    copyCoupon: features?['copyCoupon'] as bool? ?? true,
  );
}
