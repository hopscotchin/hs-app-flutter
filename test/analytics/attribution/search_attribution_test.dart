import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/plp_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/search_events.dart';

import '../support/analytics_test_harness.dart';

/// The funnel context a tapped suggestion installs, and the keys deliberately
/// left off it. See [SearchEvents.setSearchAttribution].
void main() {
  late AnalyticsTestHarness h;

  setUp(() async => h = await AnalyticsTestHarness.build());
  tearDown(() => h.tearDown());

  Map<String, Object?> attribution() => h.orderAttribution.segmentParams;

  test('installs funnel_tile', () {
    h.analytics.setSearchAttribution(funnelTile: 'red dress');
    expect(attribution()[AnalyticsProperties.funnelTile], 'red dress');
  });

  test('writes neither section nor funnel_section — both deprecated', () {
    // Android sets both here (SearchAutocompleteActivity:262, :405, :494),
    // classifying the suggestion and degrading to "NS" off Discover. Neither
    // is resolved any more.
    h.analytics.setSearchAttribution(funnelTile: 'red dress');

    expect(attribution().containsKey(AnalyticsProperties.section), isFalse);
    expect(
      attribution().containsKey(AnalyticsProperties.funnelSection),
      isFalse,
    );
  });

  test('the search listing payload carries no deprecated section keys', () async {
    await h.analytics.logListingViewed(
      plpType: PlpType.search,
      keyword: 'red dress',
      suggestionIndex: 2,
    );

    final e = h.singleEvent(AnalyticsEvents.productsSearched);
    expect(e.containsKey(AnalyticsProperties.fromSection), isFalse);
    expect(e.containsKey(AnalyticsProperties.subSection), isFalse);
    expect(e.containsKey(AnalyticsProperties.funnelSection), isFalse);
    // The keys that do still ship on this path.
    expect(e[AnalyticsProperties.keyword], 'red dress');
    expect(e[AnalyticsProperties.suggestionIndex], 2);
  });
}
