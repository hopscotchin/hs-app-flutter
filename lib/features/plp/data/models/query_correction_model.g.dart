// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_correction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCorrectionModel _$QueryCorrectionModelFromJson(
  Map<String, dynamic> json,
) => QueryCorrectionModel(
  resultsOf: parseToStringOrNull(json['resultsOf']),
  searchFor: parseToStringOrNull(json['searchFor']),
  confidence: json['confidence'] == null
      ? -2
      : _parseConfidence(json['confidence']),
);
