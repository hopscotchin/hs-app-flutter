import 'dart:async';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:injectable/injectable.dart';

import '../analytics/constants/analytics_defaults.dart';
import '../analytics/constants/analytics_properties.dart';
import '../analytics/events/analytics_helper.dart';
import '../analytics/events/modules/lifecycle_events.dart';
import '../../features/splash/data/models/app_config_response.dart';
import 'notification_nudge_helper.dart';
import 'pref_manager.dart';

/// Notification-permission nudge orchestrator. Ports Android's
/// `NotificationUtil` + the per-screen `CTPushPermissionNotificationResponseListener`
/// wiring: gates *when* to ask for the OS permission per screen using the
/// server-driven rules in [NotificationNudgeHelper], delegates the actual OS
/// prompt to CleverTap (which is also how the native app does it), and fires
/// the same four `notification_permission_*` analytics events.
///
/// Runs on both platforms. All three CleverTap APIs used here are implemented
/// on iOS as well as Android (`promptForPushPermission:`,
/// `getNotificationPermissionStatusWithCompletionHandler:` and the
/// `CleverTapPushPermissionDelegate`), so the same gating drives both. One
/// difference worth knowing: on iOS `getPushNotificationPermissionStatus`
/// reports false for *both* "not asked yet" and "denied", so a shopper who has
/// already declined still satisfies the frequency rules and gets nudged again —
/// `promptForPushNotification(true)` sends them to Settings in that case, since
/// iOS only ever presents the system dialog once.
///
/// Only three of Android's five trigger screens exist in this app today —
/// Order Confirmation and Orders Listing aren't built yet. Wire those two in
/// (`FromScreens.orderConfirmation` / `FromScreens.orderListing` are already
/// defined) once those screens exist.
@lazySingleton
class NotificationPermissionService {
  NotificationPermissionService(this._prefManager, this._nudgeHelper, this._analytics);

  final PrefManager _prefManager;
  final NotificationNudgeHelper _nudgeHelper;
  final AnalyticsHelper _analytics;

  // `setCleverTapPushPermissionResponseReceivedHandler` is an instance
  // method that registers this instance's platform-channel handler — no
  // other code in the app currently instantiates CleverTapPlugin to set
  // instance-level callbacks, so this is the single owner of that channel.
  final CleverTapPlugin _cleverTapPlugin = CleverTapPlugin();

  static const _homepageScreen = 'HOMEPAGE';
  static const _plpScreen = 'PLP';
  static const _wishlistScreen = 'WISH_LIST';

  /// Screen name passed to the pending `promptForPushNotification` call, read
  /// back by [_onPermissionResponse] once CleverTap reports the OS dialog's
  /// result. The plugin's response handler is a single global callback (not
  /// scoped per-caller like Android's per-Activity listener), so this is how
  /// we recover "which screen asked" for the ACCEPTED/REJECTED event.
  String? _pendingFromScreen;

  /// Call once at app startup (see `PushNotificationService.initialize`).
  void registerResponseListener() {
    _cleverTapPlugin.setCleverTapPushPermissionResponseReceivedHandler(_onPermissionResponse);
  }

  void _onPermissionResponse(bool accepted) {
    final fromScreen = _pendingFromScreen;
    _pendingFromScreen = null;
    if (accepted) {
      _analytics.logNotificationPermissionAccepted(fromScreen: fromScreen);
    } else {
      _analytics.logNotificationPermissionRejected(fromScreen: fromScreen);
    }
  }

  Future<bool> get isGranted async {
    return await CleverTapPlugin.getPushNotificationPermissionStatus() ?? false;
  }

  Future<void> _requestOsPermission(String fromScreen) async {
    _pendingFromScreen = fromScreen;
    unawaited(CleverTapPlugin.promptForPushNotification(true));
  }

  // ─── Homepage ───────────────────────────────────────────────────
  //
  // Custom pre-permission dialog, gated by the server-driven rule for the
  // "HOMEPAGE" screen. Mirrors `NotificationUtil.shouldShowDialog`.

  Future<bool> shouldShowHomepageDialog({bool isFromOrderConfirmation = false}) async {
    if (await isGranted) return false;
    final rule = _nudgeHelper.getNudge(_homepageScreen)?.rule;
    if (rule?.dismissedFrequency == null ||
        rule?.deniedFrequency == null ||
        rule?.oneTimeTargetDate == null) {
      return false;
    }
    return _shouldShowByRule(
      rule!,
      // naPermission: dialog was shown before but user hasn't explicitly
      // dismissed it (i.e. they backgrounded/ignored it).
      naPermission: _prefManager.notificationDialogShown && !_prefManager.isNotificationNudgeDismissed,
      noPermission: _prefManager.isNotificationNudgeDismissed,
      lastShownAtMs: _prefManager.notificationNudgeDateTime,
      oneTimeTargetDateNotified: _prefManager.notificationNudgeOneTimeTargetDateNotified,
      onOneTimeTargetDateNotified: _prefManager.setNotificationNudgeOneTimeTargetDateNotified,
      isFromOrderConfirmation: isFromOrderConfirmation,
    );
  }

  void recordHomepageIntentShown() {
    _prefManager.setNotificationDialogShown(true);
    _prefManager.setNotificationNudgeDateTime(DateTime.now().millisecondsSinceEpoch);
    _analytics.logNotificationPermissionIntentShown(fromScreen: FromScreens.discover);
  }

  void recordHomepageDismissed() {
    _prefManager.setNotificationNudgeDismissed(true);
    _analytics.logNotificationPermissionDismissed(fromScreen: FromScreens.discover);
  }

  Future<void> requestHomepagePermission() => _requestOsPermission(FromScreens.discover);

  NotificationNudge? get homepageNudgeCopy => _nudgeHelper.getNudge(_homepageScreen);

  // ─── PLP ────────────────────────────────────────────────────────
  //
  // Inline nudge shown once the shopper has scrolled past a target product
  // index, gated by the "PLP" screen's own rule + its own timestamp/dismiss
  // pair (Android keeps this separate from the homepage dialog's state).

  Future<bool> shouldShowPlpNudge() async {
    if (await isGranted) return false;
    final rule = _nudgeHelper.getNudge(_plpScreen)?.rule;
    if (rule == null) return false;
    final dismissed = _prefManager.isNotificationNudgePlpDismissed;
    final timeDiffHours = _hoursSince(_prefManager.notificationNudgePlpDateTime);
    if (rule.showNudgeFrequency != null && !dismissed && timeDiffHours >= rule.showNudgeFrequency!) {
      return true;
    }
    if (rule.dismissedFrequency != null && dismissed && timeDiffHours >= rule.dismissedFrequency!) {
      return true;
    }
    return false;
  }

  // Android fires this event's `from_screen` as lowercase `"plp"`
  // (`AnalyticsProperties.PLP`), not the capitalized `FromScreens` values
  // ("Search Plp" / "Boutique Plp") used elsewhere for PLP — preserved here
  // for verbatim parity with the dashboard funnel.
  void recordPlpIntentShown() {
    _prefManager.setNotificationNudgePlpDateTime(DateTime.now().millisecondsSinceEpoch);
    _analytics.logNotificationPermissionIntentShown(fromScreen: AnalyticsProperties.plp);
  }

  void recordPlpDismissed() {
    _prefManager.setNotificationNudgePlpDismissed(true);
    _prefManager.setNotificationNudgePlpDateTime(DateTime.now().millisecondsSinceEpoch);
    _analytics.logNotificationPermissionDismissed(fromScreen: AnalyticsProperties.plp);
  }

  Future<void> requestPlpPermission() => _requestOsPermission(AnalyticsProperties.plp);

  NotificationNudge? get plpNudgeCopy => _nudgeHelper.getNudge(_plpScreen);

  // ─── WebView (wishlist page only) ──────────────────────────────
  //
  // No frequency gating on Android for this one — shown every time the
  // wishlist page loads with permission still missing.

  Future<bool> shouldShowWebviewNudge() async {
    if (_nudgeHelper.getNudge(_wishlistScreen) == null) return false;
    return !await isGranted;
  }

  void recordWebviewIntentShown() {
    _analytics.logNotificationPermissionIntentShown(fromScreen: FromScreens.webview);
  }

  void recordWebviewDismissed() {
    _analytics.logNotificationPermissionDismissed(fromScreen: FromScreens.webview);
  }

  Future<void> requestWebviewPermission() => _requestOsPermission(FromScreens.webview);

  NotificationNudge? get wishlistNudgeCopy => _nudgeHelper.getNudge(_wishlistScreen);

  // ─── Shared rule engine (homepage only — PLP has its own above) ──

  bool _shouldShowByRule(
    NotificationNudgeRule rule, {
    required bool naPermission,
    required bool noPermission,
    required int lastShownAtMs,
    required int oneTimeTargetDateNotified,
    required void Function(int) onOneTimeTargetDateNotified,
    bool isFromOrderConfirmation = false,
  }) {
    if (isFromOrderConfirmation) return true;

    // Never shown before: always show once, regardless of the frequency
    // rules below (mirrors Android's `isFirstInstall()` check, which is
    // really "first time this specific dialog would ever be evaluated" —
    // not `PrefManager.isFirstInstall`, which flips false during lifecycle
    // event firing *before* the homepage even loads, so by the time this
    // runs it's already stale for a real first-time user).
    if (!_prefManager.notificationDialogShown) {
      return true;
    }

    final timeDiffHours = _hoursSince(lastShownAtMs);
    if (rule.dismissedFrequency != null && naPermission && timeDiffHours >= rule.dismissedFrequency!) {
      return true;
    }
    if (rule.deniedFrequency != null && noPermission && timeDiffHours >= rule.deniedFrequency!) {
      return true;
    }
    final targetDate = rule.oneTimeTargetDate;
    if (targetDate != null && DateTime.now().millisecondsSinceEpoch <= targetDate) {
      if (oneTimeTargetDateNotified == -1 || oneTimeTargetDateNotified < targetDate) {
        onOneTimeTargetDateNotified(targetDate);
        return true;
      }
      return false;
    }
    return false;
  }

  int _hoursSince(int epochMs) {
    if (epochMs == 0) return 1 << 30; // never shown — treat as "long enough ago"
    return (DateTime.now().millisecondsSinceEpoch - epochMs) ~/ (1000 * 60 * 60);
  }
}
