// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoOfferModel _$PromoOfferModelFromJson(Map<String, dynamic> json) =>
    PromoOfferModel(
      promoId: (_readPromoId(json, 'id') as num?)?.toInt() ?? 0,
      promoCode: json['promoCode'] as String? ?? '',
      header: json['header'] as String? ?? '',
      description: json['description'] as String? ?? '',
      promoOfferText: json['promoOfferText'] as String?,
      offerValidity: json['offerValidity'] as String?,
      actionText: json['actionText'] as String?,
      promoTermsText: json['promoTermsText'] as String?,
      promoTermsLink: json['promoTermsLink'] as String?,
      actionURI: _readActionUri(json, 'actionUri') as String?,
      isApplied: json['isApplied'] as bool? ?? false,
    );
