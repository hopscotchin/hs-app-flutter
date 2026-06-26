part of 'wishlist_cubit.dart';

/// Single source of truth for wishlist membership across every screen.
///
/// [items] maps a product id (always `productId.toString()` so PLP `int` ids and
/// PDP `String` ids unify) to its wishlist-item id (needed for removal; may be
/// null when the membership is known but the item id is not yet).
@freezed
abstract class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default(<String, String?>{}) Map<String, String?> items,
    @Default(<String>{}) Set<String> inFlight,
    @Default(0) int feedbackTick,
    String? feedbackMessage,
    @Default(false) bool feedbackIsError,
  }) = _WishlistState;
}

extension WishlistStateX on WishlistState {
  bool isWishlisted(String productId) => items.containsKey(productId);
  bool isInFlight(String productId) => inFlight.contains(productId);
}
