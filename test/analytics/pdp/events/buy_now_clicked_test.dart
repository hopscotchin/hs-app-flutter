import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `buy_now_clicked` — fired ON TAP, before the network call.
///
/// So a failed buy-now emits this with no `product_added_to_cart` after it,
/// matching Android. That gap is the signal, not a bug.
///
/// Carries the SKU node, which Android does NOT: its `buy_now_clicked` has no
/// size and no sku at all, so the highest-intent action on the page recorded
/// less variant detail than the add before it. Deliberate widening.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics
      .logBuyNowClicked(product: c.product, selectedSku: c.inStockSku);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.buyNowClickedAlt));
  });

  test('adds the SKU node and nothing else', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.buyNowClickedAlt), const {
      'sku_size', 'pdt_size', 'available_quantity', 'low_inventory',
    });
  });

  test('carries the size Android omits here', () async {
    await fire();
    final e = c.single(AnalyticsEvents.buyNowClickedAlt);
    expect(e['sku_size'], c.inStockSku.trackingMeta!['sku_size']);
    expect(e['sku'], c.inStockSku.trackingMeta!['sku']);
  });

  test('no tab-page block — buy now takes no entry args', () async {
    await fire();
    expectAbsent(c.single(AnalyticsEvents.buyNowClickedAlt), const {
      'tab_name', 'tab_position',
      'tabbed_page_container_name', 'tabbed_page_container_id',
    });
  });
}
