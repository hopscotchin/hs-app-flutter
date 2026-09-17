// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_to_cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoveToCartResponseModel _$MoveToCartResponseModelFromJson(
  Map<String, dynamic> json,
) => MoveToCartResponseModel(
  action: parseToStringOrNull(json['action']),
  cartItemQty: parseToIntOrNull(json['cartItemQty']),
  popUpMessage: parseToStringOrNull(json['popUpMessage']),
);
