import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/search_suggestion_entity.dart';

part 'search_suggestion_model.g.dart';

@JsonSerializable(createToJson: false)
class SearchSuggestionModel {
  const SearchSuggestionModel({
    this.term,
    this.displayName,
    this.actionUri,
    this.actionUriWeb,
    this.searchParams,
    this.trackingMeta,
  });

  final String? term;
  final String? displayName;
  final String? actionUri;
  final String? actionUriWeb;

  @JsonKey(name: 'search_params')
  final String? searchParams;

  /// Server-driven map of analytics keys/values (`id`/`type`/`section`).
  /// Schema is owned by the backend; we treat it as an opaque payload to
  /// forward to segment.
  final Map<String, dynamic>? trackingMeta;

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionModelFromJson(json);
}

extension SearchSuggestionModelX on SearchSuggestionModel {
  SearchSuggestionEntity toEntity() => SearchSuggestionEntity(
        term: term,
        displayName: displayName,
        actionUri: actionUri,
        actionUriWeb: actionUriWeb,
        searchParams: searchParams,
        trackingMeta: trackingMeta,
      );
}
