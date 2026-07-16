import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class _AppFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) return true;
    return event.level.index >= Level.error.index;
  }
}

class _CrashlyticsOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (kIsWeb) return;
    if (event.level.index < Level.error.index) return;
    final error = event.origin.error;
    final stackTrace = event.origin.stackTrace ?? StackTrace.current;
    FirebaseCrashlytics.instance.recordError(
      error ?? event.origin.message,
      stackTrace,
      reason: error != null ? event.origin.message?.toString() : null,
      fatal: event.level == Level.fatal,
    );
  }
}

final logger = Logger(
  filter: _AppFilter(),
  output: MultiOutput([
    if (kDebugMode) ConsoleOutput(),
    if (!kIsWeb) _CrashlyticsOutput(),
  ]),
);
