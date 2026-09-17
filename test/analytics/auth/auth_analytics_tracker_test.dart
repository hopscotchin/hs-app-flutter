import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/services/clevertap_service.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';
import 'package:hs_app_flutter/features/auth/domain/entities/auth_credentials/auth_credentials_entity.dart';
import 'package:hs_app_flutter/features/auth/domain/entities/auth_entry_args.dart';
import 'package:hs_app_flutter/features/auth/domain/entities/user_config/user_config_entity.dart';
import 'package:hs_app_flutter/features/auth/domain/entities/user_info/user_info_entity.dart';
import 'package:hs_app_flutter/features/auth/domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';
import 'package:hs_app_flutter/features/auth/presentation/analytics/auth_analytics_tracker.dart';

import '../support/analytics_test_harness.dart';

/// Tests the tracker's job, which is **when and how many events fire** — not
/// what each payload contains. `auth_events_test.dart` and the golden cover the
/// payloads by driving the events module directly, and would pass unchanged if
/// the tracker never fired at all.
///
/// Three of these guard failures that are otherwise silent:
///
/// * **A6** — `customer_logged_in` must fire on the signup path too. Wire the
///   two terminal events as alternatives and every payload stays correct while
///   one event goes missing for every new user.
/// * **C4** — cohort values are coerced, not cast. A backend `"2"` must land as
///   the int `2`; sending `"2"` splits six Amplitude traits with nothing
///   erroring.
/// * **Sign-out ordering** — the event must reach the wire before
///   `resetIdentity` wipes the userId, or it is attributed to nobody.
/// A [Fake], not a mock: the real service reaches
/// `CleverTapPlugin.onUserLogin`, a platform channel that does not exist in a
/// unit-test host. Recording the call is all the tracker's contract needs —
/// what the profile map holds is `CleverTapService`'s own concern.
class _FakeCleverTapService extends Fake implements CleverTapService {
  final List<Map<String, String?>> logins = [];

  @override
  Future<void> identifyOnUserLogin({
    String? userId,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    logins.add({
      'userId': userId,
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
    });
  }
}

VerifyOtpResponseEntity _session({
  Map<String, dynamic>? cohorts,
  bool eligible = false,
}) => VerifyOtpResponseEntity(
  user: const UserInfoEntity(
    userId: '4242',
    email: 'user@example.com',
    mobile: '9000000001',
    userName: 'Test User',
    // CleverTap takes the name in two parts where Segment takes `userName`
    // whole, so the fixture carries both forms.
    firstName: 'Test',
    lastName: 'User',
    mobileStatus: 'VERIFIED',
  ),
  auth: const AuthCredentialsEntity(),
  childCohorts: cohorts,
  userConfig: UserConfigEntity(continueBrowsingEligibleVisitor: eligible),
);

const _entry = AuthEntryArgs(
  fromScreen: FromScreens.shoppingCart,
  fromLocation: FromLocations.signInButton,
);

void main() {
  late AnalyticsTestHarness h;
  late _FakeCleverTapService cleverTap;
  late AuthAnalyticsTracker tracker;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    cleverTap = _FakeCleverTapService();
    tracker = AuthAnalyticsTracker(h.analytics, cleverTap);
  });
  tearDown(() => h.tearDown());

  group('screen views', () {
    // These three await a microtask flush, unlike the rest of the file.
    // `logLoginViewed` awaits `logAppLaunched` BEFORE firing its own event
    // (auth_events.dart), matching Android, which calls logAppLaunchedEvent at
    // AnalyticsHelper.java:829 and logEvent at :830. Since the tracker fires
    // and forgets, the viewed event lands one microtask after the call
    // returns — real behaviour, not a test artifact.
    test('onLoginViewed fires login_viewed once, with the entry context', () async {
      tracker.onLoginViewed(_entry);
      await pumpEventQueue();
      final e = h.singleEvent(AnalyticsEvents.loginViewed);
      expect(e[AnalyticsProperties.fromScreen], 'Cart');
      expect(e[AnalyticsProperties.fromLocation], 'Sign in button');
      // Hardcoded by the tracker, not the caller — the login screen has one
      // credential type (MobileLoginFragment.kt:36-37).
      expect(e[AnalyticsProperties.validationType], 'OTP');
      expect(e[AnalyticsProperties.authenticationType], 'Mobile');
    });

    test('onJoinViewed fires join_viewed once', () async {
      tracker.onJoinViewed(_entry);
      await pumpEventQueue();
      expect(h.singleEvent(AnalyticsEvents.joinViewed), isNotEmpty);
    });

    test('app_launched precedes login_viewed when login is the first screen', () async {
      // LaunchTimer starts stopped, so logAppLaunched self-guards and emits
      // nothing — which is why the other tests here see only one event. Drive
      // the timer to exercise the cold-start path.
      h.launchTimer.recordProcessStart();

      tracker.onLoginViewed(_entry);
      await pumpEventQueue();

      final names = h.captured.map((e) => e.name).toList();
      // The order is the contract: Android emits app_launched first
      // (AnalyticsHelper.java:829) and login_viewed second (:830), because
      // app_launched carries the tti/ttl of the screen that is only now
      // interactive. Flutter's logLoginViewed awaits logAppLaunched for the
      // same reason.
      expect(names, contains(AnalyticsEvents.appLaunched));
      expect(
        names.indexOf(AnalyticsEvents.appLaunched),
        lessThan(names.indexOf(AnalyticsEvents.loginViewed)),
      );
    });

    test('app_launched does not fire when login is not the first screen', () async {
      // The timer is already stopped, standing in for "some other screen
      // already claimed the cold start". logAppLaunched is safe to call from
      // any screen-viewed handler precisely because it self-guards.
      tracker.onLoginViewed(_entry);
      await pumpEventQueue();
      expect(h.hasEvent(AnalyticsEvents.appLaunched), isFalse);
      expect(h.eventsNamed(AnalyticsEvents.loginViewed), hasLength(1));
    });

    test('unknown entry reports "none", never a dropped key', () async {
      tracker.onLoginViewed(AuthEntryArgs.unknown);
      await pumpEventQueue();
      final e = h.singleEvent(AnalyticsEvents.loginViewed);
      expect(e[AnalyticsProperties.fromScreen], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.fromLocation], AnalyticsDefaults.none);
    });
  });

  group('otp_sent fires once per API response (A4)', () {
    test('sign-in carries no email', () {
      tracker.onOtpSent(
        entry: _entry,
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );
      final e = h.singleEvent(AnalyticsEvents.otpSent);
      expect(e[AnalyticsProperties.verificationReason], 'SIGN_IN');
      expect(e[AnalyticsProperties.mobile], '9000000001');
      expect(e[AnalyticsProperties.email], AnalyticsDefaults.none);
    });

    test('signup carries the email from the form', () {
      tracker.onOtpSent(
        entry: _entry,
        verificationReason: AuthStrings.signUpReason,
        mobile: '9000000001',
        email: 'user@example.com',
      );
      final e = h.singleEvent(AnalyticsEvents.otpSent);
      expect(e[AnalyticsProperties.verificationReason], 'SIGN_UP');
      expect(e[AnalyticsProperties.email], 'user@example.com');
    });

    test('one call fires exactly one event', () {
      tracker.onOtpSent(
        entry: _entry,
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );
      // Android fires otp_sent twice for one OTP on its order-details flow.
      // Flutter must not, and this is the assertion that says so.
      expect(h.eventsNamed(AnalyticsEvents.otpSent), hasLength(1));
    });
  });

  group('otp_verified reports the real entry context (A2)', () {
    test('passes the entry through, not Android\'s hardcoded literals', () {
      tracker.onOtpVerified(
        entry: _entry, // Cart / Sign in button
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );
      final e = h.singleEvent(AnalyticsEvents.otpVerified);
      // A2, decided 2026-09-02: report the truth. Android hardcodes
      // FromScreens.ACCOUNT / FromLocations.PROFILE_DETAILS here
      // (OTPVerificationActivity.kt:216-217) on every fire, from a screen
      // serving nine flows — wrong on eight of them.
      expect(e[AnalyticsProperties.fromScreen], 'Cart');
      expect(e[AnalyticsProperties.fromLocation], 'Sign in button');
      // The two literals must not reappear. Their return would mean someone
      // restored the reproduction.
      expect(e[AnalyticsProperties.fromLocation], isNot('Profile Details'));
    });

    test('matches what the other events on the same fold report', () {
      // The point of the fix: otp_verified used to disagree with its own
      // journey. In a captured Android session it reported "Profile Details"
      // 19ms before customer_logged_in reported "Sign in button".
      tracker.onOtpVerified(
        entry: _entry,
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: false);
      final verified = h.singleEvent(AnalyticsEvents.otpVerified);
      final loggedIn = h.singleEvent(AnalyticsEvents.customerLoggedIn);
      for (final k in [
        AnalyticsProperties.fromScreen,
        AnalyticsProperties.fromLocation,
      ]) {
        expect(verified[k], loggedIn[k], reason: '$k disagrees within one journey');
      }
    });
  });

  group('from_redirect is populated (A1)', () {
    const redirected = AuthEntryArgs(
      fromScreen: FromScreens.shoppingCart,
      fromLocation: FromLocations.signInButton,
      fromRedirect: 'REDIRECT_PROMO',
    );

    test('the type key reaches the wire, not the display sentence', () async {
      tracker.onLoginViewed(redirected);
      await pumpEventQueue();
      // A1, decided 2026-09-02: pass it from wherever the user was redirected.
      // Android sends "none" on 100% of fires — the intent extra behind it is
      // never written (LoginActivity.kt:83).
      expect(
        h.singleEvent(AnalyticsEvents.loginViewed)[AnalyticsProperties.fromRedirect],
        'REDIRECT_PROMO',
      );
    });

    test('reaches all four events that carry the key', () async {
      tracker.onLoginViewed(redirected);
      tracker.onJoinViewed(redirected);
      tracker.onAuthSuccess(
        session: _session(),
        entry: redirected,
        isSignUp: true,
      );
      await pumpEventQueue();
      for (final name in [
        AnalyticsEvents.loginViewed,
        AnalyticsEvents.joinViewed,
        AnalyticsEvents.customerLoggedIn,
        AnalyticsEvents.customerRegistered,
      ]) {
        expect(
          h.singleEvent(name)[AnalyticsProperties.fromRedirect],
          'REDIRECT_PROMO',
          reason: '$name lost from_redirect',
        );
      }
    });

    test('no redirect reports "none", not a dropped key', () async {
      tracker.onLoginViewed(AuthEntryArgs.unknown);
      await pumpEventQueue();
      expect(
        h.singleEvent(AnalyticsEvents.loginViewed)[AnalyticsProperties.fromRedirect],
        AnalyticsDefaults.none,
      );
    });
  });

  group('auth success fires both terminal events on signup (A6)', () {
    test('signup fires customer_registered AND customer_logged_in, in order', () {
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: true);
      expect(
        h.captured.map((e) => e.name).where(
          (n) =>
              n == AnalyticsEvents.customerRegistered ||
              n == AnalyticsEvents.customerLoggedIn,
        ),
        [AnalyticsEvents.customerRegistered, AnalyticsEvents.customerLoggedIn],
        reason: 'Android fires both, 5ms apart — Util.java:1606\'s '
            '`if (!isRegister)` guard is dead code. Wiring these as '
            'alternatives drops customer_logged_in for every new user.',
      );
    });

    test('sign-in fires only customer_logged_in', () {
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: false);
      expect(h.hasEvent(AnalyticsEvents.customerRegistered), isFalse);
      expect(h.eventsNamed(AnalyticsEvents.customerLoggedIn), hasLength(1));
    });

    test('customer_logged_in carries the real entry context on both paths', () {
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: true);
      final e = h.singleEvent(AnalyticsEvents.customerLoggedIn);
      // Unlike otp_verified, this event is NOT subject to A2 — Android reads it
      // from the view model, so Flutter passes the real values.
      expect(e[AnalyticsProperties.fromScreen], 'Cart');
      expect(e[AnalyticsProperties.fromLocation], 'Sign in button');
      expect(e[AnalyticsProperties.validationType], 'OTP');
    });

    test('identify follows the flow: registered on signup, logged-in otherwise', () {
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: true);
      // identifyRegistered adds createdAt; identifyLoggedIn does not. That is
      // the only trait separating them, so it is how the choice is asserted.
      expect(h.identifies, isNotEmpty);
      expect(
        h.identifies.any((i) => i.traits.containsKey('createdAt')),
        isTrue,
        reason: 'signup must use identifyRegistered',
      );

      h.clear();
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: false);
      expect(
        h.identifies.any((i) => i.traits.containsKey('createdAt')),
        isFalse,
        reason: 'sign-in must use identifyLoggedIn',
      );
    });

    test('CleverTap is told about the login on both paths', () {
      // A second identity system, not a Segment destination: only
      // `onUserLogin` switches profiles, so skipping it leaves every signed-in
      // session writing to the anonymous CleverTap profile. Segment's identify
      // passing is no evidence this happened — nothing else asserts it.
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: true);
      tracker.onAuthSuccess(session: _session(), entry: _entry, isSignUp: false);
      expect(cleverTap.logins, hasLength(2));
      for (final p in cleverTap.logins) {
        // Identity is what resolves the profile; without it onUserLogin has
        // nothing to key on.
        expect(p['userId'], '4242');
        expect(p['email'], 'user@example.com');
        expect(p['phone'], '9000000001');
        // Split, not the whole `userName` Segment gets.
        expect(p['firstName'], 'Test');
        expect(p['lastName'], 'User');
      }
    });
  });

  group('child cohorts are coerced, not cast (C4)', () {
    /// The six keys the trait writer always emits, suffixed `_child_profile`.
    Map<String, Object?> cohortTraits() {
      final merged = <String, Object?>{};
      for (final i in h.identifies) {
        merged.addAll(i.traits);
      }
      return merged;
    }

    test('an int arrives as an int', () {
      tracker.onAuthSuccess(
        session: _session(cohorts: {'boy_infant': 2}),
        entry: _entry,
        isSignUp: false,
      );
      expect(cohortTraits()['boy_infant_child_profile'], 2);
      expect(cohortTraits()['boy_infant_child_profile'], isA<int>());
    });

    test('a numeric String is parsed to an int, not passed through', () {
      // The response type is Map<String, dynamic>, so a backend sending "2"
      // compiles fine. Passing it through would send a String where the other
      // five cohorts are ints — six traits, two types.
      tracker.onAuthSuccess(
        session: _session(cohorts: {'girl_child': '3'}),
        entry: _entry,
        isSignUp: false,
      );
      expect(cohortTraits()['girl_child_child_profile'], 3);
      expect(cohortTraits()['girl_child_child_profile'], isA<int>());
      expect(cohortTraits()['girl_child_child_profile'], isNot('3'));
    });

    test('a malformed value is dropped, leaving the zero default', () {
      tracker.onAuthSuccess(
        session: _session(cohorts: {'boy_toddler': 'not-a-number'}),
        entry: _entry,
        isSignUp: false,
      );
      // Dropped rather than sent: the trait writer zero-fills every key, so the
      // dimension stays an int and reads "none of these" instead of splitting.
      expect(cohortTraits()['boy_toddler_child_profile'], 0);
      expect(cohortTraits()['boy_toddler_child_profile'], isA<int>());
    });

    test('every trait value is an int, whatever the response held', () {
      tracker.onAuthSuccess(
        session: _session(
          cohorts: {'boy_infant': 1, 'girl_infant': '2', 'boy_child': null},
        ),
        entry: _entry,
        isSignUp: false,
      );
      final cohortKeys = cohortTraits().entries.where(
        (e) => e.key.endsWith('_child_profile'),
      );
      expect(cohortKeys, hasLength(6), reason: 'all six keys are always written');
      for (final t in cohortKeys) {
        expect(t.value, isA<int>(), reason: '${t.key} is ${t.value.runtimeType}');
      }
    });
  });

  group('nav_screens is a Flutter-only key (B5)', () {
    // The harness leaves the nav stack empty, so `navigationTrackerParams`
    // returns nothing and neither the golden nor the capture-coverage test can
    // see this key. A real-device capture is what surfaced it. Driving the
    // observer here closes that blind spot.
    test('appears on auth events once a screen has been pushed', () async {
      // Must be a route in AppNavigationObserver's _routeToScreenLabel map —
      // only labelled screens join the trail. `/login` is deliberately not one,
      // which is why the real-device capture shows Account/Discover/Splash and
      // never Login.
      h.navObserver.didPush(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: RouteNames.cartName),
          builder: (_) => const SizedBox.shrink(),
        ),
        null,
      );

      tracker.onOtpSent(
        entry: _entry,
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );

      final e = h.singleEvent(AnalyticsEvents.otpSent);
      // Android sends nothing like this — it is a deliberate Flutter-only
      // breadcrumb, stamped on EVERY event app-wide by AppNavigationObserver
      // (analytics_properties.dart:539-541), not an auth addition.
      expect(e.containsKey(AnalyticsProperties.navScreens), isTrue);
      expect(e[AnalyticsProperties.navScreens], isA<List<String>>());
    });

    test('absent when nothing has been pushed, rather than empty', () {
      tracker.onOtpSent(
        entry: _entry,
        verificationReason: AuthStrings.signInReason,
        mobile: '9000000001',
      );
      // navigationTrackerParams returns {} on an empty stack, so the key is
      // omitted rather than sent as []. An empty list would read on a
      // dashboard as "the user was on no screens".
      expect(
        h.singleEvent(AnalyticsEvents.otpSent).containsKey(
          AnalyticsProperties.navScreens,
        ),
        isFalse,
      );
    });
  });

  group('sign-out order is a contract', () {
    test('customer_logged_out reaches the wire before identity is reset', () async {
      await tracker.onSignedOut();
      expect(
        h.timeline,
        ['track:${AnalyticsEvents.customerLoggedOut}', 'reset'],
        reason: 'resetIdentity wipes the userId, so the event has to go out '
            'first or it is attributed to nobody. Both Android call sites use '
            'this order — LoginViewModel.kt:62, '
            'BottombarNavigationActivity.java:892.',
      );
    });

    test('the event carries no properties of its own', () async {
      await tracker.onSignedOut();
      final e = h.singleEvent(AnalyticsEvents.customerLoggedOut);
      // Android's loggedOutEvent() passes an empty map
      // (AnalyticsHelper.java:324-326), so the payload is the helper's common
      // block alone.
      expect(e.keys, isNot(contains(AnalyticsProperties.fromScreen)));
    });
  });
}
