import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/signup_otp_response/signup_otp_response_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RegisterUseCase
    implements UseCase<SignupOtpResponseEntity, RegisterParams> {
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SignupOtpResponseEntity>> call(
    RegisterParams params,
  ) => _repository.register(
    displayName: params.displayName,
    email: params.email,
    mobile: params.mobile,
    cancelToken: params.cancelToken,
  );
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.displayName,
    required this.email,
    required this.mobile,
    this.cancelToken,
  });

  final String displayName;
  final String email;
  final String mobile;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [displayName, email, mobile];
  // cancelToken intentionally excluded — not a semantic field
}
