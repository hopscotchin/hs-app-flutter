import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../cart/domain/entities/cart_item_detail_entity.dart';
import '../../../../pdp/domain/entities/media_entity.dart';
import '../../../../plp/domain/entities/product_price_entity.dart';
import '../common/order_status_entity.dart';

part 'order_listing_record_entity.freezed.dart';

/// One card on the Orders or Gift Cards listing.
///
/// **One record per order ITEM**, not per order. The redesign dropped
/// order-grouping — no image stacks, no "+N more", no per-card CTA — which also
/// retires v5's worst defect, where an order's items straddling a page boundary
/// broke the grouping.
///
/// A gift-card row is a strict subset: the same keys minus [size]. That is why
/// one entity, one model and one card widget serve both tabs.
///
/// A free gift is an ordinary record too — the backend resolves [title] to
/// "Free Gift", [media] to a gift-box asset and the price to ₹0, and omits
/// [size]. No `isGift` flag reaches the client and nothing branches on one.
@freezed
abstract class OrderListingRecordEntity with _$OrderListingRecordEntity {
  const factory OrderListingRecordEntity({
    /// The parent order. Not unique across rows on the Gift Cards tab.
    @Default('') String orderId,

    /// The row's stable identity — list key, automation key, and what
    /// `track/v3` takes.
    ///
    /// On gift cards this is a backend ask: the v1 wire sends no item id and
    /// `orderId` repeats across rows, so there is nothing unique to key on.
    @Default('') String orderItemId,

    /// Whole-card tap target. Android builds this Intent in the adapter.
    String? actionUri,
    String? actionUriWeb,

    MediaEntity? media,
    String? title,

    /// Display-ready, symbol and separators included. Android renders
    /// `"₹" + amount.toInt()`, dropping paise and the thousands comma
    /// (2493.04 → "₹2493" where the design shows "₹2,493").
    ///
    /// The listing draws `sellingPrice` only — no strikethrough, no discount
    /// badge, even on a free gift whose wire record carries both.
    ProductPriceEntity? priceInfo,

    @Default(0) int quantity,

    /// Absent on every gift card, on a free gift, and whenever the SKU is
    /// "One Size". The backend decides; the client just omits the row.
    String? size,

    /// A single advisory line under the price — "Non returnable & non
    /// exchangeable" and the like — with its own colour and an optional
    /// tooltip. Reuses Cart's [CartItemDetailEntity]: the shape is
    /// {title, titleColor, action}, and order details already sends the same
    /// block as `itemDetails`.
    ///
    /// Was `itemMessageBar` on the v5 wire, where the client picked the colour
    /// and the tooltip copy. Both arrive resolved now.
    CartItemDetailEntity? itemDetails,

    OrderStatusEntity? status,
  }) = _OrderListingRecordEntity;
}

extension OrderListingRecordEntityX on OrderListingRecordEntity {
  /// Falls back to [orderId] so a row is never keyless, even if the gift-card
  /// id ask has not shipped. Duplicate keys degrade list diffing; a missing
  /// key throws.
  String get stableKey => orderItemId.isNotEmpty ? orderItemId : orderId;

  bool get hasSize => size != null && size!.isNotEmpty;
  bool get isTappable => actionUri != null && actionUri!.isNotEmpty;
}
