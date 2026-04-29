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

  const MoveToWishlist({
    required this.sku,
    this.productId,
    this.price,
  });

  @override
  List<Object?> get props => [sku, productId, price];
}

class ApplyPromoCode extends CartEvent {
  final String promoCode;

  const ApplyPromoCode({required this.promoCode});

  @override
  List<Object?> get props => [promoCode];
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
