import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/otp_config/otp_config_entity.dart';

part 'otp_config_model.g.dart';

@JsonSerializable(createToJson: false)
class OtpConfigModel {
  const OtpConfigModel({this.timerSeconds = 30, this.length = 6, this.hint});

  @JsonKey(name: 'timerSeconds', defaultValue: 30)
  final int timerSeconds;
  @JsonKey(name: 'length', defaultValue: 6)
  final int length;
  final String? hint;

  factory OtpConfigModel.fromJson(Map<String, dynamic> json) =>
      _$OtpConfigModelFromJson(json);
}

extension OtpConfigModelX on OtpConfigModel {
  OtpConfigEntity toEntity() =>
      OtpConfigEntity(timerSeconds: timerSeconds, length: length, hint: hint);
}
