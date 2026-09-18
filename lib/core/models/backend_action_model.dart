import '../entities/backend_action_entity.dart';
import '../utils/json_parsers.dart';

class BackendActionButtonModel extends BackendActionButtonEntity {
  const BackendActionButtonModel({
    super.label,
    super.actionUri,
    super.type,
    super.style,
    super.iconUrl,
  });

  /// Accepts `actionUri` for the destination.
  ///
  /// `type` is the identity for buttons that have no destination — a dialog's
  /// Continue, a fixed next step, or a behaviour whose target is app config.
  /// Values are [BackendActionType]. It is optional and defaults to `unknown`.
  factory BackendActionButtonModel.fromJson(Map<String, dynamic> json) {
    return BackendActionButtonModel(
      label: parseToStringOrNull(json['label']),
      actionUri: parseToStringOrNull(json['actionUri'] ?? json['action']),
      type: parseToStringOrNull(json['type']),
      style: parseToStringOrNull(json['style']),
      iconUrl: parseToStringOrNull(json['icon']),
    );
  }

  static BackendActionButtonModel? fromJsonOrNull(Map<String, dynamic>? json) {
    return json != null ? BackendActionButtonModel.fromJson(json) : null;
  }
}

class BackendActionContentModel extends BackendActionContentEntity {
  const BackendActionContentModel({
    super.title,
    super.description,
    super.text,
    super.bgColor,
    super.textColor,
    super.leftAction,
    super.rightAction,
  });

  factory BackendActionContentModel.fromJson(Map<String, dynamic> json) {
    final leftJson = json['leftAction'] as Map<String, dynamic>?;
    final rightJson = json['rightAction'] as Map<String, dynamic>?;
    return BackendActionContentModel(
      title: parseToStringOrNull(json['title']),
      description: parseToStringOrNull(json['description']),
      text: parseToStringOrNull(json['text']),
      bgColor: parseToStringOrNull(json['bgColor']),
      textColor: parseToStringOrNull(json['textColor']),
      leftAction: leftJson != null ? BackendActionButtonModel.fromJson(leftJson) : null,
      rightAction: rightJson != null ? BackendActionButtonModel.fromJson(rightJson) : null,
    );
  }
}

class BackendActionModel extends BackendActionEntity {
  const BackendActionModel({super.type, super.iconUrl, super.content});

  factory BackendActionModel.fromJson(Map<String, dynamic> json) {
    final contentJson = json['content'] as Map<String, dynamic>?;
    return BackendActionModel(
      type: parseToStringOrNull(json['type']),
      iconUrl: parseToStringOrNull(json['icon']),
      content: contentJson != null ? BackendActionContentModel.fromJson(contentJson) : null,
    );
  }

  static BackendActionModel? fromJsonOrNull(Map<String, dynamic>? json) {
    return json != null ? BackendActionModel.fromJson(json) : null;
  }
}
