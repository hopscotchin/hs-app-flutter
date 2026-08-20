// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OffersListModel _$OffersListModelFromJson(Map<String, dynamic> json) =>
    OffersListModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => OfferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trackingMeta: _mapOrNull(json['trackingMeta']),
    );

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
  promoCode: json['promoCode'] as String?,
  header: json['header'] as String?,
  description: json['description'] as String?,
  features: json['features'] as Map<String, dynamic>?,
);
