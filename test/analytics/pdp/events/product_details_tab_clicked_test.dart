import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `product_details_tab_clicked` — a details tab was tapped.
///
/// Chains the tapped tab's node, which is where `tab_name` comes from.
///
/// The same wire key is also written by the entry args' tab-page block on
/// `product_viewed` and `product_added_to_cart`. The two never meet — this event
/// carries no entry args — but they are one key with two meanings.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  Future<void> fire() =>
      c.h.analytics.logProductDetailsTabClicked(product: c.product, tab: c.tab);

  test('fires once, carrying the product node', () async {
    await fire();
    expectProductNode(c.single(AnalyticsEvents.productDetailsTabClicked));
  });

  test('adds only tab_name, from the tab node', () async {
    await fire();
    final e = c.single(AnalyticsEvents.productDetailsTabClicked);
    expectAddsExactly(e, const {'tab_name'});
    expect(e['tab_name'], c.tab.trackingMeta!['tab_name']);
  });

  test('a null tab drops the key rather than guessing', () async {
    await c.h.analytics.logProductDetailsTabClicked(product: c.product, tab: null);
    expectAddsExactly(
        c.single(AnalyticsEvents.productDetailsTabClicked), const <String>{});
  });

  test('carries no tab-page attribution', () async {
    await fire();
    expectAbsent(c.single(AnalyticsEvents.productDetailsTabClicked), const {
      'tabbed_page_container_name', 'tabbed_page_container_id', 'tab_position',
    });
  });
}
