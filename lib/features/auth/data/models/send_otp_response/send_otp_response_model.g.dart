// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOtpResponseModel _$SendOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => SendOtpResponseModel(
  otp: OtpConfigModel.fromJson(json['otp'] as Map<String, dynamic>),
  loginId: json['loginId'] as String?,
  otpReason: json['otpReason'] as String?,
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _messageBarsFromJson(json['messageBars']),
);
