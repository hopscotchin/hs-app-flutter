part of 'search_bloc.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  /// Fired on every keystroke. The bloc debounces this internally.
  const factory SearchEvent.queryChanged(String query) = QueryChanged;

  /// Fired by the debounce timer once the user stops typing for 300ms.
  /// Underscore-prefixed because only the bloc itself dispatches it.
  const factory SearchEvent.fetchSuggestions(String query) = _FetchSuggestions;

  /// Clears the input, suggestions, and any error.
  const factory SearchEvent.clearQuery() = ClearQuery;

  /// Loads recent searches from local storage. Dispatched once on page entry.
  const factory SearchEvent.loadRecentSearches() = LoadRecentSearches;

  /// Persists [term] as the most-recent search — fired right before
  /// navigating away on a committed search (suggestion tap, submit, or a
  /// recent-search item re-tapped).
  const factory SearchEvent.recordRecentSearch(String term) = RecordRecentSearch;

  /// Removes a single term from recent searches.
  const factory SearchEvent.removeRecentSearch(String term) = RemoveRecentSearch;

  /// Clears all recent searches ("Clear All").
  const factory SearchEvent.clearRecentSearches() = ClearRecentSearches;
}
