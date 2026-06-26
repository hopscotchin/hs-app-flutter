// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedFilterModel _$SelectedFilterModelFromJson(Map<String, dynamic> json) =>
    SelectedFilterModel(
      filterKey: parseToStringOrNull(json['filterKey']),
      filterValue: parseToStringOrNull(json['filterValue']),
      selectedFilterName: parseToStringOrNull(json['selectedFilterName']),
      showOnUi: json['showOnUi'] == null
          ? true
          : _parseShowOnUi(json['showOnUi']),
    );
