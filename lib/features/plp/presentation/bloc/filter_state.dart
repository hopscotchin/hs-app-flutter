part of 'filter_bloc.dart';

class FilterState extends Equatable {
  final PlpFilterEntity plpFilter;
  final Map<String, Set<String>> pendingFilters;
  final Map<String, String> treeSelections;
  final int selectedSectionIndex;
  final int treeExpandedLevel;
  final bool isRefreshing;
  final Map<String, dynamic> baseQueryParams;
  final String? errorMessage;

  const FilterState({
    this.plpFilter = const PlpFilterEntity(),
    this.pendingFilters = const {},
    this.treeSelections = const {},
    this.selectedSectionIndex = 0,
    this.treeExpandedLevel = 0,
    this.isRefreshing = false,
    this.baseQueryParams = const {},
    this.errorMessage,
  });

  List<FilterSectionEntity> get sections => plpFilter.filterSection;

  /// The selected index clamped to valid bounds.
  int get safeSectionIndex =>
      sections.isEmpty ? 0 : selectedSectionIndex.clamp(0, sections.length - 1);

  bool get hasSelections =>
      pendingFilters.values.any((v) => v.isNotEmpty) ||
      treeSelections.isNotEmpty;

  FilterSectionEntity? get currentSection =>
      sections.isEmpty ? null : sections[safeSectionIndex];

  bool isSectionActive(FilterSectionEntity section) {
    for (final filter in section.filterList) {
      final param = filter.param ?? '';
      if (pendingFilters[param]?.isNotEmpty == true) return true;
    }
    // Also check tree selections
    for (final filter in section.filterList) {
      final param = filter.param ?? '';
      if (treeSelections.containsKey(param)) return true;
      // Check nested tree params
      for (final child in filter.filter) {
        final childParam = child.param ?? '';
        if (treeSelections.containsKey(childParam)) return true;
        for (final grandchild in child.filter) {
          final grandchildParam = grandchild.param ?? '';
          if (treeSelections.containsKey(grandchildParam)) return true;
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

  FilterState copyWith({
    PlpFilterEntity? plpFilter,
    Map<String, Set<String>>? pendingFilters,
    Map<String, String>? treeSelections,
    int? selectedSectionIndex,
    int? treeExpandedLevel,
    bool? isRefreshing,
    Map<String, dynamic>? baseQueryParams,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FilterState(
      plpFilter: plpFilter ?? this.plpFilter,
      pendingFilters: pendingFilters ?? this.pendingFilters,
      treeSelections: treeSelections ?? this.treeSelections,
      selectedSectionIndex: selectedSectionIndex ?? this.selectedSectionIndex,
      treeExpandedLevel: treeExpandedLevel ?? this.treeExpandedLevel,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      baseQueryParams: baseQueryParams ?? this.baseQueryParams,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    plpFilter,
    pendingFilters,
    treeSelections,
    selectedSectionIndex,
    treeExpandedLevel,
    isRefreshing,
    baseQueryParams,
    errorMessage,
  ];
}
