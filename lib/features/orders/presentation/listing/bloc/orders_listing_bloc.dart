import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../../core/analytics/events/analytics_helper.dart';
import '../../../../../core/analytics/events/modules/orders_events.dart';
import '../../../../../core/base/base_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/listing/order_listing_record_entity.dart';
import '../../../domain/entities/listing/orders_listing_entity.dart';
import '../../../domain/entities/orders_entry_args.dart';
import '../../../domain/entities/orders_tab.dart';
import '../../../domain/usecases/listing/get_orders_listing_usecase.dart';

part 'orders_listing_bloc.freezed.dart';
part 'orders_listing_event.dart';
part 'orders_listing_state.dart';

/// Drives both listing tabs.
///
/// One bloc rather than one per tab: `BlocProvider` may only live in the route
/// file, which rules out creating a provider inside the `TabBarView`. Each tab
/// therefore keeps its own [TabListingState] and every event names the tab it
/// acts on.
///
/// What this bloc does *not* do: no JSON, no repository calls, no `sl<T>()`,
/// no navigation. Status icons, copy and colours all arrive resolved from the
/// backend — there is nothing here that maps a code to a drawable, which is the
/// ~90-line `if/else` this refactor exists to delete.
@injectable
class OrdersListingBloc
    extends BaseBloc<OrdersListingEvent, OrdersListingState> {
  OrdersListingBloc(this._getListing, this._analytics)
    : super(const OrdersListingState()) {
    on<LoadListing>(_onLoad);
    on<RefreshListing>(_onRefresh);
    on<LoadNextListingPage>(_onLoadNextPage);
    on<SwitchListingTab>(_onSwitchTab);
    on<ClearListingPaginationError>(_onClearPaginationError);
  }

  final GetOrdersListingUseCase _getListing;
  final AnalyticsHelper _analytics;

  /// How the user reached the screen. Set once by the route and held for the
  /// bloc's life, so it survives tab switches and pagination.
  OrdersEntryArgs? entryArgs;

  static const int _pageSize = 20;

  // ── Load ────────────────────────────────────────────────────────────────

  /// Full reset for one tab. Emits a bare [TabListingState] rather than a
  /// `copyWith` so stale records, page number and error text cannot survive
  /// underneath the shimmer.
  Future<void> _onLoad(
    LoadListing event,
    Emitter<OrdersListingState> emit,
  ) async {
    emit(
      state.withTab(
        event.tab,
        const TabListingState(status: ListingStatus.loading),
      ),
    );

    final token = swapCancelToken();
    final result = await _getListing(
      GetOrdersListingParams(
        tab: event.tab,
        page: 1,
        pageSize: _pageSize,
        cancelToken: token,
      ),
    );

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.withTab(
            event.tab,
            TabListingState(
              status: ListingStatus.error,
              errorMessage: failure.message,
            ),
          ),
        );
      },
      (page) {
        emit(
          state.withTab(
            event.tab,
            TabListingState(
              status: ListingStatus.success,
              page: page,
              currentPage: 1,
            ),
          ),
        );
        _logListingViewed(page);
      },
    );
  }

  // ── Refresh ─────────────────────────────────────────────────────────────

  /// Silent reload: no loading status, so the list stays on screen under the
  /// pull-to-refresh spinner.
  ///
  /// [TabListingState.refreshTick] is bumped on both outcomes — it is the only
  /// signal the page can await, since a failed refresh deliberately changes
  /// nothing else.
  ///
  /// Every emit reads `state` live rather than a snapshot taken before the
  /// await: a refresh usually follows something the UI has already consumed and
  /// cleared, and rebuilding from a stale snapshot would put that back.
  Future<void> _onRefresh(
    RefreshListing event,
    Emitter<OrdersListingState> emit,
  ) async {
    final token = swapCancelToken();
    final result = await _getListing(
      GetOrdersListingParams(
        tab: event.tab,
        page: 1,
        pageSize: _pageSize,
        cancelToken: token,
      ),
    );

    final tabState = state.forTab(event.tab);

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.withTab(
            event.tab,
            tabState.copyWith(refreshTick: tabState.refreshTick + 1),
          ),
        );
      },
      (page) {
        emit(
          state.withTab(
            event.tab,
            tabState.copyWith(
              status: ListingStatus.success,
              page: page,
              currentPage: 1,
              errorMessage: null,
              refreshTick: tabState.refreshTick + 1,
            ),
          ),
        );
        _logListingViewed(page);
      },
    );
  }

  // ── Pagination ──────────────────────────────────────────────────────────

  /// Appends the next page, keeping the current list visible throughout.
  ///
  /// `current` is snapshotted before the first emit because bloc's default
  /// transformer is concurrent: a refresh landing mid-flight could otherwise
  /// null out `page` and make the merge below a null dereference. The guard
  /// after the await covers the same race from the other side — if the tab was
  /// reloaded while this request was out, the appended page belongs to a list
  /// that no longer exists, so it is dropped rather than resurrecting stale
  /// rows.
  Future<void> _onLoadNextPage(
    LoadNextListingPage event,
    Emitter<OrdersListingState> emit,
  ) async {
    final current = state.forTab(event.tab);
    if (current.status != ListingStatus.success ||
        !current.hasNextPage ||
        current.isLoadingMore) {
      return;
    }

    final nextPage = current.currentPage + 1;
    emit(state.withTab(event.tab, current.copyWith(isLoadingMore: true)));

    final token = swapCancelToken();
    final result = await _getListing(
      GetOrdersListingParams(
        tab: event.tab,
        page: nextPage,
        pageSize: _pageSize,
        cancelToken: token,
      ),
    );

    // The list this append was based on is gone — a reload or refresh replaced
    // it while the request was in flight.
    if (!identical(state.forTab(event.tab).page, current.page)) return;

    result.fold(
      (failure) {
        if (failure is RequestCancelledFailure) return;
        emit(
          state.withTab(
            event.tab,
            current.copyWith(
              isLoadingMore: false,
              paginationError: failure.message,
            ),
          ),
        );
      },
      (next) => emit(
        state.withTab(
          event.tab,
          current.copyWith(
            isLoadingMore: false,
            page: current.page!.merge(next),
            currentPage: nextPage,
          ),
        ),
      ),
    );
  }

  // ── Tab switching ───────────────────────────────────────────────────────

  /// Records the active tab and loads it if this is its first visit.
  ///
  /// Lazy on purpose: firing the Gift Cards request on screen entry would put a
  /// second call on the wire for a tab the user may never open.
  void _onSwitchTab(SwitchListingTab event, Emitter<OrdersListingState> emit) {
    emit(state.copyWith(activeTab: event.tab));

    if (state.forTab(event.tab).isUntouched) {
      add(OrdersListingEvent.load(event.tab));
      return;
    }

    // Already loaded — the user is looking at this listing again, so the view
    // event fires again, as it would on any other entry to the screen.
    final page = state.forTab(event.tab).page;
    if (page != null) _logListingViewed(page);
  }

  void _onClearPaginationError(
    ClearListingPaginationError event,
    Emitter<OrdersListingState> emit,
  ) {
    emit(
      state.withTab(
        event.tab,
        state.forTab(event.tab).copyWith(paginationError: null),
      ),
    );
  }

  // ── Analytics ───────────────────────────────────────────────────────────

  /// `order_listing_viewed`, on first-page loads only.
  ///
  /// Android fires it on every successful response including paginated ones,
  /// which is why its `active_orders` grows as the user scrolls. Here both
  /// counts come from the server node and no longer change per page, so firing
  /// per page would inflate the event count without adding a dimension. Flagged
  /// for the analytics owner in docs/orders/orders-tracking-meta.md.
  void _logListingViewed(OrdersListingEntity page) {
    _analytics.logOrderListingViewed(
      trackingMeta: page.trackingMeta,
      fromScreen: entryArgs?.fromScreen ?? FromScreens.account,
    );
  }
}
