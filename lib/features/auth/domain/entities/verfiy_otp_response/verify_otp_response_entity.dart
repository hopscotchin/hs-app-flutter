import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/message_bar_entity.dart';
import '../auth_credentials/auth_credentials_entity.dart';
import '../user_config/user_config_entity.dart';
import '../user_info/user_info_entity.dart';

part 'verify_otp_response_entity.freezed.dart';

@freezed
abstract class VerifyOtpResponseEntity with _$VerifyOtpResponseEntity {
  const factory VerifyOtpResponseEntity({
    required UserInfoEntity user,
    required AuthCredentialsEntity auth,
    Map<String, dynamic>? childCohorts,
    UserConfigEntity? userConfig,
    String? loginId,
    String? action,
    String? popUpMessage,
    @Default([]) List<MessageBarEntity> messageBars,
  }) = _VerifyOtpResponseEntity;
}
