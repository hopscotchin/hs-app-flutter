import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_to_cart_response_entity.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(String skuId, int quantity);
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(String skuId, int quantity);
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> removeCartItem(String sku);
  Future<Either<Failure, CartEntity>> updateCartItem(String sku, int quantity);
  Future<Either<Failure, CartEntity>> moveToWishlist(
    String sku, {
    int? productId,
    int? price,
  });
  Future<Either<Failure, CartEntity>> applyPromoCode(String promoCode);
  Future<Either<Failure, CartEntity>> removePromoCode(String promoCode);
  Future<Either<Failure, CartEntity>> mergeCart();
}
