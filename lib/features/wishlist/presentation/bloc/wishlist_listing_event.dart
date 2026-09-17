part of 'wishlist_listing_bloc.dart';

@freezed
sealed class WishlistListingEvent with _$WishlistListingEvent {
  /// Load page 1 from scratch. [fromScreen] is the analytics screen that
  /// opened the wishlist — stamped on the wishlist_viewed event.
  const factory WishlistListingEvent.load({String? fromScreen}) = LoadWishlist;

  /// Pull-to-refresh alias for [LoadWishlist].
  const factory WishlistListingEvent.refresh() = RefreshWishlist;

  /// Append the next page to the current list.
  const factory WishlistListingEvent.loadNextPage() = LoadNextWishlistPage;

  /// Remove a single item (delete icon).
  const factory WishlistListingEvent.removeItem(WishlistProductEntity item) =
      RemoveWishlistItem;

  /// Add a single item's SKU to the bag, then drop it from the wishlist.
  /// [skuId] is the size picked in the selection sheet; when null the item's
  /// own [WishlistProductEntity.moveToBagSku] is used.
  const factory WishlistListingEvent.moveToBag(
    WishlistProductEntity item, {
    String? skuId,
  }) = MoveWishlistItemToBag;

  /// Clear the one-shot [WishlistListingState.message] after the listener has
  /// shown the snackbar.
  const factory WishlistListingEvent.clearMessage() = ClearWishlistMessage;
}
