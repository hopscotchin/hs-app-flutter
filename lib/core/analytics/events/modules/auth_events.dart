import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Auth events. Entry-point screens (`logLoginViewed`, `logJoinViewed`)
/// also drive `logAppLaunched` — self-guarded by `LaunchTimer.isStopped`.
///
/// **Every auth event fires with `attribution: false`** — no exceptions. Android
/// passes `false` on all eight loggers (`AnalyticsHelper.java:311`, `:321`,
/// `:325`, `:830`, `:842`, `:853`, `:1150`, `:1161`), because auth is not part
/// of a shopping funnel: merging funnel/UTM/LP/TabPage keys here would attach
/// the last tile the user tapped to a login event. `logEvent` defaults
/// `attribution` to `true`, so each call must pass `false` explicitly.
///
/// `logForgotViewed` has no call site — no Flutter forgot-password flow exists
/// and Android never fires the event either. It is kept defined rather than
/// deleted so the payload is settled when that flow lands; see finding A5 for
/// the one place it deliberately departs from Android (`mobile` is a String).
///
/// `universal` is not expressible yet: Android fires `login_viewed`,
/// `join_viewed` and `forgot_viewed` with `universal = true`, but `logEvent`
/// has no such parameter and the one-shot buffer does not exist. Finding B1.
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
    await logEvent(AnalyticsEvents.loginViewed, props, attribution: false);
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
    await logEvent(AnalyticsEvents.joinViewed, props, attribution: false);
  }

  /// `forgot_viewed`. No Flutter UI reaches this yet and Android has no caller
  /// either — kept available rather than deleted, so the payload is defined
  /// when a forgot-password flow lands.
  ///
  /// **`mobile` is a String here, unlike Android.** Android puts a raw `long`
  /// (`AnalyticsHelper.java:851`) while sending a String on `otp_sent` and
  /// `otp_verified` (`:1148`, `:1159`) — one Amplitude key, two JSON types.
  /// Since Android never fires this event there is no live value to match, so
  /// Flutter keeps the key String-typed throughout. See finding A5.
  Future<void> logForgotViewed({
    required String fromScreen,
    String? fromLocation,
    String? fromAuthenticationType,
    String? fromRedirect,
    String? email,
    String? mobile,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: _noneIfEmpty(fromScreen),
      AnalyticsProperties.fromLocation: _noneIfEmpty(fromLocation),
      AnalyticsProperties.fromAuthenticationType: _noneIfEmpty(fromAuthenticationType),
      AnalyticsProperties.fromRedirect: _noneIfEmpty(fromRedirect),
      AnalyticsProperties.mobile: _noneIfEmpty(mobile),
      AnalyticsProperties.email: _noneIfEmpty(email),
    };
    await logEvent(AnalyticsEvents.forgotViewed, props, attribution: false);
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
    await logEvent(AnalyticsEvents.otpSent, props, attribution: false);
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
    await logEvent(AnalyticsEvents.otpVerified, props, attribution: false);
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
    await logEvent(AnalyticsEvents.customerLoggedIn, props, attribution: false);
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
      AnalyticsProperties.validationType: AnalyticsDefaults.otp,
    };
    await logEvent(AnalyticsEvents.customerRegistered, props, attribution: false);
  }

  /// Caller must invoke [resetIdentity] afterwards, once
  /// `_prefs.clearCustomerInfo()` has run.
  Future<void> logCustomerLoggedOut() =>
      logEvent(
        AnalyticsEvents.customerLoggedOut,
        const <String, Object?>{},
        attribution: false,
      );

  String _noneIfEmpty(String? value) {
    if (value == null || value.isEmpty) return AnalyticsDefaults.none;
    return value;
  }
}
