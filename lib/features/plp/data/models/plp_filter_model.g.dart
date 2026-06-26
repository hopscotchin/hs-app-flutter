// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plp_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlpFilterModel _$PlpFilterModelFromJson(
  Map<String, dynamic> json,
) => PlpFilterModel(
  quickFilters:
      (json['quickFilters'] as List<dynamic>?)
          ?.map((e) => QuickFilterModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  sortingOptions: json['sortingOptions'] == null
      ? null
      : PlpSortingOptionsModel.fromJson(
          json['sortingOptions'] as Map<String, dynamic>,
        ),
  filterSections:
      (json['filterSections'] as List<dynamic>?)
          ?.map((e) => FilterSectionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  selectedFilters:
      (json['selectedFilters'] as List<dynamic>?)
          ?.map((e) => SelectedFilterModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  action: parseToStringOrNull(json['action']),
  message: parseToStringOrNull(json['message']),
);
