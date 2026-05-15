import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/usecases/get_filter_data_usecase.dart';

part 'filter_event.dart';
part 'filter_state.dart';

@injectable
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final GetFilterDataUseCase getFilterDataUseCase;

  CancelToken? _cancelToken;

  /// Snapshot of filters at last successful API refresh, used to decide
  /// whether a section switch needs a refresh (matching Android's logic).
  Map<String, String> _lastRefreshedFilters = {};

  FilterBloc({required this.getFilterDataUseCase})
    : super(const FilterState()) {
    on<InitializeFilter>(_onInitialize);
    on<ToggleFilterItem>(_onToggleFilterItem);
    on<SelectTreeItem>(_onSelectTreeItem);
    on<SwitchSection>(_onSwitchSection);
    on<ClearAllPendingFilters>(_onClearAll);
    on<NavigateTreeBack>(_onNavigateTreeBack);
  }

  void _onInitialize(InitializeFilter event, Emitter<FilterState> emit) {
    final parsed = _parseAppliedFilters(event.appliedFilters);
    _lastRefreshedFilters = event.appliedFilters;

    emit(
      FilterState(
        plpFilter: event.plpFilter,
        pendingFilters: parsed,
        baseQueryParams: event.baseQueryParams,
      ),
    );
  }

  void _onToggleFilterItem(ToggleFilterItem event, Emitter<FilterState> emit) {
    final updated = Map<String, Set<String>>.from(
      state.pendingFilters.map((k, v) => MapEntry(k, Set<String>.from(v))),
    );

    final current = updated[event.param] ?? <String>{};
    if (current.contains(event.value)) {
      current.remove(event.value);
    } else {
      if (!event.isMultiSelect) current.clear();
      current.add(event.value);
    }
    updated[event.param] = Set.from(current);

    emit(state.copyWith(pendingFilters: updated, clearError: true));
  }

  Future<void> _onSelectTreeItem(
    SelectTreeItem event,
    Emitter<FilterState> emit,
  ) async {
    // Clear child-level selections when a parent is selected
    final section = state.currentSection;
    if (section == null) return;

    final treeParams = _extractTreeParams(section);
    final updated = Map<String, String>.from(state.treeSelections);

    // Clear all levels at and below this level
    for (var i = event.level; i < treeParams.length; i++) {
      updated.remove(treeParams[i]);
    }
    // Set the new selection
    updated[event.param] = event.value;

    final nextLevel = (event.level + 1).clamp(0, treeParams.length - 1);
    final shouldDrillDown = event.level < treeParams.length - 1;

    emit(
      state.copyWith(
        treeSelections: updated,
        treeExpandedLevel: shouldDrillDown ? nextLevel : event.level,
        clearError: true,
      ),
    );

    // Refresh filter data from API
    await _refreshFilter(emit);
  }

  Future<void> _onSwitchSection(
    SwitchSection event,
    Emitter<FilterState> emit,
  ) async {
    final currentFlat = state.flattenFilters();
    final needsRefresh = !mapEquals(currentFlat, _lastRefreshedFilters);

    if (needsRefresh) {
      // Refresh first, then switch
      await _refreshFilter(emit);
    }

    emit(
      state.copyWith(
        selectedSectionIndex: event.sectionIndex,
        treeExpandedLevel: 0,
        clearError: true,
      ),
    );
  }

  Future<void> _onClearAll(
    ClearAllPendingFilters event,
    Emitter<FilterState> emit,
  ) async {
    emit(
      state.copyWith(
        pendingFilters: const {},
        treeSelections: const {},
        treeExpandedLevel: 0,
        clearError: true,
      ),
    );

    await _refreshFilter(emit);
  }

  void _onNavigateTreeBack(NavigateTreeBack event, Emitter<FilterState> emit) {
    if (state.treeExpandedLevel <= 0) return;

    final section = state.currentSection;
    if (section == null) return;

    final treeParams = _extractTreeParams(section);
    final newLevel = state.treeExpandedLevel - 1;

    // Clear the current level's selection
    final updated = Map<String, String>.from(state.treeSelections);
    for (var i = state.treeExpandedLevel; i < treeParams.length; i++) {
      updated.remove(treeParams[i]);
    }

    emit(state.copyWith(treeExpandedLevel: newLevel, treeSelections: updated));
  }

  Future<void> _refreshFilter(Emitter<FilterState> emit) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    emit(state.copyWith(isRefreshing: true));

    final queryParams = <String, dynamic>{};
    queryParams.addAll(state.baseQueryParams);
    queryParams.addAll(state.flattenFilters());

    final result = await getFilterDataUseCase(
      GetFilterDataParams(queryParams: queryParams, cancelToken: _cancelToken),
    );

    result.fold(
      (failure) {
        if (failure.message == 'Request cancelled') return;
        emit(
          state.copyWith(isRefreshing: false, errorMessage: failure.message),
        );
      },
      (filterData) {
        _lastRefreshedFilters = state.flattenFilters();
        emit(
          state.copyWith(
            plpFilter: filterData,
            isRefreshing: false,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Extract tree param names at each level from the section's filter hierarchy.
  List<String> _extractTreeParams(FilterSectionEntity section) {
    final params = <String>[];
    if (section.filterList.isEmpty) return params;

    // Level 0: the wrapper filterList items contain the top-level filter entries
    final wrapper = section.filterList.first;
    if (wrapper.filter.isEmpty) return params;

    // First item at each depth gives us the param name for that level
    final level0 = wrapper.filter.first;
    params.add(level0.param ?? '');

    if (level0.filter.isNotEmpty) {
      final level1 = level0.filter.first;
      params.add(level1.param ?? '');

      if (level1.filter.isNotEmpty) {
        final level2 = level1.filter.first;
        params.add(level2.param ?? '');
      }
    }

    return params;
  }

  Map<String, Set<String>> _parseAppliedFilters(Map<String, String> filters) {
    return filters.map(
      (key, value) =>
          MapEntry(key, value.split(',').where((v) => v.isNotEmpty).toSet()),
    );
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
}
