// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promos_offers_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoOfferSectionModel _$PromoOfferSectionModelFromJson(
  Map<String, dynamic> json,
) => PromoOfferSectionModel(
  title: json['title'] as String? ?? '',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PromoOfferModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

PromosOffersResponseModel _$PromosOffersResponseModelFromJson(
  Map<String, dynamic> json,
) => PromosOffersResponseModel(
  applicableOffers: json['applicableOffers'] == null
      ? null
      : PromoOfferSectionModel.fromJson(
          json['applicableOffers'] as Map<String, dynamic>,
        ),
  nonApplicableOffers: json['nonApplicableOffers'] == null
      ? null
      : PromoOfferSectionModel.fromJson(
          json['nonApplicableOffers'] as Map<String, dynamic>,
        ),
);
