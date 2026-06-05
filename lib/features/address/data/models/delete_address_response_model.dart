import 'package:json_annotation/json_annotation.dart';

part 'delete_address_response_model.g.dart';

@JsonSerializable(createToJson: false)
class DeleteAddressResponseModel {
  const DeleteAddressResponseModel({this.popUpMessage = ''});

  @JsonKey(defaultValue: '')
  final String popUpMessage;

  factory DeleteAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteAddressResponseModelFromJson(json);
}
