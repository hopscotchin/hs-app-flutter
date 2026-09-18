import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/constants/analytics_properties.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

/// `quantity_status` and `price_status` for a single cart line.
///
/// Both ride on `product_update_clicked` and `product_updated` as **one-element
/// lists** — the same key `cart_viewed` sends as an array across the whole bag,
/// so a dashboard can group on it either way without knowing which event it
/// came from.
///
/// The two are sourced differently on purpose, which is the reason they live
/// side by side here rather than being read from one place:
///
/// - [CartItemAnalytics.quantityStatus] is **computed** from the line. Every
///   input is already on the entity, and the answer has to reflect the row the
///   user just touched — including the optimistic local step that a quantity
///   tap applies before the server has confirmed it.
/// - [CartAnalyticsStatuses.priceStatusAt] is **read from the backend**. It
///   used to be derived from the line's `messageType` (`Info` → `Lower`,
///   `Warning` → `Higher`, else `Same`), but that moved server-side and the
///   field is no longer on the response at all — so there is nothing left to
///   derive it from.
extension CartItemAnalytics on CartItemEntity {
  /// `"0"` when the line cannot be bought, `"Lower"` when the bag holds more
  /// than is still available, `"Available"` otherwise.
  ///
  /// Mirrors `CartAnalytics.getQuantityStatus`. A null [quantity] or
  /// [selectMaxValue] reads as 0, matching Android's `zeroIfNull()` — so a line
  /// with a quantity and no stated maximum reports `"Lower"` rather than
  /// silently passing as available.
  ///
  /// `"0"` is the string, never the number: a numeric zero would be dropped by
  /// Android's own `putAnalyticsKey` filter, so the sold-out bucket is a string
  /// on both platforms.
  String get quantityStatus {
    if (isSoldOut || isSizeSoldOut) return AnalyticsDefaults.zeroQuantity;
    if ((quantity ?? 0) > (selectMaxValue ?? 0)) return AnalyticsDefaults.lower;
    return AnalyticsDefaults.available;
  }
}

extension CartAnalyticsStatuses on CartEntity {
  /// `price_status` for the line at [index], from the cart-level block.
  ///
  /// The block carries one entry per cart line, positionally aligned with
  /// [items] — the same array `cart_viewed` forwards whole. Reading it by
  /// position is what the alignment is for; there is no per-item copy.
  ///
  /// Falls back to [AnalyticsDefaults.same] when the block is absent, shorter
  /// than the cart, or holds a non-string at that slot. That is the value the
  /// old client-side derivation produced for "no price message", so a response
  /// without the block reports what the app would have said anyway rather than
  /// dropping the key and leaving an unattributed gap.
  String priceStatusAt(int index) {
    final raw = trackingMeta?.analyticsProps[AnalyticsProperties.priceStatus];
    if (raw is! List || index < 0 || index >= raw.length) {
      return AnalyticsDefaults.same;
    }
    final value = raw[index];
    return value is String && value.isNotEmpty ? value : AnalyticsDefaults.same;
  }

  /// Position of [sku] in [items], or -1 when the line is already gone.
  int indexOfSku(String? sku) {
    if (sku == null || sku.isEmpty) return -1;
    return items.indexWhere((item) => item.sku == sku);
  }
}
