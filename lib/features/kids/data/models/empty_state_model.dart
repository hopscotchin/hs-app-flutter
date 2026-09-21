import 'package:json_annotation/json_annotation.dart';

part 'empty_state_model.g.dart';

/// The My Kids list screen's empty state, sent directly on the
/// `GET v2/questionnaire/list` response (a sibling of `children`, no longer
/// nested under a `content` wrapper).
@JsonSerializable(createToJson: false)
class EmptyStateModel {
  const EmptyStateModel({this.icon, this.title, this.subTitle});

  final String? icon;
  final String? title;
  final String? subTitle;

  factory EmptyStateModel.fromJson(Map<String, dynamic> json) =>
      _$EmptyStateModelFromJson(json);
}
