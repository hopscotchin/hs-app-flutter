import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_share_clicked` — the share icon was tapped
///
/// Carries the product node and nothing else. Android records no share
/// destination either — WhatsApp, copy-link and a dismissed sheet are
/// indistinguishable, and a tap that shares nothing still counts.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logProductShareClicked(c.product);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productShareClicked));
  });

  test('adds nothing of its own', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productShareClicked);
    expectAddsExactly(e, const <String>{});
  });

  test('carries no other node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productShareClicked);
    expectAbsent(e, clickedProductKeys);
    expectAbsent(e, {'tab_name', 'coupon_code', 'feed_size', 'sku_size'});
  });
}
