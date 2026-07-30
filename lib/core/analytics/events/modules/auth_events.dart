import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Auth events. Entry-point screens (`logLoginViewed`, `logJoinViewed`)
/// also drive `logAppLaunched` — self-guarded by `LaunchTimer.isStopped`.
extension AuthEvents on AnalyticsHelper {
  Future<void> logLoginViewed({
    required String fromScreen,
    String? fromLocation,
    String? validationType,
    String? fromValidationType,
    String? authenticationType,
    String? fromRedirect,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.validationType: _noneIfEmpty(validationType),
      AnalyticsProperties.fromValidationType: _noneIfEmpty(fromValidationType),
      AnalyticsProperties.authenticationType: _noneIfEmpty(authenticationType),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
    };
    await logAppLaunched(FromScreens.login);
    await logEvent(AnalyticsEvents.loginViewed, props);
  }

  Future<void> logJoinViewed({
    required String fromScreen,
    String? fromLocation,
    String? validationType,
    String? fromValidationType,
    String? authenticationType,
    String? fromRedirect,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.validationType: _noneIfEmpty(validationType),
      AnalyticsProperties.fromValidationType: _noneIfEmpty(fromValidationType),
      AnalyticsProperties.authenticationType: _noneIfEmpty(authenticationType),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
    };
    await logAppLaunched(FromScreens.join);
    await logEvent(AnalyticsEvents.joinViewed, props);
  }

  Future<void> logForgotViewed({
    required String fromScreen,
    String? fromLocation,
    String? fromAuthenticationType,
    String? fromRedirect,
    String? email,
    int? mobileNo,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.fromAuthenticationType: _noneIfEmpty(fromAuthenticationType),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
      AnalyticsProperties.mobile:
          (mobileNo != null && mobileNo != 0) ? mobileNo : AnalyticsDefaults.none,
      AnalyticsProperties.email: _noneIfEmpty(email),
    };
    await logEvent(AnalyticsEvents.forgotViewed, props);
  }

  Future<void> logOtpSent({
    required String fromScreen,
    String? fromLocation,
    String? authenticationType,
    String? verificationReason,
    String? mobile,
    String? email,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.authenticationType: _noneIfEmpty(authenticationType),
      AnalyticsProperties.verificationReason: _noneIfEmpty(verificationReason),
      AnalyticsProperties.mobile: _noneIfEmpty(mobile),
      AnalyticsProperties.email: _noneIfEmpty(email),
    };
    await logEvent(AnalyticsEvents.otpSent, props);
  }

  Future<void> logOtpVerified({
    required String fromScreen,
    String? fromLocation,
    String? authenticationType,
    String? verificationReason,
    String? mobile,
    String? email,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.authenticationType: _noneIfEmpty(authenticationType),
      AnalyticsProperties.verificationReason: _noneIfEmpty(verificationReason),
      AnalyticsProperties.mobile: _noneIfEmpty(mobile),
      AnalyticsProperties.email: _noneIfEmpty(email),
    };
    await logEvent(AnalyticsEvents.otpVerified, props);
  }

  Future<void> logCustomerLoggedIn({
    required String authenticationType,
    required String fromScreen,
    String? fromLocation,
    String? validationType,
    String? fromValidationType,
    String? fromRedirect,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.authenticationType: _noneIfEmpty(authenticationType),
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.validationType: _noneIfEmpty(validationType),
      AnalyticsProperties.fromValidationType: _noneIfEmpty(fromValidationType),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
    };
    await logEvent(AnalyticsEvents.customerLoggedIn, props);
  }

  Future<void> logCustomerRegistered({
    required String fromScreen,
    String? fromLocation,
    String? fromRedirect,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
      AnalyticsProperties.authenticationType: AnalyticsDefaults.mobile,
    };
    await logEvent(AnalyticsEvents.customerRegistered, props);
  }

  /// Caller must invoke [resetIdentity] afterwards, once
  /// `_prefs.clearCustomerInfo()` has run.
  Future<void> logCustomerLoggedOut() =>
      logEvent(AnalyticsEvents.customerLoggedOut, const <String, Object?>{});

  String _noneIfEmpty(String? value) {
    if (value == null || value.isEmpty) return AnalyticsDefaults.none;
    return value;
  }
}
