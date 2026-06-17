// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterSectionModel _$FilterSectionModelFromJson(Map<String, dynamic> json) =>
    FilterSectionModel(
      filterKey: json['filterKey'] as String?,
      label: json['label'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
      hasSelected: json['hasSelected'] as bool? ?? false,
      isMultiSelect: json['isMultiSelect'] as bool? ?? false,
      showSearch: json['showSearch'] as bool? ?? false,
      searchBarLabel: json['searchBarLabel'] as String?,
      appliedCount: (json['appliedCount'] as num?)?.toInt(),
      uiType: json['uiType'] as String?,
      filterList:
          (json['filterList'] as List<dynamic>?)
              ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      visualCue: json['visualCue'] == null
          ? null
          : VisualCueModel.fromJson(json['visualCue'] as Map<String, dynamic>),
    );
