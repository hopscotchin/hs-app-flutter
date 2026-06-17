import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/query_correction_entity.dart';

part 'query_correction_model.g.dart';

/// Parses the `queryCorrection` block of the v8 listing response:
///
/// ```json
/// "queryCorrection": {
///   "resultsOf":  "shrit",
///   "searchFor":  "shirt",
///   "confidence": 0
/// }
/// ```
///
/// Confidence values (matches Android constants):
///   • 0  — LOW_CONFIDENCE
///   • 1  — HIGH_CONFIDENCE
///   • -1 — NO_RESULTS
@JsonSerializable(createToJson: false)
class QueryCorrectionModel {
  const QueryCorrectionModel({
    this.resultsOf,
    this.searchFor,
    this.confidence = -2,
  });

  final String? resultsOf;
  final String? searchFor;
  @JsonKey(defaultValue: -2)
  final int confidence;

  factory QueryCorrectionModel.fromJson(Map<String, dynamic> json) =>
      _$QueryCorrectionModelFromJson(json);
}

extension QueryCorrectionModelX on QueryCorrectionModel {
  QueryCorrectionEntity toEntity() => QueryCorrectionEntity(
    resultsOf: resultsOf,
    searchFor: searchFor,
    confidence: confidence,
  );
}
