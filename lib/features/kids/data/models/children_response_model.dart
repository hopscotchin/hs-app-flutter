import 'package:json_annotation/json_annotation.dart';

import 'child_model.dart';
import 'kids_list_content_model.dart';

part 'children_response_model.g.dart';

/// `GET v2/questionnaire/list` response. The live envelope wraps the array
/// under a `children` key, alongside a sibling `content` object carrying the
/// My Kids list screen's backend-driven copy + footer avatar images.
@JsonSerializable(createToJson: false)
class ChildrenResponseModel {
  const ChildrenResponseModel({
    this.action,
    this.message,
    this.children = const [],
    this.content,
  });

  final String? action;
  final String? message;
  @JsonKey(defaultValue: []) final List<ChildModel> children;
  final KidsListContentModel? content;

  factory ChildrenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChildrenResponseModelFromJson(json);
}

extension ChildrenResponseModelX on ChildrenResponseModel {
  bool get isSuccess => action?.toLowerCase() == 'success';
}
