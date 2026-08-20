import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/cart_item_media_entity.dart';

class CartItemMediaModel extends CartItemMediaEntity {
  const CartItemMediaModel({super.mimeType, super.url});

  factory CartItemMediaModel.fromJson(Map<String, dynamic> json) {
    return CartItemMediaModel(
      mimeType: parseToStringOrNull(json['mimeType']),
      url: parseToStringOrNull(json['url']),
    );
  }

  static List<CartItemMediaModel> listFromJson(List<dynamic>? raw) {
    return (raw ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CartItemMediaModel.fromJson)
        .toList();
  }
}
