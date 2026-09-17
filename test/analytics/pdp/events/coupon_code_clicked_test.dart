import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `coupon_code_clicked` — an offer card was tapped or its code copied.
///
/// The only four-node chain in the set: product + orderAttribution + the offers
/// node + the tapped offer's own node. `coupon_code` comes from the leaf, which
/// is why tapping a different card reports a different code without the client
/// reading one.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire({String? cta}) => c.h.analytics.logCouponCodeClicked(
        product: c.product,
        offer: c.offer,
        offersTrackingMeta: c.offersMeta,
        callToAction: cta ?? AnalyticsDefaults.couponCodeCopied,
      );

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.couponCodeClicked));
  });

  test('adds the offers node, the offer node and the call to action', () async {
    await fire();
    expectAddsExactly(c.single(AnalyticsEvents.couponCodeClicked),
        const {'coupon_applicable', 'coupon_code', 'call_to_action'});
  });

  test('coupon_code comes from the tapped offer, not the rail', () async {
    await fire();
    final e = c.single(AnalyticsEvents.couponCodeClicked);
    expect(e['coupon_code'], c.offer.trackingMeta!['coupon_code']);
  });

  test('call_to_action records how the coupon was taken', () async {
    await fire();
    expect(c.single(AnalyticsEvents.couponCodeClicked)['call_to_action'],
        AnalyticsDefaults.couponCodeCopied);
  });

  test('a null offer drops coupon_code, keeping the rest', () async {
    await c.h.analytics.logCouponCodeClicked(
      product: c.product,
      offer: null,
      offersTrackingMeta: c.offersMeta,
      callToAction: AnalyticsDefaults.couponCodeCopied,
    );
    expectAddsExactly(c.single(AnalyticsEvents.couponCodeClicked),
        const {'coupon_applicable', 'call_to_action'});
  });
}
