import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/network/models/action_response.dart';

part 'logout_model.g.dart';

@JsonSerializable(createToJson: false)
class LogoutModel {
  const LogoutModel({this.action, this.message});

  final String? action;
  final String? message;

  /// [ActionResponse.validate] throws [ApiFailureException] when
  /// action != "success", which [SafeApiCall] maps to Left(ApiFailure).
  factory LogoutModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutModelFromJson(ActionResponse.validate(json));
}
