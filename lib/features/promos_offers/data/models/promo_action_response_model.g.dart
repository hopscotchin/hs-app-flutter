// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_action_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoActionResponseModel _$PromoActionResponseModelFromJson(
  Map<String, dynamic> json,
) => PromoActionResponseModel(
  success: _readSuccess(json, 'success') as bool? ?? false,
  message: _readMessage(json, 'popupMessage') as String? ?? '',
  promoCode: json['promoCode'] as String? ?? '',
  bottomSheet: json['bottomSheet'] as Map<String, dynamic>?,
);
