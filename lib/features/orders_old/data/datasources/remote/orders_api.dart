import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/orders_page_response_model.dart';

part 'orders_api.g.dart';

/// Typed HTTP surface for the Orders endpoints.
///
/// RULES (see CODING_GUIDELINES.md §2.6):
///  - Feature code MUST NOT call `Dio` directly. It calls this API.
///  - The Dio instance injected here is the one owned by `NetworkClient`
///    (auth + cookie + logging + retry interceptors already attached),
///    provided via `RegisterModule`.
///  - Paths are constants from [ApiConstants]. Never hard-code routes here.
@RestApi()
@lazySingleton
abstract class OrdersApi {
  @factoryMethod
  factory OrdersApi(Dio dio) = _OrdersApi;

  @GET(
    '/orders/v5',
  ) // use ApiConstants.ordersListing when the endpoint is ready
  Future<OrdersPageResponseModel> getOrders({
    @Query('pageNo') required int pageNo,
    @Query('pageSize') required int pageSize,
    @CancelRequest() CancelToken? cancelToken,
  });
}
