import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/message_bar_entity.dart';
import '../otp_config/otp_config_entity.dart';

part 'signup_otp_response_entity.freezed.dart';

@freezed
abstract class SignupOtpResponseEntity with _$SignupOtpResponseEntity {
  const factory SignupOtpResponseEntity({
    required OtpConfigEntity otp,
    String? loginId,
    String? mobile,
    String? email,
    String? action,
    String? popUpMessage,
    @Default([]) List<MessageBarEntity> messageBars,
  }) = _SignupOtpResponseEntity;
}
