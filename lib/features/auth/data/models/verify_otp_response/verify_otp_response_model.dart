import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/message_bar_model.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../../domain/entities/verfiy_otp_response/verify_otp_response_entity.dart';
import '../auth_credentials/auth_credentials_model.dart';
import '../user_config/user_config_model.dart';
import '../user_info/user_info_model.dart';

part 'verify_otp_response_model.g.dart';

UserConfigModel? _userConfigFromJson(Object? json) =>
    json is Map<String, dynamic> ? UserConfigModel.fromJson(json) : null;

List<MessageBarModel> _messageBarsFromJson(Object? json) => json is List
    ? json
          .whereType<Map<String, dynamic>>()
          .map(MessageBarModel.fromJson)
          .toList()
    : const [];

@JsonSerializable(createToJson: false)
class VerifyOtpResponseModel {
  const VerifyOtpResponseModel({
    required this.user,
    required this.auth,
    this.childCohorts,
    this.userConfig,
    this.loginId,
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
  });

  final UserInfoModel user;
  final AuthCredentialsModel auth;
  final Map<String, dynamic>? childCohorts;
  @JsonKey(name: 'userConfig', fromJson: _userConfigFromJson)
  final UserConfigModel? userConfig;
  final String? loginId;
  final String? action;
  final String? popUpMessage;
  @JsonKey(fromJson: _messageBarsFromJson)
  final List<MessageBarModel> messageBars;

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseModelFromJson(ActionResponse.validate(json));
}

extension VerifyOtpResponseModelX on VerifyOtpResponseModel {
  VerifyOtpResponseEntity toEntity() => VerifyOtpResponseEntity(
    user: user.toEntity(),
    auth: auth.toEntity(),
    childCohorts: childCohorts,
    userConfig: userConfig?.toEntity(),
    loginId: loginId,
    action: action,
    popUpMessage: popUpMessage,
    messageBars: messageBars,
  );
}
