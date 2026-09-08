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

    /// How the user got here — supplies the client-owned `from_screen` /
    /// `from_location` block on the listing-viewed event. Null for deeplinks.
    PlpEntryArgs? entryArgs,

    /// True when this load is the user accepting a spelling suggestion.
    /// Changes which analytics event the completed load emits: a trimmed
    /// `products_searched` carrying `query_correction: "Suggestion used"`,
    /// rather than the full listing-viewed payload.
    @Default(false) bool isFromQueryCorrection,
  }) = LoadPlpData;

  const factory PlpEvent.loadMore() = LoadMorePlpData;

  const factory PlpEvent.applyFilter({required String key, required String value}) = ApplyFilter;

  /// [clickSource] is which control the user actually applied from — the
  /// sticky bar's per-section bottom sheet ([FilterClickSource.stickyFilter])
  /// or the full-screen filter page ([FilterClickSource.standardFilter]).
  /// Both routes land on the same handler, so the source has to travel with
  /// the event; the backend cannot infer it from the query params.
  const factory PlpEvent.applyMultipleFilters({
    required Map<String, String> filters,
    required String clickSource,
  }) = ApplyMultipleFilters;

  const factory PlpEvent.removeFilter({required SelectedFilterEntity filterToRemove}) =
      RemoveFilter;

  const factory PlpEvent.clearAllFilters() = ClearAllFilters;

  const factory PlpEvent.applySort({required int orderRule}) = ApplySort;

  const factory PlpEvent.applyFloatingFilter({required String key, required String value}) =
      ApplyFloatingFilter;
}
