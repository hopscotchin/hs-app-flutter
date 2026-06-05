import 'package:json_annotation/json_annotation.dart';

import '../../../../core/network/models/action_response.dart';

part 'register_device_model.g.dart';

@JsonSerializable(createToJson: false)
class RegisterDeviceModel {
  const RegisterDeviceModel({this.action, this.message});

  final String? action;
  final String? message;

  factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceModelFromJson(ActionResponse.validate(json));
}
