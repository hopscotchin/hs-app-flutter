import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/message_bar_entity.dart';
import '../mobile_info/mobile_info_entity.dart';

part 'check_mobile_response_entity.freezed.dart';

@freezed
abstract class CheckMobileResponseEntity with _$CheckMobileResponseEntity {
  const factory CheckMobileResponseEntity({
    MobileInfoEntity? mobile,
    @Default(false) bool showMobileScreen,
    @Default(false) bool hasEmail,
    @Default(false) bool isPhoneVerifiedForCod,
    // OTP endpoint path to use for the next sendOtp call.
    // Mirrors Android's AccountMobileResponse.pathUri.
    String? pathUri,
    // OTP reason to forward to sendOtp. From ActionResponse.otpReason.
    String? otpReason,
    String? action,
    String? popUpMessage,
    @Default([]) List<MessageBarEntity> messageBars,
  }) = _CheckMobileResponseEntity;
}
