import 'package:freezed_annotation/freezed_annotation.dart';

part 'query_correction_entity.freezed.dart';

/// The PLP "Showing results for / Did you mean" data block.
///
/// Driven by the API's `queryCorrection` field on the listing response.
/// Absent → no widget shown. Present → render a two-line banner above
/// the product grid:
///
///   Line 1 (`resultsOf`) — "Showing results for {resultsOf}"
///   Line 2 (`searchFor`) — branches on [confidence]:
///     • 0  (LOW)  → "Did you mean {searchFor}"  (clickable, re-fires
///                    the PLP search with the corrected term).
///     • 1  (HIGH) → "No results for {searchFor}" (server-side fallback
///                    already shown; no click).
///     • -1 (NONE) → "No results for {searchFor}" (no results at all).
///
/// Matches the Android `QueryCorrection` shape exactly.
@freezed
abstract class QueryCorrectionEntity with _$QueryCorrectionEntity {
  const factory QueryCorrectionEntity({
    String? resultsOf,
    String? searchFor,
    @Default(-2) int confidence,
  }) = _QueryCorrectionEntity;
}

extension QueryCorrectionConfidence on QueryCorrectionEntity {
  /// Low confidence → "Did you mean {searchFor}" (clickable re-search).
  bool get isLowConfidence => confidence == 0;

  /// High confidence → server already substituted; surface as
  /// "No results for {searchFor}" with no click.
  bool get isHighConfidence => confidence == 1;

  /// No results → "No results for {searchFor}".
  bool get isNoResults => confidence == -1;

  /// Show the widget at all? Only when we have at least one piece of
  /// usable text. Absent / empty payloads collapse to false.
  bool get isRenderable =>
      (resultsOf?.isNotEmpty ?? false) || (searchFor?.isNotEmpty ?? false);
}
