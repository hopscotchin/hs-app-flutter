// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pincode_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PincodeCheckModel _$PincodeCheckModelFromJson(Map<String, dynamic> json) =>
    PincodeCheckModel(
      serviceable: json['serviceable'] == null
          ? false
          : parseToBool(json['serviceable']),
      codAvailable: json['codAvailable'] == null
          ? false
          : parseToBool(json['codAvailable']),
      edd: parseToStringOrNull(json['edd']),
      eddPrefix: parseToStringOrNull(json['eddPrefix']),
      eddSuffix: parseToStringOrNull(json['eddSuffix']),
      eddSecondaryMsg: parseToStringOrNull(json['eddSecondaryMsg']),
      eddColor: parseToStringOrNull(json['eddColor']),
      eddTextColor: parseToStringOrNull(json['eddTextColor']),
      noPinCodeMessage: parseToStringOrNull(json['noPinCodeMessage']),
    );
