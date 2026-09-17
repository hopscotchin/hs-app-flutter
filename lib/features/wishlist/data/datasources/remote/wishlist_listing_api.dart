import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/wishlist_page_response_model.dart';

part 'wishlist_listing_api.g.dart';

/// Typed HTTP surface for reading the wishlist listing.
///
/// Kept separate from the toggle-only [WishlistRemoteDataSource] (which uses
/// the raw `ApiClient`): the listing is a GET with pagination and maps to a
/// typed page model, so Retrofit is the right tool.
@RestApi()
@lazySingleton
abstract class WishlistListingApi {
  @factoryMethod
  factory WishlistListingApi(Dio dio) = _WishlistListingApi;

  @GET(ApiConstants.wishlistListing)
  Future<WishlistPageResponseModel> getWishlist({
    @Query('pageNo') required int pageNo,
    @Query('pageSize') required int pageSize,
    @Query('isPaginationRequired') bool isPaginationRequired = true,
    @CancelRequest() CancelToken? cancelToken,
  });
}
