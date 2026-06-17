import 'package:freezed_annotation/freezed_annotation.dart';

part 'sorting_option_entity.freezed.dart';

@freezed
abstract class SortingOptionEntity with _$SortingOptionEntity {
  const factory SortingOptionEntity({
    String? label,
    @Default(0) int orderRule,
    @Default(false) bool isSelected,
  }) = _SortingOptionEntity;
}
