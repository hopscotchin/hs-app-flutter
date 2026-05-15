import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/remote/account_remote_data_source.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl with SafeApiCall implements AccountRepository {
  final AccountRemoteDataSource _api;
  final NetworkInfo _networkInfo;

  AccountRepositoryImpl(this._api, this._networkInfo);

  @override
  Future<Either<Failure, AccountEntity>> getAccount({CancelToken? cancelToken}) {
    return safeApiCall(_networkInfo, () async {
      final model = await _api.getAccount(cancelToken: cancelToken);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> forgetGuestUser({CancelToken? cancelToken}) {
    return safeApiCall(
      _networkInfo,
      () => _api.forgetGuestUser(cancelToken: cancelToken)
    );
  }
}
