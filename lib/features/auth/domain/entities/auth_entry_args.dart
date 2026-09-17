import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entry_args.freezed.dart';

/// How the user arrived at the login, join or OTP screen.
///
/// Mirrors the two intent extras Android reads in `LoginActivity.kt:81-82`
/// (`IntentHelper.FROM_SCREEN` and `FROM_LOCATION`), which it holds on
/// `LoginViewModel` and passes to every auth event.
///
/// Set once when the route is pushed and carried through the whole flow —
/// login → OTP → verified → logged-in are one journey, and the entry point that
/// started it applies to all of them. The captured Android session shows exactly
/// that: three of its four sign-in events report `from_location: "Sign in
/// button"` unchanged across 2 minutes 19 seconds.
///
/// ## What this deliberately does NOT carry
///
/// **`fromValidationType`** — permanently `"none"` on Flutter. Android assigns
/// it only when the user toggles between its mobile and email login pages
/// (`LoginActivity.kt:128-133`), and Flutter has no email login, so no toggle
/// and no value. Finding A3, scope Unfireable.
///
/// **`validationType`** and **`authenticationType`** — always `"OTP"` and
/// `"Mobile"`. Android hardcodes both in each fragment rather than passing them
/// (`MobileLoginFragment.kt:36-37`, `RegisterFragment.kt:86` and `:88`), because
/// each screen has exactly one credential type. Flutter passes the constants
/// from its single firing site per event for the same reason.
@freezed
abstract class AuthEntryArgs with _$AuthEntryArgs {
  const factory AuthEntryArgs({
    /// The screen the user came from — e.g. `FromScreens.account`,
    /// `FromScreens.shoppingCart`.
    ///
    /// Nullable, and null becomes `"none"` on the wire. That is Android's
    /// behaviour too: every auth logger runs the value through an explicit
    /// `!TextUtils.isEmpty(x) ? x : NONE` ternary, so the key is always present
    /// and an unknown entry point is reported rather than dropped.
    String? fromScreen,

    /// The control that opened the screen — e.g. `FromLocations.signInButton`,
    /// `FromLocations.signUpButton`.
    ///
    /// Same null handling as [fromScreen].
    String? fromLocation,

    /// Why the user was sent to sign in — a `LoginRedirects.type*` key such as
    /// `REDIRECT_PROMO`, or null when they navigated here themselves.
    ///
    /// **Flutter populates this; Android does not.** Android reads the value
    /// from an intent extra no caller ever writes (`LoginActivity.kt:83`), so
    /// `from_redirect` is the literal `"none"` on 100% of its fires — dead
    /// across four events, confirmed on a device capture. Approved 2026-09-02
    /// to populate it on Flutter rather than reproduce a constant that carries
    /// no dimension. Finding A1.
    ///
    /// The **type key** goes on the wire, not the user-facing sentence
    /// `LoginRedirects.lookup` returns: the key is the stable dimension, and it
    /// is what Android's own `INTENT_FLAG_SIGN_ACTION` extra already carries.
    String? fromRedirect,
  }) = _AuthEntryArgs;

  /// No entry context — every property reports `"none"`.
  ///
  /// Use where a screen genuinely has no originating context to pass, such as a
  /// deep link into login. Prefer this over passing `null` args so the absence
  /// reads as considered rather than forgotten.
  static const AuthEntryArgs unknown = AuthEntryArgs();
}
