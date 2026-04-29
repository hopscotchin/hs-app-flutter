import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_page_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomePageEntity>> getHomePage({
    CancelToken? cancelToken,
  });
}
