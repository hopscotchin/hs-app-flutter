import 'dart:convert';

import 'order_details_mock_data.dart';

/// Which fixture [OrderDetailsMockSource] serves.
///
/// Switching variant is the one line a developer changes while building the
/// screen, so the names say what the screen will look like rather than which
/// order id they came from.
enum OrderDetailsMockVariant {
  /// Every block at once — [kOrderDetailsEverything].
  everything,

  /// One shipment, prepaid, in flight — [kOrderDetailsSingleShipment].
  singleShipment,

  /// The recovery path — [kOrderDetailsPaymentFailed].
  paymentFailed,

  /// The error envelope — [kOrderDetailsFailure].
  failure,
}

/// Serves the Order Details payload from bundled Dart constants while
/// `order-details/v9/{orderId}` is still being built.
///
/// Static by design, exactly like the listing's mock source: nothing is
/// injected and nothing is registered in DI, so the dependency graph is
/// identical whether the mock is in play or not.
///
/// It returns the decoded map rather than a model because the details models
/// do not exist yet. Once they do, change the return type to
/// `OrderDetailsResponseModel` and decode through its real `fromJson` — the
/// point of a mock is to exercise the production parsing path, and a raw map
/// does not.
///
/// Delete this file, its data file and the `if` that calls it when the
/// endpoint ships.
abstract final class OrderDetailsMockSource {
  /// Stand-in for network latency, so the shimmer is actually visible.
  /// Without it every state transition completes in the same frame and the
  /// loading UI never renders — which is the UI a mock is most useful for.
  static const Duration _latency = Duration(milliseconds: 400);

  /// The fixture served by [getDetails]. Change this line to build against a
  /// different one.
  static const OrderDetailsMockVariant variant =
      OrderDetailsMockVariant.everything;

  static Future<Map<String, dynamic>> getDetails({String? orderId}) async {
    await Future<void>.delayed(_latency);
    return jsonDecode(payloadFor(variant)) as Map<String, dynamic>;
  }

  /// Exposed so a widgetbook entry or a test can ask for one variant without
  /// touching [variant].
  static String payloadFor(OrderDetailsMockVariant v) => switch (v) {
    OrderDetailsMockVariant.everything => kOrderDetailsEverything,
    OrderDetailsMockVariant.singleShipment => kOrderDetailsSingleShipment,
    OrderDetailsMockVariant.paymentFailed => kOrderDetailsPaymentFailed,
    OrderDetailsMockVariant.failure => kOrderDetailsFailure,
  };
}
