// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterSectionModel _$FilterSectionModelFromJson(Map<String, dynamic> json) =>
    FilterSectionModel(
      filterKey: parseToStringOrNull(json['filterKey']),
      label: parseToStringOrNull(json['label']),
      isSelected: json['isSelected'] == null
          ? false
          : parseToBool(json['isSelected']),
      hasSelected: json['hasSelected'] == null
          ? false
          : parseToBool(json['hasSelected']),
      isMultiSelect: json['isMultiSelect'] == null
          ? false
          : parseToBool(json['isMultiSelect']),
      showSearch: json['showSearch'] == null
          ? false
          : parseToBool(json['showSearch']),
      searchBarLabel: parseToStringOrNull(json['searchBarLabel']),
      appliedCount: parseToIntOrNull(json['appliedCount']),
      uiType: parseToStringOrNull(json['uiType']),
      filterList:
          (json['filterList'] as List<dynamic>?)
              ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      visualCue: json['visualCue'] == null
          ? null
          : VisualCueModel.fromJson(json['visualCue'] as Map<String, dynamic>),
    );
