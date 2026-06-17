import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/search_suggestion_entity.dart';

part 'search_suggestion_model.g.dart';

@JsonSerializable(createToJson: false)
class SearchSuggestionModel {
  const SearchSuggestionModel({
    this.id,
    this.type,
    this.term,
    this.displayName,
    this.actionURI,
    this.searchParams,
    this.trackingData,
  });

  final String? id;
  final String? type;
  final String? term;
  final String? displayName;
  final String? actionURI;

  @JsonKey(name: 'search_params')
  final String? searchParams;

  /// Server-driven map of analytics keys/values. Schema is owned by the
  /// backend; we treat it as an opaque payload to forward to segment.
  final Map<String, dynamic>? trackingData;

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionModelFromJson(json);
}

extension SearchSuggestionModelX on SearchSuggestionModel {
  SearchSuggestionEntity toEntity() => SearchSuggestionEntity(
        id: id,
        type: type,
        term: term,
        displayName: displayName,
        actionUri: actionURI,
        searchParams: searchParams,
        trackingData: trackingData,
      );
}
