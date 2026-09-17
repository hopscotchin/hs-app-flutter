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

class CheckoutError extends CheckoutState {
  final String message;
  final List<MessageBarEntity> messageBars;

  const CheckoutError({required this.message, this.messageBars = const []});

  @override
  List<Object?> get props => [message, messageBars];
}
