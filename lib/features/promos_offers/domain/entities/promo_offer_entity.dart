import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_offer_entity.freezed.dart';

@freezed
abstract class PromoOfferEntity with _$PromoOfferEntity {
  const factory PromoOfferEntity({
    /// Server id for this promo. The terms deeplink carries it as `?id=`.
    @Default(0) int promoId,
    @Default('') String code,
    @Default('') String title,
    @Default('') String description,
    String? validityText,
    String? savingsText,
    /// Label + deeplink for the backend-driven CTA on the card (e.g. "View
    /// eligible products" → PLP). Routed through `ActionUrlHandler`, exactly
    /// like home-page components.
    String? actionLabel,
    String? actionUri,
    String? termsText,
    String? termsLink,
    @Default(false) bool isApplied,
    @Default(true) bool isApplicable,

    /// The details endpoint can suppress the code badge (`showPromotionCode`);
    /// the offer list always shows it, hence the default.
    @Default(true) bool showCode,
  }) = _PromoOfferEntity;
}

extension PromoOfferEntityX on PromoOfferEntity {
  bool get showCodeBadge => showCode && code.isNotEmpty;
  bool get showSavings => savingsText != null && savingsText!.isNotEmpty;
  bool get showValidity => validityText != null && validityText!.isNotEmpty;
  /// Both halves are required — a label with no target would render a link that
  /// does nothing, which is how the CTA behaved before it was wired up.
  bool get hasAction =>
      actionLabel != null &&
      actionLabel!.isNotEmpty &&
      actionUri != null &&
      actionUri!.isNotEmpty;
  /// Deeplink to the promo details page. Backend sends it as `promoTermsLink`
  /// (`hopscotch://offers?id=<promoId>`); synthesised from [promoId] if that
  /// field is missing, since the page only needs the id.
  String? get termsUri {
    if (termsLink != null && termsLink!.isNotEmpty) return termsLink;
    return promoId > 0 ? 'hopscotch://offers?id=$promoId' : null;
  }

  bool get showTerms =>
      termsText != null && termsText!.isNotEmpty && termsUri != null;
}