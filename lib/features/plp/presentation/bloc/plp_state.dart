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
    @Default([]) List<BannerEntity> banners,
    @Default({}) Map<String, String> appliedFilters,
    String? screenName,
    String? screenSubtitle,
    String? errorMessage,
    QueryCorrectionEntity? queryCorrection,
    int? currentOrderRule,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,
  }) = _PlpState;
}

extension PlpStateX on PlpState {
  bool get hasProducts => products.isNotEmpty;
}
