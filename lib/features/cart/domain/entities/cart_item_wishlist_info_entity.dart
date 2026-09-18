import 'package:equatable/equatable.dart';

class CartItemWishlistInfoEntity extends Equatable {
  final int? id;
  final bool isWishlisted;
  final bool canWishlist;

  /// Analytics-only metadata for this line's move-to-wishlist — sent verbatim
  /// to tracking, never parsed or rendered.
  ///
  /// It sits under `wishlistInfo` rather than on the item because it describes
  /// the *move*, not the row: it carries the finished
  /// `product_added_to_wishlist` payload (identity, variant, pricing,
  /// classification, flags, the cart's promo context, and the nine
  /// merchandising attributes Android resolves by looking the SKU up in
  /// `trackingData.itemLevelTrackingData`). Kept as raw JSON so new backend
  /// dimensions reach the dashboards without an app change.
  final Map<String, dynamic>? trackingMeta;

  const CartItemWishlistInfoEntity({
    this.id,
    this.isWishlisted = false,
    this.canWishlist = false,
    this.trackingMeta,
  });

  @override
  List<Object?> get props => [id, isWishlisted, canWishlist, trackingMeta];
}
