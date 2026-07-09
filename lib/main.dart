import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) enableFlutterDriverExtension(silenceErrors: true);
  // debugPaintBaselinesEnabled = true;

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

  // Increase image cache limits so decoded images survive scrolling.
  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20; // 200 MB

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

  runApp(const HSApp());
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

  // Restore persistent ticket so initial API requests include auth header.
  final savedTicket = prefManager.persistentTicket;
  if (savedTicket != null && savedTicket.isNotEmpty) {
    networkClient.setPersistentTicket(savedTicket);
  }

  // Wire PrefManager into AutoLoginInterceptor so it can persist refreshed tickets.
  networkClient.bindPrefManager(prefManager);

  await sl<PushNotificationService>().initialize();
  // HTTP Inspector — debug builds only. Opened via the floating button overlay.
  if (kDebugMode) {
    final talker = TalkerFlutter.init();
    networkClient.dio.interceptors.add(
      AdvancedDioLogger(
        talker: talker,
        settings: const AdvancedDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: true,
          printErrorData: true,
          printErrorHeaders: true,
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

    // this helps in logging the full event/state data, but can be very verbose and may cause performance issues in large apps, so use with caution

    // transitionFilter: (bloc, transition) {
    //   print(
    //     'Bloc transition: ${bloc.runtimeType} ${transition.event}${transition.nextState} ${transition.currentState}',
    //   );
    //   return true;
    // },
    // ),
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
