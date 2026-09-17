import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/base/base_bloc.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../../domain/entities/auth_entry_args.dart';
import '../../domain/entities/check_mobile_response/check_mobile_response_entity.dart';
import '../../domain/entities/otp_config/otp_config_entity.dart';
import '../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../../domain/usecases/check_mobile_usecase.dart';
import '../../domain/usecases/clear_session_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/persist_session_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../analytics/auth_analytics_tracker.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc(
    this._checkMobile,
    this._sendOtp,
    this._verifyOtp,
    this._register,
    this._persistSession,
    this._clearSession,
    this._logout,
    this._pushNotificationService,
    this._accountBloc,
    this._tracker,
  ) : super(const AuthState()) {
    on<LoginViewed>(_onLoginViewed);
    on<JoinViewed>(_onJoinViewed);
    on<CheckMobile>(_onCheckMobile);
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<Register>(_onRegister);
    on<ResetAuth>(_onResetAuth);
    on<AuthSignOut>(_onSignOut);
  }

  final CheckMobileUseCase _checkMobile;
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final RegisterUseCase _register;
  final PersistSessionUseCase _persistSession;
  final ClearSessionUseCase _clearSession;
  final LogoutUseCase _logout;
  final PushNotificationService _pushNotificationService;
  final AccountBloc _accountBloc;
  final AuthAnalyticsTracker _tracker;

  void _onLoginViewed(LoginViewed event, Emitter<AuthState> emit) =>
      _tracker.onLoginViewed(event.entry);

  void _onJoinViewed(JoinViewed event, Emitter<AuthState> emit) =>
      _tracker.onJoinViewed(event.entry);

  Future<void> _onCheckMobile(CheckMobile event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final token = swapCancelToken();
    final result = await _checkMobile.call(
      CheckMobileParams(mobile: event.mobile, cancelToken: token),
    );
    result.fold((failure) {
      if (failure is RequestCancelledFailure) return;
      emit(
        AuthState(
          status: AuthStatus.error,
          errorMessage: failure.message,
          messageBars: failure is ApiFailure ? failure.messageBars : [],
        ),
      );
    }, (entity) => emit(AuthState(status: AuthStatus.mobileChecked, checkMobileResult: entity)));
  }

  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final token = swapCancelToken();
    final result = await _sendOtp.call(
      SendOtpParams(
        loginId: event.loginId,
        otpReason: event.otpReason,
        pathUri: event.pathUri,
        cancelToken: token,
      ),
    );
    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          AuthState(
            status: AuthStatus.error,
            errorMessage: failure.message,
            messageBars: failure is ApiFailure ? failure.messageBars : [],
          ),
        );
      },
      (entity) {
        _tracker.onOtpSent(
          entry: event.entry,
          verificationReason: event.otpReason,
          mobile: event.loginId,
        );
        emit(
          AuthState(
            status: AuthStatus.otpSent,
            otpConfig: entity.otp,
            messageBars: entity.messageBars,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final token = swapCancelToken();
    final result = await _verifyOtp.call(
      VerifyOtpParams(
        loginId: event.loginId,
        otpCode: event.otp,
        otpReason: event.otpReason,
        cancelToken: token,
      ),
    );
    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        emit(
          AuthState(
            status: AuthStatus.error,
            errorMessage: failure.message,
            otpMessageBars: failure is ApiFailure ? failure.messageBars : [],
          ),
        );
      },
      (entity) async {
        await _persistSession.call(entity);

        _tracker.onOtpVerified(
          entry: event.entry,
          verificationReason: event.otpReason,
          mobile: event.loginId,
        );
        _tracker.onAuthSuccess(
          session: entity,
          entry: event.entry,
          isSignUp: event.otpReason == AuthStrings.signUpReason,
        );

        unawaited(_pushNotificationService.reRegister());
        _accountBloc.add(const PrefetchAddresses());
        emit(AuthState(status: AuthStatus.success, verifyOtpResult: entity));
      },
    );
  }

  Future<void> _onRegister(Register event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final token = swapCancelToken();
    final result = await _register.call(
      RegisterParams(
        displayName: event.displayName,
        email: event.email,
        mobile: event.mobile,
        cancelToken: token,
      ),
    );
    result.fold((failure) {
      if (failure is RequestCancelledFailure) return;
      final bars = failure is ApiFailure ? failure.messageBars : <MessageBarEntity>[];
      final redirectLink = bars.map((b) => b.redirectLink).nonNulls.firstOrNull;
      if (redirectLink != null) {
        emit(
          AuthState(
            status: AuthStatus.redirectLinkFound,
            redirectLink: redirectLink,
            messageBars: bars,
          ),
        );
        return;
      }
      emit(AuthState(status: AuthStatus.error, errorMessage: failure.message, messageBars: bars));
    }, (entity) {
      _tracker.onOtpSent(
        entry: event.entry,
        verificationReason: AuthStrings.signUpReason,
        mobile: event.mobile,
        email: event.email,
      );
      emit(AuthState(status: AuthStatus.otpSent, otpConfig: entity.otp));
    });
  }

  void _onResetAuth(ResetAuth event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(const AuthState(status: AuthStatus.loading));
    final token = swapCancelToken();
    final result = await _logout.call(LogoutParams(cancelToken: token));
    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        emit(AuthState(status: AuthStatus.error, errorMessage: failure.message));
      },
      (_) async {
        await _clearSession.call();

        await _tracker.onSignedOut();

        unawaited(_pushNotificationService.reRegister());
        emit(const AuthState(status: AuthStatus.signedOut));
        event.onSuccess?.call();
      },
    );
  }
}
