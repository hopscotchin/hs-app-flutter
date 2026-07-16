import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/pincode_check_entity.dart';
import '../entities/product_detail_entity.dart';
import '../entities/recommendations_entity.dart';
import '../entities/size_chart_entity.dart';

abstract class PdpRepository {
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(
    int productId, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, RecommendationsEntity>> getRecommendations(
    int productId, {
    required int pageNo,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, PincodeCheckEntity>> verifyPincode(
    int productId,
    String pincode, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, SizeChartEntity>> getSizeChart(int productId, {CancelToken? cancelToken});
}
