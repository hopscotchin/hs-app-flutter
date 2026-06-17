// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloatingFilterChipModel _$FloatingFilterChipModelFromJson(
  Map<String, dynamic> json,
) => FloatingFilterChipModel(
  filterKey: json['filterKey'] as String?,
  filterValue: json['filterValue'] as String?,
  label: json['label'] as String?,
  chipType: json['chipType'] as String?,
  textColor: json['textColor'] as String?,
  backgroundColor: json['bgColor'] as String?,
  imageUrl: json['imageUrl'] as String?,
  isSelected: json['isSelected'] as bool? ?? false,
);

FloatingFilterSectionModel _$FloatingFilterSectionModelFromJson(
  Map<String, dynamic> json,
) => FloatingFilterSectionModel(
  title: json['title'] as String?,
  chipType: json['chipType'] as String?,
  position: (json['position'] as num?)?.toInt(),
  tileWidth: (json['tileWidth'] as num?)?.toInt(),
  tileHeight: (json['tileHeight'] as num?)?.toInt(),
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
      type: json['type'] as String?,
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
