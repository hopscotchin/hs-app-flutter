import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `size_selected` — a size chip was tapped.
///
/// The SKU node is chained **second**, and that ordering is the contract: the
/// product node carries `sku` as the array of every variant, the SKU node
/// carries it as the single selected id. Deeper wins, so the string reaches the
/// wire — matching Android. Reverse the two and it silently reports all five
/// variants instead, with no error.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire({bool soldOut = false}) => c.h.analytics.logSizeSelected(
        product: c.product,
        sku: soldOut ? c.soldOutSku : c.inStockSku,
        fromLocation: FromLocations.sizeListUpfront,
      );

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.sizeSelected));
  });

  test('adds the SKU node and the tap location', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.sizeSelected), const {
      'sku_size', 'pdt_size', 'available_quantity', 'low_inventory',
      'from_location',
    });
  });

  test('the SKU node turns sku from an array into the selected id', () async {
    await fire();
    final e = c.single(AnalyticsEvents.sizeSelected);
    expect(e['sku'], isA<String>(),
        reason: 'the product node sends a List; chaining the SKU node second '
            'must override it with the selected id');
    expect(e['sku'], c.inStockSku.trackingMeta!['sku']);
  });

  test('size comes from the node under both wire names', () async {
    await fire();
    final e = c.single(AnalyticsEvents.sizeSelected);
    final node = c.inStockSku.trackingMeta!;
    expect(e['sku_size'], node['sku_size']);
    expect(e['pdt_size'], node['pdt_size']);
  });

  test('low_inventory carries the Sold out bucket the client cannot derive', () async {
    await fire(soldOut: true);
    final e = c.single(AnalyticsEvents.sizeSelected);
    expect(e['low_inventory'], 'Sold out');
    expect(e['available_quantity'], 0,
        reason: 'a zero quantity is a fact and must survive the drop rule');
  });

  test('from_location names where the size was tapped', () async {
    await fire();
    expect(c.single(AnalyticsEvents.sizeSelected)['from_location'],
        FromLocations.sizeListUpfront);
  });
}
