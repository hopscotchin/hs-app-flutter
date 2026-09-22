import 'dart:convert';

import '../../../domain/entities/orders_tab.dart';
import '../../models/listing/orders_listing_response_model.dart';
import 'gift_cards_mock_data.dart';
import 'orders_listing_mock_data.dart';

/// Serves the listing payloads from bundled Dart constants while
/// `orders-listing/v6` and `gift-cards-listing/v2` are still being built.
///
/// Static by design. Nothing is injected and nothing is registered in DI, so
/// the dependency graph is identical whether the flag is on or off — the only
/// trace of the mock in production code is one `if` at the top of
/// `OrdersListingRepositoryImpl.getListing`.
///
/// Delete this file, its two data files and that `if` when the endpoints ship.
abstract final class OrdersListingMockSource {
  /// Stand-in for network latency, so the shimmer and the pull-to-refresh
  /// spinner are actually visible. Without it every state transition completes
  /// in the same frame and the loading UI never renders — which is precisely
  /// the UI a mock is most useful for checking.
  static const Duration _latency = Duration(milliseconds: 400);

  static Future<OrdersListingResponseModel> getListing({
    required OrdersTab tab,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_latency);
    return OrdersListingResponseModel.fromJson(
      jsonDecode(_payloadFor(tab, page)) as Map<String, dynamic>,
    );
  }

  /// Orders has two pages so infinite scroll has something to do; gift cards
  /// has one, matching the real account the contract was captured from.
  ///
  /// To check an empty tab, swap the relevant branch for `kOrdersListingEmpty`
  /// or `kGiftCardsEmpty`.
  static String _payloadFor(OrdersTab tab, int page) => switch (tab) {
    OrdersTab.orders => page <= 1 ? kOrdersListingPage1 : kOrdersListingPage2,
    OrdersTab.giftCards => kGiftCardsPage1,
  };
}
