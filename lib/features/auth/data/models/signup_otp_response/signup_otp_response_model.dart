import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/message_bar_model.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../../domain/entities/signup_otp_response/signup_otp_response_entity.dart';
import '../otp_config/otp_config_model.dart';

part 'signup_otp_response_model.g.dart';

List<MessageBarModel> _messageBarsFromJson(Object? json) => json is List
    ? json
          .whereType<Map<String, dynamic>>()
          .map(MessageBarModel.fromJson)
          .toList()
    : const [];

@JsonSerializable(createToJson: false)
class SignupOtpResponseModel {
  const SignupOtpResponseModel({
    required this.otp,
    this.loginId,
    this.mobile,
    this.email,
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
  });

  final OtpConfigModel otp;
  final String? loginId;
  final String? mobile;
  final String? email;
  final String? action;
  final String? popUpMessage;
  @JsonKey(fromJson: _messageBarsFromJson)
  final List<MessageBarModel> messageBars;

  factory SignupOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignupOtpResponseModelFromJson(ActionResponse.validate(json));
}

extension SignupOtpResponseModelX on SignupOtpResponseModel {
  SignupOtpResponseEntity toEntity() => SignupOtpResponseEntity(
    otp: otp.toEntity(),
    loginId: loginId,
    mobile: mobile,
    email: email,
    action: action,
    popUpMessage: popUpMessage,
    messageBars: messageBars,
  );
}
