import '../../analytics_map.dart';
import '../../analytics_payload_builder.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Orders events. Android source of truth:
/// `OrdersListingAnalyticsImpl.kt` and `OrderDetailsActivity.java`; the wire
/// contract and its defects are catalogued in
/// `docs/orders/orders-tracking-meta.md`, which was reconciled against captured
/// Segment payloads rather than read off the Java alone.
///
/// ## Pass-through design
///
/// The listing sends three server-known properties — `order_count`,
/// `active_orders` and `tab` — and every one arrives inside the response's
/// `trackingMeta` blob, spread onto the payload untouched. The client
/// contributes only `from_screen`, which the server cannot know.
///
/// Because the node is forwarded whole, a new backend dimension needs a backend
/// deploy, not an app release. Nothing here enumerates the blob's contents.
///
/// ## Two known defects in the values
///
/// Both are Android's, both are live metrics, and neither is silently
/// "corrected" here — the fix is a conversation with the analytics owner:
///
/// * `order_count` counts line **items**, not orders. It is v5's
///   `totalRecords`, and the name has always been wrong.
/// * `active_orders` is the row count currently loaded on the client, so on a
///   first page it is just the page size. On the Gift Cards tab it has been
///   observed exceeding `order_count` — 15 loaded against a reported total of
///   13 — because that endpoint's `totalRecords` is itself wrong.
///
/// `tab` is new. Both tabs fire this event through the same Android call site
/// with no tab argument, so the two are indistinguishable in the dashboard
/// today. Adding a key is allowed; the parity rule is that no key Android sends
/// may go missing.
extension OrdersEvents on AnalyticsHelper {
  /// `order_listing_viewed` — the Orders or Gift Cards tab was shown.
  ///
  /// | Property | Source |
  /// |---|---|
  /// | `order_count` | node |
  /// | `active_orders` | node |
  /// | `tab` | node |
  /// | `from_screen` | app |
  ///
  /// `attribution: true`, matching Android's `isAttributionDataRequired` at
  /// this call site — the captured payload carries `funnel`, `sortbar` and the
  /// three `redirected_from_*` keys.
  ///
  /// Fired on first-page loads only: initial load, pull-to-refresh, and
  /// switching to an already-loaded tab. Android also fires it on every
  /// paginated response, which is what makes its `active_orders` climb; here
  /// the counts come from the node and do not change per page, so per-page
  /// firing would inflate the count without adding information.
  Future<void> logOrderListingViewed({
    required Map<String, dynamic>? trackingMeta,
    required String? fromScreen,
  }) => logEvent(
    AnalyticsEvents.orderListingViewed,
    buildAnalyticsPayload(
      nodes: [trackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen),
    ),
    attribution: true,
  );
}
