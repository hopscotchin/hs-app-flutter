// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pincode_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PincodeCheckModel _$PincodeCheckModelFromJson(Map<String, dynamic> json) =>
    PincodeCheckModel(
      serviceable: json['serviceable'] as bool? ?? false,
      codAvailable: json['codAvailable'] as bool? ?? false,
      edd: json['edd'] as String?,
      eddPrefix: json['eddPrefix'] as String?,
      eddSuffix: json['eddSuffix'] as String?,
      eddSecondaryMsg: json['eddSecondaryMsg'] as String?,
      eddColor: json['eddColor'] as String?,
      eddTextColor: json['eddTextColor'] as String?,
      noPinCodeMessage: json['noPinCodeMessage'] as String?,
    );
