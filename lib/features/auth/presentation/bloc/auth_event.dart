part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// The login screen was shown. Fires `login_viewed`.
  ///
  /// Dispatched from the page rather than fired there: analytics emits from
  /// Blocs on this codebase, never from widgets. Android's equivalent is
  /// `MobileLoginFragment.onViewCreated` (`MobileLoginFragment.kt:78`), which
  /// has no suppression flag — so this fires once per route mount, as Android
  /// fires once per fragment creation.
  const factory AuthEvent.loginViewed({
    @Default(AuthEntryArgs.unknown) AuthEntryArgs entry,
  }) = LoginViewed;

  /// The join screen was shown. Fires `join_viewed`. See [LoginViewed].
  const factory AuthEvent.joinViewed({
    @Default(AuthEntryArgs.unknown) AuthEntryArgs entry,
  }) = JoinViewed;

  const factory AuthEvent.sendOtp({
    required String loginId,
    @Default(AuthStrings.signInReason) String otpReason,
    String? pathUri,
    @Default(AuthEntryArgs.unknown) AuthEntryArgs entry,
  }) = SendOtp;

  const factory AuthEvent.verifyOtp({
    required String loginId,
    required String otp,
    @Default(AuthStrings.signInReason) String otpReason,
    @Default(AuthEntryArgs.unknown) AuthEntryArgs entry,
  }) = VerifyOtp;

  const factory AuthEvent.register({
    required String displayName,
    required String email,
    required String mobile,
    @Default(AuthEntryArgs.unknown) AuthEntryArgs entry,
  }) = Register;

  const factory AuthEvent.checkMobile({required String mobile}) = CheckMobile;

  const factory AuthEvent.reset() = ResetAuth;

  const factory AuthEvent.signOut({void Function()? onSuccess}) = AuthSignOut;
}
