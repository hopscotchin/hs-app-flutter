import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/check_mobile_response/check_mobile_response_entity.dart';
import '../entities/send_otp_response/send_otp_response_entity.dart';
import '../entities/signup_otp_response/signup_otp_response_entity.dart';
import '../entities/verfiy_otp_response/verify_otp_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, CheckMobileResponseEntity>> checkMobile({
    required String mobile,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SendOtpResponseEntity>> sendOtp({
    required String loginId,
    required String otpReason,
    String? pathUri,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, VerifyOtpResponseEntity>> verifyOtp({
    required String loginId,
    required String otpCode,
    required String otpReason,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SignupOtpResponseEntity>> register({
    required String displayName,
    required String email,
    required String mobile,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, void>> logout({CancelToken? cancelToken});
}
