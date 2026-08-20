import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/cart_item_wishlist_info_entity.dart';

class CartItemWishlistInfoModel extends CartItemWishlistInfoEntity {
  const CartItemWishlistInfoModel({
    super.id,
    super.isWishlisted,
    super.canWishlist,
  });

  factory CartItemWishlistInfoModel.fromJson(Map<String, dynamic> json) {
    return CartItemWishlistInfoModel(
      id: parseToIntOrNull(json['id']),
      isWishlisted: parseToBool(json['isWishlisted']),
      canWishlist: parseToBool(json['canWishlist']),
    );
  }
}
