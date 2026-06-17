import 'package:json_annotation/json_annotation.dart';

import 'search_suggestion_model.dart';

part 'search_suggestions_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SearchSuggestionsResponseModel {
  const SearchSuggestionsResponseModel({this.suggestions = const []});

  @JsonKey(defaultValue: [])
  final List<SearchSuggestionModel> suggestions;

  factory SearchSuggestionsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionsResponseModelFromJson(json);
}
