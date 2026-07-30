import 'package:flutter/foundation.dart';

class AnalyticsEventLog {
  AnalyticsEventLog(this.event, this.payload, this.timestamp);
  final String event;
  final Map<String, Object?> payload;
  final DateTime timestamp;
}

/// ponytail: debug-only in-memory buffer of the last N analytics events.
/// Opened via the Talker floating button (long-press).
class AnalyticsDebugLog {
  AnalyticsDebugLog._();

  static const _maxLogSize = 500;

  static final ValueNotifier<List<AnalyticsEventLog>> log =
      ValueNotifier(<AnalyticsEventLog>[]);

  static void record(String event, Map<String, Object?> payload) {
    if (!kDebugMode) return;
    final entry = AnalyticsEventLog(
      event,
      Map<String, Object?>.of(payload),
      DateTime.now(),
    );
    final next = <AnalyticsEventLog>[entry, ...log.value];
    if (next.length > _maxLogSize) next.removeRange(_maxLogSize, next.length);
    log.value = next;
  }
}
