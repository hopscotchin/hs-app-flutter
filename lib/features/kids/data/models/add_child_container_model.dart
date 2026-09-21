import 'package:json_annotation/json_annotation.dart';

part 'add_child_container_model.g.dart';

/// The My Kids list screen's persistent "Add child" footer, sent directly on
/// the `GET v2/questionnaire/list` response. Replaces the old
/// `addChildLabel`/`addAnotherChildLabel`/`footerAvatars` fields — the
/// backend now pre-resolves a single [title] (it already knows from the
/// same response whether `children` is empty) and sends [leadingIcon]/
/// [trailingIcon] in place of the old two-avatar preview stack.
@JsonSerializable(createToJson: false)
class AddChildContainerModel {
  const AddChildContainerModel({
    this.title,
    this.subTitle,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String? title;
  final String? subTitle;
  final String? leadingIcon;
  final String? trailingIcon;

  factory AddChildContainerModel.fromJson(Map<String, dynamic> json) =>
      _$AddChildContainerModelFromJson(json);
}
