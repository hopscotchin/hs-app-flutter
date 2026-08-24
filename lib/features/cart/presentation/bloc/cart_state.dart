part of 'cart_bloc.dart';

enum CartStatus { initial, loading, loaded, error }

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default(CartStatus.initial) CartStatus status,
    CartEntity? cart,
    String? errorMessage,
    String? loadingItemSku,
    @Default(false) bool isCheckoutLoading,
    @Default(false) bool isPromoLoading,
    @Default(false) bool isMerging,
    // Full-screen overlay flag — true while any cart mutation (quantity
    // change, remove, move-to-wishlist, promo apply/remove, merge) is in
    // flight, including its mandatory follow-up cart refresh. See
    // CartBloc._refreshAfterMutation.
    @Default(false) bool isCartUpdating,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> staticMessageBars,
    String? toastMessage,

    /// Whether [toastMessage] is a failure, so the snack can be styled the way
    /// PLP/PDP style theirs (`WishlistState.feedbackIsError` is the same idea).
    @Default(false) bool toastIsError,

    /// Bumped every time a [RefreshCart] handler completes (success or
    /// failure) — lets the pull-to-refresh indicator await exactly one
    /// round-trip via `bloc.stream.firstWhere((s) => s.refreshTick != tick)`
    /// without needing a dedicated loading flag (RefreshCart is otherwise a
    /// silent background refresh).
    @Default(0) int refreshTick,

    /// Non-null when an apply/remove returned a backend-authored sheet — UI
    /// shows it instead of [toastMessage].
    BackendActionContentEntity? promoActionSheet,
  }) = _CartState;
}

extension CartStateX on CartState {
  bool get isLoading => status == CartStatus.loading;
  bool get isLoaded => status == CartStatus.loaded && cart != null;
  bool get isError => status == CartStatus.error;
}
