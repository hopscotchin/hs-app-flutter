import 'package:freezed_annotation/freezed_annotation.dart';

import 'promo_offer_entity.dart';

part 'promo_details_entity.freezed.dart';

/// Full detail of a single promo, fetched by `promoId` from
/// `/v2/promotion/offerterms/{promoId}` and rendered by `PromoDetailsPage`.
///
/// [item] is the same [PromoOfferEntity] the offer list uses, so the page can
/// render the promo with `PromoOfferCard` instead of a look-alike.
@freezed
abstract class PromoDetailsEntity with _$PromoDetailsEntity {
  const factory PromoDetailsEntity({
    @Default(PromoOfferEntity()) PromoOfferEntity item,
    @Default('') String about,
    @Default(<String>[]) List<String> terms,
    @Default(<PromoFaqEntity>[]) List<PromoFaqEntity> faqs,
  }) = _PromoDetailsEntity;
}

@freezed
abstract class PromoFaqEntity with _$PromoFaqEntity {
  const factory PromoFaqEntity({
    @Default('') String question,
    @Default('') String answer,
  }) = _PromoFaqEntity;
}

extension PromoDetailsEntityX on PromoDetailsEntity {
  bool get hasAbout => about.isNotEmpty;
  bool get hasTerms => terms.isNotEmpty;
  bool get hasFaqs => faqs.isNotEmpty;

  /// Nothing worth showing below the header block.
  bool get hasNoContent => !hasAbout && !hasTerms && !hasFaqs;
}

extension PromoFaqEntityX on PromoFaqEntity {
  bool get isNotBlank => question.isNotEmpty || answer.isNotEmpty;
}
