// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_mobile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckMobileResponseModel _$CheckMobileResponseModelFromJson(
  Map<String, dynamic> json,
) => CheckMobileResponseModel(
  mobile: _mobileFromJson(json['mobile']),
  showMobileScreen: json['showMobileScreen'] as bool? ?? false,
  hasEmail: json['hasEmail'] as bool? ?? false,
  isPhoneVerifiedForCod: json['isPhoneVerifiedForCod'] as bool? ?? false,
  pathUri: json['pathUri'] as String?,
  otpReason: json['otpReason'] as String?,
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _messageBarsFromJson(json['messageBars']),
);
