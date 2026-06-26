import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/query_correction_entity.dart';

part 'query_correction_model.g.dart';

int _parseConfidence(dynamic value) => parseToIntOrNull(value) ?? -2;

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

  @JsonKey(fromJson: parseToStringOrNull)
  final String? resultsOf;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? searchFor;
  @JsonKey(fromJson: _parseConfidence)
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
