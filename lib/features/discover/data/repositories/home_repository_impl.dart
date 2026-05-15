import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/home_page_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_datasource.dart';
import '../models/home_page_response_model.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl with SafeApiCall implements HomeRepository {
  HomeRepositoryImpl(this._api, this._networkInfo);

  final HomeRemoteDataSource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, HomePageEntity>> getHomePage({
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        final response = await _api.getPage(
          pageName: 'discover',
          pageSize: '20',
          pageNo: '1',
          cancelToken: cancelToken,
        );
        return response.toEntity();
      });
}
