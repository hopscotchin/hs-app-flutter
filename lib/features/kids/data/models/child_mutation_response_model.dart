import 'package:json_annotation/json_annotation.dart';

import 'child_model.dart';

part 'child_mutation_response_model.g.dart';

/// `POST v3/questionnaire/save-and-update` response — the saved child's own
/// fields sit nested under a singular `child` key alongside the envelope
/// (`action`/`message`).
@JsonSerializable(createToJson: false)
class ChildMutationResponseModel {
  const ChildMutationResponseModel({this.action, this.message, this.child});

  final String? action;
  final String? message;
  final ChildModel? child;

  factory ChildMutationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChildMutationResponseModelFromJson(json);
}

extension ChildMutationResponseModelX on ChildMutationResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';
}
