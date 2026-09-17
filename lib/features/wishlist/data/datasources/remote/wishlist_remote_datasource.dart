import 'package:injectable/injectable.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/strings/wishlist_strings.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/move_to_cart_response_model.dart';
import '../../models/remove_from_wishlist_response_model.dart';
import '../../models/wishlist_response_model.dart';

abstract class WishlistRemoteDataSource {
  Future<WishlistResponseModel> addToWishlist(
    String productId,
    int price,
    String? skuId,
  );
  /// Deletes a wishlist entry. The API returns a `popUpMessage` to show in the
  /// toast on both success and failure.
  Future<RemoveFromWishlistResponseModel> removeFromWishlist(String wishlistId);

  /// Moves a wishlisted item into the bag in one call: the API adds the SKU to
  /// the cart and drops the wishlist entry, returning the new bag count.
  Future<MoveToCartResponseModel> moveToCart({
    required String wishlistItemId,
    required String skuId,
    int quantity,
  });
}

@LazySingleton(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WishlistResponseModel> addToWishlist(
    String productId,
    int price,
    String? skuId,
  ) async {
    final body = <String, dynamic>{'productId': productId, 'price': price};
    if (skuId != null) body['sku'] = skuId;

    final response = await apiClient.post(ApiConstants.wishlist, data: body);
    final json = response.data as Map<String, dynamic>;
    return WishlistResponseModel.fromJson(json);
  }

  @override
  Future<MoveToCartResponseModel> moveToCart({
    required String wishlistItemId,
    required String skuId,
    int quantity = 1,
  }) async {
    final response = await apiClient.post(
      ApiConstants.moveToCartFromWishlist,
      data: <String, dynamic>{
        'wishlistItemId': wishlistItemId,
        'quantity': quantity,
        'skuId': skuId,
      },
    );
    final model = MoveToCartResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    // A non-success action carries popUpMessage for the toast; surface it as an
    // ApiFailure so the bloc gets it through the normal failure branch.
    if (!model.isSuccess) {
      throw ApiFailureException(
        message: model.failureMessage ?? WishlistStrings.actionFailed,
      );
    }
    return model;
  }

  @override
  Future<RemoveFromWishlistResponseModel> removeFromWishlist(
    String wishlistId,
  ) async {
    final response = await apiClient.delete(
      '${ApiConstants.wishlistListing}/$wishlistId',
    );
    final model = RemoveFromWishlistResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );

    // A non-success action carries popUpMessage for the toast; surface it as an
    // ApiFailure so the bloc gets it through the normal failure branch.
    if (!model.isSuccess) {
      throw ApiFailureException(
        message: model.message ?? WishlistStrings.actionFailed,
      );
    }
    return model;
  }
}
