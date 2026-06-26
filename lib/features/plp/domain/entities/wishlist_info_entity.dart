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
  /// The backend uses `id == 0` (or null) as the "no wishlist item" sentinel,
  /// so a real wishlist-item id is only present when `id > 0`. Used by the
  /// remove flow, which needs the id as a string.
  String? get wishlistId => (id ?? 0) > 0 ? id.toString() : null;
}
