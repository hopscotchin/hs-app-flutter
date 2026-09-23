import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_confirmation_entity.dart';

part 'order_confirmation_entry_args.freezed.dart';

/// Route args for the order-confirmation page. Carries the confirmation
/// payload plus the analytics origin so the terminal `order_placed`
/// event can report the funnel the order came from.
@freezed
abstract class OrderConfirmationEntryArgs with _$OrderConfirmationEntryArgs {
  const factory OrderConfirmationEntryArgs({
    required OrderConfirmationEntity orderConfirmationEntity,
    String? fromScreen,
  }) = _OrderConfirmationEntryArgs;
}
