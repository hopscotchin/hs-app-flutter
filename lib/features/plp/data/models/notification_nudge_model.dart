import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notification_nudge_entity.dart';

part 'notification_nudge_model.g.dart';

@JsonSerializable(createToJson: false)
class NudgeRuleModel {
  const NudgeRuleModel({
    this.dismissedFrequency = 0,
    this.showNudgeFrequency = 0,
    this.deniedFrequency = 0,
    this.oneTimeTargetDate,
  });

  @JsonKey(defaultValue: 0) final int dismissedFrequency;
  @JsonKey(defaultValue: 0) final int showNudgeFrequency;
  @JsonKey(defaultValue: 0) final int deniedFrequency;
  final int? oneTimeTargetDate;

  factory NudgeRuleModel.fromJson(Map<String, dynamic> json) =>
      _$NudgeRuleModelFromJson(json);

  NudgeRuleEntity toEntity() => NudgeRuleEntity(
    dismissedFrequency: dismissedFrequency,
    showNudgeFrequency: showNudgeFrequency,
    deniedFrequency: deniedFrequency,
    oneTimeTargetDate: oneTimeTargetDate,
  );
}

@JsonSerializable(createToJson: false)
class NotificationNudgeModel {
  const NotificationNudgeModel({
    this.title,
    this.titleImage,
    this.description,
    this.negativeButtonText,
    this.positiveButtonText,
    this.position,
    this.rule,
  });

  final String? title;
  final String? titleImage;
  final String? description;
  final String? negativeButtonText;
  final String? positiveButtonText;
  final int? position;
  final NudgeRuleModel? rule;

  factory NotificationNudgeModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationNudgeModelFromJson(json);

  NotificationNudgeEntity toEntity() => NotificationNudgeEntity(
    title: title,
    titleImage: titleImage,
    description: description,
    negativeButtonText: negativeButtonText,
    positiveButtonText: positiveButtonText,
    position: position,
    rule: rule?.toEntity(),
  );
}
