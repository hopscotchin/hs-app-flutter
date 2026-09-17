import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `coupon_code_scrolled` — the offers rail was scrolled.
///
/// Chains the offers node, so it carries `coupon_applicable` — one of only three
/// events that do. It carries no individual `coupon_code`: scrolling past
/// coupons is not choosing one.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() => c.h.analytics
      .logCouponCodeScrolled(product: c.product, offersTrackingMeta: c.offersMeta);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.couponCodeScrolled));
  });

  test('adds only coupon_applicable, from the offers node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.couponCodeScrolled);
    expectAddsExactly(e, const {'coupon_applicable'});
    expect(e['coupon_applicable'], c.offersMeta!['coupon_applicable']);
  });

  test('names no individual coupon', () async {
    await fire();
    expectAbsent(c.single(AnalyticsEvents.couponCodeScrolled),
        const {'coupon_code', 'call_to_action'});
  });

  test('with no offers node the event still fires, minus the key', () async {
    await c.h.analytics.logCouponCodeScrolled(product: c.product);
    final e = c.single(AnalyticsEvents.couponCodeScrolled);
    expectProductNode(e);
    expectAddsExactly(e, const <String>{});
  });
}
