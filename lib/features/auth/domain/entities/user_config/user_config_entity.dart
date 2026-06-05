import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_config_entity.freezed.dart';

@freezed
abstract class UserConfigEntity with _$UserConfigEntity {
  const factory UserConfigEntity({
    @Default(false) bool continueBrowsingEligibleVisitor,
  }) = _UserConfigEntity;
}
