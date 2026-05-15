// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_component_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageComponentModel _$PageComponentModelFromJson(Map<String, dynamic> json) =>
    PageComponentModel(
      type: json['type'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      rawData: _rawDataFromJson(json['data']),
    );
