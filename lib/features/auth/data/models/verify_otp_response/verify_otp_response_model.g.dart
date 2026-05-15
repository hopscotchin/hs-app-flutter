// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => VerifyOtpResponseModel(
  user: UserInfoModel.fromJson(json['user'] as Map<String, dynamic>),
  auth: AuthCredentialsModel.fromJson(json['auth'] as Map<String, dynamic>),
  childCohorts: json['childCohorts'] as Map<String, dynamic>?,
  userConfig: _userConfigFromJson(json['userConfig']),
  loginId: json['loginId'] as String?,
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _messageBarsFromJson(json['messageBars']),
);
