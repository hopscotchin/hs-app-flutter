import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_nudge_entity.freezed.dart';

@freezed
abstract class NudgeRuleEntity with _$NudgeRuleEntity {
  const factory NudgeRuleEntity({
    @Default(0) int dismissedFrequency,
    @Default(0) int showNudgeFrequency,
    @Default(0) int deniedFrequency,
    int? oneTimeTargetDate,
  }) = _NudgeRuleEntity;
}

@freezed
abstract class NotificationNudgeEntity with _$NotificationNudgeEntity {
  const factory NotificationNudgeEntity({
    String? title,
    String? titleImage,
    String? description,
    String? negativeButtonText,
    String? positiveButtonText,
    int? position,
    NudgeRuleEntity? rule,
  }) = _NotificationNudgeEntity;
}
