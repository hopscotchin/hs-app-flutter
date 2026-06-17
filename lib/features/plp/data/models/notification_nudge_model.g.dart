// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_nudge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NudgeRuleModel _$NudgeRuleModelFromJson(Map<String, dynamic> json) =>
    NudgeRuleModel(
      dismissedFrequency: (json['dismissedFrequency'] as num?)?.toInt() ?? 0,
      showNudgeFrequency: (json['showNudgeFrequency'] as num?)?.toInt() ?? 0,
      deniedFrequency: (json['deniedFrequency'] as num?)?.toInt() ?? 0,
      oneTimeTargetDate: (json['oneTimeTargetDate'] as num?)?.toInt(),
    );

NotificationNudgeModel _$NotificationNudgeModelFromJson(
  Map<String, dynamic> json,
) => NotificationNudgeModel(
  title: json['title'] as String?,
  titleImage: json['titleImage'] as String?,
  description: json['description'] as String?,
  negativeButtonText: json['negativeButtonText'] as String?,
  positiveButtonText: json['positiveButtonText'] as String?,
  position: (json['position'] as num?)?.toInt(),
  rule: json['rule'] == null
      ? null
      : NudgeRuleModel.fromJson(json['rule'] as Map<String, dynamic>),
);
