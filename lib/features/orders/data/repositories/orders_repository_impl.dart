import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/orders_page_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/remote/orders_api.dart';

/// Repository implementation for order history.
///
/// Notes on shape:
///  - Depends directly on the retrofit [OrdersApi]. We deliberately do
///    NOT have a separate `OrdersRemoteDataSource` class — it would be
///    pure forwarding with nothing to add.
///  - All error translation (Dio + AppException → Failure) happens
///    inside [safeApiCall]. There is no try/catch in this file.
@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl with SafeApiCall implements OrdersRepository {
  final OrdersApi _api;
  final NetworkInfo _networkInfo;

  OrdersRepositoryImpl(this._api, this._networkInfo);

  @override
  Future<Either<Failure, OrdersPageEntity>> getOrders({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  }) {
    return safeApiCall(_networkInfo, () async {
      final response = await _api.getOrders(
        pageNo: pageNo,
        pageSize: pageSize,
        cancelToken: cancelToken,
      );
      return response.toEntity();
    });
  }
}
