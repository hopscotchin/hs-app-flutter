import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/promo_offer_entity.dart';

part 'promo_offer_model.g.dart';

/// This endpoint keys the promo id as `id`, while the terms endpoint and the
/// rest of the app call it `promoId` — read either so a backend rename can't
/// silently turn the id into 0 (which hides "See terms").
Object? _readPromoId(Map<dynamic, dynamic> json, String key) =>
    json['id'] ?? json['promoId'];

/// Same story for the CTA deeplink: this endpoint sends `actionUri`, while
/// `ActionResponse`/search/checkout all send `actionURI`.
Object? _readActionUri(Map<dynamic, dynamic> json, String key) =>
    json['actionUri'] ?? json['actionURI'];

/// Data-layer representation of a single promo offer item.
///
/// `isApplicable` is NOT part of the item JSON — it is derived from which
/// section ("applicableOffers" vs "nonApplicableOffers") the item belongs to,
/// so [toEntity] takes it as a parameter.
@JsonSerializable(createToJson: false)
class PromoOfferModel {
  const PromoOfferModel({
    this.promoId = 0,
    this.promoCode = '',
    this.header = '',
    this.description = '',
    this.promoOfferText,
    this.offerValidity,
    this.actionText,
    this.promoTermsText,
    this.promoTermsLink,
    this.actionURI,
    this.isApplied = false,
  });

  @JsonKey(name: 'id', readValue: _readPromoId, defaultValue: 0)
  final int promoId;
  @JsonKey(name: 'promoCode', defaultValue: '')
  final String promoCode;
  @JsonKey(name: 'header', defaultValue: '')
  final String header;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  @JsonKey(name: 'promoOfferText')
  final String? promoOfferText;
  @JsonKey(name: 'offerValidity')
  final String? offerValidity;
  @JsonKey(name: 'actionText')
  final String? actionText;
  @JsonKey(name: 'promoTermsText')
  final String? promoTermsText;
  @JsonKey(name: 'promoTermsLink')
  final String? promoTermsLink;
  @JsonKey(name: 'actionUri', readValue: _readActionUri)
  final String? actionURI;
  @JsonKey(name: 'isApplied', defaultValue: false)
  final bool isApplied;

  factory PromoOfferModel.fromJson(Map<String, dynamic> json) =>
      _$PromoOfferModelFromJson(json);
}

extension PromoOfferModelX on PromoOfferModel {
  PromoOfferEntity toEntity({required bool isApplicable}) => PromoOfferEntity(
    promoId: promoId,
    code: promoCode,
    title: header,
    description: description,
    savingsText: promoOfferText,
    validityText: offerValidity,
    actionLabel: actionText,
    actionUri: actionURI,
    termsText: promoTermsText,
    termsLink: promoTermsLink,
    isApplied: isApplied,
    isApplicable: isApplicable,
  );
}