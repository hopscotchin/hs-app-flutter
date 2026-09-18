import 'package:equatable/equatable.dart';

import 'order_details_entity.dart';

/// The cart response's root-level `trackingMeta`, split into the three things
/// it actually holds.
///
/// It is **not** a flat analytics block: alongside the event's own dimensions it
/// carries two nested objects — `orderDetails` and `itemLevelTrackingData` —
/// that belong to other consumers. Forwarding the node whole put both on
/// `cart_viewed` as nested maps, which Segment cannot group on, so the event
/// shipped three unqueryable blobs (`atcUser`, `orderDetails`,
/// `itemLevelTrackingData`) and none of the dimensions it exists to report.
///
/// Splitting it here is what makes the passthrough safe again:
/// [analyticsProps] is the flat remainder and is the whole `cart_viewed`
/// payload, while the two nested objects are parsed out for the consumers that
/// want them.
class CartTrackingMetaEntity extends Equatable {
  /// The flat analytics keys — everything that is not one of the two nested
  /// objects below. **This is the `cart_viewed` payload**, forwarded verbatim:
  /// `total_item_price`, `total_amount`, `shipping`, `net_amount`, `sku_count`,
  /// `total_quantity`, `message_bar`, `cart_filler_reco`, `quantity_status`,
  /// `price_status`, `image_url`, `shipping_minimum`, `atc_user`.
  ///
  /// Kept raw so a new backend dimension reaches the dashboards without an app
  /// release — the reason the block is sent pre-computed in the first place.
  final Map<String, dynamic> analyticsProps;

  /// The `orderDetails` copy nested inside `trackingMeta`.
  ///
  /// Typed rather than left raw because it is read, not forwarded: it is where
  /// the price figures come from when the flat block does not carry them
  /// (`total_item_price` ← `productAmount`, `total_amount` ← `totalAmount`,
  /// `from_shipping` ← `shipping`, `from_net_amount` ← `payAmount`).
  ///
  /// Duplicates the response's top-level `orderDetails`, which
  /// `CartEntity.orderDetails` parses for the UI. This is the analytics copy;
  /// reading it here means an analytics payload cannot be broken by a UI-side
  /// edit to the other.
  final OrderDetailsEntity? orderDetails;

  /// `itemLevelTrackingData`, keyed by SKU — the attribution the backend
  /// stamped on each line at add-to-cart time (funnel, section, plp, atcDate,
  /// atcSite, hbt, taste, season, …).
  ///
  /// A map rather than a typed entity: ~100 backend-owned fields per SKU that
  /// the client never reads by name. It is the source for `product_ordered`'s
  /// per-line enrichment at order time, and is **never** put on a cart event —
  /// a cart event describes the bag, not one line's journey.
  final Map<String, dynamic> itemLevelTrackingData;

  const CartTrackingMetaEntity({
    this.analyticsProps = const {},
    this.orderDetails,
    this.itemLevelTrackingData = const {},
  });

  /// Attribution for one SKU, or null when the response carried none for it.
  Map<String, dynamic>? trackingForSku(String sku) =>
      itemLevelTrackingData[sku] as Map<String, dynamic>?;

  @override
  List<Object?> get props => [analyticsProps, orderDetails, itemLevelTrackingData];
}
