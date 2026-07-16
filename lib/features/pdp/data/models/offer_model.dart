import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/offer_entity.dart';

part 'offer_model.g.dart';

/// Wrapper matching the real API shape:
/// `"offersList": { "data": [...], "trackingMeta": {...} }`
@JsonSerializable(createToJson: false)
class OffersListModel {
  const OffersListModel({this.data = const []});

  @JsonKey(defaultValue: []) final List<OfferModel> data;

  factory OffersListModel.fromJson(Map<String, dynamic> json) =>
      _$OffersListModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class OfferModel {
  const OfferModel({
    this.promoCode,
    this.header,
    this.description,
    this.features,
  });

  /// Coupon/promo code, e.g. "10OFF".
  @JsonKey(defaultValue: null) final String? promoCode;

  /// Bold headline shown in the card, e.g. "Get flat 10% off".
  @JsonKey(defaultValue: null) final String? header;

  /// Description text shown below the headline.
  @JsonKey(defaultValue: null) final String? description;

  /// Controls chip/copy button visibility: {displayCoupon: bool, copyCoupon: bool}.
  @JsonKey(defaultValue: null) final Map<String, dynamic>? features;

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
