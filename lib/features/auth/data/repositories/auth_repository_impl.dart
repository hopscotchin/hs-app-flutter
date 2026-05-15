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
import '../transformers/send_otp_transformer.dart';
import '../transformers/signup_otp_transformer.dart';
import '../transformers/verify_otp_transformer.dart';

/// Repository implementation for authentication.
///
/// Depends directly on the Retrofit [AuthRemoteDatasource]. All error translation happens
/// inside [safeApiCall]. No try/catch here.
///
/// v3 migration checklist (do all four steps atomically):
///   1. In [AuthRemoteDatasource]: change each endpoint constant to its V3 variant
///      (sendOtpV3, verifyOtpV3, signupSendOtpV3) and change each return type from
///      [LoginModel] to the matching response model (SendOtpResponseModel,
///      VerifyOtpResponseModel, SignupOtpResponseModel).
///   2. In this file: swap `.transform(response)` for `response.toEntity()` and
///      delete the transformer imports at the top.
///   3. Delete lib/features/auth/data/transformers/ entirely.
///   4. Re-run `dart run build_runner build --delete-conflicting-outputs`
///      to regenerate auth_remote_datasource.g.dart.
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
    // v3: replace with `return response.toEntity();` after updating the datasource
    return SendOtpTransformer.transform(response);
  });

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp({
    required String loginId,
    required String otp,
    required String otpReason,
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.verifyOtp(
      body: {'loginId': loginId, 'otp': otp, 'otpReason': otpReason},
      cancelToken: cancelToken,
    );
    // v3: replace with `return response.toEntity();` after updating the datasource
    return VerifyOtpTransformer.transform(response);
  });

  @override
  Future<Either<Failure, SignupOtpResponseEntity>> register({
    required String displayName,
    required String email,
    required String mobile,
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.register(
      body: {
        'name': displayName, // old API field name preserved
        'email': email,
        'phoneNo': mobile, // old API field name preserved
        'otpReason': 'SIGN_UP',
      },
      cancelToken: cancelToken,
    );
    // v3: replace with `return response.toEntity();` after updating the datasource
    return SignupOtpTransformer.transform(response);
  });

  @override
  Future<Either<Failure, void>> logout({CancelToken? cancelToken}) =>
      safeApiCall(_networkInfo, () async {
        await _api.logout(cancelToken: cancelToken);
      });
}
