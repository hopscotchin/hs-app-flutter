import '../entities/backend_action_entity.dart';
import '../utils/json_parsers.dart';

class BackendActionButtonModel extends BackendActionButtonEntity {
  const BackendActionButtonModel({
    super.label,
    super.actionUrl,
    super.style,
  });

  factory BackendActionButtonModel.fromJson(Map<String, dynamic> json) {
    return BackendActionButtonModel(
      label: parseToStringOrNull(json['label']),
      actionUrl: parseToStringOrNull(json['action']),
      style: parseToStringOrNull(json['style']),
    );
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
      leftAction: leftJson != null
          ? BackendActionButtonModel.fromJson(leftJson)
          : null,
      rightAction: rightJson != null
          ? BackendActionButtonModel.fromJson(rightJson)
          : null,
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
      content: contentJson != null
          ? BackendActionContentModel.fromJson(contentJson)
          : null,
    );
  }

  static BackendActionModel? fromJsonOrNull(Map<String, dynamic>? json) {
    return json != null ? BackendActionModel.fromJson(json) : null;
  }
}
