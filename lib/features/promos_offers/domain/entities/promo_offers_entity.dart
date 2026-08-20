import 'package:freezed_annotation/freezed_annotation.dart';

import 'promo_offer_entity.dart';

part 'promo_offers_entity.freezed.dart';

/// A response-driven group of offers (e.g. "3 OFFERS APPLICABLE").
@freezed
abstract class PromoOfferSectionEntity with _$PromoOfferSectionEntity {
  const factory PromoOfferSectionEntity({
    @Default('') String title,
    @Default(<PromoOfferEntity>[]) List<PromoOfferEntity> offers,
  }) = _PromoOfferSectionEntity;
}

/// Full promos & offers payload: applicable + non-applicable sections.
@freezed
abstract class PromoOffersEntity with _$PromoOffersEntity {
  const PromoOffersEntity._();

  const factory PromoOffersEntity({
    PromoOfferSectionEntity? applicable,
    PromoOfferSectionEntity? nonApplicable,
  }) = _PromoOffersEntity;

  /// Non-empty sections in display order. Drives the bottom-sheet UI.
  List<PromoOfferSectionEntity> get sections => [
    if (applicable != null && applicable!.offers.isNotEmpty) applicable!,
    if (nonApplicable != null && nonApplicable!.offers.isNotEmpty)
      nonApplicable!,
  ];

  bool get isEmpty => sections.isEmpty;
}