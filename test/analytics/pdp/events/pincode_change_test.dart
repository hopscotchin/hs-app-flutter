import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `pincode_change` — a pincode check settled.
///
/// The caller branches on `isServiceable`, NOT on `action`, matching Android's
/// `PinCodeSelectionDialog`. A null `isServiceable` fires nothing at all — see
/// `../tracker/`, which owns that gate. This file owns the payload.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  test('fires once, carrying the product node', () async {
    await c.h.analytics.logPincodeChange(product: c.product, serviceable: true);
    expectProductNode(c.single(AnalyticsEvents.pincodeChange));
  });

  test('adds only pincode_check_status', () async {
    await c.h.analytics.logPincodeChange(product: c.product, serviceable: true);
    expectAddsExactly(
        c.single(AnalyticsEvents.pincodeChange), const {'pincode_check_status'});
  });

  test('a serviceable pincode reports success', () async {
    await c.h.analytics.logPincodeChange(product: c.product, serviceable: true);
    expect(c.single(AnalyticsEvents.pincodeChange)['pincode_check_status'],
        AnalyticsDefaults.success);
  });

  test('an unserviceable pincode reports failure', () async {
    await c.h.analytics.logPincodeChange(product: c.product, serviceable: false);
    expect(c.single(AnalyticsEvents.pincodeChange)['pincode_check_status'],
        AnalyticsDefaults.failure);
  });

  test('from_pincode still reads the product node, not the check', () async {
    await c.h.analytics.logPincodeChange(product: c.product, serviceable: true);
    expect(c.single(AnalyticsEvents.pincodeChange)['from_pincode'],
        c.product.trackingMeta!['from_pincode'],
        reason: 'the new pincode reaches events by being MERGED into '
            'product.trackingMeta by the bloc, not by this builder reading it');
  });
}
