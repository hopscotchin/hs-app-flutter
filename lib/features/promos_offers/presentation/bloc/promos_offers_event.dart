part of 'promos_offers_bloc.dart';

@freezed
sealed class PromosOffersEvent with _$PromosOffersEvent {
  /// Load the offer list (from scratch). Fired when the sheet opens.
  const factory PromosOffersEvent.load() = LoadPromosOffers;

  /// Re-fetch the offer list.
  const factory PromosOffersEvent.refresh() = RefreshPromosOffers;

  /// Apply [promoCode], then re-fetch the list so `isApplied` flips.
  const factory PromosOffersEvent.apply(String promoCode) = ApplyPromo;

  /// Remove [promoCode], then re-fetch the list.
  const factory PromosOffersEvent.remove(String promoCode) = RemovePromo;
}