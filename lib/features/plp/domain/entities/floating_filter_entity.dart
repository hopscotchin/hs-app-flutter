import 'package:freezed_annotation/freezed_annotation.dart';

part 'floating_filter_entity.freezed.dart';

@freezed
abstract class FloatingFilterChipEntity with _$FloatingFilterChipEntity {
  const factory FloatingFilterChipEntity({
    String? filterKey,
    String? filterValue,
    String? label,
    String? chipType,
    String? textColor,
    String? backgroundColor,
    String? imageUrl,
    @Default(false) bool isSelected,
  }) = _FloatingFilterChipEntity;
}

@freezed
abstract class FloatingFilterSectionEntity with _$FloatingFilterSectionEntity {
  const factory FloatingFilterSectionEntity({
    String? title,
    String? chipType,
    int? position,
    int? tileWidth,
    int? tileHeight,
    @Default(true) bool isMultiSelect,
    @Default([]) List<FloatingFilterChipEntity> chips,
  }) = _FloatingFilterSectionEntity;
}

@freezed
abstract class FloatingFilterEntity with _$FloatingFilterEntity {
  const factory FloatingFilterEntity({
    String? type,
    @Default([]) List<FloatingFilterSectionEntity> sections,
  }) = _FloatingFilterEntity;
}
