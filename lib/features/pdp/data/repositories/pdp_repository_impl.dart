import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/pincode_check_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/recommendations_entity.dart';
import '../../domain/entities/size_chart_entity.dart';
import '../../domain/repositories/pdp_repository.dart';
import '../datasources/mock/pdp_mock_data.dart';
import '../datasources/remote/pdp_remote_datasource.dart';
import '../models/pincode_check_model.dart';
import '../models/product_detail_model.dart';
import '../models/recommendations_model.dart';
import '../models/size_chart_model.dart';

@LazySingleton(as: PdpRepository)
class PdpRepositoryImpl with SafeApiCall implements PdpRepository {
  PdpRepositoryImpl(this._api, this._networkInfo);

  final PdpRemoteDatasource _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    int productId, {
    CancelToken? cancelToken,
  }) {
    if (dotenv.env['PDP_USE_MOCK'] == 'true') return Future.value(Right(pdpMockEntity));
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getProductDetails(
        productId: productId,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, RecommendationsEntity>> getRecommendations(
    int productId, {
    required int pageNo,
    CancelToken? cancelToken,
  }) {
    if (dotenv.env['PDP_USE_MOCK'] == 'true') {
      return Future.value(Right(pdpRecommendationsMockEntity));
    }
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getRecommendations(
        productId: productId,
        pageNo: pageNo,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, PincodeCheckEntity>> verifyPincode(
    int productId,
    String pincode, {
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.verifyPincode(
      productId: productId,
      pincode: pincode,
      cancelToken: cancelToken,
    );
    return response.toEntity();
  });

  @override
  Future<Either<Failure, SizeChartEntity>> getSizeChart(
    int productId, {
    CancelToken? cancelToken,
  }) => safeApiCall(_networkInfo, () async {
    final response = await _api.getSizeChart(productId: productId, cancelToken: cancelToken);
    return response.toEntity();
  });
}
