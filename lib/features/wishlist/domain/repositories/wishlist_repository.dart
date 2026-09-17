import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../entities/move_to_cart_result_entity.dart';
import '../entities/wishlist_page_entity.dart';
import '../entities/wishlist_response_entity.dart';

abstract class WishlistRepository {
  Future<Either<Failure, WishlistResponseEntity>> addToWishlist(
    String productId,
    int price,
    String? skuId,
  );

  /// Removes a wishlist entry, returning the API's `popUpMessage` for the
  /// toast (null when the API sent none).
  Future<Either<Failure, String?>> removeFromWishlist(String wishlistId);

  /// Move a wishlisted SKU into the bag (adds to cart and removes from the
  /// wishlist server-side), returning the updated bag count.
  Future<Either<Failure, MoveToCartResultEntity>> moveToCart({
    required String wishlistItemId,
    required String skuId,
    int quantity,
  });

  /// Read one page of the customer's wishlist listing.
  Future<Either<Failure, WishlistPageEntity>> getWishlist({
    required int pageNo,
    required int pageSize,
    CancelToken? cancelToken,
  });
}
