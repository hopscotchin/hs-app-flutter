import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/message_bar_model.dart';
import '../../../../../core/network/models/action_response.dart';
import '../../../domain/entities/check_mobile_response/check_mobile_response_entity.dart';
import '../mobile_info/mobile_info_model.dart';

part 'check_mobile_response_model.g.dart';

List<MessageBarModel> _messageBarsFromJson(Object? json) => json is List
    ? json.whereType<Map<String, dynamic>>().map(MessageBarModel.fromJson).toList()
    : const [];

MobileInfoModel? _mobileFromJson(Object? json) =>
    json is Map<String, dynamic> ? MobileInfoModel.fromJson(json) : null;

@JsonSerializable(createToJson: false)
class CheckMobileResponseModel {
  const CheckMobileResponseModel({
    this.mobile,
    this.showMobileScreen = false,
    this.hasEmail = false,
    this.isPhoneVerifiedForCod = false,
    this.pathUri,
    this.otpReason,
    this.action,
    this.popUpMessage,
    this.messageBars = const [],
  });

  @JsonKey(fromJson: _mobileFromJson)
  final MobileInfoModel? mobile;
  @JsonKey(defaultValue: false)
  final bool showMobileScreen;
  @JsonKey(defaultValue: false)
  final bool hasEmail;
  @JsonKey(defaultValue: false)
  final bool isPhoneVerifiedForCod;
  @JsonKey(defaultValue: null)
  final String? pathUri;
  @JsonKey(defaultValue: null)
  final String? otpReason;
  @JsonKey(defaultValue: null)
  final String? action;
  @JsonKey(defaultValue: null)
  final String? popUpMessage;
  @JsonKey(fromJson: _messageBarsFromJson)
  final List<MessageBarModel> messageBars;

  factory CheckMobileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckMobileResponseModelFromJson(ActionResponse.validate(json));
}

extension CheckMobileResponseModelX on CheckMobileResponseModel {
  CheckMobileResponseEntity toEntity() => CheckMobileResponseEntity(
        mobile: mobile?.toEntity(),
        showMobileScreen: showMobileScreen,
        hasEmail: hasEmail,
        isPhoneVerifiedForCod: isPhoneVerifiedForCod,
        pathUri: pathUri,
        otpReason: otpReason,
        action: action,
        popUpMessage: popUpMessage,
        messageBars: messageBars,
      );
}
