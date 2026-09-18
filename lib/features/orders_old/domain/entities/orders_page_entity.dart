import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_info_entity.dart';

part 'orders_page_entity.freezed.dart';

@freezed
abstract class OrdersPageEntity with _$OrdersPageEntity {
  const OrdersPageEntity._();

  const factory OrdersPageEntity({
    @Default(0) int totalRecords,
    @Default(<OrderInfoEntity>[]) List<OrderInfoEntity> items,
  }) = _OrdersPageEntity;

  bool get hasReachedEnd => items.length >= totalRecords;

  OrdersPageEntity merge(OrdersPageEntity next) => OrdersPageEntity(
    totalRecords: next.totalRecords,
    items: [...items, ...next.items],
  );
}
