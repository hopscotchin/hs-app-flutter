import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/promo_details_entity.dart';
import '../../domain/entities/promo_offer_entity.dart';

part 'promo_details_response_model.g.dart';

/// The offer-list endpoint keys the promo id as `id`, this one as
/// `promotionId` — read either so one contract change can't zero it out.
Object? _readPromoId(Map<dynamic, dynamic> json, String key) =>
    json['promotionId'] ?? json['id'];

/// `actionUri` here, `actionURI` in `ActionResponse`/search/checkout.
Object? _readActionUri(Map<dynamic, dynamic> json, String key) =>
    json['actionUri'] ?? json['actionURI'];

Object? _readTerm(Map<dynamic, dynamic> json, String key) =>
    json['term'] ?? json['terms'];

/// The promo block itself.
///
/// `timeLeft` (epoch ms) + `timePrefix` were replaced by the pre-formatted
/// `offerValidity` string, and `backgroundImage*` / `isActive` / `promoStatus`
/// were dropped — none of them are modelled any more.
@JsonSerializable(createToJson: false)
class PromoDetailsItemModel {
  const PromoDetailsItemModel({
    this.promotionId = 0,
    this.promoCode = '',
    this.header = '',
    this.description = '',
    this.offerValidity,
    this.promoOfferText,
    this.actionText,
    this.actionUri,
    this.isApplied = false,
    this.showPromotionCode = true,
  });

  @JsonKey(name: 'promotionId', readValue: _readPromoId, defaultValue: 0)
  final int promotionId;
  @JsonKey(name: 'promoCode', defaultValue: '')
  final String promoCode;
  @JsonKey(name: 'header', defaultValue: '')
  final String header;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  @JsonKey(name: 'offerValidity')
  final String? offerValidity;
  @JsonKey(name: 'promoOfferText')
  final String? promoOfferText;
  @JsonKey(name: 'actionText')
  final String? actionText;
  @JsonKey(name: 'actionUri', readValue: _readActionUri)
  final String? actionUri;
  @JsonKey(name: 'isApplied', defaultValue: false)
  final bool isApplied;
  @JsonKey(name: 'showPromotionCode', defaultValue: true)
  final bool showPromotionCode;

  factory PromoDetailsItemModel.fromJson(Map<String, dynamic> json) =>
      _$PromoDetailsItemModelFromJson(json);
}

/// One `tnc` entry — a single line of terms, wrapped in an object.
@JsonSerializable(createToJson: false)
class PromoTncModel {
  const PromoTncModel({this.terms = ''});

  /// Live payloads key this `term`; the spec said `terms`. Read either, or the
  /// line comes back empty and the whole T&C section disappears.
  @JsonKey(name: 'term', readValue: _readTerm, defaultValue: '')
  final String terms;

  factory PromoTncModel.fromJson(Map<String, dynamic> json) =>
      _$PromoTncModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class PromoFaqModel {
  const PromoFaqModel({this.question = '', this.answer = ''});

  @JsonKey(name: 'question', defaultValue: '')
  final String question;
  @JsonKey(name: 'answer', defaultValue: '')
  final String answer;

  factory PromoFaqModel.fromJson(Map<String, dynamic> json) =>
      _$PromoFaqModelFromJson(json);
}

/// Response for `GET /v2/promotion/offerterms/{promoId}`.
@JsonSerializable(createToJson: false)
class PromoDetailsResponseModel {
  const PromoDetailsResponseModel({
    this.promoItem,
    this.about = '',
    this.tnc = const <PromoTncModel>[],
    this.faq = const <PromoFaqModel>[],
  });

  @JsonKey(name: 'promoItem')
  final PromoDetailsItemModel? promoItem;
  @JsonKey(name: 'about', defaultValue: '')
  final String about;
  @JsonKey(name: 'tnc', defaultValue: <PromoTncModel>[])
  final List<PromoTncModel> tnc;
  @JsonKey(name: 'faq', defaultValue: <PromoFaqModel>[])
  final List<PromoFaqModel> faq;

  factory PromoDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PromoDetailsResponseModelFromJson(json);
}

extension PromoDetailsItemModelX on PromoDetailsItemModel {
  /// Maps onto the offer-list entity so `PromoOfferCard` renders it. No
  /// `termsText`/`termsLink`: the "See terms" link is what got us here, so the
  /// card must not offer it again.
  PromoOfferEntity toEntity() => PromoOfferEntity(
    promoId: promotionId,
    code: promoCode,
    title: header,
    description: description,
    validityText: offerValidity,
    savingsText: promoOfferText,
    actionLabel: actionText,
    actionUri: actionUri,
    isApplied: isApplied,
    showCode: showPromotionCode,
  );
}

extension PromoDetailsResponseModelX on PromoDetailsResponseModel {
  PromoDetailsEntity toEntity() => PromoDetailsEntity(
    item: promoItem?.toEntity() ?? const PromoOfferEntity(),
    about: about,
    // Blank rows would render as empty bullets / empty Q&A blocks.
    terms: tnc
        .map((t) => t.terms)
        .where((t) => t.isNotEmpty)
        .toList(growable: false),
    faqs: faq
        .map((f) => PromoFaqEntity(question: f.question, answer: f.answer))
        .where((f) => f.isNotBlank)
        .toList(growable: false),
  );
}
