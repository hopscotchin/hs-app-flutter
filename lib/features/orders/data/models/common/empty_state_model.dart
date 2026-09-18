import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/models/backend_action_model.dart';
import '../../../../../core/utils/json_parsers.dart';
import '../../../domain/entities/common/empty_state_entity.dart';

part 'empty_state_model.g.dart';

/// `emptyState` — sent only when `records` is empty.
///
/// The `ctaAction` is a [BackendActionButtonModel]. It needs no extension here:
/// the empty-state button carries no icon, unlike the support footer's.
///
/// Named `ctaAction`, not `action`, because `action` is taken twice over — the
/// envelope's success/failure status at the root of every response, and
/// [BackendActionModel]'s `{type, icon, content}` tooltip spec. One word for a
/// button as well would be three meanings.
@JsonSerializable(createToJson: false)
class EmptyStateModel {
  const EmptyStateModel({this.title, this.ctaAction});

  /// One string carrying both lines, split on `\n` at render time.
  @JsonKey(fromJson: parseToStringOrNull)
  final String? title;

  @JsonKey(fromJson: _ctaActionFromJson)
  final BackendActionButtonModel? ctaAction;

  factory EmptyStateModel.fromJson(Map<String, dynamic> json) =>
      _$EmptyStateModelFromJson(json);
}

/// Guards against `ctaAction` arriving as something other than an object — a
/// bare string or `false` would otherwise throw during a cast, taking the whole
/// listing down over a button.
BackendActionButtonModel? _ctaActionFromJson(Object? json) =>
    json is Map<String, dynamic>
    ? BackendActionButtonModel.fromJson(json)
    : null;

extension EmptyStateModelX on EmptyStateModel {
  EmptyStateEntity toEntity() => EmptyStateEntity(title: title, ctaAction: ctaAction);
}
