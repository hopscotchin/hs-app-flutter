part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.sendOtp({
    required String loginId,
    @Default('SIGN_IN') String otpReason,
  }) = SendOtp;

  const factory AuthEvent.verifyOtp({
    required String loginId,
    required String otp,
    @Default('SIGN_IN') String otpReason,
  }) = VerifyOtp;

  const factory AuthEvent.register({
    required String displayName,
    required String email,
    required String mobile,
  }) = Register;

  const factory AuthEvent.reset() = ResetAuth;

  const factory AuthEvent.signOut() = AuthSignOut;
}
