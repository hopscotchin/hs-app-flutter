part of 'promos_offers_bloc.dart';

enum PromosOffersStatus { initial, loading, success, error }

/// Which mutation produced the latest [PromosOffersState.actionNonce].
enum PromoActionKind { apply, remove }

@freezed
abstract class PromosOffersState with _$PromosOffersState {
  const factory PromosOffersState({
    @Default(PromosOffersStatus.initial) PromosOffersStatus status,
    PromoOffersEntity? offers,
    String? errorMessage,

    /// Promo code whose apply/remove is in flight; empty when idle.
    @Default('') String pendingActionCode,

    /// Bumped once per completed apply/remove so a [BlocListener] fires
    /// exactly once even when two actions produce the same message.
    @Default(0) int actionNonce,
    String? actionMessage,
    String? actionError,

    /// Backend-authored sheet for the latest action; takes the place of the
    /// toast when present.
    BackendActionContentEntity? actionBottomSheet,

    /// Mutation behind the latest [actionNonce]; null until one completes.
    PromoActionKind? lastAction,

    /// Sticky once any apply/remove succeeds server-side, so the sheet's caller
    /// knows the cart needs a re-read even when the sheet is dismissed later.
    @Default(false) bool cartChanged,
  }) = _PromosOffersState;
}

extension PromosOffersStateX on PromosOffersState {
  List<PromoOfferSectionEntity> get sections => offers?.sections ?? const [];
  bool get isEmpty => offers?.isEmpty ?? true;

  /// True while any apply/remove is in flight — used to lock every button so
  /// two promos can't be mutated at once.
  bool get isActionInProgress => pendingActionCode.isNotEmpty;

  bool isPendingFor(String promoCode) => pendingActionCode == promoCode;
}