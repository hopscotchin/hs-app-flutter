import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/state/cart_timer.dart';

/// `tti` is the wait the user actually sees on the cart: route push, page
/// build, and the cart request.
///
/// Ports Android's `Util.cartClickedTime` — stamped when the cart is opened
/// (`BottombarNavigationActivity:300`) and read in `fireCartViewedEvent` as
/// `System.nanoTime() - cartClickedTime` (`CartAnalytics.kt:150`).
void main() {
  test('reports nothing until the cart is opened', () {
    // Android starts its anchor at 0L, which would make an unopened read
    // "milliseconds since boot". Null keeps the key off the payload instead.
    expect(CartTimer().elapsedMs, isNull);
  });

  test('measures from the open', () async {
    final timer = CartTimer()..markOpened();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(timer.elapsedMs, greaterThanOrEqualTo(25));
  });

  test('is not reset by a reload — only by a fresh open', () async {
    // Android stamps only on entry, so a promo or quantity refresh reports
    // time-since-open, not time-for-that-refresh.
    final timer = CartTimer()..markOpened();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    final firstRead = timer.elapsedMs!;

    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(timer.elapsedMs, greaterThan(firstRead), reason: 'a second read must keep counting');

    timer.markOpened();
    expect(timer.elapsedMs, lessThan(firstRead), reason: 'a fresh open restarts it');
  });

  test('is monotonic, so it can never read negative', () {
    // The reason this is a Stopwatch and not DateTime.now(): a wall-clock
    // source would measure an NTP correction as `tti`, and a backwards
    // adjustment would produce a negative reading that `putAnalyticsKey`
    // keeps — Flutter deliberately does not drop numbers <= 0.
    final timer = CartTimer()..markOpened();
    for (var i = 0; i < 100; i++) {
      expect(timer.elapsedMs, isNonNegative);
    }
  });
}
