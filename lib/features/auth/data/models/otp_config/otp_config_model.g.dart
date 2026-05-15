// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpConfigModel _$OtpConfigModelFromJson(Map<String, dynamic> json) =>
    OtpConfigModel(
      timerSeconds: (json['timerSeconds'] as num?)?.toInt() ?? 30,
      length: (json['length'] as num?)?.toInt() ?? 6,
      hint: json['hint'] as String?,
    );
