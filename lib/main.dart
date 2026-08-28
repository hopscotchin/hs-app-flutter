import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'core/analytics/attribution/utm_header_util.dart';
import 'core/analytics/events/analytics_helper.dart';
import 'core/analytics/services/clarity_helper.dart';
import 'core/analytics/services/clevertap_service.dart';
import 'core/analytics/state/device_probes.dart';
import 'core/analytics/state/experiments_util.dart';
import 'core/analytics/state/launch_timer.dart';
import 'core/config/build_config.dart';
import 'core/config/env_config.dart';
import 'core/config/environment.dart';
import 'core/di/injection.dart';
import 'core/network/cookies/cookies_based_events_util.dart';
import 'core/network/cookies/hs_cookie_store.dart';
import 'core/network/network_client.dart';
import 'core/services/pref_manager.dart';
import 'core/services/push_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'hs_app.dart';

void main() async {
  // enableFlutterDriverExtension installs its own WidgetsBinding, so it must run
  // before ensureInitialized — otherwise the binding is already initialized and
  // _DriverBinding's constructor throws '_debugInitializedType == null'.
  // Only automation builds need the driver extension; normal debug/release use
  // the standard binding.
  if (kIsAutomation && kDebugMode) {
    enableFlutterDriverExtension(silenceErrors: true);
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  // debugPaintBaselinesEnabled = true;

  // VisibilityDetector callback cadence for home-page analytics. 500ms is also
  // the package default, so this is a pin rather than a change: tighter values
  // pound the intersection-check path once per detector per interval during a
  // scroll, and 100ms was measurably janky with 6+ components mounted. Stated
  // explicitly so the cost is visible before anyone lowers it.
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 500);

  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLight);

  // Lock app to portrait orientation on all platforms.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Future.wait([
    EnvConfig.load(),
    configureDependencies(),
    if (!kIsWeb) ...[Firebase.initializeApp()],
  ]);

  await _runPostInitBootstrapping();

  // Initialize Firebase (not supported on web without firebase_options.dart)
  if (!kIsWeb) {
    // Crashlytics: catch all Flutter framework errors (not supported on web)
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Crashlytics: catch async errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(sl<ClarityHelper>().wrap(const HSApp()));
}

Future<void> _runPostInitBootstrapping() async {
  final prefManager = sl<PrefManager>();
  final networkClient = sl<NetworkClient>();

  // Restore the environment the user last selected so subsequent API calls
  // hit the same backend they were logged into. Must run before any other
  // bootstrapping that touches Dio (cookie host, persistent ticket).
  _restoreSelectedEnvironment(prefManager, networkClient);

  // Initialize cookie/session helpers with DI-managed PrefManager.
  HSCookieStore.init(prefManager);
  CookiesBasedEventsUtil.instance.init(prefManager);

  // Analytics bootstrap. Order matters:
  //   1. UTM disk hydration → so a cold-start deeplink's UTM context is
  //      visible to the first identify call.
  //   2. Fast device probes (awaited) → push permission + device profile +
  //      hs_device_id populated so the first cookie-driven identify ships a
  //      real hs_device_id.
  //   3. CleverTap init → fetches cleverTapId into PrefManager so the very
  //      first track/identify carries it (matches Android `CleverTapHelper`).
  //   4. Set applicationStatusFlag=true → mirrors Android SplashActivity.onCreate
  //      line 165. Without this, the 2nd+ cold-start `application_opened` never
  //      fires (fireLifeCycleEvents sets false on first fire and there was
  //      no writer to flip it back on subsequent launches).
  //   5. CookiesBasedEventsUtil.wireAnalytics → so the next HTTP response
  //      fires identifyOnCookieChange / session_started via AnalyticsHelper.
  //   6. LaunchTimer.recordProcessStart → anchors `tti` / `ttl` for the
  //      first viewable screen's `app_launched` event.
  //   7. Advertising-id probe (unawaited) → ATT prompt + IDFA/GAID. On Android
  //      the ad id auto-lands into the next cookie-driven identify via
  //      `_getUserTraits()` reading `_prefs.advertisingId`. **No explicit
  //      identifyAnonymous is fired** — Android emits zero identifies from
  //      `HsApplication.onCreate`; every identify comes from the cookie
  //      interceptor after the first HTTP response.
  sl<UtmHeaderUtil>().hydrateFromDisk();
  await sl<DeviceProbeService>().probe();
  await sl<CleverTapService>().init();
  await prefManager.setApplicationStatusFlag(true);
  CookiesBasedEventsUtil.instance.wireAnalytics(
    analyticsHelper: sl<AnalyticsHelper>(),
    utm: sl<UtmHeaderUtil>(),
    experiments: sl<ExperimentsUtil>(),
    clarity: sl<ClarityHelper>(),
  );
  sl<LaunchTimer>().recordProcessStart();
  // Resolve install type upfront so the first screen's `logAppLaunched`
  // ships the correct `install_type`.
  sl<AnalyticsHelper>().bootstrapInstallType();
  unawaited(sl<DeviceProbeService>().probeAdvertisingId());



  // Restore persistent ticket so initial API requests include auth header.
  final savedTicket = prefManager.persistentTicket;
  if (savedTicket != null && savedTicket.isNotEmpty) {
    networkClient.setPersistentTicket(savedTicket);
  }

  // Wire PrefManager into AutoLoginInterceptor so it can persist refreshed tickets.
  networkClient.bindPrefManager(prefManager);

  await sl<PushNotificationService>().initialize();
  // HTTP Inspector — debug builds only. Opened via the floating button overlay.
  if (kDebugMode || kProfileMode) {
    final talker = TalkerFlutter.init();
    networkClient.dio.interceptors.add(
      AdvancedDioLogger(
        talker: talker,
        settings: const AdvancedDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseData: false,
          printErrorData: false,
          printErrorHeaders: false,
          // hiddenHeaders: {'authorization', 'x-api-key', 'cookie'},
          // hideAuthorizationValue: true,
          enableCurlGeneration: true,
        ),
      ),
    );
    sl.registerSingleton<Talker>(talker);
    // Bloc.observer = TalkerBlocObserver(
    //   talker: talker,
    //   settings: const TalkerBlocLoggerSettings(
    //     printCreations: true,
    //     printClosings: true,
    //     printStateFullData: false,

    // // this helps in logging the full event/state data, but can be very verbose and may cause performance issues in large apps, so use with caution
    //
    // //transitionFilter: (bloc, transition) {
    //   //print(
    //     //'Bloc transition: ${bloc.runtimeType} ${transition.event}${transition.nextState} ${transition.currentState}',
    //   //);
    //   //return true;
    // //},
    //   ),
    // );
  }
}

void _restoreSelectedEnvironment(PrefManager prefManager, NetworkClient networkClient) {
  final name = prefManager.selectedEnvironment;
  if (name == null || name.isEmpty) return;
  for (final env in Environment.values) {
    if (env.name == name) {
      if (env == EnvironmentConfig.current) return;
      EnvironmentConfig.setEnvironment(env);
      networkClient.onEnvironmentChanged();
      return;
    }
  }
}
