part of 'orders_bloc.dart';

enum OrdersStatus { initial, loading, success, error }

@freezed
abstract class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(OrdersStatus.initial) OrdersStatus status,
    OrdersPageEntity? page,
    @Default(1) int currentPage,
    String? errorMessage,
    @Default(false) bool isLoadingMore,
    // One-shot effect field: non-null only while the listener hasn't cleared
    // it yet. Used exclusively for pagination failures so the existing list
    // stays visible. Full-page errors set [status] to error instead.
    String? paginationError,
  }) = _OrdersState;
}

extension OrdersStateX on OrdersState {
  List<OrderInfoEntity> get orders => page?.items ?? [];
  bool get hasReachedEnd => page?.hasReachedEnd ?? false;
}
