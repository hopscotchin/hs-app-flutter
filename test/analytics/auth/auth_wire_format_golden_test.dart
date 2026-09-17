import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/auth_events.dart';
import 'package:hs_app_flutter/core/constants/strings/auth_strings.dart';

import '../support/analytics_test_harness.dart';

/// Snapshots the **exact wire format** of every auth event — key, type and value
/// — against a checked-in golden file.
///
/// Two jobs:
///
/// 1. **Regression gate.** Any change to a key name, a value or a *type* fails
///    here. Type is captured deliberately: `mobile` as an int instead of a
///    String is a silent dashboard-splitting bug that no key-only assertion
///    catches, and it is the exact shape of finding A5.
///
/// 2. **The left-hand side of the Android diff.** The captured Android payloads
///    live in `docs/analytics/auth/parity/android-segment-events.json`; this
///    golden is what they are compared against, already normalised. See
///    `docs/analytics/auth/parity/payload-comparison.md`.
///
/// **Keyed by scenario, not just by event.** `otp_sent` and `customer_logged_in`
/// each appear twice, because their values differ between the sign-in and signup
/// paths — `email` is `"none"` on sign-in and populated on signup, and
/// `customer_logged_in` fires on both paths (finding A6). A golden keyed by event
/// name alone would silently keep only one of each and lose exactly the values
/// that needed pinning. PDP's golden has no such split, which is why its keys are
/// bare event names.
///
/// To regenerate after an intentional change:
/// ```
/// UPDATE_AUTH_GOLDEN=1 flutter test test/analytics/auth/auth_wire_format_golden_test.dart
/// ```
/// Then **read the diff** before committing it. A golden that is updated without
/// being read is worse than no golden.
const _goldenPath = 'test/analytics/fixtures/auth_wire_format.golden.json';

/// Keys that legitimately vary per run and would make the golden unstable.
/// Their presence *and type* are asserted separately below, so excluding their
/// values here does not weaken the check — see the time-bucket type test.
const _volatileKeys = <String>{
  'timestamp',
  '[time] hour_of_day',
  '[time] day_of_week',
  '[time] day_of_month',
  '[time] month_of_year',
  '[time] week_of_year',
  'nav_screens',
};

/// Synthetic credentials. Deliberately not the real values from the Android
/// capture — a golden is committed and read by anyone, so it carries no PII.
const _mobile = '9000000001';
const _email = 'user@example.com';

/// Renders a value as `<Type> <value>` so the golden captures both. Type drift is
/// the failure mode this file exists to catch.
String _typed(Object? value) {
  if (value == null) return 'null';
  final type = switch (value) {
    int() => 'int',
    double() => 'double',
    bool() => 'bool',
    String() => 'String',
    List() => 'List<${value.isEmpty ? 'dynamic' : value.first.runtimeType}>',
    _ => value.runtimeType.toString(),
  };
  return '$type $value';
}

/// Fire order, and the golden's keys. Mirrors the captured Android journey:
/// sign in from Account, sign out, then sign up — plus `forgot_viewed`, which
/// has no caller on either platform but whose payload is defined, so its wire
/// format is worth pinning before a forgot-password flow lands.
const _labels = <String>[
  'login_viewed',
  'otp_sent · sign-in',
  'otp_verified',
  'customer_logged_in · sign-in',
  'customer_logged_out',
  'join_viewed',
  'otp_sent · sign-up',
  'customer_registered',
  'customer_logged_in · sign-up',
  'forgot_viewed · unfireable, payload defined',
];

/// The bare event name each label resolves to, in the same order. Asserting this
/// pins the **event count and sequence**, not just the payloads — which is what
/// finding A6 turned out to need: `customer_logged_in` firing on the signup path
/// is a count fact, and every payload can be correct while the count is wrong.
const _expectedNames = <String>[
  AnalyticsEvents.loginViewed,
  AnalyticsEvents.otpSent,
  AnalyticsEvents.otpVerified,
  AnalyticsEvents.customerLoggedIn,
  AnalyticsEvents.customerLoggedOut,
  AnalyticsEvents.joinViewed,
  AnalyticsEvents.otpSent,
  AnalyticsEvents.customerRegistered,
  AnalyticsEvents.customerLoggedIn,
  AnalyticsEvents.forgotViewed,
];

void main() {
  late AnalyticsTestHarness h;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    // Seed both attribution stores. Every auth event fires with
    // `attribution: false`, so none of these keys may reach the wire — and the
    // golden is where their absence is pinned.
    h.orderAttribution.replaceTrackingMeta(const <String, dynamic>{
      'funnel_tile': 'Product945499',
      'funnel_row': 3,
      'section': 'Boutiques',
    });
    h.lpAttribution.pushLp(landingPageName: 'Summer LP', landingPageId: '4242');
    h.lpAttribution.updateTopMeta(const <String, dynamic>{
      'banner_name': 'Summer sale LP',
      'slice_id': 'LP4242',
    });
  });
  tearDown(() => h.tearDown());

  /// Fires every auth event once per scenario, in `_labels` order.
  Future<void> fireAll() async {
    final a = h.analytics;

    // ── sign-in, entered at Account's "Sign in" button ──
    await a.logLoginViewed(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signInButton,
      validationType: AnalyticsDefaults.otp,
      authenticationType: AnalyticsDefaults.mobile,
    );
    await a.logOtpSent(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signInButton,
      authenticationType: AnalyticsDefaults.mobile,
      verificationReason: AuthStrings.signInReason,
      mobile: _mobile,
    );
    await a.logOtpVerified(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signInButton,
      authenticationType: AnalyticsDefaults.mobile,
      verificationReason: AuthStrings.signInReason,
      mobile: _mobile,
    );
    await a.logCustomerLoggedIn(
      authenticationType: AnalyticsDefaults.mobile,
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signInButton,
      validationType: AnalyticsDefaults.otp,
    );

    // ── sign-out ──
    await a.logCustomerLoggedOut();

    // ── signup, entered at Account's "Join" button ──
    await a.logJoinViewed(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signUpButton,
      validationType: AnalyticsDefaults.otp,
      authenticationType: AnalyticsDefaults.mobile,
    );
    await a.logOtpSent(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signUpButton,
      authenticationType: AnalyticsDefaults.mobile,
      verificationReason: AuthStrings.signUpReason,
      mobile: _mobile,
      email: _email,
    );
    await a.logCustomerRegistered(
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signUpButton,
    );
    // A6: fires on the signup path too, not as an `else` to customer_registered.
    await a.logCustomerLoggedIn(
      authenticationType: AnalyticsDefaults.mobile,
      fromScreen: FromScreens.account,
      fromLocation: FromLocations.signUpButton,
      validationType: AnalyticsDefaults.otp,
    );

    // ── defined but unfireable ──
    await a.logForgotViewed(
      fromScreen: FromScreens.login,
      fromLocation: FromLocations.signInButton,
      fromAuthenticationType: AnalyticsDefaults.mobile,
      mobile: _mobile,
      email: _email,
    );
  }

  test('every auth event matches the golden wire format', () async {
    await fireAll();
    expect(
      h.captured,
      hasLength(_labels.length),
      reason: 'fire order and _labels are out of step',
    );

    final actual = <String, Map<String, String>>{};
    for (var i = 0; i < h.captured.length; i++) {
      final props = <String, String>{};
      for (final e in h.captured[i].props.entries) {
        if (_volatileKeys.contains(e.key)) continue;
        props[e.key] = _typed(e.value);
      }
      // Sorted so the golden is stable and diffs read cleanly.
      actual[_labels[i]] = Map.fromEntries(
        props.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    }

    const encoder = JsonEncoder.withIndent('  ');
    // Keys kept in fire order, not sorted: the order *is* the journey, and A6
    // is a statement about sequence.
    final rendered = encoder.convert(actual);

    final golden = File(_goldenPath);
    if (Platform.environment['UPDATE_AUTH_GOLDEN'] == '1') {
      golden.writeAsStringSync('$rendered\n');
      // ignore: avoid_print
      print('golden rewritten: $_goldenPath');
      return;
    }

    expect(
      golden.existsSync(),
      isTrue,
      reason: 'Golden missing. Generate it with '
          'UPDATE_AUTH_GOLDEN=1 flutter test test/analytics/auth/auth_wire_format_golden_test.dart',
    );
    expect(
      rendered,
      golden.readAsStringSync().trimRight(),
      reason: 'Auth wire format changed. If intentional, regenerate with '
          'UPDATE_AUTH_GOLDEN=1 and READ the diff — a key, value or type change '
          'here is a dashboard change.',
    );
  });

  test('fires the expected events in the expected order, including A6', () async {
    await fireAll();
    expect(
      h.captured.map((e) => e.name).toList(),
      _expectedNames,
      reason: 'event count or sequence changed. `customer_logged_in` appearing '
          'once instead of twice means it was wired as an alternative to '
          '`customer_registered` — finding A6 — which drops it for every new '
          'user while every payload stays correct.',
    );
    // Stated separately so the failure message is unambiguous.
    expect(
      h.captured.where((e) => e.name == AnalyticsEvents.customerLoggedIn).length,
      2,
      reason: 'customer_logged_in must fire on the signup path as well as sign-in',
    );
  });

  test('no auth event carries an attribution key', () async {
    await fireAll();
    final forbidden = {
      ...h.orderAttribution.segmentParams.keys,
      ...h.lpAttribution.segmentParams.keys,
    };
    expect(forbidden, isNotEmpty, reason: 'attribution seeding produced no keys');
    for (final captured in h.captured) {
      for (final k in forbidden) {
        expect(
          captured.props.containsKey(k),
          isFalse,
          reason: '${captured.name} carries attribution key "$k" — every auth '
              'event fires with attribution: false',
        );
      }
    }
  });

  test('time buckets keep their types, though their values are volatile', () async {
    await fireAll();
    // Excluded from the golden because they change every run — so their types
    // are pinned here instead. `week_of_year` being a String while the other
    // four are ints is Android's shape, confirmed on the wire, and a live
    // type-flip risk if someone "tidies" it.
    for (final captured in h.captured) {
      final p = captured.props;
      expect(p[AnalyticsProperties.hourOfDay], isA<int>(), reason: captured.name);
      expect(p[AnalyticsProperties.dayOfWeek], isA<int>(), reason: captured.name);
      expect(p[AnalyticsProperties.dayOfMonth], isA<int>(), reason: captured.name);
      expect(p[AnalyticsProperties.monthOfYear], isA<int>(), reason: captured.name);
      expect(p[AnalyticsProperties.weekOfYear], isA<String>(), reason: captured.name);
      expect(p[AnalyticsProperties.timestamp], isA<String>(), reason: captured.name);
    }
  });

  test('no event ships a null-valued property', () async {
    await fireAll();
    for (final captured in h.captured) {
      final nulls = captured.props.entries
          .where((e) => e.value == null)
          .map((e) => e.key)
          .toList();
      expect(nulls, isEmpty, reason: '${captured.name} has null keys: $nulls');
    }
  });
}
