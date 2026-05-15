import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/account_repository.dart';

class ForgetGuestUserParams {
  final CancelToken? cancelToken;

  const ForgetGuestUserParams({this.cancelToken});

  @override
  bool operator ==(Object other) => other is ForgetGuestUserParams;

  @override
  int get hashCode => 0;
}

@lazySingleton
class ForgetGuestUserUseCase implements UseCase<void, ForgetGuestUserParams> {
  final AccountRepository _repository;

  ForgetGuestUserUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgetGuestUserParams params) =>
      _repository.forgetGuestUser(cancelToken: params.cancelToken);
}
