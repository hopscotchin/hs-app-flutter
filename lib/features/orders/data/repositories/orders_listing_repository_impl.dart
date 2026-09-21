import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/mixins/safe_api_call.dart';
import '../../../../core/network/connectivity/network_info.dart';
import '../../domain/entities/listing/orders_listing_entity.dart';
import '../../domain/entities/orders_tab.dart';
import '../../domain/repositories/orders_listing_repository.dart';
import '../datasources/remote/orders_listing_api.dart';
import '../mock/listing/orders_listing_mock_source.dart';
import '../models/listing/orders_listing_response_model.dart';

/// Talks to [OrdersListingApi] and maps the response to the domain.
///
/// Depends on the Retrofit client directly — there is no separate
/// `OrdersRemoteDataSource`, because it would forward calls and add nothing.
/// All Dio and exception translation happens inside [safeApiCall]; there is no
/// try/catch in this file.
@LazySingleton(as: OrdersListingRepository)
class OrdersListingRepositoryImpl
    with SafeApiCall
    implements OrdersListingRepository {
  OrdersListingRepositoryImpl(this._api, this._networkInfo);

  final OrdersListingApi _api;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, OrdersListingEntity>> getListing({
    required OrdersTab tab,
    required int page,
    required int pageSize,
    CancelToken? cancelToken,
  }) {
    // ── MOCK — delete this block when BE ships the endpoints ────────────────
    if (EnvConfig.useOrderListingMock) {
      return safeApiCall(_networkInfo, () async {
        final response = await OrdersListingMockSource.getListing(
          tab: tab,
          page: page,
          pageSize: pageSize,
        );
        return _toEntity(response);
      });
    }
    // ────────────────────────────────────────────────────────────────────────

    return safeApiCall(_networkInfo, () async {
      final response = switch (tab) {
        OrdersTab.orders => await _api.getOrders(
          page: page,
          pageSize: pageSize,
          cancelToken: cancelToken,
        ),
        OrdersTab.giftCards => await _api.getGiftCards(
          page: page,
          pageSize: pageSize,
          cancelToken: cancelToken,
        ),
      };
      return _toEntity(response);
    });
  }

  /// Rejects a failure envelope before mapping.
  ///
  /// The BFF answers HTTP 200 even for logical failures, and a Retrofit call
  /// bypasses `ApiClient._validateActionResponse` — that only runs for the
  /// `ApiClient`-based datasources. Without this check an
  /// `{"action":"error","errorMsg":"…"}` body parses into zero records and the
  /// screen reports "no orders" for what was actually a server error.
  OrdersListingEntity _toEntity(OrdersListingResponseModel response) {
    if (response.isFailure) {
      final message = response.message;
      throw (message != null && message.isNotEmpty)
          ? ApiFailureException(message: message)
          : const ApiFailureException();
    }
    return response.toEntity();
  }
}
