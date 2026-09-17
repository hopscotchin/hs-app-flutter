import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment_retry_entity.dart';

part 'payment_retry_entry_args.freezed.dart';

/// Route args for the payment-retry page. Mirrors Android
/// `PaymentRetryActivity` reading `ORDER_ID`, `PAYMENT_MODE`, `FROM_SCREEN`.
///
/// [previousPaymentMode] is the mode the failed attempt used — Android
/// forwards it via `IntentConstants.PAYMENT_MODE` and reuses it when the
/// server-driven retry action omits its own `paymentMode`.
@freezed
abstract class PaymentRetryEntryArgs with _$PaymentRetryEntryArgs {
  const factory PaymentRetryEntryArgs({
    required PaymentRetryEntity paymentRetryEntity,
    required int orderId,
    String? fromScreen,
    String? previousPaymentMode,
  }) = _PaymentRetryEntryArgs;
}
