import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger_plus/talker_dio_logger_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/config/env_config.dart';
import 'core/di/injection.dart';
import 'core/network/cookies/cookies_based_events_util.dart';
import 'core/network/cookies/hs_cookie_store.dart';
import 'core/network/network_client.dart';
import 'core/services/pref_manager.dart';
import 'core/theme/app_theme.dart';
import 'hs_app.dart';

void main() async {
  // if (kDebugMode) enableFlutterDriverExtension(silenceErrors: true);

  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintBaselinesEnabled = true;

  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiLight);

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

  // Initialize cookie/session helpers with DI-managed PrefManager.
  HSCookieStore.init(prefManager);
  CookiesBasedEventsUtil.instance.init(prefManager);

  // Restore persistent ticket so initial API requests include auth header.
  final savedTicket = prefManager.persistentTicket;
  if (savedTicket != null && savedTicket.isNotEmpty) {
    networkClient.setPersistentTicket(savedTicket);
  }
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
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printCreations: true,
        printClosings: true,
        printStateFullData: false,
        // this helps in logging the full event/state data, but can be very verbose and may cause performance issues in large apps, so use with caution

        // transitionFilter: (bloc, transition) {
        //   print(
        //     'Bloc transition: ${bloc.runtimeType} ${transition.event}${transition.nextState} ${transition.currentState}',
        //   );
        //   return true;
        // },
      ),
    );
  }
}
