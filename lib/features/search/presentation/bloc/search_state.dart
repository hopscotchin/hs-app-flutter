part of 'search_bloc.dart';

enum SearchStatus { idle, loading, loaded, error }

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default(SearchStatus.idle) SearchStatus status,
    @Default('') String query,
    @Default(<SearchSuggestionEntity>[]) List<SearchSuggestionEntity> suggestions,
    @Default(<String>[]) List<String> recentSearches,
    String? errorMessage,
  }) = _SearchState;
}
