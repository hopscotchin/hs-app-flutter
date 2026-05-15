part of 'plp_bloc.dart';

enum PlpStatus { initial, loading, loaded, error, empty }

@freezed
abstract class PlpState with _$PlpState {
  const factory PlpState({
    @Default(PlpStatus.initial) PlpStatus status,
    @Default([]) List<ListingProductEntity> products,
    @Default([]) List<PlpListItem> listItems,
    int? totalRecords,
    @Default(0) int currentPage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    PlpFilterEntity? plpFilter,
    @Default([]) List<SortingOptionEntity> sortingOptions,
    @Default({}) Map<String, String> appliedFilters,
    ListingHeaderEntity? salePlanDetail,
    TopBannerEntity? topBanner,
    String? screenName,
    int? orderRule,
    String? errorMessage,
  }) = _PlpState;
}

extension PlpStateX on PlpState {
  bool get hasProducts => products.isNotEmpty;
}
