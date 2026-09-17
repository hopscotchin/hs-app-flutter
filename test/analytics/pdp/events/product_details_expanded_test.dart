import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_details_expanded` — the details accordion opened
///
/// Product node only — no tab node. The expand fires before a tab is chosen,
/// so `tab_name` here would be a guess. Its pair is
/// `product_details_collapsed`; the tab identity arrives on
/// `product_details_tab_clicked`.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logProductDetailsExpanded(c.product);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productDetailsExpanded));
  });

  test('adds nothing of its own', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productDetailsExpanded);
    expectAddsExactly(e, const <String>{});
  });

  test('carries no other node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productDetailsExpanded);
    expectAbsent(e, clickedProductKeys);
    expectAbsent(e, {'tab_name', 'coupon_code', 'feed_size', 'sku_size'});
  });
}
