part of 'cart_bloc.dart';

enum CartStatus { initial, loading, loaded, error }

/// Which per-item call is currently in flight. Only one can run at a time —
/// every one of them blocks the page (or, for remove, sits behind a modal
/// sheet), so the state carries a single pending action rather than one
/// nullable sku per action type.
enum CartItemAction { quantity, remove, moveToWishlist }

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default(CartStatus.initial) CartStatus status,
    CartEntity? cart,
    String? errorMessage,

    /// The item call in flight, if any. Read it through [CartStateX]'s
    /// `isItemBusy` / `isRemoving` / `isMovingToWishlist` rather than
    /// destructuring it at call sites.
    ({String sku, CartItemAction action})? pendingItemAction,
    @Default(false) bool isCheckoutLoading,
    @Default(false) bool isPromoLoading,
    @Default(false) bool isMerging,

    /// Full-screen overlay flag — set by the quantity change, move-to-wishlist,
    /// promo apply/remove and the post-login merge. Remove is the exception:
    /// it runs behind its confirmation sheet's own button loader.
    ///
    /// It spans the follow-up cart refresh for every mutation except the
    /// quantity change, which drops it as soon as its own call answers and
    /// refreshes silently — see [CartBloc._onUpdateCartItem].
    @Default(false) bool isCartUpdating,

    @Default(<MessageBarEntity>[]) List<MessageBarEntity> staticMessageBars,
    String? toastMessage,

    /// Whether [toastMessage] is a failure, so the snack can be styled the way
    /// PLP/PDP style theirs (`WishlistState.feedbackIsError` is the same idea).
    @Default(false) bool toastIsError,

    /// How long [toastMessage] stays up. Defaults to the app-wide 2s; the
    /// quantity-update rejection ("Cart limit of 100 items exceeded!…") asks
    /// for 10s because it tells the user what to DO next — remove items — and
    /// two seconds is not enough to read an instruction and act on it.
    @Default(Duration(seconds: 2)) Duration toastDuration,

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

  /// Any call is in flight for this row — dims the tile and blocks its taps.
  bool isItemBusy(String? sku) => sku != null && pendingItemAction?.sku == sku;

  bool _isPending(String? sku, CartItemAction action) =>
      sku != null &&
      pendingItemAction?.sku == sku &&
      pendingItemAction?.action == action;

  /// Drives the spinner on the confirmation sheet's Remove button; its
  /// transition back to false is what closes the sheet, success or failure.
  bool isRemoving(String? sku) => _isPending(sku, CartItemAction.remove);

  /// Greys out and disables that row's "Move to Wishlist" action so it can't
  /// be tapped twice.
  bool isMovingToWishlist(String? sku) =>
      _isPending(sku, CartItemAction.moveToWishlist);
  bool get isLoaded => status == CartStatus.loaded && cart != null;
  bool get isError => status == CartStatus.error;
}
