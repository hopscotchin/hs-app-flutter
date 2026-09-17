import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `recently_viewed_products_loaded` — the recently-viewed rail rendered.
///
/// Chains the rail's OWN node, which is where `feed_size` comes from. The client
/// does not count the tile list: `feed_size` is the total in the rail, which for
/// a paginated rail is not the number in this response.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() =>
      c.h.analytics.logRecentlyViewedProductsLoaded(product: c.product, railTrackingMeta: c.railMeta);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.recentlyViewedProductsLoaded));
  });

  test('adds only feed_size, from the rail node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.recentlyViewedProductsLoaded);
    expectAddsExactly(e, const {'feed_size'});
    expect(e['feed_size'], c.railMeta!['feed_size']);
  });

  test('carries no tile identity — nothing was clicked', () async {
    await fire();
    expectAbsent(c.single(AnalyticsEvents.recentlyViewedProductsLoaded), clickedProductKeys);
  });

  test('with no rail node the event still fires, minus feed_size', () async {
    await c.h.analytics.logRecentlyViewedProductsLoaded(product: c.product);
    expectAddsExactly(c.single(AnalyticsEvents.recentlyViewedProductsLoaded), const <String>{});
  });
}
