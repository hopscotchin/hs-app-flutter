// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoDetailsItemModel _$PromoDetailsItemModelFromJson(
  Map<String, dynamic> json,
) => PromoDetailsItemModel(
  promotionId: (_readPromoId(json, 'promotionId') as num?)?.toInt() ?? 0,
  promoCode: json['promoCode'] as String? ?? '',
  header: json['header'] as String? ?? '',
  description: json['description'] as String? ?? '',
  offerValidity: json['offerValidity'] as String?,
  promoOfferText: json['promoOfferText'] as String?,
  actionText: json['actionText'] as String?,
  actionUri: _readActionUri(json, 'actionUri') as String?,
  isApplied: json['isApplied'] as bool? ?? false,
  showPromotionCode: json['showPromotionCode'] as bool? ?? true,
);

PromoTncModel _$PromoTncModelFromJson(Map<String, dynamic> json) =>
    PromoTncModel(terms: _readTerm(json, 'term') as String? ?? '');

PromoFaqModel _$PromoFaqModelFromJson(Map<String, dynamic> json) =>
    PromoFaqModel(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );

PromoDetailsResponseModel _$PromoDetailsResponseModelFromJson(
  Map<String, dynamic> json,
) => PromoDetailsResponseModel(
  promoItem: json['promoItem'] == null
      ? null
      : PromoDetailsItemModel.fromJson(
          json['promoItem'] as Map<String, dynamic>,
        ),
  about: json['about'] as String? ?? '',
  tnc:
      (json['tnc'] as List<dynamic>?)
          ?.map((e) => PromoTncModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  faq:
      (json['faq'] as List<dynamic>?)
          ?.map((e) => PromoFaqModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);
