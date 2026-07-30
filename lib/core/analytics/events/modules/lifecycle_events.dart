import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// In-app update + notification permission events. The lifecycle events
/// themselves (`application_opened` / `app_launched` / `session_started`)
/// live on `AnalyticsHelper` — those are lifecycle-driven, not user-driven.
extension LifecycleEvents on AnalyticsHelper {
  Future<void> logInAppUpdate(
    String event, {
    required String fromScreen,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: fromScreen,
    };
    await logEvent(event, props);
  }

  Future<void> logInAppUpdateDownloadClicked({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateDownloadClicked, fromScreen: fromScreen);

  Future<void> logInAppUpdateLaterClicked({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateLaterClicked, fromScreen: fromScreen);

  Future<void> logInAppUpdateInstallShown({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateInstallShown, fromScreen: fromScreen);

  Future<void> logInAppUpdateInstalledSuccess({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateInstalledSuccess, fromScreen: fromScreen);

  Future<void> logInAppUpdateInstalledFailed({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateInstalledFailed, fromScreen: fromScreen);

  Future<void> logInAppUpdateUserCancelled({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateUserCancelled, fromScreen: fromScreen);

  Future<void> logInAppUpdateInstallClicked({required String fromScreen}) =>
      logInAppUpdate(AnalyticsEvents.inAppUpdateInstallClicked, fromScreen: fromScreen);

  Future<void> _logNotificationPermissionEvent(
    String event, {
    required String fromScreen,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: fromScreen,
    };
    await logEvent(event, props, attribution: true);
  }

  Future<void> logNotificationPermissionIntentShown({String? fromScreen}) =>
      _logNotificationPermissionEvent(
        AnalyticsEvents.notificationPermissionIntentShown,
        fromScreen: fromScreen ?? FromScreens.discover,
      );

  Future<void> logNotificationPermissionAccepted({String? fromScreen}) =>
      _logNotificationPermissionEvent(
        AnalyticsEvents.notificationPermissionAccepted,
        fromScreen: fromScreen ?? FromScreens.discover,
      );

  Future<void> logNotificationPermissionRejected({String? fromScreen}) =>
      _logNotificationPermissionEvent(
        AnalyticsEvents.notificationPermissionRejected,
        fromScreen: fromScreen ?? FromScreens.discover,
      );

  Future<void> logNotificationPermissionDismissed({String? fromScreen}) =>
      _logNotificationPermissionEvent(
        AnalyticsEvents.notificationPermissionDismissed,
        fromScreen: fromScreen ?? FromScreens.discover,
      );
}
