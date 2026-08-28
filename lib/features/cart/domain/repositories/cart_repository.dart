import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_to_cart_response_entity.dart';
import '../entities/cart_entity.dart';
import '../entities/message_bar_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(String skuId, int quantity);
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(String skuId, int quantity);

  /// [instantCheckout] scopes every cart call to the single buy-now item: the
  /// backend answers with just that line rather than the whole bag. Android
  /// sends the same flag from `CartViewModel.isFromBuyNow`.
  Future<Either<Failure, CartEntity>> getCart({
    bool isMergeCall = false,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, CartEntity>> removeCartItem(
    String sku, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, CartEntity>> updateCartItem(
    String sku,
    int quantity, {
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, CartEntity>> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
    bool instantCheckout = false,
    CancelToken? cancelToken,
  });
  Future<Either<Failure, CartEntity>> mergeCart({CancelToken? cancelToken});

  /// Message bars authored in the app config and cached at splash — read from
  /// local storage, not the network, so no [CancelToken].
  Future<Either<Failure, List<MessageBarEntity>>> getStaticMessageBars();
}
