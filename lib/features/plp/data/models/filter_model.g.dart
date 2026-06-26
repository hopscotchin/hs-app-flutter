// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => FilterModel(
  filterKey: parseToStringOrNull(json['filterKey']),
  filterValue: parseToStringOrNull(json['filterValue']),
  count: parseToIntOrNull(json['productCount']),
  label: parseToStringOrNull(json['label']),
  isSelected: json['isSelected'] == null
      ? false
      : parseToBool(json['isSelected']),
  isMultiSelect: json['isMultiSelect'] == null
      ? false
      : parseToBool(json['isMultiSelect']),
  type: parseToStringOrNull(json['type']),
  filters:
      (json['filters'] as List<dynamic>?)
          ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  colorHex: parseToStringOrNull(json['colorHex']),
  ovalImgUrl: parseToStringOrNull(json['ovalImgUrl']),
  isSection: json['isSection'] == null ? false : parseToBool(json['isSection']),
  pincode: parseToStringOrNull(json['pincode']),
  visualCue: json['visualCue'] as Map<String, dynamic>?,
);
