import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/search_suggestion_entity.dart';
import '../../domain/usecases/get_search_suggestions_usecase.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends BaseBloc<SearchEvent, SearchState> {
  final GetSearchSuggestionsUseCase _getSuggestions;

  static const int _minQueryLength = 3;
  static const Duration _debounce = Duration(milliseconds: 300);

  Timer? _debounceTimer;

  SearchBloc(this._getSuggestions) : super(const SearchState()) {
    on<QueryChanged>(_onQueryChanged);
    on<_FetchSuggestions>(_onFetchSuggestions);
    on<ClearQuery>(_onClearQuery);
  }

  /// User typed in the search box. We update the query immediately so the
  /// input stays responsive, then debounce the network call.
  ///
  /// Mirrors Android's `SearchAutocompleteActivity.setupAutocompleteView()`:
  ///   - filter: length >= 3
  ///   - debounce: 300ms
  ///   - distinct: skipped if same as last query (handled by status checks)
  void _onQueryChanged(QueryChanged event, Emitter<SearchState> emit) {
    final trimmed = event.query.trim();
    emit(state.copyWith(query: event.query));

    _debounceTimer?.cancel();

    if (trimmed.length < _minQueryLength) {
      emit(state.copyWith(
        status: SearchStatus.idle,
        suggestions: const [],
        errorMessage: null,
      ));
      return;
    }

    _debounceTimer = Timer(_debounce, () {
      add(_FetchSuggestions(trimmed));
    });
  }

  Future<void> _onFetchSuggestions(
    _FetchSuggestions event,
    Emitter<SearchState> emit,
  ) async {
    final current = state;
    emit(current.copyWith(status: SearchStatus.loading, errorMessage: null));

    final token = swapCancelToken();
    final result = await _getSuggestions(
      GetSearchSuggestionsParams(query: event.query, cancelToken: token),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(current.copyWith(
          status: SearchStatus.error,
          errorMessage: failure.message,
        ));
      },
      (suggestions) => emit(current.copyWith(
        status: SearchStatus.loaded,
        suggestions: suggestions,
      )),
    );
  }

  void _onClearQuery(ClearQuery event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
