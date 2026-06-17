import '../../domain/entities/add_to_cart_response_entity.dart';

class AddToCartResponseModel extends AddToCartResponseEntity {
  const AddToCartResponseModel({super.cartItemQty});

  AddToCartResponseModel.fromJson(super.json)
    : super.fromJson(cartItemQty: json['cartItemQty'] as int?);
}
