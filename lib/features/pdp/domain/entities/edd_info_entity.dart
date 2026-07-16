import 'package:freezed_annotation/freezed_annotation.dart';

part 'edd_info_entity.freezed.dart';

@freezed
abstract class EddInfoEntity with _$EddInfoEntity {
  const factory EddInfoEntity({
    String? destination,
    String? edd,
    String? orderSla,
  }) = _EddInfoEntity;
}
