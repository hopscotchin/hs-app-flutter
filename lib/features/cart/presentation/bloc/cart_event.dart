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

  const UpdateCartItemQuantity({required this.sku, required this.quantity});

  @override
  List<Object?> get props => [sku, quantity];
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
  const RefreshCart();
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

/// User picked/confirmed a new EDD pincode via [PincodeBottomSheet].
/// Updates the cart's [DeliveryPincodeEntity] locally — no dedicated backend
/// endpoint exists for this yet, so it doesn't refetch the cart.
class UpdateDeliveryPincode extends CartEvent {
  final String pincode;

  const UpdateDeliveryPincode({required this.pincode});

  @override
  List<Object?> get props => [pincode];
}
