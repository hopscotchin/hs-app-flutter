// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupOtpResponseModel _$SignupOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => SignupOtpResponseModel(
  otp: OtpConfigModel.fromJson(json['otp'] as Map<String, dynamic>),
  loginId: json['loginId'] as String?,
  mobile: json['mobile'] as String?,
  email: json['email'] as String?,
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _messageBarsFromJson(json['messageBars']),
);
