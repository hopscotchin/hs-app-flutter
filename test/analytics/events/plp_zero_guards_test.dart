import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/plp_events.dart';
import '../support/analytics_test_harness.dart';

/// This codebase keeps zeros on the wire (see `AnalyticsMap`), so a value that
/// means "unknown" has to be null — `putAnalyticsKey` will not swallow a 0 for
/// us. These pin the two places where a 0 would otherwise be a false claim.
void main() {
  late AnalyticsTestHarness h;
  setUp(() async => h = await AnalyticsTestHarness.build());
  tearDown(() => h.tearDown());

  test('an empty keyword ships neither keyword nor length', () async {
    // length is derived, so an empty query would otherwise send `length: 0`
    // with no `keyword` beside it — a measurement of nothing.
    await h.analytics.logListingViewed(plpType: PlpType.search, keyword: '');

    final e = h.singleEvent(AnalyticsEvents.productsSearched);
    expect(e.containsKey(AnalyticsProperties.keyword), isFalse);
    expect(e.containsKey(AnalyticsProperties.length), isFalse);
  });

  test('a real keyword still reports its length', () async {
    await h.analytics.logListingViewed(
      plpType: PlpType.search,
      keyword: 'red dress',
    );

    final e = h.singleEvent(AnalyticsEvents.productsSearched);
    expect(e[AnalyticsProperties.keyword], 'red dress');
    expect(e[AnalyticsProperties.length], 9);
  });

  test('an unmeasured screen_height is absent, not 0', () async {
    await h.analytics.logPlpScrolled(
      scrollDepthParams: const {AnalyticsProperties.fromRow: 1},
    );

    final e = h.singleEvent(AnalyticsEvents.plpScrolled);
    expect(e.containsKey(AnalyticsProperties.screenHeight), isFalse);
  });
}
