import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/strings/auth_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase implements UseCase<VerifyOtpResponseEntity, VerifyOtpParams> {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(
        loginId: params.loginId,
        otpCode: params.otpCode,
        otpReason: params.otpReason,
        cancelToken: params.cancelToken,
      );
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({
    required this.loginId,
    required this.otpCode,
    this.otpReason = AuthStrings.signInReason,
    this.cancelToken,
  });

  final String loginId;
  final String otpCode;
  final String otpReason;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [loginId, otpCode, otpReason];
  // cancelToken intentionally excluded — not a semantic field
}
