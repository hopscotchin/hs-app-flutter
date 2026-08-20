part of 'promo_details_bloc.dart';

enum PromoDetailsStatus { initial, loading, success, error }

@freezed
abstract class PromoDetailsState with _$PromoDetailsState {
  const factory PromoDetailsState({
    @Default(PromoDetailsStatus.initial) PromoDetailsStatus status,
    PromoDetailsEntity? details,
    String? errorMessage,
  }) = _PromoDetailsState;
}

extension PromoDetailsStateX on PromoDetailsState {
  PromoOfferEntity get item => details?.item ?? const PromoOfferEntity();
  String get about => details?.about ?? '';
  List<String> get terms => details?.terms ?? const [];
  List<PromoFaqEntity> get faqs => details?.faqs ?? const [];
}
