import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_info_entity.freezed.dart';

@freezed
abstract class WishlistInfoEntity with _$WishlistInfoEntity {
  const factory WishlistInfoEntity({
    int? id,
    @Default(false) bool isWishlisted,
    @Default(false) bool canWishlist,
  }) = _WishlistInfoEntity;
}

extension WishlistInfoEntityX on WishlistInfoEntity {
  String? get wishlistId => (id ?? 0) > 0 ? id.toString() : null;
}
