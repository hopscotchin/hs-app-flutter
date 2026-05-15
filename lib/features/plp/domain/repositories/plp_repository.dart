import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/listing_data_entity.dart';
import '../entities/page_type.dart';
import '../entities/plp_filter_entity.dart';

abstract class PlpRepository {
  Future<Either<Failure, ListingDataEntity>> getListingData({
    required PageType pageType,
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, PlpFilterEntity>> getFilterData({
    required Map<String, dynamic> queryParams,
    CancelToken? cancelToken,
  });
}
