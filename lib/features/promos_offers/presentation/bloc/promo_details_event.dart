part of 'promo_details_bloc.dart';

@freezed
sealed class PromoDetailsEvent with _$PromoDetailsEvent {
  /// Fetch detail for [promoId]. Fired when the page opens.
  const factory PromoDetailsEvent.load(int promoId) = LoadPromoDetails;
}
