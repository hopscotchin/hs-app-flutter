import '../../../../core/entities/message_bar_entity.dart';
import 'payment_status_entity.dart';

/// Value popped back to the checkout bottom sheet from any downstream
/// route (payment-state or payment-retry). Carries whichever of the two
/// error surfaces applies:
///
/// * [paymentError] — payment-status `actionStatus = FAILURE`; sheet
///   renders it as the banner above the purple CTA.
/// * [messageBars] — any checkout-scope API failure (place-order,
///   init-payment, payment-status, retry-place-order, order-confirmation);
///   sheet renders them at the top.
///
/// Never both at once. Success / abort paths navigate elsewhere and
/// never resolve with a value (Future completes with `null`).
class PaymentStateResult {
  final PaymentErrorEntity? paymentError;
  final List<MessageBarEntity> messageBars;

  const PaymentStateResult({this.paymentError, this.messageBars = const []});

  const PaymentStateResult.paymentFailed(PaymentErrorEntity? error)
      : paymentError = error,
        messageBars = const [];

  const PaymentStateResult.apiError(this.messageBars) : paymentError = null;
}
