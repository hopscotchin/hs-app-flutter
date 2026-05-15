part of 'plp_bloc.dart';

abstract class PlpEvent extends Equatable {
  const PlpEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlpData extends PlpEvent {
  final PageType pageType;
  final int plpId;
  final String? searchQuery;
  final String? categoryName;
  final Map<String, String>? initialFilters;

  const LoadPlpData({
    required this.pageType,
    required this.plpId,
    this.searchQuery,
    this.categoryName,
    this.initialFilters,
  });

  @override
  List<Object?> get props => [
    pageType,
    plpId,
    searchQuery,
    categoryName,
    initialFilters,
  ];
}

class LoadMorePlpData extends PlpEvent {
  const LoadMorePlpData();
}

class ApplyFilter extends PlpEvent {
  final String key;
  final String value;

  const ApplyFilter({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class ApplyMultipleFilters extends PlpEvent {
  final Map<String, String> filters;

  const ApplyMultipleFilters({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class RemoveFilter extends PlpEvent {
  final SelectedFilterEntity filterToRemove;

  const RemoveFilter({required this.filterToRemove});

  @override
  List<Object?> get props => [filterToRemove];
}

class ClearAllFilters extends PlpEvent {
  const ClearAllFilters();
}

class ApplySort extends PlpEvent {
  final int orderRule;

  const ApplySort({required this.orderRule});

  @override
  List<Object?> get props => [orderRule];
}

class ApplyFloatingFilter extends PlpEvent {
  final String key;
  final String value;

  const ApplyFloatingFilter({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}
