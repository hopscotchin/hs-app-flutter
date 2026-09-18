part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class RemoveCartItem extends CartEvent {
  final String sku;

  const RemoveCartItem({required this.sku});

  @override
  List<Object?> get props => [sku];
}

class UpdateCartItemQuantity extends CartEvent {
  final String sku;
  final int quantity;

  /// Row position the tap came from, so the optimistic local step can address
  /// the item directly instead of searching for it. Treated as a hint only —
  /// the bloc falls back to a sku lookup if it no longer points at [sku].
  final int? itemIndex;

  const UpdateCartItemQuantity({required this.sku, required this.quantity, this.itemIndex});

  @override
  List<Object?> get props => [sku, quantity, itemIndex];
}

class MoveToWishlist extends CartEvent {
  final String sku;
  final int? productId;
  final int? price;

  /// Same rationale as [ApplyPromoCode.reloadCartFirst] — a move replayed
  /// after login must act on the authenticated cart, not the anonymous one.
  final bool reloadCartFirst;

  const MoveToWishlist({
    required this.sku,
    this.productId,
    this.price,
    this.reloadCartFirst = false,
  });

  @override
  List<Object?> get props => [sku, productId, price, reloadCartFirst];
}

class ApplyPromoCode extends CartEvent {
  final String promoCode;

  /// Re-read the cart before applying. Set when replaying a code stashed
  /// while logged out: the server's cart for the freshly-authenticated user
  /// is not the anonymous cart the code was chosen against, and applying
  /// against the stale one fails validation. See `CartBloc.resumePendingPromo`.
  final bool reloadCartFirst;

  const ApplyPromoCode({required this.promoCode, this.reloadCartFirst = false});

  @override
  List<Object?> get props => [promoCode, reloadCartFirst];
}

class RefreshCart extends CartEvent {
  /// What caused this reload, reported as `from_location` on the `cart_viewed`
  /// it fires. Null when the reload has no reason of its own — a
  /// pull-to-refresh, or a return to the cart — in which case the control that
  /// opened the cart is reported instead.
  final String? reloadReason;

  const RefreshCart({this.reloadReason});

  @override
  List<Object?> get props => [reloadReason];
}

class RemovePromoCode extends CartEvent {
  final String promoCode;

  const RemovePromoCode({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
}

class MergeCart extends CartEvent {
  const MergeCart();
}

class ProceedToCheckout extends CartEvent {
  const ProceedToCheckout();
}

class ClearToast extends CartEvent {
  const ClearToast();
}

class ClearCheckoutData extends CartEvent {
  const ClearCheckoutData();
}

/// Fired once the promo apply/remove sheet has been shown, so it can't reappear
/// on the next rebuild.
class ClearPromoActionSheet extends CartEvent {
  const ClearPromoActionSheet();
}

/// A row control was tapped — quantity +/-, delete, move-to-wishlist — before
/// the corresponding API call runs. Fires `product_update_clicked`, which
/// measures intent: Android reports it from the view holder on tap, so a tap
/// that then fails (or that the user abandons at the confirmation sheet) is
/// still counted, and the drop-off between it and `product_updated` is the
/// number the event exists to produce.
///
/// Deliberately not folded into [UpdateCartItemQuantity] / [RemoveCartItem] /
/// [MoveToWishlist]: the delete tap opens a confirmation sheet and only reaches
/// [RemoveCartItem] if the user confirms, so the two are genuinely different
/// moments.
class CartItemControlTapped extends CartEvent {
  final String sku;

  /// Which control — [FromLocations.updateCart],
  /// [FromLocations.removeCartItem], [FromLocations.moveToWishlist].
  ///
  /// The control, not the reload reason: a removal's follow-up `cart_viewed`
  /// reports [FromLocations.deleteCart]. Android draws the two from different
  /// value sets — `Swipe` / `More button` for the control
  /// (`CartProductViewHolder:167`, `:180`) against `Delete cart` for the
  /// refetch (`CartFragment:444`).
  final String fromLocation;

  const CartItemControlTapped({required this.sku, required this.fromLocation});

  @override
  List<Object?> get props => [sku, fromLocation];
}

/// The delivery-pincode row was tapped, before the sheet opens. Fires
/// `pincode_check_clicked`.
class PincodeCheckClicked extends CartEvent {
  const PincodeCheckClicked();
}

/// A price-summary row's ⓘ opened its sheet. Fires `shipping_info_viewed` or
/// `platform_fee_info_viewed`, picked from [priceType].
///
/// The row rather than a resolved `from_location`: which fee it was decides the
/// **event name** now, and that mapping belongs with the other analytics
/// decisions in the bloc, not in the page.
class PriceRowInfoOpened extends CartEvent {
  /// The row's backend `priceType` — "Shipping fee", "Platform fee", ….
  final String? priceType;

  const PriceRowInfoOpened({this.priceType});

  @override
  List<Object?> get props => [priceType];
}

/// Which promo mutation the offers bottom sheet completed.
///
/// [failed] covers both rejection shapes: a transport `Failure` and the
/// commoner HTTP 200 with `success: false`. Only an **apply** reports it —
/// Android declares `promo_removed_failed` but never fires it.
enum OffersSheetPromoOutcome { applied, removed, failed }

/// An apply/remove inside [PromoOffersBottomSheet] settled server-side.
///
/// The sheet's own `PromosOffersBloc` owns the offer list but knows nothing
/// about the bag, and every promo event's payload *is* bag state — so the
/// sheet reports the outcome here and this bloc builds the event.
///
/// [promoCode] is the code the action was for; it is unreadable from the cart
/// afterwards (a removed code is gone from `orderPromocodes`, a rejected one
/// was never in it). [error] is the server's reason, sent as `promo_error`.
class OffersSheetPromoActionCompleted extends CartEvent {
  final OffersSheetPromoOutcome outcome;
  final String promoCode;
  final String? error;

  const OffersSheetPromoActionCompleted({
    required this.outcome,
    required this.promoCode,
    this.error,
  });

  @override
  List<Object?> get props => [outcome, promoCode, error];
}
