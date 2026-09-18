import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_entry_args.freezed.dart';

/// How the user arrived at the Orders screen.
///
/// Set once when the route is pushed and held for the screen's lifetime, so the
/// value survives tab switches and pagination — the same shape as
/// `PdpEntryArgs`.
///
/// [fromScreen] is the one property on `order_listing_viewed` the server cannot
/// supply: `order_count`, `active_orders` and `tab` all arrive in the response's
/// `trackingMeta` node, while the journey that led here is only known to the
/// app. It merges last, after the node, so a server key can never overwrite it.
///
/// Typically `FromScreens.account` — the Account page is the only entry point
/// today.
@freezed
abstract class OrdersEntryArgs with _$OrdersEntryArgs {
  const factory OrdersEntryArgs({String? fromScreen}) = _OrdersEntryArgs;
}
