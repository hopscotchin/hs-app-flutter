part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, otpSent, success, error, signedOut, redirectLinkFound }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    OtpConfigEntity? otpConfig,
    VerifyOtpResponseEntity? verifyOtpResult,
    @Default('') String errorMessage,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    String? redirectLink,
  }) = _AuthState;
}

extension AuthStateX on AuthState {
  bool get isLoading => status == AuthStatus.loading;
  bool get isOtpSent => status == AuthStatus.otpSent;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;
  bool get isSignedOut => status == AuthStatus.signedOut;
  bool get isRedirectLinkFound => status == AuthStatus.redirectLinkFound;
}
