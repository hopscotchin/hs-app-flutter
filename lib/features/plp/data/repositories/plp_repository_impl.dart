import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/listing_data_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/repositories/plp_repository.dart';
import '../datasources/remote/plp_remote_datasource.dart';

@LazySingleton(as: PlpRepository)
class PlpRepositoryImpl with SafeApiCall implements PlpRepository {
  final PlpRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlpRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ListingDataEntity>> getListingData({
    required PageType pageType,
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => pageType != PageType.boutique
          ? remoteDataSource.getPlpProducts(
              queryParams: queryParams,
              cancelToken: cancelToken,
            )
          : remoteDataSource.getBoutiqueProducts(
              queryParams: queryParams,
              cancelToken: cancelToken,
            ),
    );
  }

  @override
  Future<Either<Failure, PlpFilterEntity>> getFilterData({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(
      networkInfo,
      () => remoteDataSource.getFilterData(
        queryParams: queryParams,
        cancelToken: cancelToken,
      ),
    );
  }
}
