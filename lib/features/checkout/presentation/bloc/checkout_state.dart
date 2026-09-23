part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class PlaceOrderSuccess extends CheckoutState {
  final PlaceOrderEntity placeOrderEntity;
  final bool fullCreditsApplied;

  const PlaceOrderSuccess({
    required this.placeOrderEntity,
    required this.fullCreditsApplied,
  });

  @override
  List<Object?> get props => [placeOrderEntity, fullCreditsApplied];
}

class JuspayReady extends CheckoutState {
  final InitJusPayEntity initJusPayEntity;

  const JuspayReady({required this.initJusPayEntity});

  @override
  List<Object?> get props => [initJusPayEntity];
}

class PaymentProcessing extends CheckoutState {
  const PaymentProcessing();
}

class PaymentStatusLoading extends CheckoutState {
  const PaymentStatusLoading();
}

class PaymentStatusReceived extends CheckoutState {
  final PaymentStatusEntity paymentStatusEntity;

  const PaymentStatusReceived({required this.paymentStatusEntity});

  @override
  List<Object?> get props => [paymentStatusEntity];
}

class PaymentRetryLoaded extends CheckoutState {
  final PaymentRetryEntity paymentRetryEntity;
  final int orderId;

  const PaymentRetryLoaded({
    required this.paymentRetryEntity,
    required this.orderId,
  });

  @override
  List<Object?> get props => [paymentRetryEntity, orderId];
}

class OrderConfirmationLoaded extends CheckoutState {
  final OrderConfirmationEntity orderConfirmationEntity;

  const OrderConfirmationLoaded({required this.orderConfirmationEntity});

  @override
  List<Object?> get props => [orderConfirmationEntity];
}

class OrderMarkedFailed extends CheckoutState {
  const OrderMarkedFailed();
}

/// Payment-status returned `actionStatus = FAILURE`. Instead of navigating
/// to the retry page, the payment-state page pops back to the checkout
/// bottom sheet (still mounted underneath) so the sheet can render the
/// server's `error` block as a banner above the purple CTA.
class PaymentFailedInCheckout extends CheckoutState {
  final int orderId;
  final PaymentErrorEntity? error;

  const PaymentFailedInCheckout({required this.orderId, this.error});

  @override
  List<Object?> get props => [orderId, error];
}

/// Emitted on any checkout-scoped API failure (place-order, init-payment,
/// payment-status, retry-place-order, order-confirmation). The checkout
/// bottom sheet renders [messageBars] at the top — no snackbars. If the
/// server didn't return any, the bloc synthesises a single INFO fallback.
class CheckoutError extends CheckoutState {
  final List<MessageBarEntity> messageBars;

  const CheckoutError({required this.messageBars});

  @override
  List<Object?> get props => [messageBars];
}
