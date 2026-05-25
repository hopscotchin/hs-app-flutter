import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/send_otp_response/send_otp_response_entity.dart';
import '../../domain/entities/signup_otp_response/signup_otp_response_entity.dart';
import '../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/send_otp_response/send_otp_response_model.dart';
import '../models/signup_otp_response/signup_otp_response_model.dart';
import '../models/verify_otp_response/verify_otp_response_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with SafeApiCall implements AuthRepository {
  AuthRepositoryImpl(this._api, this._networkInfo);

  final AuthRemoteDatasource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, SendOtpResponseEntity>> sendOtp({
    required String loginId,
    required String otpReason,
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.sendOtp(
      body: {'loginId': loginId, 'otpReason': otpReason},
      cancelToken: cancelToken,
    );
    return response.toEntity();
  });

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp({
    required String loginId,
    required String otpCode,
    required String otpReason,
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.verifyOtp(
      body: {'loginId': loginId, 'otpCode': otpCode, 'otpReason': otpReason},
      cancelToken: cancelToken,
    );
    return response.toEntity();
  });

  @override
  Future<Either<Failure, SignupOtpResponseEntity>> register({
    required String displayName,
    required String email,
    required String mobile,
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.register(
      body: {'displayName': displayName, 'email': email, 'mobile': mobile, 'otpReason': 'SIGN_UP'},
      cancelToken: cancelToken,
    );
    return response.toEntity();
  });

  @override
  Future<Either<Failure, void>> logout({CancelToken? cancelToken}) =>
      safeApiCall(_networkInfo, () async {
        await _api.logout(cancelToken: cancelToken);
      });
}
