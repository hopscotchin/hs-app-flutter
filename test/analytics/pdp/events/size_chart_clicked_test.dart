import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `size_chart_clicked` — the size-chart link was tapped
///
/// Product node only. Nothing identifies WHICH chart opened or for which
/// variant, so the event measures intent to check sizing, not the outcome.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logSizeChartClicked(c.product);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.sizeChartClicked));
  });

  test('adds nothing of its own', () async {
    await fire();
    final e = c.single(AnalyticsEvents.sizeChartClicked);
    expectAddsExactly(e, const <String>{});
  });

  test('carries no other node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.sizeChartClicked);
    expectAbsent(e, clickedProductKeys);
    expectAbsent(e, {'tab_name', 'coupon_code', 'feed_size', 'sku_size'});
  });
}
