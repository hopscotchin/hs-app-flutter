import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_info_entity.freezed.dart';

@freezed
abstract class MobileInfoEntity with _$MobileInfoEntity {
  const factory MobileInfoEntity({
    @Default('') String number,
    @Default(false) bool isVerified,
  }) = _MobileInfoEntity;
}
