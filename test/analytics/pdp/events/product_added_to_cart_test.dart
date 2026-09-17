import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_added_to_cart` — the add succeeded.
///
/// Fires on SUCCESS, unlike `buy_now_clicked` which fires on tap. A failed add
/// therefore produces no event, which is what makes the two separable.
///
/// Chains the selected SKU node. The tab-page block was retired — it is no
/// longer emitted from any surface.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logProductAddedToCart(
        product: c.product,
        entry: PdpEventCase.entry,
        selectedSku: c.inStockSku,
      );

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productAddedToCart));
  });

  test('adds the SKU node keys — the tab-page block is no longer emitted', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.productAddedToCart), const {
      'sku_size', 'pdt_size', 'available_quantity', 'low_inventory',
    });
  });

  test('sku is the added size, not the array', () async {
    await fire();
    expect(c.single(AnalyticsEvents.productAddedToCart)['sku'],
        c.inStockSku.trackingMeta!['sku']);
  });

  test('carries no client-owned tile keys — the add is not a tile tap', () async {
    await fire();
    // `position`, `source_tile_type` and the tab-page block used to be
    // client-owned via `PdpEntryArgs`. All retired: none appear from the
    // client any more.
    expectAbsent(c.single(AnalyticsEvents.productAddedToCart), const {
      'position',
      'source_tile_type',
      'tabbed_page_container_name',
      'tabbed_page_container_id',
      'tab_name',
      'tab_position',
    });
  });

  test('with no selected sku the event still fires, minus the node', () async {
    await c.h.analytics.logProductAddedToCart(
        product: c.product, entry: PdpEventCase.entry, selectedSku: null);
    final e = c.single(AnalyticsEvents.productAddedToCart);
    expectAbsent(e, skuNodeKeys.difference(const {'sku'}));
    expect(e['sku'], isA<List<dynamic>>(),
        reason: 'without the SKU node the product node array stands');
  });
}
