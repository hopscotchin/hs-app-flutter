import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/add_to_cart_response_entity.dart';

part 'add_to_cart_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AddToCartResponseModel {
  const AddToCartResponseModel({this.action, this.message, this.cartItemQty});

  @JsonKey(defaultValue: null) final String? action;
  @JsonKey(defaultValue: null) final String? message;
  @JsonKey(defaultValue: null) final int? cartItemQty;

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartResponseModelFromJson(json);
}

extension AddToCartResponseModelX on AddToCartResponseModel {
  AddToCartResponseEntity toEntity() => AddToCartResponseEntity(
    action: action,
    message: message,
    cartItemQty: cartItemQty,
  );
}
