import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/network/models/action_response.dart';

part 'login_ticket_response_model.g.dart';

@JsonSerializable(createToJson: false)
class LoginTicketResponseModel {
  const LoginTicketResponseModel({this.action, this.loginTicket = ''});

  final String? action;

  @JsonKey(name: 'loginTicket', defaultValue: '')
  final String loginTicket;

  factory LoginTicketResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginTicketResponseModelFromJson(ActionResponse.validate(json));
}