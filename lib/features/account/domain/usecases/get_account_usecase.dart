import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountParams {
  final CancelToken? cancelToken;

  const GetAccountParams({this.cancelToken});

  @override
  bool operator ==(Object other) => other is GetAccountParams;

  @override
  int get hashCode => 0;
}

@lazySingleton
class GetAccountUseCase implements UseCase<AccountEntity, GetAccountParams> {
  final AccountRepository _repository;

  GetAccountUseCase(this._repository);

  @override
  Future<Either<Failure, AccountEntity>> call(GetAccountParams params) =>
      _repository.getAccount(cancelToken: params.cancelToken);
}
