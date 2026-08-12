import 'dart:async';

import 'package:flutter/foundation.dart';

class AnalyticsEventLog {
  AnalyticsEventLog(this.event, this.payload, this.timestamp);
  final String event;
  final Map<String, Object?> payload;
  final DateTime timestamp;
}

/// ponytail: debug-only in-memory buffer of the last N analytics events.
/// Opened via the Talker floating button (long-press).
///
/// - **Zero cost when the debug page isn't open** — `_ctrl.hasListener`
///   short-circuits both the stream emission AND the microtask schedule.
/// - **Coalesced per event-loop tick** — a batch of `record()` calls (scroll
///   burst, impression flush) triggers ONE stream event, not N.
/// - **O(1) reads by index** — the debug page hits the ring directly via
///   [eventAt] / [length]; no per-frame `List.unmodifiable(_buffer)` copy.
class AnalyticsDebugLog {
  AnalyticsDebugLog._();

  static const int _capacity = 500;

  // Ring buffer. `_head` = slot the next `record` will write to; the newest
  // entry sits at `(_head - 1) mod capacity`. External indexing goes
  // newest-first via [eventAt].
  static final List<AnalyticsEventLog?> _ring =
      List<AnalyticsEventLog?>.filled(_capacity, null);
  static int _head = 0;
  static int _count = 0;

  static final StreamController<void> _ctrl =
      StreamController<void>.broadcast();
  static bool _pending = false;

  /// Fires once per event-loop tick whenever the buffer changed. Debug page
  /// subscribes; nothing else should. Emissions are gated on `hasListener`,
  /// so a closed page pays nothing.
  static Stream<void> get changes => _ctrl.stream;

  static int get length => _count;

  /// Newest-first read. [i] = 0 → most recent event.
  static AnalyticsEventLog eventAt(int i) => _ring[_slotForIndex(i)]!;

  static int _slotForIndex(int i) =>
      (_head - 1 - i + _capacity * 2) % _capacity;

  static void record(String event, Map<String, Object?> payload) {
    if (!kDebugMode) return;
    _ring[_head] = AnalyticsEventLog(event, payload, DateTime.now());
    _head = (_head + 1) % _capacity;
    if (_count < _capacity) _count++;
    _scheduleNotify();
  }

  static void clear() {
    for (var i = 0; i < _capacity; i++) {
      _ring[i] = null;
    }
    _head = 0;
    _count = 0;
    _scheduleNotify();
  }

  /// Coalesce N synchronous `record` calls into one stream emission per
  /// microtask. Combined with Flutter's frame scheduler this becomes one
  /// UI rebuild per frame, no matter how many events fired in between.
  static void _scheduleNotify() {
    if (_pending) return;
    if (!_ctrl.hasListener) return;
    _pending = true;
    scheduleMicrotask(() {
      _pending = false;
      if (_ctrl.hasListener) _ctrl.add(null);
    });
  }
}
