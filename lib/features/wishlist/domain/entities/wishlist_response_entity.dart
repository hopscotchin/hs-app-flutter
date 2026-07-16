import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_response_entity.freezed.dart';

@freezed
abstract class WishlistResponseEntity with _$WishlistResponseEntity {
  const factory WishlistResponseEntity({
    String? action,
    String? message,
    String? wishlistItemId,
  }) = _WishlistResponseEntity;
}
