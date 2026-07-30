import 'package:json_annotation/json_annotation.dart';

part 'action_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ActionResponseModel {
  const ActionResponseModel({this.action, this.message});

  @JsonKey(defaultValue: null)
  final String? action;
  @JsonKey(defaultValue: null)
  final String? message;

  factory ActionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ActionResponseModelFromJson(json);
}
