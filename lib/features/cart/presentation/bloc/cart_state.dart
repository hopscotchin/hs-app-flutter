part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final CartEntity cart;
  final String? loadingItemSku;
  final bool isCheckoutLoading;
  final bool isPromoLoading;
  final bool isMerging;
  final List<MessageBarEntity> staticMessageBars;
  final String? toastMessage;

  const CartLoaded({
    required this.cart,
    this.loadingItemSku,
    this.isCheckoutLoading = false,
    this.isPromoLoading = false,
    this.isMerging = false,
    this.staticMessageBars = const [],
    this.toastMessage,
  });

  @override
  List<Object?> get props => [
    cart,
    loadingItemSku,
    isCheckoutLoading,
    isPromoLoading,
    isMerging,
    staticMessageBars,
    toastMessage,
  ];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
