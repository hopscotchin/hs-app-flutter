import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/send_otp_response/send_otp_response_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SendOtpUseCase implements UseCase<SendOtpResponseEntity, SendOtpParams> {
  SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SendOtpResponseEntity>> call(SendOtpParams params) =>
      _repository.sendOtp(
        loginId: params.loginId,
        otpReason: params.otpReason,
        pathUri: params.pathUri,
        cancelToken: params.cancelToken,
      );
}

class SendOtpParams extends Equatable {
  const SendOtpParams({
    required this.loginId,
    this.otpReason = 'SIGN_IN',
    this.pathUri,
    this.cancelToken,
  });

  final String loginId;
  final String otpReason;
  final String? pathUri;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [loginId, otpReason, pathUri];
  // cancelToken intentionally excluded — not a semantic field
}
