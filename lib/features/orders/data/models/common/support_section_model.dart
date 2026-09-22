import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/backend_action_model.dart';
import '../../../../../core/utils/json_parsers.dart';
import '../../../domain/entities/common/support_section_entity.dart';

part 'support_section_model.g.dart';

/// `support` — the "Need help with your order?" footer. Orders tab only.
///
/// The buttons are [BackendActionButtonModel]s. They send `{label, type, icon,
/// style}` and omit `actionUri`, because `CALL_US` and `HELP_CENTER` name
/// behaviours rather than destinations — see [BackendActionType].
@JsonSerializable(createToJson: false)
class SupportSectionModel {
  const SupportSectionModel({this.title, this.ctaActions = const []});

  @JsonKey(fromJson: parseToStringOrNull)
  final String? title;

  /// Hand-parsed rather than generated: [BackendActionButtonModel] has a
  /// hand-written `fromJson` so it can accept either `actionUri` or the older
  /// `action`, and json_serializable cannot call that for a nested list.
  @JsonKey(fromJson: _actionsFromJson)
  final List<BackendActionButtonModel> ctaActions;

  factory SupportSectionModel.fromJson(Map<String, dynamic> json) =>
      _$SupportSectionModelFromJson(json);
}

List<BackendActionButtonModel> _actionsFromJson(Object? json) => json is List
    ? json
          .whereType<Map<String, dynamic>>()
          .map(BackendActionButtonModel.fromJson)
          .toList(growable: false)
    : const [];

extension SupportSectionModelX on SupportSectionModel {
  SupportSectionEntity toEntity() =>
      SupportSectionEntity(title: title, ctaActions: ctaActions);
}
