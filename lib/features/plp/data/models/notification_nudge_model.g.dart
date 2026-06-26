// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_nudge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NudgeRuleModel _$NudgeRuleModelFromJson(Map<String, dynamic> json) =>
    NudgeRuleModel(
      dismissedFrequency: json['dismissedFrequency'] == null
          ? 0
          : parseToInt(json['dismissedFrequency']),
      showNudgeFrequency: json['showNudgeFrequency'] == null
          ? 0
          : parseToInt(json['showNudgeFrequency']),
      deniedFrequency: json['deniedFrequency'] == null
          ? 0
          : parseToInt(json['deniedFrequency']),
      oneTimeTargetDate: parseToIntOrNull(json['oneTimeTargetDate']),
    );

NotificationNudgeModel _$NotificationNudgeModelFromJson(
  Map<String, dynamic> json,
) => NotificationNudgeModel(
  title: parseToStringOrNull(json['title']),
  titleImage: parseToStringOrNull(json['titleImage']),
  description: parseToStringOrNull(json['description']),
  negativeButtonText: parseToStringOrNull(json['negativeButtonText']),
  positiveButtonText: parseToStringOrNull(json['positiveButtonText']),
  position: parseToIntOrNull(json['position']),
  rule: json['rule'] == null
      ? null
      : NudgeRuleModel.fromJson(json['rule'] as Map<String, dynamic>),
);
