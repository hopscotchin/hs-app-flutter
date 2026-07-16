part of 'orders_bloc.dart';

/// Events follow the rule: **events are imperative commands**.
/// See CODING_GUIDELINES.md §2.4.6.
@freezed
sealed class OrdersEvent with _$OrdersEvent {
  /// Load page 1 (from scratch). Safe to call repeatedly; previous
  /// in-flight requests are cancelled by [BaseBloc.swapCancelToken].
  const factory OrdersEvent.load() = LoadOrders;

  /// Pull-to-refresh alias for [LoadOrders]. Kept as a distinct event so
  /// widget listeners can react to "refresh completed" separately from
  /// "initial load completed" if needed.
  const factory OrdersEvent.refresh() = RefreshOrders;

  /// Append the next page to the currently-loaded list. Ignored if the
  /// list has already reached the end or the current state is not
  /// `OrdersLoaded`.
  const factory OrdersEvent.loadNextPage() = LoadNextOrdersPage;

  /// Clear the one-shot [OrdersState.paginationError] field after the
  /// listener has shown the snackbar.
  const factory OrdersEvent.clearPaginationError() = ClearPaginationError;
}
