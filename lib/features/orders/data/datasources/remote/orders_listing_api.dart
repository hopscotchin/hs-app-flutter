import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/listing/orders_listing_response_model.dart';

part 'orders_listing_api.g.dart';

/// The two listing endpoints. Both return [OrdersListingResponseModel] — same
/// envelope, same record shape — which is what lets one repository, one bloc
/// and one card widget serve both tabs.
///
/// Scoped to the listing rather than to orders as a whole: details, return,
/// exchange and track are separate endpoint groups and get their own clients,
/// per the coding rules' "split by endpoint group".
///
/// The Dio injected here is the one `NetworkClient` owns, with auth, cookie,
/// logging and retry interceptors already attached.
@RestApi()
@lazySingleton
abstract class OrdersListingApi {
  @factoryMethod
  factory OrdersListingApi(Dio dio) = _OrdersListingApi;

  @GET(ApiConstants.ordersListing)
  Future<OrdersListingResponseModel> getOrders({
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET(ApiConstants.giftCardsListing)
  Future<OrdersListingResponseModel> getGiftCards({
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
    @CancelRequest() CancelToken? cancelToken,
  });
}
