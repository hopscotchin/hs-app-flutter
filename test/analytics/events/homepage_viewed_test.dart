import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/home_events.dart';
import 'package:hs_app_flutter/core/constants/storage_keys.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';

/// `homepage_viewed` — kicks the cold-start chain:
///   1. `app_launched`   (via `logAppLaunched`)
///   2. `application_opened` (via `fireLifeCycleEvents`)
///   3. `homepage_viewed` (this event)
///   4. `sortbar_changed`   (sortbar = "All" default, mirroring cold-start selection)
///
/// Also seeds `orderAttribution.setFunnel(Discover)` + `setSortBar(All)` so
/// downstream events on the home page inherit the correct funnel.
void main() {
  late AnalyticsTestHarness h;

  Future<void> build({Map<String, Object> prefs = const {}}) async {
    h = await AnalyticsTestHarness.build(initialPrefs: prefs);
    h.launchTimer.recordProcessStart();
  }

  tearDown(() => h.tearDown());

  test('fires the full cold-start chain in the correct order', () async {
    await build();

    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    // Exactly 4 events, in this order.
    final names = h.captured.map((e) => e.name).toList();
    expect(names, [
      AnalyticsEvents.appLaunched,
      AnalyticsEvents.applicationOpened,
      AnalyticsEvents.homePageViewed,
      AnalyticsEvents.sortbarChanged,
    ]);
  });

  test('homepage_viewed payload carries required client keys', () async {
    await build(prefs: {StorageKeys.homePageSkin: 'purple-skin'});

    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.homePageViewed);
    expectTimeBuckets(payload);
    expectTimestamp(payload);
    expectRequiredNonEmpty(payload, [
      AnalyticsProperties.fromScreen,
      AnalyticsProperties.skin,
      // Attribution merge — homepage_viewed uses attribution: true.
      AnalyticsProperties.funnel,
      AnalyticsProperties.sortbar,
    ]);
    expect(payload[AnalyticsProperties.fromScreen], FromScreens.discover);
    expect(payload[AnalyticsProperties.skin], 'purple-skin');
    expect(payload[AnalyticsProperties.funnel], AnalyticsDefaults.discover);
    expect(payload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
  });

  test('skin defaults to "none" sentinel when prefs value is missing', () async {
    await build();

    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.homePageViewed);
    expect(payload[AnalyticsProperties.skin], AnalyticsDefaults.none);
  });

  test('optional fromLocation is stamped only when non-empty', () async {
    await build();

    await h.analytics.logHomePageViewed(
      fromScreen: FromScreens.discover,
      fromLocation: 'BottomNav',
    );

    final payload = h.singleEvent(AnalyticsEvents.homePageViewed);
    expect(payload[AnalyticsProperties.fromLocation], 'BottomNav');
  });

  test('fromLocation absent when caller passes empty string', () async {
    await build();

    await h.analytics.logHomePageViewed(
      fromScreen: FromScreens.discover,
      fromLocation: '',
    );

    final payload = h.singleEvent(AnalyticsEvents.homePageViewed);
    expect(payload.containsKey(AnalyticsProperties.fromLocation), isFalse);
  });

  test('sortbar_changed follows homepage_viewed with sortbar="All"', () async {
    await build();

    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    final sortbarPayload = h.singleEvent(AnalyticsEvents.sortbarChanged);
    expect(sortbarPayload[AnalyticsProperties.sortbar], AnalyticsDefaults.sortBarAll);
  });

  test('seeds OrderAttribution.funnel=Discover + sortbar=All as a side effect', () async {
    await build();

    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    final attribution = h.orderAttribution.getCurrent();
    expect(attribution?.funnel, AnalyticsDefaults.discover);
    expect(attribution?.sortBar, AnalyticsDefaults.sortBarAll);
  });

  test('does NOT re-fire app_launched on second call (idempotent chain)', () async {
    await build();
    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);
    h.clear();

    // Second call — e.g. tab change re-triggers logHomePageViewed logic.
    await h.analytics.logHomePageViewed(fromScreen: FromScreens.discover);

    expect(h.hasEvent(AnalyticsEvents.appLaunched), isFalse,
        reason: 'LaunchTimer is stopped after first cold-start chain');
    expect(h.hasEvent(AnalyticsEvents.applicationOpened), isFalse);
    expect(h.hasEvent(AnalyticsEvents.homePageViewed), isTrue);
    expect(h.hasEvent(AnalyticsEvents.sortbarChanged), isTrue);
  });
}
