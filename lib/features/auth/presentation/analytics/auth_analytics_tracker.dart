import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/auth_events.dart';
import '../../../../core/analytics/services/clevertap_service.dart';
import '../../domain/entities/auth_entry_args.dart';
import '../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';

/// Decides **when** each auth event fires, and how many. `auth_events.dart`
/// owns **what** each payload contains.
///
/// **Stateless, unlike `PdpAnalyticsTracker`.** That one exists to hold
/// suppression flags — twelve of PDP's events are guarded by "have I fired this
/// already?" state. Android's auth surface has none: no `sentXEvent` boolean, no
/// high-water mark, no per-id dedup. The `_viewed` events fire from
/// `onViewCreated` and the rest from API callbacks, every time.
///
/// So this class holds no fields beyond its collaborator. It exists for the
/// tracker's *other* job — orchestration:
///
/// * `customer_registered` and `customer_logged_in` both fire on signup, in
///   that order, and the second is not conditional (finding A6).
/// * `childCohorts` needs coercing before it can reach an `int`-typed trait
///   (finding C4).
/// * `identifyRegistered` or `identifyLoggedIn`, chosen by flow.
/// * CleverTap's `onUserLogin` alongside Segment's identify — a second,
///   separate identity system that has to be told about the same login.
/// * `customer_logged_out` must precede `resetIdentity`.
///
/// That is "which events, in what order, with which traits" — a firing concern,
/// not a payload one. Leaving it in `AuthBloc` put roughly eighty lines of
/// analytics inside a business-logic handler, and gave the Android-parity notes
/// nowhere sensible to live.
///
/// **`@lazySingleton`, not `@injectable`** — the opposite of PDP, and for the
/// same reason it is stateless. There is no per-route state to keep separate, so
/// two stacked auth routes can safely share one instance.
///
/// Nothing here is awaited except where ordering is a contract: analytics must
/// never sit in the user-facing path.
@lazySingleton
class AuthAnalyticsTracker {
  AuthAnalyticsTracker(this._analytics, this._cleverTap);

  final AnalyticsHelper _analytics;
  final CleverTapService _cleverTap;

  // ── RESOLVED · A1 · `from_redirect` is populated ──────────────────────────
  //  DECIDED 2026-09-02: pass it from wherever the user was redirected.
  //  ANDROID  sends the literal "none" on 100% of fires — LoginActivity.kt:83
  //           reads an intent extra no caller ever writes, so the property is
  //           dead across four events. Confirmed on a device capture.
  //  FLUTTER  populates it from `AuthEntryArgs.fromRedirect`, carried in from
  //           the `redirectType` the auth routes already receive. The type key
  //           ("REDIRECT_PROMO") goes on the wire, not the display sentence.
  //  EFFECT   Flutter reports a real dimension where Android reports a
  //           constant. Nothing regresses: a single-valued field cannot be
  //           segmented on, so no existing breakdown depended on it. Worth
  //           raising with the Android team — the fix there is one extra to
  //           write. Excluded from cross-platform comparison until then.
  // ──────────────────────────────────────────────────────────────────────────

  /// The login screen was shown. Fires once per route mount, mirroring
  /// Android's `MobileLoginFragment.onViewCreated` (`:78`), which has no
  /// suppression flag either.
  void onLoginViewed(AuthEntryArgs entry) {
    unawaited(
      _analytics.logLoginViewed(
        fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
        fromLocation: entry.fromLocation,
        fromRedirect: entry.fromRedirect,
        // Hardcoded, not taken from the caller: Android holds both as fragment
        // constants because the mobile login screen has exactly one credential
        // type (MobileLoginFragment.kt:36-37).
        validationType: AnalyticsDefaults.otp,
        authenticationType: AnalyticsDefaults.mobile,
      ),
    );
  }

  /// The join screen was shown. See [onLoginViewed]; Android's equivalent is
  /// `RegisterFragment.kt:83`, with both constants at `:86` and `:88`.
  void onJoinViewed(AuthEntryArgs entry) {
    unawaited(
      _analytics.logJoinViewed(
        fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
        fromLocation: entry.fromLocation,
        fromRedirect: entry.fromRedirect,
        validationType: AnalyticsDefaults.otp,
        authenticationType: AnalyticsDefaults.mobile,
      ),
    );
  }

  // ── ANDROID PARITY · A4 ────────────────────────────────────────────────────
  //  ANDROID  fires otp_sent twice for one OTP on the order-details reorder
  //           flow: OrderDetailsActivity.java:985 fires it at navigation time,
  //           before any OTP is requested, and MobileLoginFragment.kt:167 fires
  //           it again when the send-OTP API returns.
  //  FLUTTER  fires it ONCE, on the API response — the only point at which it is
  //           true. Nothing to reproduce today: Flutter's Orders feature does
  //           not navigate to login at all, so there is no second call site.
  //           A deliberate non-reproduction; Flutter's otp_sent volume will read
  //           LOWER than Android's for that flow, correctly.
  //  THE FIX  is Android's, not ours: drop the navigation-time call. Do NOT add
  //           a second fire when Orders gains a sign-in path —
  //           auth_wire_format_golden_test.dart asserts the count.
  // ──────────────────────────────────────────────────────────────────────────

  /// The send-OTP API returned successfully.
  ///
  /// [email] is populated on the signup path and absent on sign-in, because the
  /// signup form has an email field and the mobile login form does not
  /// (`RegisterFragment.kt:192`). That difference is why the captured payloads
  /// hold two `otp_sent` scenarios rather than one.
  void onOtpSent({
    required AuthEntryArgs entry,
    required String verificationReason,
    required String mobile,
    String? email,
  }) {
    unawaited(
      _analytics.logOtpSent(
        fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
        fromLocation: entry.fromLocation,
        authenticationType: AnalyticsDefaults.mobile,
        verificationReason: verificationReason,
        mobile: mobile,
        email: email,
      ),
    );
  }

  // ── RESOLVED · A2 · real entry context on `otp_verified` ──────────────────
  //  DECIDED 2026-09-02: report the real from_screen and from_location.
  //  ANDROID  hardcodes FromScreens.ACCOUNT and FromLocations.PROFILE_DETAILS
  //           on every fire (OTPVerificationActivity.kt:216-217), from one
  //           screen serving nine flows. Measured wrong: in a captured journey
  //           it reported "Profile Details" 19ms before customer_logged_in
  //           reported "Sign in button" — nothing a user does fits in 19ms.
  //  FLUTTER  passes the entry args through, like every other auth event.
  //  EFFECT   otp_verified becomes joinable to the login_viewed that preceded
  //           it, and OTP drop-off becomes attributable by entry point. On
  //           Android it stays broken, so these two keys must be excluded from
  //           cross-platform comparison until Android is fixed — the
  //           difference is Android's bug, not Flutter under-reporting.
  // ──────────────────────────────────────────────────────────────────────────

  /// The verify-OTP API returned successfully.
  ///
  void onOtpVerified({
    required AuthEntryArgs entry,
    required String verificationReason,
    required String mobile,
  }) {
    unawaited(
      _analytics.logOtpVerified(
        fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
        fromLocation: entry.fromLocation,
        authenticationType: AnalyticsDefaults.mobile,
        verificationReason: verificationReason,
        mobile: mobile,
      ),
    );
  }

  // ── ANDROID PARITY · A6 ────────────────────────────────────────────────────
  //  ANDROID  fires BOTH terminal events on the signup path, 5ms apart.
  //           Util.java:1606 wraps customer_logged_in in `if (!isRegister)`,
  //           which reads as "suppress this on registration" — but all three
  //           SuccessEvent producers hardcode isRegister = false
  //           (MobileLoginFragment.kt:195, EmailLoginFragment.kt:191,
  //           RegisterFragment.kt:221) and nothing in the codebase passes true.
  //           The guard is dead.
  //  FLUTTER  matches: customer_registered only on signup, customer_logged_in
  //           ALWAYS. The second call is not an `else` — wiring them as
  //           alternatives would drop customer_logged_in for every new user, and
  //           it would pass every payload test, because each payload is correct
  //           in isolation and only the COUNT is wrong. That is why
  //           auth_wire_format_golden_test.dart asserts the sequence.
  //  NO FIX   needed. This IS Android's behaviour; the dead guard is only
  //           misleading to read.
  // ──────────────────────────────────────────────────────────────────────────

  /// The session has been persisted — the user is in.
  ///
  /// Fires `customer_registered` when [isSignUp], then `customer_logged_in`
  /// unconditionally, then the identify traits. That order mirrors Android
  /// (`Util.java:1600-1611`, `RegisterFragment.kt:236-242`).
  void onAuthSuccess({
    required VerifyOtpResponseEntity session,
    required AuthEntryArgs entry,
    required bool isSignUp,
  }) {
    if (isSignUp) {
      unawaited(
        _analytics.logCustomerRegistered(
          fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
          fromLocation: entry.fromLocation,
          fromRedirect: entry.fromRedirect,
        ),
      );
    }
    unawaited(
      _analytics.logCustomerLoggedIn(
        authenticationType: AnalyticsDefaults.mobile,
        fromScreen: entry.fromScreen ?? AnalyticsDefaults.none,
        fromLocation: entry.fromLocation,
        fromRedirect: entry.fromRedirect,
        // Util.java:1604 nulls this only when it equals "Facebook", a branch
        // Flutter has no path to — it has no Facebook login.
        validationType: AnalyticsDefaults.otp,
      ),
    );

    final identify =
        isSignUp ? _analytics.identifyRegistered : _analytics.identifyLoggedIn;
    unawaited(
      identify(
        email: session.user.email,
        phone: session.user.mobile,
        userId: session.user.userId,
        userName: session.user.userName,
        mobileStatus: session.user.mobileStatus,
        isEligibleForContinueBrowsing:
            session.userConfig?.continueBrowsingEligibleVisitor ?? false,
      ),
    );
    unawaited(_analytics.identifyForChildCohorts(_cohorts(session)));

    // CleverTap is a second identity system, not a Segment destination: its
    // `onUserLogin` switches profiles, which Segment's identify cannot do. Both
    // Android paths call it right after the identify
    // (`Util.setUserProfileOnCleverTap`, `CleverTapHelper.identifyUserOnLogin`),
    // and it takes the name in two parts where Segment takes `userName` whole.
    //
    // Not ordered against the identify above: they write to different systems,
    // and CleverTap resolves the profile from `Identity` in the payload rather
    // than from anything Segment has set.
    unawaited(
      _cleverTap.identifyOnUserLogin(
        userId: session.user.userId,
        email: session.user.email,
        phone: session.user.mobile,
        firstName: session.user.firstName,
        lastName: session.user.lastName,
      ),
    );
  }

  /// Coerces the response's cohort map to the `int`-typed one the trait writer
  /// takes. Finding C4.
  ///
  /// The entity carries `Map<String, dynamic>` while `identifyForChildCohorts`
  /// takes `Map<String, int>`, so this cannot be a cast. Going through
  /// `int.tryParse` means a value arriving as `"2"` still lands as the int `2`,
  /// and a malformed one is dropped rather than sent as a String — which would
  /// split six traits in Amplitude with nothing erroring.
  Map<String, int> _cohorts(VerifyOtpResponseEntity session) {
    final out = <String, int>{};
    session.childCohorts?.forEach((key, value) {
      final n = value is int ? value : int.tryParse('$value');
      if (n != null) out[key] = n;
    });
    return out;
  }

  /// Sign-out succeeded and the session has been cleared.
  ///
  /// **Awaited, and ordered.** Both Android call sites
  /// (`LoginViewModel.kt:62`, `BottombarNavigationActivity.java:892`) clear
  /// session state, fire the event, then reset identity. `resetIdentity` wipes
  /// the `userId`, so the event has to go out while it is still attributable to
  /// the user who just left — which makes this the one place in this class where
  /// ordering matters more than staying off the user's path.
  ///
  /// `resetIdentity` self-guards on `isLoggedIn`, so the session must already be
  /// cleared before this is called.
  ///
  /// Not a divergence: this event was once recorded as dead on Android, because
  /// a search for the event-name constant missed it — the method is called
  /// `loggedOutEvent()` and names the constant at neither call site. It fires on
  /// both platforms. Scope: Building.
  Future<void> onSignedOut() async {
    await _analytics.logCustomerLoggedOut();
    await _analytics.resetIdentity();
  }
}
