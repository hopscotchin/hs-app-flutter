import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `pincode_form_opened` — the pincode sheet opened
///
/// Product node only. The result of the check is a separate event,
/// `pincode_change`, so an abandoned sheet is distinguishable from a
/// completed one.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics.logPincodeFormOpened(c.product);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.pincodeFormOpened));
  });

  test('adds nothing of its own', () async {
    await fire();
    final e = c.single(AnalyticsEvents.pincodeFormOpened);
    expectAddsExactly(e, const <String>{});
  });

  test('carries no other node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.pincodeFormOpened);
    expectAbsent(e, clickedProductKeys);
    expectAbsent(e, {'tab_name', 'coupon_code', 'feed_size', 'sku_size'});
  });
}
