import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/config/env_config.dart';
import 'core/di/injection.dart';
import 'features/main/di/injection_container.dart';
import 'hs_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // Increase image cache limits so decoded images survive scrolling.
  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 << 20; // 200 MB

  // Load environment variables from .env
  await EnvConfig.load();

  // Initialize Firebase (not supported on web without firebase_options.dart)
  if (!kIsWeb) {
    await Firebase.initializeApp();

    // Crashlytics: catch all Flutter framework errors (not supported on web)
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Crashlytics: catch async errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize dependency injection
  await initDependencies();

  runApp(const HSApp());
}
