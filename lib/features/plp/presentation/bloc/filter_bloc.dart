import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/usecases/check_pincode_usecase.dart';
import '../../domain/usecases/get_filter_data_usecase.dart';

part 'filter_bloc.freezed.dart';
part 'filter_event.dart';
part 'filter_state.dart';

@injectable
class FilterBloc extends BaseBloc<FilterEvent, FilterState> {
  final GetFilterDataUseCase getFilterDataUseCase;
  final CheckPincodeUseCase checkPincodeUseCase;

  Map<String, String> _lastRefreshedFilters = {};

  static const int _kPincodeLength = 6;

  FilterBloc({required this.getFilterDataUseCase, required this.checkPincodeUseCase})
    : super(const FilterState()) {
    on<InitializeFilter>(_onInitialize);
    on<ToggleFilterItem>(_onToggleFilterItem);
    on<SelectTreeItem>(_onSelectTreeItem);
    on<SwitchSection>(_onSwitchSection);
    on<ClearAllPendingFilters>(_onClearAll);
    on<NavigateTreeBack>(_onNavigateTreeBack);
    on<PopTreeToLevel>(_onPopTreeToLevel);
    on<VerifyPincode>(_onVerifyPincode);
    on<ClearPincodeError>(_onClearPincodeError);
  }

  void _onInitialize(InitializeFilter event, Emitter<FilterState> emit) {
    final split = _splitAppliedFilters(event.plpFilter, event.appliedFilters);
    _lastRefreshedFilters = event.appliedFilters;
    emit(
      FilterState(
        plpFilter: event.plpFilter,
        treeSelections: split.treeSelections,
        pendingFilters: split.pendingFilters,
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

    emit(state.copyWith(pendingFilters: updated, errorMessage: null));
  }

  Future<void> _onSelectTreeItem(SelectTreeItem event, Emitter<FilterState> emit) async {
    final section = state.currentSection;
    if (section == null) return;

    final treeParams = _extractTreeParams(section);
    final updated = Map<String, String>.from(state.treeSelections);

    for (var i = event.level; i < treeParams.length; i++) {
      updated.remove(treeParams[i]);
    }
    updated[event.param] = event.value;

    emit(state.copyWith(treeSelections: updated, errorMessage: null));
    await _refreshFilter(emit);
  }

  Future<void> _onSwitchSection(SwitchSection event, Emitter<FilterState> emit) async {
    final currentFlat = state.flattenFilters();
    final needsRefresh = !mapEquals(currentFlat, _lastRefreshedFilters);

    if (needsRefresh) {
      await _refreshFilter(emit);
    }

    emit(state.copyWith(selectedSectionIndex: event.sectionIndex, errorMessage: null));
  }

  Future<void> _onClearAll(ClearAllPendingFilters event, Emitter<FilterState> emit) async {
    emit(
      state.copyWith(
        pendingFilters: const <String, Set<String>>{},
        treeSelections: const <String, String>{},
        errorMessage: null,
      ),
    );

    await _refreshFilter(emit);
  }

  Future<void> _onNavigateTreeBack(NavigateTreeBack event, Emitter<FilterState> emit) async {
    final depth = state.treeSelections.length;
    if (depth <= 0) return;
    // Pop one level up — delegates to the same clear-subtree logic as ⊗.
    await _onPopTreeToLevel(PopTreeToLevel(level: depth - 1), emit);
  }

  Future<void> _onPopTreeToLevel(PopTreeToLevel event, Emitter<FilterState> emit) async {
    final section = state.currentSection;
    if (section == null) return;

    final treeParams = _extractTreeParams(section);
    if (event.level < 0 || event.level > treeParams.length) return;

    final keysToClear = _collectFilterKeysUnderPath(
      section: section,
      treeSelections: state.treeSelections,
      treeParams: treeParams,
      keepDepth: event.level,
    );

    final updatedTree = Map<String, String>.from(state.treeSelections);
    for (var i = event.level; i < treeParams.length; i++) {
      updatedTree.remove(treeParams[i]);
    }

    final updatedPending = Map<String, Set<String>>.from(
      state.pendingFilters.map((k, v) => MapEntry(k, Set<String>.from(v))),
    );
    for (final key in keysToClear) {
      updatedPending.remove(key);
    }

    emit(
      state.copyWith(
        treeSelections: updatedTree,
        pendingFilters: updatedPending,
        errorMessage: null,
      ),
    );

    await _refreshFilter(emit);
  }

  Set<String> _collectFilterKeysUnderPath({
    required FilterSectionEntity section,
    required Map<String, String> treeSelections,
    required List<String> treeParams,
    required int keepDepth,
  }) {
    final keys = <String>{};
    if (section.filterList.isEmpty) return keys;

    var current = section.filterList.first.filters;

    // Walk down to the deepest ancestor we are keeping (depth keepDepth - 1).
    for (var i = 0; i < keepDepth; i++) {
      if (i >= treeParams.length) break;
      final value = treeSelections[treeParams[i]];
      if (value == null) return keys;
      final match = current.where((f) => (f.filterValue ?? f.label) == value);
      if (match.isEmpty) return keys;
      current = match.first.filters;
    }

    void walk(List<FilterEntity> nodes) {
      for (final node in nodes) {
        final key = node.filterKey;
        if (key != null && key.isNotEmpty) keys.add(key);
        walk(node.filters);
      }
    }

    walk(current);
    return keys;
  }

  /// Rebuilds [FilterState.pendingFilters] from the freshly-returned filter
  /// data's `isSelected` flags.
  ///
  /// Flat sections (price, colour, discount, EDD, age …) trust the response:
  /// dynamic-bucket filters get recomputed boundaries on every refresh, so the
  /// values the user originally tapped no longer match the returned items —
  /// only `isSelected` is authoritative.
  ///
  /// Tree sections (e.g. Category) use stable IDs and carry their drill state
  /// in [FilterState.treeSelections], so their leaf selections are preserved
  /// from [existing] rather than rederived.
  Map<String, Set<String>> _reconcilePendingFromResponse(
    PlpFilterEntity data,
    Map<String, Set<String>> existing,
  ) {
    final result = <String, Set<String>>{};

    for (final section in data.filterSections) {
      if (section.uiType?.toLowerCase() == 'tree') {
        for (final key in _collectAllSectionKeys(section)) {
          final value = existing[key];
          if (value != null && value.isNotEmpty) {
            result[key] = Set<String>.from(value);
          }
        }
        continue;
      }

      for (final leaf in _leafNodes(section.filterList)) {
        if (!leaf.isSelected) continue;
        final key = (leaf.filterKey?.isNotEmpty ?? false)
            ? leaf.filterKey!
            : (section.filterKey ?? '');
        final value = leaf.filterValue ?? leaf.label ?? '';
        if (key.isEmpty || value.isEmpty) continue;
        (result[key] ??= <String>{}).add(value);
      }
    }

    return result;
  }

  /// Yields every leaf node (a node with no children) under [nodes].
  Iterable<FilterEntity> _leafNodes(List<FilterEntity> nodes) sync* {
    for (final node in nodes) {
      if (node.filters.isEmpty) {
        yield node;
      } else {
        yield* _leafNodes(node.filters);
      }
    }
  }

  /// Collects every `filterKey` used at any depth within [section].
  Set<String> _collectAllSectionKeys(FilterSectionEntity section) {
    final keys = <String>{};
    void walk(List<FilterEntity> nodes) {
      for (final node in nodes) {
        final key = node.filterKey;
        if (key != null && key.isNotEmpty) keys.add(key);
        walk(node.filters);
      }
    }

    walk(section.filterList);
    return keys;
  }

  Future<void> _refreshFilter(Emitter<FilterState> emit) async {
    final current = state;
    final cancelToken = swapCancelToken();

    emit(current.copyWith(isRefreshing: true));

    final queryParams = <String, dynamic>{}
      ..addAll(current.baseQueryParams)
      ..addAll(current.flattenFilters());

    final result = await getFilterDataUseCase(
      GetFilterDataParams(queryParams: queryParams, cancelToken: cancelToken),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          current.copyWith(
            isRefreshing: false,
            status: FilterStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (filterData) {
        // The canonical selected values come from the response's `isSelected`
        // flags — NOT the values the user originally tapped. Dynamic-bucket
        // filters (price, discount, EDD ranges) are recomputed by the backend
        // on every refresh, so the returned bucket boundaries differ from what
        // was sent. Rebuilding pendingFilters from `isSelected` keeps the
        // checkbox UI in sync when the user returns to such a section.
        final reconciledPending = _reconcilePendingFromResponse(
          filterData,
          current.pendingFilters,
        );

        final previousLabel = current.currentSection?.label;
        final newSections = filterData.filterSections;
        var nextIndex = current.selectedSectionIndex;
        if (previousLabel != null && previousLabel.isNotEmpty) {
          final found = newSections.indexWhere((s) => s.label == previousLabel);
          if (found >= 0) nextIndex = found;
        }

        final reconciled = current.copyWith(
          plpFilter: filterData,
          pendingFilters: reconciledPending,
          selectedSectionIndex: nextIndex,
          isRefreshing: false,
          status: FilterStatus.initial,
          errorMessage: null,
        );

        // Track the reconciled (server-canonical) values so the next section
        // switch doesn't trigger a spurious refresh.
        _lastRefreshedFilters = reconciled.flattenFilters();

        emit(reconciled);
      },
    );
  }

  List<String> _extractTreeParams(FilterSectionEntity section) {
    final params = <String>[];
    if (section.filterList.isEmpty) return params;

    final wrapper = section.filterList.first;
    if (wrapper.filters.isEmpty) return params;

    final level0 = wrapper.filters.first;
    params.add(level0.filterKey ?? '');

    if (level0.filters.isNotEmpty) {
      final level1 = level0.filters.first;
      params.add(level1.filterKey ?? '');

      if (level1.filters.isNotEmpty) {
        params.add(level1.filters.first.filterKey ?? '');
      }
    }

    return params;
  }

  ({Map<String, String> treeSelections, Map<String, Set<String>> pendingFilters})
  _splitAppliedFilters(PlpFilterEntity plpFilter, Map<String, String> appliedFilters) {
    final treeSel = <String, String>{};
    final pending = <String, Set<String>>{};
    final consumed = <String>{};

    for (final section in plpFilter.filterSections) {
      if (section.uiType?.toLowerCase() != 'tree') continue;
      if (section.filterList.isEmpty) continue;

      var current = section.filterList.first.filters;
      while (current.isNotEmpty) {
        final levelKey = current.first.filterKey ?? '';
        if (levelKey.isEmpty) break;

        final applied = appliedFilters[levelKey];
        if (applied == null || applied.isEmpty) break;

        // Drill candidate: single value pointing at a parent node.
        if (!applied.contains(',')) {
          final matches = current.where((f) => (f.filterValue ?? f.label) == applied);
          if (matches.isNotEmpty && matches.first.filters.isNotEmpty) {
            treeSel[levelKey] = applied;
            consumed.add(levelKey);
            current = matches.first.filters;
            continue;
          }
        }

        // Leaf level — single or comma-joined values map to a Set.
        pending[levelKey] = applied.split(',').where((v) => v.isNotEmpty).toSet();
        consumed.add(levelKey);
        break;
      }
    }

    // Flat filters (everything not touched by a tree walk) — same shape
    // as the old `_parseAppliedFilters` produced.
    for (final entry in appliedFilters.entries) {
      if (consumed.contains(entry.key)) continue;
      pending[entry.key] = entry.value.split(',').where((v) => v.isNotEmpty).toSet();
    }

    return (treeSelections: treeSel, pendingFilters: pending);
  }

  Future<void> _onVerifyPincode(VerifyPincode event, Emitter<FilterState> emit) async {
    final pincode = event.pincode.trim();

    // Step 1: client-side validation.
    if (!_isValidPincode(pincode)) {
      emit(state.copyWith(pincodeError: 'Enter a valid 6-digit pincode'));
      return;
    }

    emit(state.copyWith(isPincodeLoading: true, pincodeError: null));

    final cancelToken = swapCancelToken();
    final result = await checkPincodeUseCase(
      CheckPincodeParams(pincode: pincode, cancelToken: cancelToken),
    );

    await result.fold(
      (failure) async {
        if (failure is RequestCancelledFailure) return;
        emit(state.copyWith(isPincodeLoading: false, pincodeError: failure.message));
      },
      (response) async {
        if (!response.serviceable) {
          emit(
            state.copyWith(
              isPincodeLoading: false,
              pincodeError: response.noPinCodeMessage ?? "We can't deliver to this pincode",
            ),
          );
          return;
        }

        // Serviceable → clear EDD selections then refresh filter list.
        final cleared = Map<String, Set<String>>.from(state.pendingFilters)..remove('edd');
        emit(
          state.copyWith(
            isPincodeLoading: false,
            pincodeError: null,
            verifiedPincode: pincode,
            pendingFilters: cleared,
          ),
        );
        await _refreshFilter(emit);
      },
    );
  }

  void _onClearPincodeError(ClearPincodeError event, Emitter<FilterState> emit) {
    if (state.pincodeError == null) return;
    emit(state.copyWith(pincodeError: ''));
  }

  static bool _isValidPincode(String value) =>
      value.length == _kPincodeLength && value != '000000' && RegExp(r'^[0-9]+$').hasMatch(value);
}
