import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/listing/orders_listing_entity.dart';
import '../entities/orders_tab.dart';

/// One method for both tabs — [tab] picks the endpoint.
///
/// The tabs differ only in which URL is called and which optional blocks come
/// back, so splitting this into two methods would duplicate the envelope guard
/// and the entity mapping for no gain.
abstract class OrdersListingRepository {
  Future<Either<Failure, OrdersListingEntity>> getListing({
    required OrdersTab tab,
    required int page,
    required int pageSize,
    CancelToken? cancelToken,
  });
}
