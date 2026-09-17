import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `new_color_selected` — a colour swatch was tapped.
///
/// Chains the tapped variant's node, which is where `new_product_id_selected`
/// comes from — a String, sent by the backend, not the variant's int coerced by
/// the client.
///
/// ⚠️ Must fire BEFORE the PID resets. The product node still has to describe
/// the PDP being LEFT; once the refresh has run there is no product and the
/// event is dropped. That ordering is the caller's, and lives in `../tracker/`.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() =>
      c.h.analytics.logNewColorSelected(product: c.product, variant: c.variant);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.newColorSelected));
  });

  test('adds only new_product_id_selected', () async {
    await fire();
    expectAddsExactly(
        c.single(AnalyticsEvents.newColorSelected), const {'new_product_id_selected'});
  });

  test('the id is the backend String, and names the DESTINATION pid', () async {
    await fire();
    final e = c.single(AnalyticsEvents.newColorSelected);
    expect(e['new_product_id_selected'], c.variant.trackingMeta!['new_product_id_selected']);
    expect(e['new_product_id_selected'], isA<String>());
    expect(e['product_id'], c.product.trackingMeta!['product_id'],
        reason: 'product_id must still be the PDP being left');
    expect(e['new_product_id_selected'], isNot(e['product_id']));
  });

  test('a null variant drops the key rather than guessing', () async {
    await c.h.analytics.logNewColorSelected(product: c.product, variant: null);
    expectAddsExactly(c.single(AnalyticsEvents.newColorSelected), const <String>{});
  });
}
