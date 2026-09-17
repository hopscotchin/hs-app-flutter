import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_viewed` — the PDP finished loading.
///
/// The widest chain in the set: product node + orderAttribution + the offers
/// node, then the entry context the app owns. `offersList` rides this event and
/// the two coupon events only, and this is the only event on either platform
/// that carries `coupon_applicable`.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logProductViewed(
        product: c.product,
        entry: PdpEventCase.entry,
        offersTrackingMeta: c.offersMeta,
      );

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productViewed));
  });

  test('adds the entry context and the offers node', () async {
    await fire();
    // `position`, `source_tile_type` and the tab-page block are no longer
    // client-owned — they come from `product.trackingMeta` when the backend
    // ships them.
    expectAddsExactly(c.single(AnalyticsEvents.productViewed), const {
      'from_screen', 'from_page', 'from_feed_size',
      'coupon_applicable',
    });
  });

  test('coupon_applicable comes from the offers node, as a count', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productViewed);
    expect(e['coupon_applicable'], c.offersMeta!['coupon_applicable']);
    expect(e['coupon_applicable'], isA<int>(),
        reason: 'a count, not a flag — Android sends the number of applicable '
            'coupons');
  });

  test('sku is the array of every variant, not a selected one', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productViewed);
    expect(e['sku'], isA<List<dynamic>>());
    expect((e['sku']! as List).length, c.product.skus.length);
  });

  test('no sku node is chained, so no per-size key appears', () async {
    await fire();
    expectAbsent(c.single(AnalyticsEvents.productViewed),
        const {'sku_size', 'pdt_size', 'available_quantity', 'low_inventory'});
  });
}
