// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plp_sorting_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlpSortingOptionsModel _$PlpSortingOptionsModelFromJson(
  Map<String, dynamic> json,
) => PlpSortingOptionsModel(
  label: json['label'] == null ? 'Sort By' : _parseSortLabel(json['label']),
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => SortingOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);
