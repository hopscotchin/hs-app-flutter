import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../discover/domain/entities/home_page_entity.dart';

abstract class LandingPageRepository {
  Future<Either<Failure, HomePageEntity>> getLandingPage({
    required String pageName,
    CancelToken? cancelToken,
  });
}
