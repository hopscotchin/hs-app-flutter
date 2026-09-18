import '../../domain/entities/cart_tracking_meta_entity.dart';
import 'order_details_model.dart';

class CartTrackingMetaModel extends CartTrackingMetaEntity {
  const CartTrackingMetaModel({
    super.analyticsProps,
    super.orderDetails,
    super.itemLevelTrackingData,
  });

  /// Keys lifted out of the block rather than forwarded.
  ///
  /// Both are nested objects belonging to other consumers, and both would reach
  /// Segment as unqueryable maps if left in [CartTrackingMetaEntity.analyticsProps].
  /// Named explicitly rather than filtered by type, so a future nested value is
  /// a visible decision here instead of a silent drop — the contract test
  /// asserts no map survives onto the wire, which is what turns that into a
  /// failure rather than a regression.
  static const String _orderDetailsKey = 'orderDetails';
  static const String _itemLevelTrackingDataKey = 'itemLevelTrackingData';

  factory CartTrackingMetaModel.fromJson(Map<String, dynamic> json) {
    final orderDetailsJson = json[_orderDetailsKey] as Map<String, dynamic>?;
    final itemLevelJson = json[_itemLevelTrackingDataKey] as Map<String, dynamic>?;

    return CartTrackingMetaModel(
      // Everything else, untouched. When the backend moves the derived
      // dimensions into this block (`total_item_price`, `quantity_status`, …)
      // they flow through with no change here.
      analyticsProps: {
        for (final entry in json.entries)
          if (entry.key != _orderDetailsKey && entry.key != _itemLevelTrackingDataKey)
            entry.key: entry.value,
      },
      orderDetails: orderDetailsJson != null ? OrderDetailsModel.fromJson(orderDetailsJson) : null,
      itemLevelTrackingData: itemLevelJson ?? const {},
    );
  }
}
