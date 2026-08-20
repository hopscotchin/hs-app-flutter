import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/promo_offers_entity.dart';
import 'promo_offer_model.dart';

part 'promos_offers_response_model.g.dart';

/// A titled group of offers within the response.
@JsonSerializable(createToJson: false)
class PromoOfferSectionModel {
  const PromoOfferSectionModel({
    this.title = '',
    this.items = const <PromoOfferModel>[],
  });

  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'items', defaultValue: <PromoOfferModel>[])
  final List<PromoOfferModel> items;

  factory PromoOfferSectionModel.fromJson(Map<String, dynamic> json) =>
      _$PromoOfferSectionModelFromJson(json);
}

extension PromoOfferSectionModelX on PromoOfferSectionModel {
  PromoOfferSectionEntity toEntity({required bool isApplicable}) =>
      PromoOfferSectionEntity(
        title: title,
        offers: items
            .map((m) => m.toEntity(isApplicable: isApplicable))
            .toList(growable: false),
      );
}

/// Network envelope for the promos & offers payload.
@JsonSerializable(createToJson: false)
class PromosOffersResponseModel {
  const PromosOffersResponseModel({
    this.applicableOffers,
    this.nonApplicableOffers,
  });

  @JsonKey(name: 'applicableOffers')
  final PromoOfferSectionModel? applicableOffers;
  @JsonKey(name: 'nonApplicableOffers')
  final PromoOfferSectionModel? nonApplicableOffers;

  factory PromosOffersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PromosOffersResponseModelFromJson(json);
}

extension PromosOffersResponseModelX on PromosOffersResponseModel {
  PromoOffersEntity toEntity() => PromoOffersEntity(
    applicable: applicableOffers?.toEntity(isApplicable: true),
    nonApplicable: nonApplicableOffers?.toEntity(isApplicable: false),
  );
}