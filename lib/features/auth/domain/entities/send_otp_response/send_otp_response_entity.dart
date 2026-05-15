import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/message_bar_entity.dart';
import '../otp_config/otp_config_entity.dart';

part 'send_otp_response_entity.freezed.dart';

@freezed
abstract class SendOtpResponseEntity with _$SendOtpResponseEntity {
  const factory SendOtpResponseEntity({
    required OtpConfigEntity otp,
    String? loginId,
    String? otpReason,
    String? action,
    String? popUpMessage,
    @Default([]) List<MessageBarEntity> messageBars,
  }) = _SendOtpResponseEntity;
}
