import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';

part 'filter_entity.freezed.dart';

@freezed
abstract class FilterEntity with _$FilterEntity {
  const factory FilterEntity({
    String? filterKey,
    String? filterValue,
    int? count,
    String? label,
    @Default(false) bool isSelected,
    @Default(false) bool isMultiSelect,
    String? type,
    @Default([]) List<FilterEntity> filters,
    String? colorHex,
    String? ovalImgUrl,
    @Default(false) bool isSection,
    String? pincode,
    VisualCueEntity? visualCue,
  }) = _FilterEntity;
}
