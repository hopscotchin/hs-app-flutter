part of 'filter_bloc.dart';

enum FilterStatus { initial, error }

@freezed
abstract class FilterState with _$FilterState {
  const factory FilterState({
    @Default(FilterStatus.initial) FilterStatus status,
    @Default(PlpFilterEntity()) PlpFilterEntity plpFilter,
    @Default(<String, Set<String>>{}) Map<String, Set<String>> pendingFilters,
    @Default(<String, String>{}) Map<String, String> treeSelections,
    // Tree keys written into [treeSelections] purely to auto-expand a
    // single-child branch for navigation (e.g. a lone top-level category). They
    // are NOT user selections, so they must not be sent to the API or counted
    // as active filters unless the user actually selects something below them.
    @Default(<String>{}) Set<String> autoExpandedKeys,
    // Whether the filter UI opened with filters already applied. Captured once
    // at initialization and never mutated. Lets the Apply button stay enabled
    // after the user clears previously-applied filters, so an empty selection
    // can still be committed (see [canApply]).
    @Default(false) bool hadInitialFilters,
    @Default(0) int selectedSectionIndex,
    @Default(false) bool isRefreshing,
    @Default(<String, dynamic>{}) Map<String, dynamic> baseQueryParams,
    String? errorMessage,
    @Default(false) bool isPincodeLoading,
    String? pincodeError,
    String? verifiedPincode,
  }) = _FilterState;
}

extension FilterStateX on FilterState {
  List<FilterSectionEntity> get sections => plpFilter.filterSections;

  int get safeSectionIndex =>
      sections.isEmpty ? 0 : selectedSectionIndex.clamp(0, sections.length - 1);

  bool get hasSelections =>
      pendingFilters.values.any((v) => v.isNotEmpty) ||
      treeSelections.keys.any(_isExplicitTreeSelection);

  /// Whether the Apply button should be enabled. Enabled when there are current
  /// selections to commit, or when the UI opened with filters applied (so the
  /// user can clear them and apply an empty selection). Disabled only when the
  /// user has selected nothing and nothing was applied before — nothing to do.
  bool get canApply => hasSelections || hadInitialFilters;

  /// A tree key is a real user selection only when it wasn't auto-added for
  /// navigation. Auto-expanded keys drive the tree view but aren't filters.
  bool _isExplicitTreeSelection(String key) =>
      treeSelections.containsKey(key) && !autoExpandedKeys.contains(key);

  FilterSectionEntity? get currentSection => sections.isEmpty ? null : sections[safeSectionIndex];

  String? get currentDeliveryPincode {
    final section = currentSection;
    if (section == null || section.uiType?.toLowerCase() != 'delivery') return null;
    return verifiedPincode ?? section.deliveryPincode;
  }

  bool isSectionActive(FilterSectionEntity section) {
    for (final wrapper in section.filterList) {
      for (final child in wrapper.filters) {
        final key = child.filterKey ?? '';
        if (pendingFilters[key]?.isNotEmpty == true) return true;
      }
    }
    for (final wrapper in section.filterList) {
      for (final child in wrapper.filters) {
        final childKey = child.filterKey ?? '';
        if (_isExplicitTreeSelection(childKey)) return true;
        for (final grandchild in child.filters) {
          final grandchildKey = grandchild.filterKey ?? '';
          if (_isExplicitTreeSelection(grandchildKey)) return true;
          for (final ggChild in grandchild.filters) {
            if (_isExplicitTreeSelection(ggChild.filterKey ?? '')) return true;
          }
        }
      }
    }
    return false;
  }

  Map<String, String> flattenFilters() {
    final result = <String, String>{};

    // Leaf and flat selections are explicit by definition — always sent.
    for (final entry in pendingFilters.entries) {
      if (entry.value.isNotEmpty) {
        result[entry.key] = entry.value.join(',');
      }
    }

    // Tree drill params. A key auto-expanded only for navigation (a single-child
    // prefix such as a lone category) must NOT be sent unless the user actually
    // selected something inside that tree — otherwise every refresh/apply would
    // filter by a category the user never chose. When there IS a real selection,
    // the auto-expanded ancestors are sent as its scope. Mirrors Android, where
    // auto-shown tree nodes never call insertTreeParams but an explicit tap adds
    // the node together with its ancestors.
    for (final entry in treeSelections.entries) {
      if (!autoExpandedKeys.contains(entry.key) || _treeHasRealSelection(entry.key)) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// Whether the tree section that owns [autoKey] carries a real user
  /// selection: an explicitly drilled node (not auto-expanded) or a selected
  /// leaf. Decides whether [autoKey]'s auto-expanded ancestor is sent as scope.
  bool _treeHasRealSelection(String autoKey) {
    final sectionKeys = _treeSectionKeysContaining(autoKey);
    if (sectionKeys == null) return true; // unknown structure — stay permissive
    for (final key in treeSelections.keys) {
      if (key != autoKey && sectionKeys.contains(key) && !autoExpandedKeys.contains(key)) {
        return true;
      }
    }
    for (final key in sectionKeys) {
      if (pendingFilters[key]?.isNotEmpty ?? false) return true;
    }
    return false;
  }

  /// Every `filterKey` in the tree section that contains [key], or null when no
  /// tree section owns it.
  Set<String>? _treeSectionKeysContaining(String key) {
    for (final section in plpFilter.filterSections) {
      if (section.uiType?.toLowerCase() != 'tree') continue;
      final keys = <String>{};
      void walk(List<FilterEntity> nodes) {
        for (final node in nodes) {
          final k = node.filterKey;
          if (k != null && k.isNotEmpty) keys.add(k);
          walk(node.filters);
        }
      }

      walk(section.filterList);
      if (keys.contains(key)) return keys;
    }
    return null;
  }

  List<String> treeBreadcrumbLabels(FilterSectionEntity section) {
    if (section.filterList.isEmpty) return const [];
    var current = section.filterList.first.filters;
    final labels = <String>[];
    while (current.isNotEmpty) {
      final paramAtLevel = current.first.filterKey ?? '';
      final value = treeSelections[paramAtLevel];
      if (value == null) break;
      final match = current.where((f) => (f.filterValue ?? f.label) == value);
      if (match.isEmpty) break;
      labels.add(match.first.label ?? '');
      current = match.first.filters;
    }
    return labels;
  }

  List<FilterEntity> treeVisibleChildren(FilterSectionEntity section) {
    if (section.filterList.isEmpty) return const [];
    var current = section.filterList.first.filters;
    while (current.isNotEmpty) {
      final paramAtLevel = current.first.filterKey ?? '';
      final value = treeSelections[paramAtLevel];
      if (value == null) break;
      final match = current.where((f) => (f.filterValue ?? f.label) == value);
      if (match.isEmpty) break;
      current = match.first.filters;
    }
    return current;
  }
}
