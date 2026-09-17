import '../../../../features/pdp/domain/entities/color_variants_entity.dart';
import '../../../../features/pdp/domain/entities/detail_entity.dart';
import '../../../../features/pdp/domain/entities/offer_entity.dart';
import '../../../../features/pdp/domain/entities/pdp_entry_args.dart';
import '../../../../features/pdp/domain/entities/product_entity.dart';
import '../../../../features/pdp/domain/entities/tile_entity.dart';
import '../../../../features/pdp/domain/entities/sku_entity.dart';
import '../../analytics_map.dart';
import '../../analytics_payload_builder.dart';
import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// PDP events, assembled by **tracking-meta passthrough**.
///
/// Every event is one expression: merge an ordered list of backend
/// `trackingMeta` nodes, then layer on the interaction facts the app owns. No key
/// is read from a node, so a dimension the backend adds reaches Segment on a
/// deploy rather than an app release.
///
/// * Wire contract: `docs/analytics/pdp/contract/passthrough-spec.md`
/// * Per-event chains and build sites: `docs/analytics/pdp/client/tm-collection.md`
///
/// ## Two rules hold this together
///
/// **Node order is the contract.** Deeper nodes win. That is what resolves the
/// one key two nodes share: `product.trackingMeta` carries `sku` as the array of
/// every variant, and `product.skus[sel].trackingMeta` carries it as the single
/// selected id. The product node goes first, so `size_selected` reports the
/// string Android sends. Reverse them and it silently reports all five variants —
/// [buildAnalyticsPayload]'s tests pin both directions.
///
/// **Interaction merges last**, so a server key can never overwrite a value the
/// app computed. Nothing has to hold app-owned keys back by name — the order
/// does it. The wishlist events are assembled the same way.
///
/// **Every PDP event fires with `attribution: true`** — no exceptions. Android's
/// private `send()` sink defaults `isAttributionDataRequired = true` and no call
/// site overrides it (`PDPAnalytics.kt:479-493`).
extension PdpEvents on AnalyticsHelper {
  // ─── Page view ──────────────────────────────────────────────────────

  /// `product_viewed`. Android: `PDPAnalytics.sendProductViewedEvent` (`:113-140`).
  ///
  /// Chain: `product.trackingMeta + offersList.trackingMeta`. `offersList` is on
  /// this event only, which is also the only event that carries
  /// `coupon_applicable` on either platform.
  Future<void> logProductViewed({
    required ProductEntity product,
    required PdpEntryArgs entry,
    Map<String, dynamic>? offersTrackingMeta
  }) => logEvent(
    AnalyticsEvents.productViewed,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, offersTrackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromScreen, entry.fromScreen)
        ..putAnalyticsKey(AnalyticsProperties.fromPage, entry.fromPage)
        ..putAnalyticsKey(AnalyticsProperties.fromFeedSize, entry.fromFeedSize)
    ),
    attribution: true,
  );

  // ─── Image carousel ─────────────────────────────────────────────────

  /// `pdp_images_scrolled`. Fired on route exit / app pause, not per swipe.
  ///
  /// [uniqueImagesScrolled] is the count of **distinct pages the carousel settled
  /// on**, which excludes the initial page because no scroll settles on it — what
  /// Android's carousel exposes (`CarouselView.kt:44-47`, populated only on
  /// `SCROLL_STATE_IDLE`) and what Flutter's `onPageChanged` reports.
  ///
  /// The `+ 1` (`PDPAnalytics.kt:358`) adds the initial image back, so the emitted
  /// value is total distinct images viewed. Compensation, not an off-by-one.
  ///
  /// The `> 1` guard means a user who never swiped produces no event. The
  /// high-water check belongs to the caller, which owns the per-PID mark.
  Future<void> logPdpImagesScrolled({
    required ProductEntity product,
    required int uniqueImagesScrolled,
  }) => logEvent(
    AnalyticsEvents.pdpImagesScrolled,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.uniqueImagesScrolled, uniqueImagesScrolled + 1),
    ),
    attribution: true,
  );

  // ─── Product node only ──────────────────────────────────────────────

  Future<void> logProductShareClicked(ProductEntity product) =>
      _productOnly(AnalyticsEvents.productShareClicked, product);

  Future<void> logSizeChartClicked(ProductEntity product) =>
      _productOnly(AnalyticsEvents.sizeChartClicked, product);

  Future<void> logProductDetailsExpanded(ProductEntity product) =>
      _productOnly(AnalyticsEvents.productDetailsExpanded, product);

  /// `product_details_collapsed`. No tab node: the collapse fires with no tab
  /// selected, so there is nothing to attach.
  Future<void> logProductDetailsCollapsed(ProductEntity product) =>
      _productOnly(AnalyticsEvents.productDetailsCollapsed, product);

  Future<void> logPincodeFormOpened(ProductEntity product) =>
      _productOnly(AnalyticsEvents.pincodeFormOpened, product);

  // ─── Details tabs ───────────────────────────────────────────────────

  /// `product_details_tab_clicked`. Chain adds the tapped tab's node, which is
  /// where `tab_name` comes from.
  ///
  /// ⚠️ `tab_name` is also written by [_tabPageProperties] for tab-page
  /// attribution on `product_viewed` and `product_added_to_cart`. The two never
  /// meet — this event carries no entry args — but they are the same wire key with
  /// two meanings.
  Future<void> logProductDetailsTabClicked({
    required ProductEntity product,
    required DetailEntity? tab,
  }) => logEvent(
    AnalyticsEvents.productDetailsTabClicked,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, tab?.trackingMeta],
    ),
    attribution: true,
  );

  // ─── Pincode ────────────────────────────────────────────────────────

  Future<void> logPincodeChange({required ProductEntity product, required bool serviceable}) =>
      logEvent(
        AnalyticsEvents.pincodeChange,
        buildAnalyticsPayload(
          nodes: [product.trackingMeta, product.orderAttribution],
          payload: <String, Object?>{}
            ..putAnalyticsKey(
              AnalyticsProperties.pincodeCheckStatus,
              serviceable ? AnalyticsDefaults.success : AnalyticsDefaults.failure,
            ),
        ),
        attribution: true,
      );

  // ─── Offers ─────────────────────────────────────────────────────────

  Future<void> logCouponCodeScrolled({
    required ProductEntity product,
    Map<String, dynamic>? offersTrackingMeta,
  }) => logEvent(
    AnalyticsEvents.couponCodeScrolled,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, offersTrackingMeta],
    ),
    attribution: true,
  );

  /// `coupon_code_clicked` — the only three-node chain in the set.
  /// `coupon_code` comes from the tapped offer's node.
  Future<void> logCouponCodeClicked({
    required ProductEntity product,
    required OfferEntity? offer,
    Map<String, dynamic>? offersTrackingMeta,
    String? callToAction,
  }) => logEvent(
    AnalyticsEvents.couponCodeClicked,
    buildAnalyticsPayload(
      nodes: [
        product.trackingMeta,
        product.orderAttribution,
        offersTrackingMeta,
        offer?.trackingMeta,
      ],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.callToAction, callToAction),
    ),
    attribution: true,
  );

  // ─── Rails ──────────────────────────────────────────────────────────

  /// `reco_viewed`. `feed_size` comes from the rail's own node.
  Future<void> logRecoViewed({
    required ProductEntity product,
    Map<String, dynamic>? railTrackingMeta,
  }) => logEvent(
    AnalyticsEvents.recoViewed,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, railTrackingMeta],
    ),
    attribution: true,
  );

  Future<void> logRecentlyViewedProductsLoaded({
    required ProductEntity product,
    Map<String, dynamic>? railTrackingMeta,
  }) => logEvent(
    AnalyticsEvents.recentlyViewedProductsLoaded,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, railTrackingMeta],
    ),
    attribution: true,
  );

  Future<void> logRecentlyViewedProductsScrolled({
    required ProductEntity product,
    required int scrollDepth,
    Map<String, dynamic>? railTrackingMeta,
  }) => logEvent(
    AnalyticsEvents.recentlyViewedProductsScrolled,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, railTrackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.scrollDepth, scrollDepth),
    ),
    attribution: true,
  );

  /// `recently_viewed_products_clicked`. The chain adds the **tile** node, not the
  /// tile's product node.
  ///
  /// The tile node holds the already-prefixed `clicked_product_*` keys. The
  /// product's own node uses unprefixed names, so merging it over the PDP's block
  /// would overwrite `product_id`, `price` and the rest — erasing the source PDP
  /// from its own event. Role comes from which node is chained.
  Future<void> logRecentlyViewedProductsClicked({
    required ProductEntity product,
    required TileEntity tile,
  }) => logEvent(
    AnalyticsEvents.recentlyViewedProductsClicked,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, tile.trackingMeta],
    ),
    attribution: true,
  );

  /// `reco_product_clicked`. Same shape as the recently-viewed click — one chain
  /// builder serves both rails because both tiles carry the same node.
  Future<void> logRecoProductClicked({required ProductEntity product, required TileEntity tile}) =>
      logEvent(
        AnalyticsEvents.recoProductClicked,
        buildAnalyticsPayload(
          nodes: [product.trackingMeta, product.orderAttribution, tile.trackingMeta],
        ),
        attribution: true,
      );

  // ─── Size ───────────────────────────────────────────────────────────

  /// `size_selected`. The sku node is chained **second**, which is what turns the
  /// product node's `sku` array into the selected sku string. See the class doc.
  Future<void> logSizeSelected({
    required ProductEntity product,
    required SkuEntity sku,
    required String fromLocation,
  }) => logEvent(
    AnalyticsEvents.sizeSelected,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, sku.trackingMeta],
      payload: <String, Object?>{}
        ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation),
    ),
    attribution: true,
  );

  // ─── Colour ─────────────────────────────────────────────────────────

  /// `new_color_selected`. Chain adds the tapped variant's node, which is where
  /// `new_product_id_selected` comes from.
  ///
  /// ⚠️ Must be called **before** the PID resets. The product node still has to
  /// describe the PDP being left; once `onPidRefreshed` has run there is no
  /// product and the event is dropped.
  Future<void> logNewColorSelected({
    required ProductEntity product,
    required ColorVariantEntity? variant,
  }) => logEvent(
    AnalyticsEvents.newColorSelected,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, variant?.trackingMeta],
    ),
    attribution: true,
  );

  // ─── Conversion ─────────────────────────────────────────────────────

  Future<void> logProductAddedToCart({
    required ProductEntity product,
    required PdpEntryArgs entry,
    required SkuEntity? selectedSku,
  }) => logEvent(
    AnalyticsEvents.productAddedToCart,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, selectedSku?.trackingMeta]
    ),
    attribution: true,
  );

  /// `buy_now_clicked`.
  ///
  /// Carries the sku node, which Android does not: its `buy_now_clicked` has no
  /// size and no sku at all, so the highest-intent action on the page recorded
  /// less variant detail than the add before it. Deliberate divergence, recorded
  /// in the spec's widenings.
  ///
  /// ⚠️ Fires **on tap, before** the network call, so a failed buy-now emits this
  /// with no `product_added_to_cart` — matching `ProductDetailActivity.kt:205`.
  Future<void> logBuyNowClicked({
    required ProductEntity product,
    required SkuEntity? selectedSku,
  }) => logEvent(
    AnalyticsEvents.buyNowClickedAlt,
    buildAnalyticsPayload(
      nodes: [product.trackingMeta, product.orderAttribution, selectedSku?.trackingMeta],
    ),
    attribution: true,
  );

  Future<void> _productOnly(String event, ProductEntity product) => logEvent(
    event,
    buildAnalyticsPayload(nodes: [product.trackingMeta, product.orderAttribution]),
    attribution: true,
  );
}
