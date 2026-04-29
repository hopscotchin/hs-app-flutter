import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/home_page_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_datasource.dart';

class HomeRepositoryImpl with SafeApiCall implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, HomePageEntity>> getHomePage({
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getHomePage(cancelToken: cancelToken),
    );
  }
}
