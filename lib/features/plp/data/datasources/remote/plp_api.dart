import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/listing_data_model.dart';
import '../../models/pincode_check_model.dart';
import '../../models/plp_filter_model.dart';

part 'plp_api.g.dart';

/// Typed HTTP surface for the PLP / Search / Boutique endpoints.
///
/// Mirrors the Orders module — repositories depend directly on this Retrofit
/// client (no intermediate remote-datasource class; that would be pure
/// forwarding). See CODING_GUIDELINES.md §2.6.
@RestApi()
@lazySingleton
abstract class PlpApi {
  @factoryMethod
  factory PlpApi(Dio dio) = _PlpApi;

  /// Regular PLP / category listing — `/products/v8`.
  @GET(ApiConstants.plpProducts)
  Future<ListingDataModel> getPlpProducts({
    @Queries() required Map<String, dynamic> queryParams,
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Boutique + Search listing — `/search/product/v6`.
  @GET(ApiConstants.boutiqueProducts)
  Future<ListingDataModel> getBoutiqueProducts({
    @Queries() required Map<String, dynamic> queryParams,
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Filter section payload for a given listing — `/v2/filter`.
  @GET(ApiConstants.plpFilter)
  Future<PlpFilterModel> getFilterData({
    @Queries() required Map<String, dynamic> queryParams,
    @CancelRequest() CancelToken? cancelToken,
  });

  /// Pincode serviceability check — `/products/pincode`. The filter sheet
  /// passes `productId: -1` (sentinel meaning "filter context, no specific
  /// product"); PDP passes a real productId.
  @GET(ApiConstants.pincodeCheck)
  Future<PincodeCheckModel> checkPincode({
    @Query('pincode') required String pincode,
    @Query('productId') int productId = -1,
    @CancelRequest() CancelToken? cancelToken,
  });
}
