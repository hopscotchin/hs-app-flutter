import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_page_entity.dart';

abstract class HomeRepository {
  /// Single source of truth for the v13 home-page API.
  /// Used by both the Discover (Home) and LandingPage features.
  Future<Either<Failure, HomePageEntity>> getHomePage({
    required String pageName,
    int pageNo = 1,
    CancelToken? cancelToken,
  });
}
