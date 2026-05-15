import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase implements UseCase<void, LogoutParams> {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(LogoutParams params) =>
      _repository.logout(cancelToken: params.cancelToken);
}

class LogoutParams extends Equatable {
  const LogoutParams({this.cancelToken});

  final CancelToken? cancelToken;

  @override
  List<Object?> get props => [];
  // cancelToken intentionally excluded — not a semantic field
}
