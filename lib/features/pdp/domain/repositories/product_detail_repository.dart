import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_to_cart_response_entity.dart';
import '../entities/pincode_check_entity.dart';
import '../entities/product_detail_entity.dart';
import '../entities/wishlist_response_entity.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetailEntity>> getProductDetails(int productId);
  Future<Either<Failure, AddToCartResponseEntity>> addToCart(
    String skuId,
    int quantity,
  );
  Future<Either<Failure, AddToCartResponseEntity>> buyNow(
    String skuId,
    int quantity,
  );
  Future<Either<Failure, WishlistResponseEntity>> addToWishlist(
    String productId,
    int price,
    String? skuId,
  );
  Future<Either<Failure, void>> removeFromWishlist(String wishlistId);
  Future<Either<Failure, PincodeCheckEntity>> verifyPincode(
    int productId,
    String pincode,
  );
}
