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
}
