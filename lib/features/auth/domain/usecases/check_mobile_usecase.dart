import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/check_mobile_response/check_mobile_response_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class CheckMobileUseCase
    implements UseCase<CheckMobileResponseEntity, CheckMobileParams> {
  CheckMobileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, CheckMobileResponseEntity>> call(
    CheckMobileParams params,
  ) =>
      _repository.checkMobile(
        mobile: params.mobile,
        cancelToken: params.cancelToken,
      );
}

class CheckMobileParams extends Equatable {
  const CheckMobileParams({required this.mobile, this.cancelToken});

  final String mobile;
  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [mobile];
  // cancelToken intentionally excluded
}
