import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/base/base_bloc.dart';
import '../../domain/entities/order_info_entity.dart';
import '../../domain/entities/orders_page_entity.dart';
import '../../domain/usecases/get_orders_page_usecase.dart';

part 'orders_bloc.freezed.dart';
part 'orders_event.dart';
part 'orders_state.dart';

/// BLoC for the Orders screen.
///
/// Responsibilities:
///  - Load page 1 on `LoadOrders`.
///  - Refresh (reset to page 1) on `RefreshOrders`.
///  - Append page N+1 on `LoadNextOrdersPage`, de-duplicating rapid-fire
///    pagination events via the [BaseBloc]-managed `CancelToken`.
///
/// Business rules that live elsewhere (NOT in this BLoC):
///  - `hasReachedEnd` is derived by the [OrdersPage] entity.
///  - Page merging is implemented by `OrdersPage.merge`.
///  - Error → user message mapping is `Failure.message` (owned by the
///    error layer). The BLoC never builds its own strings.
@injectable
class OrdersBloc extends BaseBloc<OrdersEvent, OrdersState> {
  final GetOrdersPageUseCase _getOrdersPage;

  OrdersBloc(this._getOrdersPage) : super(const OrdersState()) {
    on<LoadOrders>(_onLoadOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<LoadNextOrdersPage>(_onLoadNextOrdersPage);
    on<ClearPaginationError>(_onClearPaginationError);
  }

  /// Fresh constructor, not `state.copyWith`, because this is an intentional
  /// full reset. Using `copyWith` would carry forward stale `page`,
  /// `currentPage`, and `errorMessage` into the loading state, leaving old
  /// data sitting silently underneath the shimmer. A bare constructor wipes
  /// everything back to defaults so the subsequent loaded/error emit always
  /// starts from a clean slate.
  ///
  /// Contrast with [_onLoadNextOrdersPage], which uses `copyWith` precisely
  /// to *keep* the existing list visible while more pages load.
  ///
  /// Wrong:
  /// ```dart
  /// emit(state.copyWith(status: OrdersStatus.loading));
  /// // page / currentPage / errorMessage still hold the previous values
  /// ```
  /// Right:
  /// ```dart
  /// emit(const OrdersState(status: OrdersStatus.loading));
  /// // page: null, currentPage: 1, errorMessage: null — clean slate
  /// ```
  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersState(status: OrdersStatus.loading));
    final token = swapCancelToken();

    final result = await _getOrdersPage(
      GetOrdersPageParams(pageNo: 1, cancelToken: token),
    );

    result.fold(
      (failure) => emit(
        OrdersState(status: OrdersStatus.error, errorMessage: failure.message),
      ),
      (page) => emit(
        OrdersState(status: OrdersStatus.success, page: page, currentPage: 1),
      ),
    );
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    add(const LoadOrders());
  }

  /// `current` captures a snapshot of [state] before any intermediate emit.
  /// After `emit(current.copyWith(isLoadingMore: true))`, `this.state` is
  /// already the new loading-indicator state. All subsequent `copyWith` calls
  /// must branch from `current` (the pre-emit snapshot), not from the updated
  /// `this.state`, so that `page`, `currentPage`, and other fields reflect
  /// what was loaded before this handler started — not whatever was emitted
  /// mid-flight.
  ///
  /// This also protects against a concurrent event (e.g. a rapid refresh)
  /// slipping in between the intermediate emit and the `await` resolving.
  /// `current` is frozen at the point we decided to paginate; `this.state`
  /// is not.
  ///
  /// Wrong:
  /// ```dart
  /// emit(state.copyWith(isLoadingMore: true));  // state is now isLoadingMore:true
  /// final result = await ...;
  /// result.fold(
  ///   (_) => emit(state.copyWith(...)),  // branching from isLoadingMore:true state — fragile
  ///   (next) => emit(state.copyWith(page: state.page!.merge(next))),  // same issue
  /// );
  /// ```
  /// Right:
  /// ```dart
  /// final current = state;               // snapshot before any emit
  /// emit(current.copyWith(isLoadingMore: true));
  /// final result = await ...;
  /// result.fold(
  ///   (_) => emit(current.copyWith(...)),          // always from the snapshot
  ///   (next) => emit(current.copyWith(page: current.page!.merge(next))),
  /// );
  /// ```
  Future<void> _onLoadNextOrdersPage(
    LoadNextOrdersPage event,
    Emitter<OrdersState> emit,
  ) async {
    // isLoadingMore guard prevents scroll flooding: while a page request is
    // already in flight, status is still `loaded` so the status check alone
    // would not stop repeated events from the scroll listener.
    if (state.status != OrdersStatus.success ||
        state.hasReachedEnd ||
        state.isLoadingMore) {
      return;
    }

    final current = state;
    final nextPage = current.currentPage + 1;
    emit(current.copyWith(isLoadingMore: true));
    final token = swapCancelToken();

    final result = await _getOrdersPage(
      GetOrdersPageParams(pageNo: nextPage, cancelToken: token),
    );

    result.fold(
      (failure) => emit(
        current.copyWith(
          isLoadingMore: false,
          // Keep status loaded so the already-fetched list stays visible.
          // The error is surfaced as a snackbar via paginationError, which
          // the BlocListener in orders_page clears immediately after showing it.
          paginationError: failure.message,
        ),
      ),
      (next) => emit(
        current.copyWith(
          isLoadingMore: false,
          page: current.page!.merge(next),
          currentPage: nextPage,
        ),
      ),
    );
  }

  Future<void> _onClearPaginationError(
    ClearPaginationError event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(paginationError: null));
  }
}
