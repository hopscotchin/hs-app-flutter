part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class InitializeFilter extends FilterEvent {
  final PlpFilterEntity plpFilter;
  final Map<String, String> appliedFilters;
  final Map<String, dynamic> baseQueryParams;

  const InitializeFilter({
    required this.plpFilter,
    required this.appliedFilters,
    required this.baseQueryParams,
  });

  @override
  List<Object?> get props => [plpFilter, appliedFilters, baseQueryParams];
}

class ToggleFilterItem extends FilterEvent {
  final String param;
  final String value;
  final bool isMultiSelect;

  const ToggleFilterItem({
    required this.param,
    required this.value,
    required this.isMultiSelect,
  });

  @override
  List<Object?> get props => [param, value, isMultiSelect];
}

class SelectTreeItem extends FilterEvent {
  final String param;
  final String value;
  final int level;

  const SelectTreeItem({
    required this.param,
    required this.value,
    required this.level,
  });

  @override
  List<Object?> get props => [param, value, level];
}

class SwitchSection extends FilterEvent {
  final int sectionIndex;

  const SwitchSection({required this.sectionIndex});

  @override
  List<Object?> get props => [sectionIndex];
}

class ClearAllPendingFilters extends FilterEvent {
  const ClearAllPendingFilters();
}

class NavigateTreeBack extends FilterEvent {
  const NavigateTreeBack();
}
