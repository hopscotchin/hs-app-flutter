import '../../analytics_map.dart';
import '../../analytics_payload_builder.dart';
import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// `product_added_to_wishlist` and `product_removed_from_wishlist`.
///
/// **The backend's `trackingMeta` block IS the payload.** Every product dimension
/// is forwarded exactly as sent — no renaming, no type conversion, no derivation,
/// no defaults. The call site supplies only what the server cannot know: which
/// screen the user was on, which element they tapped, and the product's id.
///
/// That is why these take a `Map` rather than a typed product. A DTO can only carry
/// fields someone has declared, so every new backend dimension would need an app
/// release; and each surface needs a mapper to fill it, which is where renames and
/// entity fallbacks accumulate. Five surfaces fire this event and it belongs to none
/// of them, so a map is also the only shape that keeps feature entities out of
/// `core/`.
///
/// **Assembled by [buildAnalyticsPayload]**, the same builder the PDP events use:
/// the backend nodes are chained product → sku so a size-specific value wins, and
/// the app's journey facts merge last so a `trackingMeta` key can never overwrite
/// them. No by-name guard, because the order does that job.
///
/// **When** these fire is not decided here — `WishlistCubit` calls them from its
/// server-confirmed branches, so an add reports only once the request succeeds, a
/// removal only once it succeeds, and a logged-out tap reports nothing until the
/// deferred action replays after login.
///
/// Android sends **three different payloads** under `product_added_to_wishlist`
/// — PDP 22 keys, PLP 18, cart 27, with only 7 common to all three — and PDP's is
/// the only one omitting `from_location` and `from_screen`, so PDP-originated
/// wishlists are identifiable there only by absence (finding A12).
///
/// ⚠️ **One shape now depends on the BLOCKS agreeing.** The tile blocks name things
/// `category_name` / `product_name` / `brand_name` / `on_sale` where the product
/// block says `category` / `name` / `brand` / `sale`, so a tile-sourced event and a
/// PDP-sourced one carry different keys for the same dimension. Aligning them is a
/// backend change; reconciling them here would be exactly the renaming this channel
/// exists to remove.
extension WishlistEvents on AnalyticsHelper {
  /// Wishlist listing opened. Android fires this from the shared
  /// `WishlistViewModel.loadWishlist` path, which `loadMoreItems()` re-enters
  /// — so initial load, pull-to-refresh, and every paginated page each emit
  /// one. Mirrored: N events per session on a scrolled list is expected.
  Future<void> logWishlistViewed({
    List<Map<String, dynamic>?> trackingMetaChain = const [],
    String? fromScreen,
  }) async {
    // Kick the lifecycle chain — LaunchTimer self-guards, so this only wins
    // when the wishlist is the first viewable screen (push/deeplink entry).
    await logAppLaunched(FromScreens.wishlist);

    await logEvent(
      AnalyticsEvents.wishlistViewed,
      buildAnalyticsPayload(
        nodes: trackingMetaChain,
        payload: <String, Object?>{}
          ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen),
      ),
      attribution: true,
    );
  }

  /// Ports `PLPAnalytics.logProductAddedToWishList` (`:437-484`), the richest of
  /// Android's three shapes.
  ///
  /// [trackingMeta] is the product's or the tile's block; [skuTrackingMeta] the
  /// selected size's, which only PDP main has. Both are chained, the SKU block
  /// second so a size-specific value wins over a product-level one of the same
  /// name.
  Future<void> logProductAddedToWishlist({
    required String productId,
    required String fromScreen,
    Map<String, dynamic>? trackingMeta,
    Map<String, dynamic>? skuTrackingMeta,
    String fromLocation = FromLocations.wishlistButton,
    String? sourceTileType,
  }) => logEvent(
    AnalyticsEvents.productAddedToWishlist,
    buildAnalyticsPayload(
      nodes: [trackingMeta, skuTrackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
        ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
        ..putAnalyticsKey(AnalyticsProperties.productId, productId)
        // Read here rather than passed in, matching Android's
        // `PrefUtils.aTCUserType` — the helper owns the prefs handle.
        ..putAnalyticsKey(AnalyticsProperties.atcUser, prefs.atcUserType),
    ),
    attribution: true,
  );

  /// Move-to-bag on a wishlist tile, after the API confirms the move. Android:
  /// `WishlistViewModel.moveToCart` → `PRODUCT_ADDED_TO_CART` (the same event
  /// name the PDP/PLP use — `from_screen`/`from_location` inside the blob are
  /// what mark it as the wishlist's).
  Future<void> logProductMovedToBag({
    List<Map<String, dynamic>?> trackingMetaChain = const [],
  }) {
    return logEvent(
      AnalyticsEvents.productAddedToCart,
      buildAnalyticsPayload(nodes: trackingMetaChain),
      attribution: true,
    );
  }

  /// Ports `PLPAnalytics.logProductRemovedFromWishlist` (`:486-504`).
  ///
  /// Android emits it from four places: the new PLP (`ProductListViewModel.kt:312`),
  /// and the shared `AnalyticsHelper.logProductRemovedFromWishList` called by the
  /// **old PDP** (`ProductDetailPageActivityNew.java:4966`), the old PLP (`:4203`)
  /// and `PDPAttributeListFragment.kt:358`. Only the new `hspdp` module lacks it —
  /// so emitting from Flutter's PDP restores `hsapp`'s behaviour rather than
  /// diverging from it.
  ///
  /// ⚠️ Android's remove payload is a **subset** of its add payload. This one is not:
  /// it forwards the same block, so it carries every dimension the add event does.
  /// Additive — no existing value moves — and the alternative would be an app-side
  /// allow-list deciding which server keys an event may report, which is the
  /// filtering this channel exists to remove.
  ///
  /// `low_inventory` needs no special handling as a result: it arrives in the block,
  /// `"Sold out"` included, which the client could never compute anyway — Android's
  /// third value needs `canWishList` (`ProductDetailPageActivityNew.java:3395`),
  /// which is not on our entity, so a derivation could only ever produce two of the
  /// three and would quietly empty that bucket.
  Future<void> logProductRemovedFromWishlist({
    required String productId,
    required String fromScreen,
    Map<String, dynamic>? trackingMeta,
    Map<String, dynamic>? skuTrackingMeta,
    String fromLocation = FromLocations.wishlistButton,
    String? sourceTileType,
  }) => logEvent(
    AnalyticsEvents.productRemovedFromWishlist,
    buildAnalyticsPayload(
      nodes: [trackingMeta, skuTrackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
        ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
        ..putAnalyticsKey(AnalyticsProperties.productId, productId)
        // Android sends the literal `NONE` — not a computed status.
        ..putAnalyticsKey(
          AnalyticsProperties.priceStatus,
          AnalyticsDefaults.none,
        ),
    ),
    attribution: true,
  );
}
