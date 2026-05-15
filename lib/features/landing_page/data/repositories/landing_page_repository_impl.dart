import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../../discover/data/datasources/remote/home_remote_datasource.dart';
import '../../../discover/data/models/home_page_response_model.dart';
import '../../../discover/domain/entities/home_page_entity.dart';
import '../../domain/repositories/landing_page_repository.dart';

@LazySingleton(as: LandingPageRepository)
class LandingPageRepositoryImpl with SafeApiCall implements LandingPageRepository {
  LandingPageRepositoryImpl(this._api, this._networkInfo);

  final HomeRemoteDataSource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, HomePageEntity>> getLandingPage({
    required String pageName,
    CancelToken? cancelToken,
  }) =>
      safeApiCall(_networkInfo, () async {
        final response = await _api.getPage(
          pageName: pageName,
          pageSize: '20',
          pageNo: '1',
          cancelToken: cancelToken,
        );
        return response.toEntity();
      });
}
