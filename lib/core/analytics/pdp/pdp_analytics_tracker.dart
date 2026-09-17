import 'dart:async';

import 'package:injectable/injectable.dart';

import '../constants/analytics_defaults.dart';
import '../events/analytics_helper.dart';
import '../events/modules/pdp_events.dart';
import '../events/modules/wishlist_events.dart';
import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../../../features/plp/domain/entities/listing_product_entity.dart';
import '../../../features/pdp/domain/entities/color_variants_entity.dart';
import '../../../features/pdp/domain/entities/detail_entity.dart';
import '../../../features/pdp/domain/entities/offer_entity.dart';
import '../../../features/pdp/domain/entities/tile_entity.dart';
import '../../../features/pdp/domain/entities/pdp_entry_args.dart';
import '../../../features/pdp/domain/entities/pincode_check_entity.dart';
import '../../../features/pdp/domain/entities/product_detail_entity.dart';
import '../../../features/pdp/domain/entities/product_entity.dart';
import '../../../features/pdp/domain/entities/sku_entity.dart';

/// Screen-scoped analytics state for one PDP visit.
///
/// Ports the mutable fields of Android `PDPAnalytics` (`:35-49`) — the
/// suppression flags and high-water marks that decide whether an event fires at
/// all. Twelve of the twenty-two PDP events are guarded by state held here.
///
/// **Why this isn't in `PdpState`:** these are not view state. Putting them in
/// the Bloc state would drag them into the rebuild graph and push tracking onto
/// state emissions rather than user actions — the exact anti-pattern the
/// analytics conventions call out ("wire `track()` to the action, not the
/// state"). This mirrors the role `HomeTrackAnalyticManager` plays for
/// Discover/LP.
///
/// **`@injectable`, not `@lazySingleton`** — one instance per PDP route. Two
/// stacked PDPs must not share suppression state.
///
/// Callers pass semantic signals (`onSizeSelected`, `onImagePageSettled`); the
/// tracker decides whether that translates into an event. Nothing here awaits:
/// analytics must never sit in the user-facing path.
@injectable
class PdpAnalyticsTracker {
  PdpAnalyticsTracker(this._analytics);

  final AnalyticsHelper _analytics;

  // ─── Entry context — set once, survives PID refresh ─────────────────

  PdpEntryArgs _entry = const PdpEntryArgs();
  PdpEntryArgs get entry => _entry;

  // ─── Per-PID state — reset by [onPidRefreshed] ──────────────────────

  ProductDetailEntity? _detail;
  ProductEntity? get _product => _detail?.product;

  /// Guards `size_selected`: Android only fires when the SKU actually changes
  /// (`PDPAnalytics.kt:192-215`).
  SkuEntity? _currentSku;

  /// Distinct carousel pages the user settled on. Excludes the initial page —
  /// `onPageChanged` doesn't fire for it, matching Android's
  /// `uniqueImagePositions`, which is only populated on scroll-idle.
  final Set<int> _settledImagePages = <int>{};

  /// High-water mark for `pdp_images_scrolled`. Starts at 1, not 0 — Android's
  /// `pdpImagesMaxViewCount` does the same, which is what makes the `> 1` guard
  /// suppress the no-swipe case.
  int _imagesHighWater = 1;

  /// Highest carousel index the recently-viewed rail has settled on, and the
  /// size of that rail. Reported **on exit**, not per scroll — Android
  /// reads `lastImagePositionAfterScroll` from a lifecycle `onStop`
  /// (`RecentlyViewedProductsView.kt:43-45`).
  int _recentlyViewedPosition = 0;

  /// The rail's own `trackingMeta`, held so the scroll event — which flushes on
  /// exit — can chain the same node the load event did. `feed_size` lives in it;
  /// the tracker never reads the key.
  Map<String, dynamic>? _recentlyViewedRailMeta;

  /// High-water mark for `recently_viewed_products_scrolled`, mirroring
  /// `recentlyViewedMaxScrollCount` (`PDPAnalytics.kt:43,372-373`). Android
  /// re-sends the event whenever a later `onStop` reports a deeper scroll, so a
  /// boolean "already sent" latch under-counted against it: scroll to 3,
  /// background, return, scroll to 8, pop — Android sends 3 then 8.
  int _recentlyViewedScrollHighWater = 0;

  /// `reco_viewed` fires at most once per screen. **Not** reset on PID refresh —
  /// Android's flag lives on the scroll handler, which outlives `refreshPID`.
  bool _sentRecoViewed = false;

  /// Direction of the most recent page scroll, fed by [onContentScrolled].
  ///
  /// Starts `false` so a reco rail that is somehow on screen without the user
  /// ever scrolling reports nothing — Android's handler only runs from a scroll
  /// callback, so it cannot fire in that case either. Like [_sentRecoViewed],
  /// it is **not** reset on PID refresh.
  bool _lastScrollWasDown = false;

  /// `recently_viewed_products_loaded` fires once per PID, and only once the
  /// rail is **actually visible** — Android gates it on
  /// `isVisibleOnScreen()`, not on the data arriving
  /// (`RecentlyViewedProductsView.kt:97-108`).
  bool _sentRecentlyViewedLoaded = false;

  /// Tracks the last detail-tab index so expand/collapse can be distinguished.
  int _expandedDetailTab = -1;

  // ─── Lifecycle ──────────────────────────────────────────────────────

  /// Call once, from the route builder, before the first load.
  void setEntryArgs(PdpEntryArgs args) => _entry = args;

  /// Product payload arrived → `product_viewed`.
  ///
  /// Safe to call on every successful load: a colour switch routes through
  /// [onPidRefreshed] first, which is what makes the second `product_viewed`
  /// correct rather than duplicated.
  /// `from_pincode` is no longer passed in: it arrives on
  /// `product.trackingMeta`, echoed back by the endpoint the request was made
  /// with. A pincode change must therefore return an updated product node — see
  /// the spec's section 5.
  void onProductLoaded(ProductDetailEntity detail) {
    _detail = detail;
    final product = detail.product;
    if (product == null) return;
    unawaited(
      _analytics.logProductViewed(
        product: product,
        entry: _entry,
        offersTrackingMeta: detail.offersTrackingMeta,
      ),
    );
  }

  /// Keeps the cached payload in sync when the Bloc mutates it without a
  /// reload (pincode verify rewrites EDD, add-to-bag flips `isAddedToBag`).
  /// Fires nothing.
  void syncDetail(ProductDetailEntity detail) => _detail = detail;

  /// Colour variant chosen → reset the per-PID slice.
  ///
  /// Ports `PDPAnalytics.refreshPID` (`:103-111`) exactly, including the two
  /// asymmetries: `_imagesHighWater` resets to **1** (not 0), and entry args are
  /// **preserved** — the funnel that brought the user in still applies.
  ///
  /// `_sentRecoViewed` is also preserved: Android's equivalent lives on the
  /// scroll handler, which `refreshPID` does not touch.
  void onPidRefreshed() {
    _currentSku = null;
    _settledImagePages.clear();
    _imagesHighWater = 1;
    _recentlyViewedPosition = 0;
    _recentlyViewedRailMeta = null;
    _recentlyViewedScrollHighWater = 0;
    _sentRecentlyViewedLoaded = false;
    _expandedDetailTab = -1;
    _detail = null;
  }

  /// Route pop or app pause → flush `pdp_images_scrolled`.
  ///
  /// Android fires this from `Activity.onStop`, so it must run on background as
  /// well as on exit. Idempotent via the high-water mark: a pause followed by an
  /// exit with no further swiping emits once.
  void flushImagesScrolled() {
    final product = _product;
    if (product == null) return;
    final settled = _settledImagePages.length;
    final reported = settled + 1;
    // Android: `count > 1 && count > pdpImagesMaxViewCount`.
    if (reported <= 1 || reported <= _imagesHighWater) return;
    _imagesHighWater = reported;
    unawaited(_analytics.logPdpImagesScrolled(product: product, uniqueImagesScrolled: settled));
  }

  // ─── View-only signals ──────────────────────────────────────────────

  /// Carousel settled on [pageIndex]. Records only; the event flushes on exit.
  void onImagePageSettled(int pageIndex) => _settledImagePages.add(pageIndex);

  /// The page scrolled. Records direction only — Android's `reco_viewed` gate
  /// reads it (`AnalyticsScrollHandler.kt:28`, `if (!scrolledDown) return`).
  ///
  /// Recorded from the scroll callback rather than sampled inside
  /// [onRecoRailVisible], because the visibility signal there is debounced: by
  /// the time it arrives the scroll has often gone idle, and an instantaneous
  /// read would report "not scrolling" and drop the event.
  void onContentScrolled({required bool down}) => _lastScrollWasDown = down;

  /// Reco rail scrolled into view. Fires `reco_viewed` at most once per screen,
  /// and only while scrolling **down** — Android returns early otherwise, so a
  /// rail that first appears as the user scrolls back up reports nothing.
  void onRecoRailVisible(Map<String, dynamic>? railTrackingMeta) {
    final product = _product;
    if (product == null || _sentRecoViewed || !_lastScrollWasDown) return;
    _sentRecoViewed = true;
    unawaited(_analytics.logRecoViewed(product: product, railTrackingMeta: railTrackingMeta));
  }

  /// Recently-viewed rail became **visible on screen**.
  ///
  /// ⚠️ Not "rendered" — Android fires `recently_viewed_products_loaded` from
  /// `checkViewVisibilityOnScreen()`, gated on `isVisibleOnScreen()` plus a
  /// `hasTrackedView` flag (`RecentlyViewedProductsView.kt:97-108`). Firing on
  /// render instead would over-count every user who never scrolls that far.
  ///
  /// Also records [feedSize] for the scroll event, which reports on exit.
  void onRecentlyViewedRailVisible(Map<String, dynamic>? railTrackingMeta) {
    _recentlyViewedRailMeta = railTrackingMeta;
    final product = _product;
    if (product == null || _sentRecentlyViewedLoaded) return;
    // Android's guard was `feedSize > 0`, a client-side count. The node is the
    // equivalent: no rail block means no rail.
    if (railTrackingMeta == null || railTrackingMeta.isEmpty) return;
    _sentRecentlyViewedLoaded = true;
    unawaited(
      _analytics.logRecentlyViewedProductsLoaded(
        product: product,
        railTrackingMeta: railTrackingMeta,
      ),
    );
  }

  /// Recently-viewed carousel settled on [index]. **Records only** — the event
  /// flushes on exit via [flushRecentlyViewedScrolled].
  ///
  /// Monotonic, mirroring the carousel field Android reads:
  /// `lastImagePositionAfterScroll` has a `set` that ignores anything not
  /// greater than the current value (`CarouselView.kt:49-56`), so scrolling back
  /// never lowers it.
  void onRecentlyViewedSettled(int index) {
    if (index > _recentlyViewedPosition) _recentlyViewedPosition = index;
  }

  /// Flushes `recently_viewed_products_scrolled`. Called on route pop / app
  /// pause alongside [flushImagesScrolled] — Android fires both from `onStop`.
  ///
  /// The reported depth is `position + 1` **unless the position is zero**, which
  /// is the getter Android reads:
  /// `get() = if (field != 0) field + 1 else field` (`CarouselView.kt:50`).
  /// A zero then fails the `scrollDepth > 0` guard, so a user who never scrolled
  /// the rail produces no event.
  void flushRecentlyViewedScrolled() {
    final product = _product;
    if (product == null) return;
    final railMeta = _recentlyViewedRailMeta;
    if (railMeta == null || railMeta.isEmpty) return;
    final depth = _recentlyViewedPosition != 0 ? _recentlyViewedPosition + 1 : 0;
    // Android: `scrollDepth > 0 && scrollDepth > recentlyViewedMaxScrollCount`.
    if (depth <= 0 || depth <= _recentlyViewedScrollHighWater) return;
    _recentlyViewedScrollHighWater = depth;
    unawaited(
      _analytics.logRecentlyViewedProductsScrolled(
        product: product,
        scrollDepth: depth,
        railTrackingMeta: railMeta,
      ),
    );
  }

  /// Offers carousel scrolled.
  void onCouponCarouselScrolled() => _fireWithProduct(
    (product) => _analytics.logCouponCodeScrolled(
      product: product,
      offersTrackingMeta: _detail?.offersTrackingMeta,
    ),
  );

  // ─── User actions ───────────────────────────────────────────────────

  void onShareTapped() => _fireWithProduct(_analytics.logProductShareClicked);

  void onSizeChartOpened() => _fireWithProduct(_analytics.logSizeChartClicked);

  void onPincodeSheetOpened() => _fireWithProduct(_analytics.logPincodeFormOpened);

  /// Wishlist added, once the server has confirmed it. The cubit owns that gate,
  /// so a failed request and a logged-out tap report nothing.
  ///
  /// Emits through `WishlistEvents`, not a PDP-local payload, so PDP main, its two
  /// rails, PLP and home all send **one shape** (Android sends three,
  /// and PDP's is the only one without `from_location` or `from_screen`). Every
  /// added key is additive.
  ///
  /// [selectedSku] is passed in rather than read from [_currentSku]: that field is
  /// the `size_selected` change-guard and stays null until the user touches the
  /// selector, while a product can arrive with a size already chosen.
  void onWishlistAdded({SkuEntity? selectedSku}) => _fireWishlist(selectedSku, added: true);

  /// Wishlist removed, once the server has confirmed it.
  ///
  /// Android's `hspdp` module emits nothing here, but the **old** PDP does
  /// (`ProductDetailPageActivityNew.java:4966`), so this restores `hsapp`'s
  /// behaviour rather than diverging from it.
  void onWishlistRemoved({SkuEntity? selectedSku}) => _fireWishlist(selectedSku, added: false);

  /// Both blocks go through untouched: the product's, and the selected size's for
  /// `sku` and `low_inventory`. `source_tile_type` stays null — this is a page.
  void _fireWishlist(SkuEntity? selectedSku, {required bool added}) {
    final product = _product;
    if (product == null) return;
    final fire = added
        ? _analytics.logProductAddedToWishlist
        : _analytics.logProductRemovedFromWishlist;
    unawaited(
      fire(
        productId: product.id?.toString() ?? '',
        fromScreen: FromScreens.product,
        trackingMeta: product.trackingMeta,
        skuTrackingMeta: selectedSku?.trackingMeta,
      ),
    );
  }

  /// Size chosen, from the inline selector or the bottom sheet.
  ///
  /// Applies Android's change-guard: the first selection fires, and afterwards
  /// only a genuinely different SKU does. Re-tapping the selected size emits
  /// nothing.
  void onSizeSelected({required SkuEntity sku, required String fromLocation}) {
    final product = _product;
    if (product == null) return;
    if (_currentSku != null && _currentSku!.skuId == sku.skuId) return;
    _currentSku = sku;
    unawaited(_analytics.logSizeSelected(product: product, fromLocation: fromLocation, sku: sku));
  }

  /// Detail tab tapped. [tabIndex] is the Bloc's post-toggle value: `-1` means
  /// the section collapsed.
  ///
  /// Reproduces Android's ordering: on expand, `product_details_expanded`
  /// **then** `product_details_tab_clicked`; on a tab switch while already open,
  /// only `product_details_tab_clicked`; on collapse, only
  /// `product_details_collapsed`.
  Future<void> onDetailTabToggled({required int tabIndex, required DetailEntity? tab}) async {
    final product = _product;
    if (product == null) return;
    final wasCollapsed = _expandedDetailTab < 0;
    _expandedDetailTab = tabIndex;

    if (tabIndex < 0) {
      await _analytics.logProductDetailsCollapsed(product);
      return;
    }
    // Sequential, not fire-and-forget: the two events must land in this order.
    if (wasCollapsed) {
      await _analytics.logProductDetailsExpanded(product);
    }
    await _analytics.logProductDetailsTabClicked(product: product, tab: tab);
  }

  /// Pincode verification settled.
  ///
  /// ⚠️ Reads **`isServiceable`**, not `action` — Android branches on the former
  /// (`PinCodeSelectionDialog.kt:145`). And a **null** `isServiceable` fires
  /// **no event**, because Android's `?.let` skips. A `?? false` here would
  /// invent `pincode_change` events Android never sends.
  void onPincodeVerified(PincodeCheckEntity result) {
    final product = _product;
    if (product == null) return;
    final serviceable = result.isServiceable;
    if (serviceable == null) return;
    unawaited(_analytics.logPincodeChange(product: product, serviceable: serviceable));
  }

  /// Pincode verification failed at the transport level — Android's `UIError`
  /// branch, which reports `"failure"`.
  void onPincodeVerifyFailed() => _fireWithProduct(
    (product) => _analytics.logPincodeChange(product: product, serviceable: false),
  );

  /// Offer card tapped. [callToAction] is the button label, or
  /// [AnalyticsDefaults.couponCodeCopied] when the code was copied.
  void onCouponCodeTapped({required String? callToAction, required OfferEntity? offer}) =>
      _fireWithProduct(
        (product) => _analytics.logCouponCodeClicked(
          product: product,
          offer: offer,
          offersTrackingMeta: _detail?.offersTrackingMeta,
          callToAction: callToAction,
        ),
      );

  /// Colour variant chosen.
  ///
  /// Fires **before** [onPidRefreshed], so the payload still describes the
  /// outgoing product — matching Android, where `sendEventNewColorSelected`
  /// runs before `refreshPID` (`ProductDetailActivity.kt:304-305`).
  void onColourVariantSelected(ColorVariantEntity? variant) {
    final product = _product;
    if (product == null) return;
    unawaited(_analytics.logNewColorSelected(product: product, variant: variant));
  }

  /// Add-to-bag succeeded. Fires on success only.
  void onAddedToCart(SkuEntity? selectedSku) {
    final product = _product;
    if (product == null) return;
    unawaited(
      _analytics.logProductAddedToCart(
        product: product,
        entry: _entry,
        selectedSku: selectedSku ?? _currentSku,
      ),
    );
  }

  /// Buy-now tapped.
  ///
  /// ⚠️ Fires **on tap, before** the network call. A failed buy-now therefore
  /// emits this with no `product_added_to_cart` — matching
  /// `ProductDetailActivity.kt:205`. Do not move this into the success branch.
  void onBuyNowTapped({SkuEntity? selectedSku}) {
    final product = _product;
    if (product == null) return;
    unawaited(
      _analytics.logBuyNowClicked(product: product, selectedSku: selectedSku ?? _currentSku),
    );
  }

  void onRecoTileTapped(TileEntity tile) =>
      _fireWithProduct((product) => _analytics.logRecoProductClicked(product: product, tile: tile));

  void onRecentlyViewedTileTapped(TileEntity tile) => _fireWithProduct(
    (product) => _analytics.logRecentlyViewedProductsClicked(product: product, tile: tile),
  );

  /// A heart on the **reco** rail. The payload describes the *tile*, not the PDP
  /// being viewed — the user wishlisted that product, not this one.
  ///
  /// `from_screen` stays `Product details` because that is where the user is; the
  /// rail is identified by `from_location`. All three PDP surfaces share the screen
  /// name, so `from_location` is the only thing separating them — which is exactly
  /// the property Android's PDP payload omits.
  ///
  /// No `_fireWithProduct`: this does not need the loaded PDP at all, so it still
  /// reports if the rail outlives the product state.
  void onRecoTileWishlisted(ListingProductEntity item, {required bool added}) =>
      _fireTileWishlist(item, added: added, fromLocation: FromLocations.recoSection);

  /// A heart on the **recently-viewed** rail. See [onRecoTileWishlisted].
  void onRecentlyViewedTileWishlisted(PageCarouselTile tile, {required bool added}) {
    final product = tile.product;
    if (product == null) return;
    _fireTileWishlist(product, added: added, fromLocation: FromLocations.recentlyViewedSection);
  }

  /// `from_screen` stays `Product details` for both rails — the user is on the PDP,
  /// and `from_location` is what separates them.
  void _fireTileWishlist(
    ListingProductEntity item, {
    required bool added,
    required String fromLocation,
  }) {
    final fire = added
        ? _analytics.logProductAddedToWishlist
        : _analytics.logProductRemovedFromWishlist;
    unawaited(
      fire(
        productId: item.id.toString(),
        fromScreen: FromScreens.product,
        fromLocation: fromLocation,
        trackingMeta: item.trackingMeta,
      ),
    );
  }

  // ─── Internals ──────────────────────────────────────────────────────
  void _fireWithProduct(Future<void> Function(ProductEntity) fire) {
    final product = _product;
    if (product == null) return;
    unawaited(fire(product));
  }
}
