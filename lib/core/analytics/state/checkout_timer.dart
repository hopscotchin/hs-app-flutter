import 'package:injectable/injectable.dart';

/// Step / total / background duration timer for the checkout funnel.
/// Runtime-only. Millisecond precision via a process-anchored monotonic clock.
@lazySingleton
class CheckoutTimer {
  CheckoutTimer();

  final Stopwatch _clock = Stopwatch()..start();

  int _firstEventTimeMicros = 0;
  int _lastEventTimeMicros = 0;
  int _backgroundStartMicros = 0;
  int _backgroundDurationMillis = 0;

  /// Anchor the checkout funnel start. Sets both `first` and `last` to now.
  void updateFirstEventTime() {
    _firstEventTimeMicros = _clock.elapsedMicroseconds;
    _lastEventTimeMicros = _firstEventTimeMicros;
  }

  /// `step_duration`. Advances the last-event anchor when
  /// [updateWithCurrentTime] is true (default).
  int timeSinceLastEvent({bool updateWithCurrentTime = true}) {
    final now = _clock.elapsedMicroseconds;
    final ms = (now - _lastEventTimeMicros) ~/ 1000;
    if (updateWithCurrentTime) _lastEventTimeMicros = now;
    return ms;
  }

  /// `total_duration` — read-only, does not advance anchors.
  int get timeSinceFirstEvent =>
      (_clock.elapsedMicroseconds - _firstEventTimeMicros) ~/ 1000;

  /// Anchor the background-start timestamp. Idempotent-ish — if the app
  /// pauses twice without an intervening resume (Android can fire paused
  /// during a system dialog), the second call overwrites the anchor. That
  /// still yields the correct total because the first stint's duration
  /// was flushed to `_backgroundDurationMillis` on the missing resume —
  /// wait, it wasn't. See guard in [setBackgroundEnd].
  void setBackgroundStart() {
    _backgroundStartMicros = _clock.elapsedMicroseconds;
  }

  /// **Accumulates** each pause→resume stint. Guards against a stray
  /// resume with no preceding pause (would otherwise read full process
  /// uptime since `_backgroundStartMicros` defaults to 0). Zeros the
  /// anchor after each accumulation so a subsequent stray resume no-ops.
  void setBackgroundEnd() {
    if (_backgroundStartMicros == 0) return;
    _backgroundDurationMillis +=
        (_clock.elapsedMicroseconds - _backgroundStartMicros) ~/ 1000;
    _backgroundStartMicros = 0;
  }

  /// Called after a non-zero background duration has been read onto an event.
  void resetBackgroundTimer() {
    _backgroundStartMicros = 0;
    _backgroundDurationMillis = 0;
  }

  int get backgroundDuration =>
      _backgroundDurationMillis < 0 ? 0 : _backgroundDurationMillis;
}
