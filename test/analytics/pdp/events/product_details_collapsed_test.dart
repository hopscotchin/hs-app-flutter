import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_details_collapsed` — the details accordion closed
///
/// Product node only. The collapse fires with NO tab selected, so there is
/// no tab node to chain — deliberate, not an omission.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logProductDetailsCollapsed(c.product);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productDetailsCollapsed));
  });

  test('adds nothing of its own', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productDetailsCollapsed);
    expectAddsExactly(e, const <String>{});
  });

  test('carries no other node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productDetailsCollapsed);
    expectAbsent(e, clickedProductKeys);
    expectAbsent(e, {'tab_name', 'coupon_code', 'feed_size', 'sku_size'});
  });
}
