import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/message_bar_model.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../../domain/entities/send_otp_response/send_otp_response_entity.dart';
import '../otp_config/otp_config_model.dart';

part 'send_otp_response_model.g.dart';

List<MessageBarModel> _messageBarsFromJson(Object? json) => json is List
    ? json
          .whereType<Map<String, dynamic>>()
          .map(MessageBarModel.fromJson)
          .toList()
    : const [];

@JsonSerializable(createToJson: false)
class SendOtpResponseModel {
  const SendOtpResponseModel({
    required this.otp,
    this.loginId,
    this.otpReason,
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
  });

  final OtpConfigModel otp;
  final String? loginId;
  final String? otpReason;
  final String? action;
  final String? popUpMessage;
  @JsonKey(fromJson: _messageBarsFromJson)
  final List<MessageBarModel> messageBars;

  /// [ActionResponse.validate] runs first — throws [ApiFailureException] on
  /// `action: "failure"`, which [SafeApiCall] maps to [Left(ApiFailure(...))].
  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseModelFromJson(ActionResponse.validate(json));
}

extension SendOtpResponseModelX on SendOtpResponseModel {
  SendOtpResponseEntity toEntity() => SendOtpResponseEntity(
    otp: otp.toEntity(),
    loginId: loginId,
    otpReason: otpReason,
    action: action,
    popUpMessage: popUpMessage,
    messageBars: messageBars,
  );
}
