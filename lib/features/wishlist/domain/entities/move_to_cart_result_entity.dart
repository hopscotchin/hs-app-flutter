import 'package:freezed_annotation/freezed_annotation.dart';

part 'move_to_cart_result_entity.freezed.dart';

/// Outcome of moving a wishlist item to the bag. The API performs both halves
/// (add to cart + drop from wishlist) and returns the new bag count.
@freezed
abstract class MoveToCartResultEntity with _$MoveToCartResultEntity {
  const factory MoveToCartResultEntity({int? cartItemQty}) =
      _MoveToCartResultEntity;
}
