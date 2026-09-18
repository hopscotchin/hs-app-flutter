import 'package:injectable/injectable.dart';

/// Anchor for `cart_viewed`'s `tti` — when the user asked for the cart.
///
/// Runtime-only, like [LaunchTimer] and [CheckoutTimer], and stamped from
/// `AppNavigationObserver.didPush` rather than by whoever navigated. `tti`
/// measures the wait the user actually sees — route push, page build, cart
/// request — so the clock has to start before the page exists, which rules out
/// `CartPage.initState`. Driving it off the push instead of a navigator helper
/// means every route to the cart is covered: a new `goToCart` variant, a
/// deeplink, or a direct `pushNamed` cannot forget to start it.
///
/// Ports Android's `Util.cartClickedTime`, set when the cart tab is tapped and
/// read in `fireCartViewedEvent` as `now - cartClickedTime`.
@lazySingleton
class CartTimer {
  /// Monotonic, like [LaunchTimer] and [CheckoutTimer] — and like Android,
  /// which anchors this on `System.nanoTime()` (`Util.setCartClickedTime`).
  ///
  /// Not `DateTime.now()`: that reads the wall clock, so an NTP correction or
  /// a manual clock change between the cart opening and the response landing
  /// would be measured as `tti`. A backwards adjustment yields a negative
  /// duration, which Flutter's `putAnalyticsKey` keeps (it deliberately does
  /// not reproduce Android's drop-numbers-<=-0 rule), so it would reach the
  /// dashboard as a real reading.
  final Stopwatch _clock = Stopwatch();

  /// Starts the clock. Called on every cart-route push.
  void markOpened() => _clock
    ..reset()
    ..start();

  /// Milliseconds since the cart was opened, or null if it never was.
  ///
  /// **Not reset by a reload.** Android only stamps on entry, so the
  /// `cart_viewed` of a promo or quantity refresh reports time-since-open, not
  /// time-for-that-refresh. Mirrored deliberately — resetting per reload would
  /// produce a different metric under the same name.
  int? get elapsedMs => _clock.isRunning ? _clock.elapsedMilliseconds : null;
}
