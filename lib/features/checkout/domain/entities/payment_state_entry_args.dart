import 'package:freezed_annotation/freezed_annotation.dart';

import 'init_juspay_entity.dart';

part 'payment_state_entry_args.freezed.dart';

/// Route args for the payment-state page. Mirrors the Android intent bundle
/// `PaymentStateActivity` reads via `IntentHelper` — `JUSPAY_RESPONSE`,
/// `ORDER_ID`, `IS_CREDITS_APPLIED`, `QUICK_PAY_ENABLED`, `FROM_SCREEN`,
/// `PAYMENT_MODE`.
///
/// [fromScreen] flows down into the payment analytics chain
/// (`checkout_started`, `order_placed`, retry / confirmation), and
/// [paymentMode] is threaded on to `PaymentRetryEntryArgs.previousPaymentMode`
/// when the flow lands on the retry page.
@freezed
abstract class PaymentStateEntryArgs with _$PaymentStateEntryArgs {
  const factory PaymentStateEntryArgs({
    required InitJusPayEntity initJusPayEntity,
    required int orderId,
    required bool creditsApplied,
    @Default(false) bool quickPayEnabled,
    String? fromScreen,
    String? paymentMode,
  }) = _PaymentStateEntryArgs;
}
