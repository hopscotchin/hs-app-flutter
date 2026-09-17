part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends CheckoutEvent {
  final String paymentCode;
  final bool creditsApplied;
  final bool fullCreditsApplied;
  final bool quickPayEnabled;

  const PlaceOrder({
    required this.paymentCode,
    required this.creditsApplied,
    required this.fullCreditsApplied,
    this.quickPayEnabled = false,
  });

  @override
  List<Object?> get props => [
    paymentCode,
    creditsApplied,
    fullCreditsApplied,
    quickPayEnabled,
  ];
}

class InitiatePayment extends CheckoutEvent {
  final int recordId;
  final bool creditsApplied;
  final bool quickPayEnabled;

  const InitiatePayment({
    required this.recordId,
    required this.creditsApplied,
    required this.quickPayEnabled,
  });

  @override
  List<Object?> get props => [recordId, creditsApplied, quickPayEnabled];
}

class JuspayCallbackReceived extends CheckoutEvent {
  final String event;
  final Map<String, dynamic> payload;

  const JuspayCallbackReceived({required this.event, required this.payload});

  @override
  List<Object?> get props => [event, payload];
}

class CheckPaymentStatus extends CheckoutEvent {
  final int orderId;

  const CheckPaymentStatus({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class LoadPaymentRetry extends CheckoutEvent {
  final int orderId;

  const LoadPaymentRetry({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class RetryPayment extends CheckoutEvent {
  final String paymentCode;
  final bool creditsApplied;
  final int failedOrderId;

  const RetryPayment({
    required this.paymentCode,
    required this.creditsApplied,
    required this.failedOrderId,
  });

  @override
  List<Object?> get props => [paymentCode, creditsApplied, failedOrderId];
}

class MarkOrderAsFailed extends CheckoutEvent {
  final int orderId;

  const MarkOrderAsFailed({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class LoadOrderConfirmation extends CheckoutEvent {
  final int orderId;

  const LoadOrderConfirmation({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
