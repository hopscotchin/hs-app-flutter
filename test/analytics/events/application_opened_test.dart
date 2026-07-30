import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/constants/storage_keys.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';

/// `application_opened` — fires from `fireApplicationOpenedEvent`. Called
/// directly by `fireLifeCycleEvents` (New install / Update path) and, on
/// second cold-start onwards, indirectly by `logAppLaunched` via the
/// `applicationStatusFlag` guard. Mirrors Android `fireApplicationOpenedEvent`.
void main() {
  late AnalyticsTestHarness h;

  Future<void> build({Map<String, Object> prefs = const {}}) async {
    h = await AnalyticsTestHarness.build(initialPrefs: prefs);
  }

  tearDown(() => h.tearDown());

  test('fires application_opened with install_type=New on first install', () async {
    await build(prefs: {
      // Defaults matter here: isFirstInstall defaults to true, cachedVersionCode to 0.
      StorageKeys.pushEnabled: true,
      StorageKeys.isFbAvailable: false,
      StorageKeys.isWaAvailable: true,
      StorageKeys.isFcAvailable: false,
      StorageKeys.isMyAvailable: false,
      StorageKeys.isDeviceRooted: false,
      StorageKeys.isDeviceProfileSet: true,
      StorageKeys.deviceProfile: 'A1',
    });

    await h.analytics.fireLifeCycleEvents();

    final payload = h.singleEvent(AnalyticsEvents.applicationOpened);
    expectTimeBuckets(payload);
    expectTimestamp(payload);

    // Client-owned exact values
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.newInstall);
    expect(payload[AnalyticsProperties.versionName], '1.99.0');
    expect(payload[AnalyticsProperties.versionCode], 99999);
    expect(payload[AnalyticsProperties.deviceProfile], 'A1');
    expect(payload[AnalyticsProperties.pushEnabled], AnalyticsDefaults.yes);
    expect(payload[AnalyticsProperties.fmessenger], AnalyticsDefaults.no);
    expect(payload[AnalyticsProperties.waInstalled], AnalyticsDefaults.yes);
    expect(payload[AnalyticsProperties.fcInstalled], AnalyticsDefaults.no);
    expect(payload[AnalyticsProperties.myInstalled], AnalyticsDefaults.no);
    expect(payload[AnalyticsProperties.rooted], AnalyticsDefaults.no);
    // iOS test platform → cpu arch is `none`.
    expect(payload[AnalyticsProperties.deviceCpuArch], AnalyticsDefaults.none);

    // First install has no previous version.
    expect(payload.containsKey(AnalyticsProperties.previousVersionName), isFalse);
    expect(payload.containsKey(AnalyticsProperties.previousVersionCode), isFalse);

    // Post-fire state: prefs flipped exactly like Android.
    expect(h.prefs.isFirstInstall, isFalse);
    expect(h.prefs.applicationStatusFlag, isFalse);
    expect(h.prefs.cachedVersionName, '1.99.0');
    expect(h.prefs.cachedVersionCode, 99999);
  });

  test('fires with install_type=Update + default fallback version on 2nd install', () async {
    // Not first install but no cached version → Update path with hardcoded
    // default previous version (matches Android).
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      // cachedVersionCode absent -> 0
    });

    await h.analytics.fireLifeCycleEvents();

    final payload = h.singleEvent(AnalyticsEvents.applicationOpened);
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.update);
    expect(payload[AnalyticsProperties.previousVersionName], 'v1.10.2');
    expect(payload[AnalyticsProperties.previousVersionCode], 2016102904);
    expect(h.prefs.isUpdated, isTrue);
  });

  test('fires with install_type=Update + real previous version on version bump', () async {
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      StorageKeys.cachedVersionName: '1.98.0',
      StorageKeys.cachedVersionCode: 99998,
    });

    await h.analytics.fireLifeCycleEvents();

    final payload = h.singleEvent(AnalyticsEvents.applicationOpened);
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.update);
    expect(payload[AnalyticsProperties.previousVersionName], '1.98.0');
    expect(payload[AnalyticsProperties.previousVersionCode], 99998);
    expect(h.prefs.cachedVersionName, '1.99.0'); // cached refreshed
  });

  test('does NOT fire when cached version matches current version', () async {
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      StorageKeys.cachedVersionName: '1.99.0',
      StorageKeys.cachedVersionCode: 99999,
    });

    await h.analytics.fireLifeCycleEvents();

    expect(h.hasEvent(AnalyticsEvents.applicationOpened), isFalse);
    expect(h.prefs.isUpdated, isFalse);
  });

  test('device_profile absent when isDeviceProfileSet=false', () async {
    await build(prefs: {
      StorageKeys.isFirstInstall: true,
      StorageKeys.isDeviceProfileSet: false,
      StorageKeys.deviceProfile: 'A1',
    });

    await h.analytics.fireLifeCycleEvents();

    final payload = h.singleEvent(AnalyticsEvents.applicationOpened);
    expect(payload.containsKey(AnalyticsProperties.deviceProfile), isFalse);
  });
}
