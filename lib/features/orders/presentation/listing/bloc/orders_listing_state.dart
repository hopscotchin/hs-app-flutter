part of 'orders_listing_bloc.dart';

enum ListingStatus { initial, loading, success, error }

/// Everything one tab knows about itself.
///
/// Both tabs are independent listings that happen to share a screen, so each
/// gets its own copy rather than the two fighting over one set of fields.
@freezed
abstract class TabListingState with _$TabListingState {
  const factory TabListingState({
    @Default(ListingStatus.initial) ListingStatus status,
    OrdersListingEntity? page,
    @Default(1) int currentPage,
    @Default(false) bool isLoadingMore,

    /// Bumped on every refresh outcome, success or failure.
    ///
    /// A silent refresh changes no other field on failure, so there would
    /// otherwise be nothing for `RefreshIndicator` to await and the spinner
    /// would vanish on the same frame it appeared.
    @Default(0) int refreshTick,

    /// Full-page failure — shown only when there is no data to fall back on.
    String? errorMessage,

    /// One-shot: a pagination failure surfaced as a snackbar while the loaded
    /// list stays visible. Cleared by [ClearListingPaginationError] once the
    /// listener has shown it.
    String? paginationError,
  }) = _TabListingState;
}

extension TabListingStateX on TabListingState {
  List<OrderListingRecordEntity> get records => page?.records ?? const [];
  bool get hasNextPage => page?.hasNextPage ?? false;
  bool get isLoading => status == ListingStatus.loading;
  bool get isError => status == ListingStatus.error;

  /// Loaded, and the server sent nothing.
  bool get isEmpty => status == ListingStatus.success && records.isEmpty;

  /// Whether a tab has ever been fetched — drives lazy loading on first visit
  /// to the Gift Cards tab, so its request is not fired behind the Orders tab
  /// on screen entry.
  bool get isUntouched => status == ListingStatus.initial;
}

@freezed
abstract class OrdersListingState with _$OrdersListingState {
  const factory OrdersListingState({
    @Default(OrdersTab.orders) OrdersTab activeTab,
    @Default(TabListingState()) TabListingState orders,
    @Default(TabListingState()) TabListingState giftCards,
  }) = _OrdersListingState;
}

extension OrdersListingStateX on OrdersListingState {
  TabListingState forTab(OrdersTab tab) =>
      tab == OrdersTab.orders ? orders : giftCards;

  OrdersListingState withTab(OrdersTab tab, TabListingState next) =>
      tab == OrdersTab.orders
      ? copyWith(orders: next)
      : copyWith(giftCards: next);
}
