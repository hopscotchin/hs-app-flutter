part of 'filter_bloc.dart';

enum FilterStatus { initial, error }

@freezed
abstract class FilterState with _$FilterState {
  const factory FilterState({
    @Default(FilterStatus.initial) FilterStatus status,
    @Default(PlpFilterEntity()) PlpFilterEntity plpFilter,
    @Default(<String, Set<String>>{}) Map<String, Set<String>> pendingFilters,
    @Default(<String, String>{}) Map<String, String> treeSelections,
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
      pendingFilters.values.any((v) => v.isNotEmpty) || treeSelections.isNotEmpty;

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
        if (treeSelections.containsKey(childKey)) return true;
        for (final grandchild in child.filters) {
          final grandchildKey = grandchild.filterKey ?? '';
          if (treeSelections.containsKey(grandchildKey)) return true;
          for (final ggChild in grandchild.filters) {
            if (treeSelections.containsKey(ggChild.filterKey ?? '')) return true;
          }
        }
      }
    }
    return false;
  }

  Map<String, String> flattenFilters() {
    final result = <String, String>{};
    for (final entry in pendingFilters.entries) {
      if (entry.value.isNotEmpty) {
        result[entry.key] = entry.value.join(',');
      }
    }
    result.addAll(treeSelections);
    return result;
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
