import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_config_entity.freezed.dart';

@freezed
abstract class OtpConfigEntity with _$OtpConfigEntity {
  const factory OtpConfigEntity({
    @Default(30) int timerSeconds,
    @Default(6) int length,
    String? hint,
  }) = _OtpConfigEntity;
}
