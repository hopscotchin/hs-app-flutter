part of 'plp_bloc.dart';

@freezed
sealed class PlpEvent with _$PlpEvent {
  const factory PlpEvent.loadPlpData({
    required PageType pageType,
    required int plpId,
    String? searchQuery,
    String? categoryName,
    String? rawSearchParams,
    Map<String, String>? initialFilters,
  }) = LoadPlpData;

  const factory PlpEvent.loadMore() = LoadMorePlpData;

  const factory PlpEvent.applyFilter({required String key, required String value}) = ApplyFilter;

  const factory PlpEvent.applyMultipleFilters({required Map<String, String> filters}) =
      ApplyMultipleFilters;

  const factory PlpEvent.removeFilter({required SelectedFilterEntity filterToRemove}) =
      RemoveFilter;

  const factory PlpEvent.clearAllFilters() = ClearAllFilters;

  const factory PlpEvent.applySort({required int orderRule}) = ApplySort;

  const factory PlpEvent.applyFloatingFilter({required String key, required String value}) =
      ApplyFloatingFilter;
}
