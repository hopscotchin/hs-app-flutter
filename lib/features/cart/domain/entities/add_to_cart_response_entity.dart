import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_to_cart_response_entity.freezed.dart';

@freezed
abstract class AddToCartResponseEntity with _$AddToCartResponseEntity {
  const factory AddToCartResponseEntity({String? action, String? message, int? cartItemQty}) =
      _AddToCartResponseEntity;
}
