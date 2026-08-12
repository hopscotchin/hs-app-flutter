import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';

/// `session_started` — fired by the cookie interceptor when the sessionId
/// cookie rotates. Payload is UTM-driven: every `session_utm_*` key is
/// OPTIONAL (only stamped when the corresponding UtmHeaderUtil value is
/// non-empty). Matches Android `fireSessionStartedEvent` (AnalyticsHelper.java:408-426).
void main() {
  late AnalyticsTestHarness h;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
  });
  tearDown(() => h.tearDown());

  test('fires session_started with only time buckets when UTM is empty', () async {
    await h.analytics.fireSessionStartedEvent();

    final payload = h.singleEvent(AnalyticsEvents.sessionStarted);
    expectTimeBuckets(payload);
    expectTimestamp(payload);

    // Every session_utm_* key must be ABSENT when the source is empty —
    // Android omits, doesn't send empty string.
    for (final key in const [
      AnalyticsProperties.sessionUtmSource,
      AnalyticsProperties.sessionUtmMedium,
      AnalyticsProperties.sessionUtmCampaign,
      AnalyticsProperties.sessionDeeplink,
      AnalyticsProperties.sessionUtmGender,
    ]) {
      expect(payload.containsKey(key), isFalse, reason: '$key must be absent');
    }
  });

  test('stamps session_utm_* keys when UTM values are set', () async {
    await h.utm.setUtmSource('google');
    await h.utm.setUtmMedium('cpc');
    await h.utm.setUtmCampaign('summer-2026');
    await h.utm.setUtmGender('girl');
    await h.utm.setDeeplink('hopscotch://home');

    await h.analytics.fireSessionStartedEvent();

    final payload = h.singleEvent(AnalyticsEvents.sessionStarted);
    expect(payload[AnalyticsProperties.sessionUtmSource], 'google');
    expect(payload[AnalyticsProperties.sessionUtmMedium], 'cpc');
    expect(payload[AnalyticsProperties.sessionUtmCampaign], 'summer-2026');
    expect(payload[AnalyticsProperties.sessionUtmGender], 'girl');
    expect(payload[AnalyticsProperties.sessionDeeplink], 'hopscotch://home');
  });

  test('omits individual session_utm_* keys whose source is empty', () async {
    // Only some UTM fields set — the empty ones must NOT ship.
    await h.utm.setUtmSource('google');
    await h.utm.setUtmMedium(''); // explicit empty
    await h.utm.setUtmCampaign('summer-2026');

    await h.analytics.fireSessionStartedEvent();

    final payload = h.singleEvent(AnalyticsEvents.sessionStarted);
    expect(payload[AnalyticsProperties.sessionUtmSource], 'google');
    expect(payload[AnalyticsProperties.sessionUtmCampaign], 'summer-2026');
    expect(payload.containsKey(AnalyticsProperties.sessionUtmMedium), isFalse);
  });

  // ANDROID PARITY NOTE: Android calls `logEvent(SESSION_STARTED, props, false, false)`
  // — attribution:false. Flutter's `logEvent` defaults `attribution: true` and
  // `fireSessionStartedEvent` doesn't override, so today session_started ships
  // WITH the current OrderAttribution merged in. This test pins current
  // behaviour so any silent change fires a red — if you fix Flutter to match
  // Android, flip this to `isFalse`.
  test('currently merges OrderAttribution (Flutter/Android divergence)', () async {
    h.orderAttribution.setFunnel(Funnel.search);
    h.orderAttribution.setSortBar('Girl');

    await h.analytics.fireSessionStartedEvent();

    final payload = h.singleEvent(AnalyticsEvents.sessionStarted);
    expect(payload[AnalyticsProperties.funnel], Funnel.search.wire);
    expect(payload[AnalyticsProperties.sortbar], 'Girl');
  });
}
