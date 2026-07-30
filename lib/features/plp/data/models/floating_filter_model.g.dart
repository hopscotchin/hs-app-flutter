// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloatingFilterChipModel _$FloatingFilterChipModelFromJson(
  Map<String, dynamic> json,
) => FloatingFilterChipModel(
  filterKey: parseToStringOrNull(json['filterKey']),
  filterValue: parseToStringOrNull(json['filterValue']),
  label: parseToStringOrNull(json['label']),
  chipType: parseToStringOrNull(json['chipType']),
  textColor: parseToStringOrNull(json['textColor']),
  backgroundColor: parseToStringOrNull(json['bgColor']),
  imageUrl: parseToStringOrNull(json['imageUrl']),
  isSelected: json['isSelected'] == null
      ? false
      : parseToBool(json['isSelected']),
);

FloatingFilterSectionModel _$FloatingFilterSectionModelFromJson(
  Map<String, dynamic> json,
) => FloatingFilterSectionModel(
  title: parseToStringOrNull(json['title']),
  chipType: parseToStringOrNull(json['chipType']),
  position: parseToIntOrNull(json['position']),
  tileWidth: parseToIntOrNull(json['tileWidth']),
  tileHeight: parseToIntOrNull(json['tileHeight']),
  isMultiSelect: json['isMultiSelect'] == null
      ? true
      : parseToBool(json['isMultiSelect']),
  chips:
      (json['chips'] as List<dynamic>?)
          ?.map(
            (e) => FloatingFilterChipModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

FloatingFilterModel _$FloatingFilterModelFromJson(Map<String, dynamic> json) =>
    FloatingFilterModel(
      type: parseToStringOrNull(json['type']),
      sections:
          (json['sections'] as List<dynamic>?)
              ?.map(
                (e) => FloatingFilterSectionModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
