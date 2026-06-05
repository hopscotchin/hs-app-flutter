import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/customer_info_entity.dart';

abstract class SplashRepository {
  Future<Either<Failure, Unit>> getAppConfig({
    CancelToken? cancelToken,
  });

  Future<Either<Failure, CustomerInfoEntity>> getCustomerInfo({
    CancelToken? cancelToken,
  });
}
