import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/wishlist_response_entity.dart';

abstract class WishlistRepository {
  Future<Either<Failure, WishlistResponseEntity>> addToWishlist(
    String productId,
    int price,
    String? skuId,
  );

  Future<Either<Failure, void>> removeFromWishlist(String wishlistId);
}
