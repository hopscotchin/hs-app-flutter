import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../navigation/action_url_handler.dart';
import '../router/app_router.dart';

/// Captures every way a deep link can reach the app and routes it through
/// the existing [ActionUrlHandler] pipeline:
///   - Custom scheme (`hopscotch://…`) or Universal/App Link, cold start.
///   - Same, tapped while the app is warm/backgrounded.
///   - A CleverTap push notification tapped warm/backgrounded
///     (`setCleverTapPushClickedPayloadReceivedHandler`).
///   - A CleverTap push notification tapped from a fully killed process
///     (`onKilledStateNotificationClicked`).
///
/// Previously none of these were wired up — `ActionUrlHandler`/
/// `DeeplinkHost` existed but nothing ever called them from an OS-level
/// trigger, so tapping a notification just opened the app to its default
/// screen with no navigation and no click attribution.
@lazySingleton
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final CleverTapPlugin _cleverTapPlugin = CleverTapPlugin();
  StreamSubscription<Uri>? _linkSubscription;

  /// True as soon as a cold-start deep link is known (custom scheme/App
  /// Link, or a push tap that launched the app from a killed process).
  /// `SplashPage` checks this before its own "finished loading → go home"
  /// navigation so it doesn't clobber the screen this service is about to
  /// navigate to. Deliberately never cleared — once a cold start is driven
  /// by a deep link, splash's default auto-navigation should stay
  /// suppressed for the rest of that launch, not just until the first
  /// post-frame callback runs (which fires long before splash's own
  /// network-dependent "loaded" state).
  bool hasPendingColdStartDeepLink = false;

  static void _onKilledStateNotificationClicked(Map<String, dynamic> payload) {
    CleverTapPlugin.pushNotificationClickedEvent(payload);
  }

  Future<void> initialize() async {
    _cleverTapPlugin.setCleverTapPushClickedPayloadReceivedHandler(_onPushClicked);
    // Must be a static/top-level function, not a closure over `this` — per
    // the plugin's own doc comment this callback fires on a background
    // isolate, which can only invoke static/top-level functions and has no
    // access to this instance's state or the UI. Navigation for this case
    // is already covered by getInitialLink() below (CleverTap sets the
    // launch Intent's data URI to the same wzrk_dl), so this only needs to
    // fire the attribution event.
    CleverTapPlugin.onKilledStateNotificationClicked(_onKilledStateNotificationClicked);

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) => _handle(uri.toString()),
    );

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      hasPendingColdStartDeepLink = true;
      _handle(initialUri.toString());
      return;
    }

    await _handleIosColdStartPush();
  }

  /// iOS cold start from a push tap. Android needs nothing here — CleverTap
  /// puts `wzrk_dl` on the launch Intent's data URI, so `getInitialLink()`
  /// above already caught it — but iOS has no equivalent, and
  /// [_onPushClicked] cannot be relied on for this case: the OS delivers the
  /// tap to `AppDelegate.userNotificationCenter(_:didReceive:…)` moments
  /// after launch, typically before Dart has finished registering the
  /// handler above, and a method-channel call with no handler yet is
  /// dropped rather than queued.
  ///
  /// The value is captured natively by the
  /// `CleverTapPlugin.applicationDidLaunchWithOptions:` call in AppDelegate.
  Future<void> _handleIosColdStartPush() async {
    if (!Platform.isIOS) return;
    final url = await CleverTapPlugin.getInitialUrl();
    if (url == null || url.isEmpty) return;

    // If the handler *did* manage to register in time, the same tap also
    // arrives through [_onPushClicked]; suppress that one so we don't
    // navigate twice. Released after a few seconds so a genuine later tap on
    // a push carrying the same deep link still routes.
    _coldStartPushUrl = url;
    Timer(const Duration(seconds: 5), () => _coldStartPushUrl = null);

    hasPendingColdStartDeepLink = true;
    _handle(url);
  }

  /// Deep link already navigated by [_handleIosColdStartPush], pending a
  /// possible duplicate delivery through [_onPushClicked]. iOS only.
  String? _coldStartPushUrl;

  void _onPushClicked(Map<String, dynamic> payload) {
    debugPrint('DeepLinkService: push clicked, payload=$payload');
    // Attribution — mirrors Android SplashActivity.onNewIntent's
    // `pushNotificationClickedEvent(intent.getExtras())`.
    //
    // Skipped on iOS: `AppDelegate.userNotificationCenter(_:didReceive:…)`
    // routes the tap through the SDK's `handleNotificationWithData:`, which
    // records the click itself. Recording it again here would double-count
    // every iOS notification click in the dashboard.
    if (!Platform.isIOS) {
      CleverTapPlugin.pushNotificationClickedEvent(payload);
    }

    final deepLink = payload['wzrk_dl'];
    if (deepLink is! String || deepLink.isEmpty) {
      debugPrint('DeepLinkService: no wzrk_dl in payload, nothing to navigate to');
      return;
    }
    if (deepLink == _coldStartPushUrl) {
      debugPrint('DeepLinkService: $deepLink already handled as a cold start, skipping');
      _coldStartPushUrl = null;
      return;
    }
    _handle(deepLink);
  }

  /// Tries to navigate immediately — the common case (app already idle in
  /// the foreground when a link/push is tapped) has a ready context right
  /// away, and waiting a frame for no reason adds a visible flash of
  /// whatever screen was already showing. Falls back to a deferred retry
  /// only when the context genuinely isn't attached yet (true cold start,
  /// or the OS is still mid-resume-from-background transition).
  ///
  /// The retry explicitly calls `scheduleFrame()` — `addPostFrameCallback`
  /// alone only fires once a frame actually happens; it doesn't request
  /// one. Without this, a callback registered while the app is fully idle
  /// (no pending frame) could sit unfired indefinitely.
  void _handle(String url) {
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      debugPrint('DeepLinkService: navigating to $url');
      final handled = ActionUrlHandler.navigate(context, url);
      if (!handled) {
        debugPrint('DeepLinkService: ActionUrlHandler could not resolve $url');
      }
      return;
    }
    debugPrint('DeepLinkService: no navigator context yet for $url, retrying next frame');
    WidgetsBinding.instance.addPostFrameCallback((_) => _handle(url));
    WidgetsBinding.instance.scheduleFrame();
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
