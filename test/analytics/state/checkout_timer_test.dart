import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/state/checkout_timer.dart';

/// Background-timer semantics — regressions from the previous version:
///   • `setBackgroundEnd` OVERWROTE (multi-stint pauses lost all but last).
///   • Stray `setBackgroundEnd` with no prior `setBackgroundStart` read
///     full process uptime (anchor at 0).
///
/// Now: accumulates across stints, guards against stray resumes.
void main() {
  late CheckoutTimer timer;

  setUp(() => timer = CheckoutTimer());

  test('stray setBackgroundEnd with no prior start is a no-op', () async {
    // Wait a tick so the internal stopwatch has some ms; without the guard
    // the resume would read full uptime.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    timer.setBackgroundEnd();
    expect(timer.backgroundDuration, 0);
  });

  test('single stint reports its duration', () async {
    timer.setBackgroundStart();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    timer.setBackgroundEnd();

    expect(timer.backgroundDuration, greaterThanOrEqualTo(10));
  });

  test('multi-stint pauses ACCUMULATE (regression: previously overwrote)',
      () async {
    // Stint 1.
    timer.setBackgroundStart();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    timer.setBackgroundEnd();
    final afterStint1 = timer.backgroundDuration;

    // Stint 2 — must ADD, not replace.
    timer.setBackgroundStart();
    await Future<void>.delayed(const Duration(milliseconds: 15));
    timer.setBackgroundEnd();

    expect(timer.backgroundDuration, greaterThanOrEqualTo(afterStint1 + 15),
        reason: 'each stint accumulates onto the total');
  });

  test('setBackgroundEnd zeros the anchor so a stray follow-up no-ops',
      () async {
    timer.setBackgroundStart();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    timer.setBackgroundEnd();
    final firstTotal = timer.backgroundDuration;

    // Second setBackgroundEnd with no start in between → guard trips, no add.
    await Future<void>.delayed(const Duration(milliseconds: 20));
    timer.setBackgroundEnd();

    expect(timer.backgroundDuration, firstTotal,
        reason: 'anchor cleared after each accumulation; stray end no-ops');
  });

  test('resetBackgroundTimer clears total and anchor together', () async {
    timer.setBackgroundStart();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    timer.setBackgroundEnd();
    expect(timer.backgroundDuration, greaterThan(0));

    timer.resetBackgroundTimer();

    expect(timer.backgroundDuration, 0);
    // Anchor also zeroed → a stray end still no-ops post-reset.
    timer.setBackgroundEnd();
    expect(timer.backgroundDuration, 0);
  });
}
