import '../../../../core/models/backend_action_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/cart_item_detail_entity.dart';

class CartItemDetailModel extends CartItemDetailEntity {
  const CartItemDetailModel({super.title, super.titleColor, super.action});

  factory CartItemDetailModel.fromJson(Map<String, dynamic> json) {
    return CartItemDetailModel(
      title: parseToStringOrNull(json['title']),
      titleColor: parseToStringOrNull(json['titleColor']),
      action: BackendActionModel.fromJsonOrNull(
        json['action'] as Map<String, dynamic>?,
      ),
    );
  }

  static List<CartItemDetailModel> listFromJson(List<dynamic>? raw) {
    return (raw ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CartItemDetailModel.fromJson)
        .toList();
  }
}
