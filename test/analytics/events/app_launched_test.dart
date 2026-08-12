import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/constants/storage_keys.dart';

import '../support/analytics_test_harness.dart';
import '../support/common_props_matchers.dart';

/// `app_launched` — self-guards via `LaunchTimer.isStopped`. Fires once per
/// cold start with `tti`, `ttl`, `install_type`, `from_source`. Also drives
/// `fireLifeCycleEvents` immediately after. Mirrors Android `logAppLaunched`.
///
/// `ttl` is stamped by `AppNavigationObserver.didPush` on the first
/// non-splash route commit (Android parity with `Activity.onCreate`); `tti`
/// is stamped here when the first viewable screen's Bloc invokes this. So
/// `ttl <= tti` — real delta, not two names for one number.
void main() {
  late AnalyticsTestHarness h;

  Future<void> build({Map<String, Object> prefs = const {}}) async {
    h = await AnalyticsTestHarness.build(initialPrefs: prefs);
    h.launchTimer.recordProcessStart();
    // Match main.dart's `_runPostInitBootstrapping` — resolve install type
    // upfront so `logAppLaunched` reads the correct value (bug fix: Android
    // parity — `install_type="New"` on first install / `"Update"` on bump).
    h.analytics.bootstrapInstallType();
  }

  tearDown(() => h.tearDown());

  test('fires app_launched with all required keys on first call', () async {
    await build();

    await h.analytics.logAppLaunched(FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expectTimeBuckets(payload);
    expectTimestamp(payload);

    expect(payload[AnalyticsProperties.fromScreen], FromScreens.discover);
    // Install type is resolved at bootstrap (`bootstrapInstallType`) so
    // `logAppLaunched` reads it upfront — matches Android SplashActivity.
    // First-install harness (default prefs: cachedVersionCode=0,
    // isFirstInstall=true) → "New".
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.newInstall);
    expect(payload[AnalyticsProperties.fromSource], AnalyticsDefaults.none);

    // tti / ttl are milliseconds since `recordProcessStart` — non-negative
    // integers, and ttl ≤ tti (ttl stamped on first-route commit, tti when
    // the first screen's Bloc fires this method).
    expect(payload[AnalyticsProperties.tti], isA<int>());
    expect(payload[AnalyticsProperties.ttl], isA<int>());
    final tti = payload[AnalyticsProperties.tti] as int;
    final ttl = payload[AnalyticsProperties.ttl] as int;
    expect(tti, greaterThanOrEqualTo(0));
    expect(ttl, greaterThanOrEqualTo(0));
    expect(ttl, lessThanOrEqualTo(tti),
        reason: 'ttl (first-route commit) must precede tti (interactive)');

    // Follow-up: fireLifeCycleEvents fires application_opened on first install.
    expect(h.hasEvent(AnalyticsEvents.applicationOpened), isTrue);
    // Timer stopped so subsequent calls are no-ops.
    expect(h.launchTimer.isStopped, isTrue);
  });

  test('is no-op after LaunchTimer has stopped', () async {
    await build();
    await h.analytics.logAppLaunched(FromScreens.discover);
    h.clear();

    // 2nd call must not re-fire.
    await h.analytics.logAppLaunched(FromScreens.discover);
    expect(h.hasEvent(AnalyticsEvents.appLaunched), isFalse);
    expect(h.hasEvent(AnalyticsEvents.applicationOpened), isFalse);
  });

  test('emits from_screen=none when caller passes empty string', () async {
    await build();

    await h.analytics.logAppLaunched('');

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.fromScreen], AnalyticsDefaults.none);
  });

  test('ttl is stamped by observer on first non-splash route push', () async {
    await build();
    // Splash pushes first (bootstrap page) — must NOT stamp ttl.
    h.navObserver.didPush(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: RouteNames.splashName),
        builder: (_) => const SizedBox(),
      ),
      null,
    );
    expect(h.launchTimer.ttl, 0,
        reason: 'splash push is excluded from the TTL stamp');

    // First non-splash push — stamps ttl.
    h.navObserver.didPush(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: RouteNames.homeName),
        builder: (_) => const SizedBox(),
      ),
      null,
    );
    final firstTtl = h.launchTimer.ttl;
    expect(firstTtl, greaterThan(0),
        reason: 'first non-splash push stamps ttl');

    // Subsequent screen pushes during the same cold start must NOT overwrite
    // ttl (idempotent — first real push wins).
    h.navObserver.didPush(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: RouteNames.landingPageName),
        builder: (_) => const SizedBox(),
      ),
      null,
    );
    expect(h.launchTimer.ttl, firstTtl,
        reason: 'logTtl is idempotent — later pushes must not overwrite');

    // Fire app_launched — payload carries the stamped ttl.
    await h.analytics.logAppLaunched(FromScreens.discover);
    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.ttl], firstTtl);
  });

  test('install_type = "Update" on version bump', () async {
    // Version cached in prefs differs from PackageInfo.setMockInitialValues
    // default (1.99.0) → `_resolveInstallType` returns "Update".
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      StorageKeys.cachedVersionName: '1.10.2',
      StorageKeys.cachedVersionCode: 2016102904,
    });

    await h.analytics.logAppLaunched(FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.update);
  });

  test('install_type = "none" when cached version matches current', () async {
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      StorageKeys.cachedVersionName: '1.99.0', // matches PackageInfo mock
      StorageKeys.cachedVersionCode: 99999,
    });

    await h.analytics.logAppLaunched(FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.installType], AnalyticsDefaults.none,
        reason: 'no install/update happened — resolver returns null, '
            'AnalyticsDefaults.none is the wire fallback');
  });

  test('from_source reflects LaunchTimer.launchSource when set', () async {
    await build();
    h.launchTimer.launchSource = AnalyticsDefaults.push;

    await h.analytics.logAppLaunched(FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.fromSource], AnalyticsDefaults.push);
  });

  // ANDROID PARITY NOTE: Android calls `logEvent(APP_LAUNCHED, props, false, false)`
  // — attribution:false. Flutter's `logEvent` defaults `attribution: true` and
  // `logAppLaunched` doesn't override, so app_launched ships with current
  // OrderAttribution merged. This test pins current behaviour.
  test('currently merges OrderAttribution (Flutter/Android divergence)', () async {
    await build();
    h.orderAttribution.setFunnel(Funnel.search);

    await h.analytics.logAppLaunched(FromScreens.discover);

    final payload = h.singleEvent(AnalyticsEvents.appLaunched);
    expect(payload[AnalyticsProperties.funnel], Funnel.search.wire);
  });

  test('applicationStatusFlag=true drives a follow-up application_opened even '
      'when version unchanged', () async {
    // Simulate 3rd+ cold start: cached matches current, but the app-status
    // flag was set true by main.dart. fireLifeCycleEvents itself won't fire
    // application_opened (no version change) — the fallback branch in
    // logAppLaunched must fire it instead.
    await build(prefs: {
      StorageKeys.isFirstInstall: false,
      StorageKeys.cachedVersionName: '1.99.0',
      StorageKeys.cachedVersionCode: 99999,
      StorageKeys.applicationStatusFlag: true,
    });

    await h.analytics.logAppLaunched(FromScreens.discover);

    expect(h.hasEvent(AnalyticsEvents.applicationOpened), isTrue,
        reason: 'must fire from the applicationStatusFlag fallback');
    // The fallback path fires with sendExtraParams=false → no installType /
    // previousVersionName / previousVersionCode keys.
    final appOpened = h.singleEvent(AnalyticsEvents.applicationOpened);
    expect(appOpened.containsKey(AnalyticsProperties.installType), isFalse);
    expect(appOpened.containsKey(AnalyticsProperties.previousVersionName), isFalse);
    expect(h.prefs.applicationStatusFlag, isFalse);
  });
}
