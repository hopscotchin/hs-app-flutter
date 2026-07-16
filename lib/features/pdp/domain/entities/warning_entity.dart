import 'package:freezed_annotation/freezed_annotation.dart';

part 'warning_entity.freezed.dart';

@freezed
abstract class WarningEntity with _$WarningEntity {
  const factory WarningEntity({String? text, String? textColor}) = _WarningEntity;
}
