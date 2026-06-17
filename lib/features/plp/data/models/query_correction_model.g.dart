// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_correction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCorrectionModel _$QueryCorrectionModelFromJson(
  Map<String, dynamic> json,
) => QueryCorrectionModel(
  resultsOf: json['resultsOf'] as String?,
  searchFor: json['searchFor'] as String?,
  confidence: (json['confidence'] as num?)?.toInt() ?? -2,
);
