// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterModel _$FilterModelFromJson(Map<String, dynamic> json) => FilterModel(
  filterKey: json['filterKey'] as String?,
  filterValue: json['filterValue'] as String?,
  count: (json['productCount'] as num?)?.toInt(),
  label: json['label'] as String?,
  isSelected: json['isSelected'] as bool? ?? false,
  isMultiSelect: json['isMultiSelect'] as bool? ?? false,
  type: json['type'] as String?,
  filters:
      (json['filters'] as List<dynamic>?)
          ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  colorHex: json['colorHex'] as String?,
  ovalImgUrl: json['ovalImgUrl'] as String?,
  isSection: json['isSection'] as bool? ?? false,
  pincode: json['pincode'] as String?,
  visualCue: json['visualCue'] as Map<String, dynamic>?,
);
