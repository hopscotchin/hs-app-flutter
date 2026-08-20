import 'package:equatable/equatable.dart';

class CartItemWishlistInfoEntity extends Equatable {
  final int? id;
  final bool isWishlisted;
  final bool canWishlist;

  const CartItemWishlistInfoEntity({
    this.id,
    this.isWishlisted = false,
    this.canWishlist = false,
  });

  @override
  List<Object?> get props => [id, isWishlisted, canWishlist];
}
