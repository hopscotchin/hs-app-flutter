// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickFilterModel _$QuickFilterModelFromJson(Map<String, dynamic> json) =>
    QuickFilterModel(
      filterKey: parseToStringOrNull(json['filterKey']),
      label: parseToStringOrNull(json['label']),
      isApplied: json['isApplied'] == null
          ? false
          : parseToBool(json['isApplied']),
      trackingMeta: json['trackingMeta'] as Map<String, dynamic>? ?? {},
    );
