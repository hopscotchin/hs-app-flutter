import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/message_bar_entity.dart';

part 'pincode_check_result_entity.freezed.dart';

@freezed
abstract class PincodeCheckResultEntity with _$PincodeCheckResultEntity {
  const factory PincodeCheckResultEntity({
    @Default(false) bool isSuccessful,
    @Default('') String popUpMessage,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
  }) = _PincodeCheckResultEntity;
}