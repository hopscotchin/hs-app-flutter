import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/auth_events.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';

import '../support/analytics_test_harness.dart';

/// Wire-payload assertions for the auth events.
///
/// The `attribution: false` group is load-bearing: `logEvent` defaults
/// `attribution` to `true`, so an auth method that forgets to pass `false`
/// compiles, fires, and silently attaches the user's last shopping funnel to a
/// login event. Nothing else in the suite would catch it — which is exactly how
/// it shipped. See `docs/analytics/auth/auth-research.md` C1.
void main() {
  late AnalyticsTestHarness h;

  /// Every key an `attribution: true` event would have merged, derived from
  /// the helpers themselves rather than hand-listed — a literal list would rot
  /// the moment `AttributionData` grows a field, and rot in the safe direction
  /// (test still passes, new key still leaks).
  late Set<String> forbidden;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    // Seed both attribution stores so "carries no attribution keys" is a real
    // assertion, not one that passes because there was nothing to merge.
    h.orderAttribution.setFunnel(Funnel.discover);
    h.orderAttribution.replaceTrackingMeta(const <String, dynamic>{
      'funnel_tile': 'Product945499',
      'funnel_row': 3,
      'section': 'Boutiques',
      'slice_id': 'CT123',
      'banner_name': 'Summer sale',
      'property_type': 'Collection',
    });
    h.orderAttribution.setSortBar('Popularity');
    h.lpAttribution.pushLp(landingPageName: 'Summer LP', landingPageId: '4242');
    h.lpAttribution.updateTopMeta(const <String, dynamic>{
      'banner_name': 'Summer sale LP',
      'slice_id': 'LP4242',
      'funnel_tile': 'Product945499',
      'funnel_row': 1,
      'property_type': 'Collection',
    });

    forbidden = {
      ...h.orderAttribution.segmentParams.keys,
      ...h.lpAttribution.segmentParams.keys,
    };
    // Guard the guard: if seeding stops producing keys, every assertion below
    // would pass vacuously.
    expect(forbidden, isNotEmpty,
        reason: 'attribution seeding produced no keys — the C1 assertions '
            'below would pass without proving anything');
  });
  tearDown(() => h.tearDown());

  group('attribution: false on every auth event (C1)', () {
    test('login_viewed carries no attribution keys', () async {
      await h.analytics.logLoginViewed(
        fromScreen: FromScreens.shoppingCart,
        fromLocation: FromLocations.signInButton,
      );
      final e = h.singleEvent(AnalyticsEvents.loginViewed);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'login_viewed must not carry "$k"');
      }
    });

    test('join_viewed carries no attribution keys', () async {
      await h.analytics.logJoinViewed(fromScreen: FromScreens.account);
      final e = h.singleEvent(AnalyticsEvents.joinViewed);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'join_viewed must not carry "$k"');
      }
    });

    test('forgot_viewed carries no attribution keys', () async {
      await h.analytics.logForgotViewed(fromScreen: FromScreens.login);
      final e = h.singleEvent(AnalyticsEvents.forgotViewed);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'forgot_viewed must not carry "$k"');
      }
    });

    test('otp_sent carries no attribution keys', () async {
      await h.analytics.logOtpSent(
        fromScreen: FromScreens.login,
        authenticationType: AnalyticsDefaults.mobile,
        verificationReason: AuthStrings.signInReason,
        mobile: '9876543210',
      );
      final e = h.singleEvent(AnalyticsEvents.otpSent);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'otp_sent must not carry "$k"');
      }
    });

    test('otp_verified carries no attribution keys', () async {
      await h.analytics.logOtpVerified(
        fromScreen: FromScreens.login,
        authenticationType: AnalyticsDefaults.mobile,
        verificationReason: AuthStrings.signInReason,
        mobile: '9876543210',
      );
      final e = h.singleEvent(AnalyticsEvents.otpVerified);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'otp_verified must not carry "$k"');
      }
    });

    test('customer_logged_in carries no attribution keys', () async {
      await h.analytics.logCustomerLoggedIn(
        authenticationType: AnalyticsDefaults.mobile,
        fromScreen: FromScreens.shoppingCart,
        validationType: AnalyticsDefaults.otp,
      );
      final e = h.singleEvent(AnalyticsEvents.customerLoggedIn);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'customer_logged_in must not carry "$k"');
      }
    });

    test('customer_registered carries no attribution keys', () async {
      await h.analytics.logCustomerRegistered(fromScreen: FromScreens.join);
      final e = h.singleEvent(AnalyticsEvents.customerRegistered);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'customer_registered must not carry "$k"');
      }
    });

    test('customer_logged_out carries no attribution keys', () async {
      await h.analytics.logCustomerLoggedOut();
      final e = h.singleEvent(AnalyticsEvents.customerLoggedOut);
      for (final k in forbidden) {
        expect(e.containsKey(k), isFalse, reason: 'customer_logged_out must not carry "$k"');
      }
    });
  });

  group('customer_registered hardcodes both credential keys (C2)', () {
    test('authentication_type = Mobile and validation_type = OTP', () async {
      await h.analytics.logCustomerRegistered(
        fromScreen: FromScreens.join,
        fromLocation: FromLocations.signUpButton,
      );
      final e = h.singleEvent(AnalyticsEvents.customerRegistered);
      // Android hardcodes both in the logger — AnalyticsHelper.java:319-320.
      expect(e[AnalyticsProperties.authenticationType], 'Mobile');
      expect(e[AnalyticsProperties.validationType], 'OTP');
    });

    test('exposes no parameter that could override them', () async {
      // Regression guard for C2's fix: if someone promotes either key to a
      // named parameter, a call site can send the wrong credential type and
      // diverge from Android silently. Both stay logger-owned.
      await h.analytics.logCustomerRegistered(fromScreen: FromScreens.join);
      final e = h.singleEvent(AnalyticsEvents.customerRegistered);
      expect(e[AnalyticsProperties.validationType], AnalyticsDefaults.otp);
    });
  });

  group('one JSON type per key: mobile is always a String (A5)', () {
    // `logForgotViewed`'s deletion is enforced by the compiler, not here — a
    // test cannot assert a method's absence. What it *can* pin is the rule the
    // deletion exists to protect: Android sends `mobile` as a long on
    // forgot_viewed and a String on these two, so any auth event that ever
    // emits a non-String `mobile` re-splits the Amplitude key.
    test('every auth event emitting mobile emits it as a String', () async {
      await h.analytics.logOtpSent(
        fromScreen: FromScreens.login,
        mobile: '9876543210',
      );
      await h.analytics.logOtpVerified(
        fromScreen: FromScreens.login,
        mobile: '9876543210',
      );
      await h.analytics.logCustomerLoggedIn(
        authenticationType: AnalyticsDefaults.mobile,
        fromScreen: FromScreens.login,
      );
      // The event that carries the split on Android — Flutter sends a String.
      await h.analytics.logForgotViewed(
        fromScreen: FromScreens.login,
        mobile: '9876543210',
      );
      final withMobile = h.captured
          .where((e) => e.props.containsKey(AnalyticsProperties.mobile))
          .toList();
      expect(withMobile, isNotEmpty, reason: 'no event carried `mobile`');
      for (final e in withMobile) {
        expect(
          e.props[AnalyticsProperties.mobile],
          isA<String>(),
          reason: '${e.name} emitted `mobile` as '
              '${e.props[AnalyticsProperties.mobile].runtimeType}, not String',
        );
      }
    });
  });

  group('absent values arrive as "none", never dropped (§2)', () {
    test('login_viewed always carries all six keys', () async {
      await h.analytics.logLoginViewed(fromScreen: FromScreens.account);
      final e = h.singleEvent(AnalyticsEvents.loginViewed);
      // Android uses plain `properties.put` with an explicit "none" ternary,
      // so no auth key is ever absent — including from_validation_type, which
      // Flutter can never populate (finding A3).
      expect(e[AnalyticsProperties.fromScreen], 'Account');
      expect(e[AnalyticsProperties.fromLocation], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.validationType], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.fromValidationType], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.authenticationType], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.fromRedirect], AnalyticsDefaults.none);
    });
  });

  group('forgot_viewed is defined but unfireable (A5)', () {
    test('all six keys present, mobile String-typed', () async {
      await h.analytics.logForgotViewed(
        fromScreen: FromScreens.login,
        fromLocation: FromLocations.signInButton,
        fromAuthenticationType: AnalyticsDefaults.mobile,
        mobile: '9876543210',
        email: 'a@b.com',
      );
      final e = h.singleEvent(AnalyticsEvents.forgotViewed);
      expect(e[AnalyticsProperties.fromScreen], 'Login');
      expect(e[AnalyticsProperties.fromLocation], 'Sign in button');
      expect(e[AnalyticsProperties.fromAuthenticationType], 'Mobile');
      expect(e[AnalyticsProperties.fromRedirect], AnalyticsDefaults.none);
      expect(e[AnalyticsProperties.email], 'a@b.com');
      // Deliberate departure from Android, which puts a raw long here
      // (AnalyticsHelper.java:851) while sending a String on otp_sent /
      // otp_verified. Android never fires this event, so there is no live
      // value to match and one JSON type per key wins.
      expect(e[AnalyticsProperties.mobile], '9876543210');
      expect(e[AnalyticsProperties.mobile], isA<String>());
      expect(e[AnalyticsProperties.mobile], isNot(isA<int>()));
    });

    test('an absent mobile is "none", not 0', () async {
      await h.analytics.logForgotViewed(fromScreen: FromScreens.login);
      final e = h.singleEvent(AnalyticsEvents.forgotViewed);
      // Android's `mobileNo != 0 ? mobileNo : NONE` ternary means a missing
      // number lands as the String "none" there too — so this one agrees.
      expect(e[AnalyticsProperties.mobile], AnalyticsDefaults.none);
    });
  });

  group('verification_reason allowlist (B3)', () {
    // Android has 12 reasons (Constants.java:255-268); Flutter reaches three,
    // and GET_ADDRESS is Flutter-only.
    const allowed = {
      AuthStrings.signInReason,
      AuthStrings.signUpReason,
      AuthStrings.getAddressReason,
    };

    test('each allowed reason reaches the wire unchanged', () async {
      for (final reason in allowed) {
        h.clear();
        await h.analytics.logOtpSent(
          fromScreen: FromScreens.login,
          verificationReason: reason,
        );
        expect(
          h.singleEvent(AnalyticsEvents.otpSent)[AnalyticsProperties.verificationReason],
          reason,
        );
      }
    });

    test('no bare otpReason literal anywhere in the auth feature', () {
      // The real B3 guard, asserted against the source the way
      // `pdp_tracking_meta_consistency_test.dart` does: a literal at a call
      // site is how a fourth value reaches the dashboard without the analytics
      // owner hearing about it. `auth_strings.dart` is the one legal home.
      final offenders = <String>[];
      final pattern = RegExp(r'''['"](SIGN_IN|SIGN_UP|GET_ADDRESS)['"]''');
      for (final dir in ['lib/features/auth', 'lib/core']) {
        for (final f in Directory(dir).listSync(recursive: true)) {
          if (f is! File || !f.path.endsWith('.dart')) continue;
          if (f.path.endsWith('auth_strings.dart')) continue;
          if (f.path.endsWith('.g.dart') || f.path.endsWith('.freezed.dart')) {
            continue;
          }
          final lines = f.readAsLinesSync();
          for (var i = 0; i < lines.length; i++) {
            if (pattern.hasMatch(lines[i])) {
              offenders.add('${f.path}:${i + 1}: ${lines[i].trim()}');
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason: 'use AuthStrings.signInReason / signUpReason / '
            'getAddressReason instead of a literal:\n${offenders.join('\n')}',
      );
    });
  });
}
