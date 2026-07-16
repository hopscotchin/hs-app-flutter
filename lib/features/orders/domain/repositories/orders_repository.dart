import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/orders_page_entity.dart';

/// Domain contract for reading the user's order history.
///
/// RULES (see CODING_GUIDELINES.md §2.2):
///  - Returns `Either<Failure, T>`. Never throws.
///  - Accepts a [CancelToken] so BLoCs can cancel in-flight requests
///    when a newer request supersedes them (see `BaseBloc`).
abstract class OrdersRepository {
  Future<Either<Failure, OrdersPageEntity>> getOrders({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  });
}
