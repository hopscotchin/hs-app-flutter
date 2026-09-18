import 'package:json_annotation/json_annotation.dart';

import 'child_model.dart';

part 'child_mutation_response_model.g.dart';

/// `POST v3/questionnaire/save-and-update` response — the saved child's own
/// fields sit nested under a singular `child` key alongside the envelope
/// (`action`/`message`). A validation failure (e.g. missing consent on
/// create) additionally carries `errorType` (e.g. `"CONSENT_REQUIRED"`)
/// alongside a human [message] already suitable to show verbatim.
@JsonSerializable(createToJson: false)
class ChildMutationResponseModel {
  const ChildMutationResponseModel({this.action, this.message, this.child, this.errorType});

  final String? action;
  final String? message;
  final ChildModel? child;
  final String? errorType;

  factory ChildMutationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChildMutationResponseModelFromJson(json);
}

extension ChildMutationResponseModelX on ChildMutationResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';
}
