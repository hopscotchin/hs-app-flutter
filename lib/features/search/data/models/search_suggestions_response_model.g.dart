// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSuggestionsResponseModel _$SearchSuggestionsResponseModelFromJson(
  Map<String, dynamic> json,
) => SearchSuggestionsResponseModel(
  suggestions:
      (json['suggestions'] as List<dynamic>?)
          ?.map(
            (e) => SearchSuggestionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);
