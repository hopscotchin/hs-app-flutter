part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, mobileChecked, otpSent, success, error, signedOut, redirectLinkFound }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    OtpConfigEntity? otpConfig,
    VerifyOtpResponseEntity? verifyOtpResult,
    CheckMobileResponseEntity? checkMobileResult,
    @Default('') String errorMessage,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> otpMessageBars,
    String? redirectLink,
  }) = _AuthState;
}

extension AuthStateX on AuthState {
  bool get isLoading => status == AuthStatus.loading;
  bool get isMobileChecked => status == AuthStatus.mobileChecked;
  bool get isOtpSent => status == AuthStatus.otpSent;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;
  bool get isSignedOut => status == AuthStatus.signedOut;
  bool get isRedirectLinkFound => status == AuthStatus.redirectLinkFound;
}
