import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `recently_viewed_products_scrolled` — the rail was scrolled horizontally.
///
/// `feed_size` comes from the rail node; `scroll_depth` is computed by the
/// caller, which owns the "a user who never scrolled emits nothing" gate. Both
/// together are the ratio the metric exists for.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire({int depth = 4}) => c.h.analytics
      .logRecentlyViewedProductsScrolled(
          product: c.product, scrollDepth: depth, railTrackingMeta: c.railMeta);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.recentlyViewedProductsScrolled));
  });

  test('adds feed_size and scroll_depth', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.recentlyViewedProductsScrolled),
        const {'feed_size', 'scroll_depth'});
  });

  test('scroll_depth is the caller value, forwarded', () async {
    await fire(depth: 3);
    expect(c.single(AnalyticsEvents.recentlyViewedProductsScrolled)['scroll_depth'], 3);
  });

  test('a zero depth survives — it is a fact, not an absence', () async {
    await fire(depth: 0);
    expect(c.single(AnalyticsEvents.recentlyViewedProductsScrolled)['scroll_depth'], 0,
        reason: 'the chain drops null, empty String and empty List — never a zero');
  });
}
