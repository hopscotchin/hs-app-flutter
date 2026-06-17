import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import 'filter_entity.dart';

part 'filter_section_entity.freezed.dart';

@freezed
abstract class FilterSectionEntity with _$FilterSectionEntity {
  const factory FilterSectionEntity({
    String? filterKey,
    String? label,
    @Default(false) bool isSelected,
    @Default(false) bool hasSelected,
    @Default(false) bool isMultiSelect,
    @Default(false) bool showSearch,
    String? searchBarLabel,
    int? appliedCount,
    String? uiType,
    @Default([]) List<FilterEntity> filterList,

    /// Optional API-driven badge for the row in the filter sidebar (e.g.
    /// "NEW" ribbon). Reuses the core VisualCueEntity; the same shape we
    /// use for product visual cues so badge rendering can share a widget.
    VisualCueEntity? visualCue,
  }) = _FilterSectionEntity;
}

extension FilterSectionEntityX on FilterSectionEntity {
  String? get deliveryPincode => filterList.isEmpty ? null : filterList.first.pincode;
}
