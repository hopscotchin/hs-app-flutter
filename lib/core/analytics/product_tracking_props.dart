import 'analytics_map.dart';
import 'constants/analytics_properties.dart';

/// Maps one entry of the cart response's `trackingData.itemLevelTrackingData`
/// — keyed by SKU — onto analytics wire keys.
///
/// The block is the attribution and merchandising the backend stamped on that
/// line **at add-to-cart time**, so it describes the journey *that item* took,
/// not the one the user is on now.
///
/// **Mapped, not forwarded.** Unlike the cart-level and `wishlistInfo` blocks,
/// this one carries the backend's own field names (`merchType`, `country`,
/// `atcSite`, …) and shares almost none with the keys the events emit. Spreading
/// it raw put `merchType` and `atcSite` on the wire where the dashboards read
/// `merch_type` and `atc_site`, and never produced `v_country` at all.
///
/// Ports `AnalyticsHelper.setProductOrderedData(sku)`
/// (`AnalyticsHelper.java:1171-1312`).
class ProductTrackingProps {
  ProductTrackingProps._();

  // ── Backend field names, as Gson serialises them ────────────────────────
  // None of these carry an `@SerializedName` on Android's `ProductTrackingData`,
  // so the wire key is the Java field name verbatim. Named here so a backend
  // rename breaks in one place.
  static const String _merchType = 'merchType';
  static const String _country = 'country';
  static const String _hbt = 'hbt';
  static const String _taste = 'taste';
  static const String _season = 'season';
  static const String _style = 'style';
  static const String _pattern = 'pattern';
  static const String _character = 'character';
  static const String _weave = 'weave';

  /// The nine merchandising attributes, and nothing else.
  ///
  /// This is the exact set `CartObserver.handleProductWishListedEvent`
  /// (`CartObserver.kt:92-100`) lifts out of `setProductOrderedData` for
  /// `product_added_to_wishlist`. Android reads the full block and then
  /// cherry-picks these nine, deliberately dropping the ~30 attribution, LP and
  /// UTM keys — a move-to-wishlist reports *what the product is*, not the
  /// funnel that first put it in the bag.
  ///
  /// `country` → `v_country` is the one genuine rename in the set.
  static Map<String, Object?> merchandising(Map<String, dynamic>? block) {
    if (block == null || block.isEmpty) return const {};
    return <String, Object?>{}
      ..putAnalyticsKey(AnalyticsProperties.taste, block[_taste])
      ..putAnalyticsKey(AnalyticsProperties.hbt, block[_hbt])
      ..putAnalyticsKey(AnalyticsProperties.merchType, block[_merchType])
      ..putAnalyticsKey(AnalyticsProperties.country, block[_country])
      ..putAnalyticsKey(AnalyticsProperties.style, block[_style])
      ..putAnalyticsKey(AnalyticsProperties.season, block[_season])
      ..putAnalyticsKey(AnalyticsProperties.pattern, block[_pattern])
      ..putAnalyticsKey(AnalyticsProperties.character, block[_character])
      ..putAnalyticsKey(AnalyticsProperties.weave, block[_weave]);
  }
}
