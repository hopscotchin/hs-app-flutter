import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `recently_viewed_products_clicked` — a recently-viewed tile was tapped.
///
/// The chain adds the **tile** node, NOT the tile's product node.
///
/// That distinction is the whole design. The tile node holds already-prefixed
/// `clicked_product_*` keys; the product's own node names its fields
/// `product_id`, `price`, `gender` — the same names the PDP node uses. Chain the
/// product node and the tapped item would overwrite the item being viewed,
/// erasing the source PDP from its own event.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() =>
      c.h.analytics.logRecentlyViewedProductsClicked(product: c.product, tile: c.railTile);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.recentlyViewedProductsClicked));
  });

  test('adds exactly the prefixed click block', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.recentlyViewedProductsClicked), clickedProductKeys);
  });

  test('the click block describes the TAPPED product', () async {
    await fire();
    final e = c.single(AnalyticsEvents.recentlyViewedProductsClicked);
    final tile = c.railTile.trackingMeta!;
    for (final k in clickedProductKeys) {
      expect(e[k], tile[k], reason: '\$k must come from the tile node');
    }
  });

  test('the PDP being viewed is not overwritten by the tile', () async {
    await fire();
    final e = c.single(AnalyticsEvents.recentlyViewedProductsClicked);
    expect(e['product_id'], c.product.trackingMeta!['product_id'],
        reason: 'the tile product node must NOT be chained — it would win on '
            'product_id and the event would report the wrong PDP');
    expect(e['product_id'], isNot(e['clicked_product_pid']));
  });
}
