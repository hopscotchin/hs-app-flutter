import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/visual_cue_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/filter_section_entity.dart';
import 'filter_model.dart';

part 'filter_section_model.g.dart';

@JsonSerializable(createToJson: false)
class FilterSectionModel {
  const FilterSectionModel({
    this.filterKey,
    this.label,
    this.isSelected = false,
    this.hasSelected = false,
    this.isMultiSelect = false,
    this.showSearch = false,
    this.searchBarLabel,
    this.appliedCount,
    this.uiType,
    this.filterList = const [],
    this.visualCue,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? filterKey;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? label;
  @JsonKey(fromJson: parseToBool)
  final bool isSelected;
  @JsonKey(fromJson: parseToBool)
  final bool hasSelected;
  @JsonKey(fromJson: parseToBool)
  final bool isMultiSelect;
  @JsonKey(fromJson: parseToBool)
  final bool showSearch;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? searchBarLabel;
  @JsonKey(fromJson: parseToIntOrNull)
  final int? appliedCount;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? uiType;
  @JsonKey(defaultValue: [])
  final List<FilterModel> filterList;

  /// Optional API-driven badge (e.g. "NEW" ribbon) rendered on the section
  /// row in the filter sidebar. Null when the API doesn't supply one.
  final VisualCueModel? visualCue;

  factory FilterSectionModel.fromJson(Map<String, dynamic> json) =>
      _$FilterSectionModelFromJson(json);

  FilterSectionEntity toEntity() => FilterSectionEntity(
    filterKey: filterKey,
    label: label,
    isSelected: isSelected,
    hasSelected: hasSelected,
    isMultiSelect: isMultiSelect,
    showSearch: showSearch,
    searchBarLabel: searchBarLabel,
    appliedCount: appliedCount,
    uiType: uiType,
    filterList: filterList.map((f) => f.toEntity()).toList(),
    visualCue: visualCue,
  );
}
