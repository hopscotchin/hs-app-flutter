import '../../../navigation/nav_destination.dart';
import '../../analytics_map.dart';
import '../../analytics_payload_builder.dart';
import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// PLP events. Android source of truth: `hsplp/.../analytics/PLPAnalytics.kt`;
/// behavioural reference `PLP_ANALYTICS.md`; backend key contract
/// `PLP_ANALYTICS_BACKEND_CONTRACT.md`; field-by-field parity table
/// `PLP_ANALYTICS_FIELD_MAP.md`.
///
/// ## Pass-through design
///
/// Every page-identity key — `plp_type`, `plp_name`, `feed_size`,
/// `product_listing_id/_name`, the boutique block, the doorway block, the
/// search block, `plp` — arrives inside the backend's page-level
/// `trackingMeta` blob and is spread onto the payload untouched. The client
/// only contributes what the backend cannot know: navigation context
/// (`from_screen`, `from_location`, …), the filter entry point
/// (`click_source`), the sort transition, and scroll geometry.
///
/// Two consequences worth internalising:
///
/// * **Adding a key is a backend deploy, not an app release.** Nothing here
///   enumerates the blob's contents.
/// * **Payload keys go through [AnalyticsMap.putAnalyticsKey]**, which drops
///   `null`, numbers `<= 0`, empty strings and empty lists — matching
///   Android's `putAnalyticsKey`. A PLP with no results therefore ships *no*
///   `feed_size` key rather than `feed_size: 0`.
///
/// ## How to read the per-event property manifests
///
/// Each method below documents every property the event carries, tagged with
/// its owner. That is the checklist for verifying a payload, and the list to
/// hand the backend when asking what to put in `trackingMeta`.
///
/// | Tag | Owner | Source |
/// |---|---|---|
/// | `BE` | Backend | inside the `trackingMeta` blob, spread verbatim |
/// | `APP` | This client | nav context, UI interaction, device geometry |
/// | `CORE` | [AnalyticsHelper] | time buckets, `timestamp`, attribution, SDK ids |
///
/// `CORE` keys are stamped on every event and are never listed per-event:
/// `[time] hour_of_day`, `[time] day_of_week`, `[time] day_of_month`,
/// `[time] month_of_year`, `[time] week_of_year`, `timestamp` (absent on
/// scroll events), `afUserId`, `cleverTapId`, plus the attribution merge when
/// `attribution: true`.
extension PlpEvents on AnalyticsHelper {
  // ────────────────────────────────────────────────────────────────────
  //  Listing viewed — five event names, one payload
  // ────────────────────────────────────────────────────────────────────

  /// The listing-viewed family — one of five event names sharing a single
  /// payload builder. Mirrors `PLPAnalytics.logListingViewed` (`:278`).
  ///
  /// Name selection (checked in this order, `PLPAnalytics.kt:285-295`):
  ///
  /// | Condition | Event |
  /// |---|---|
  /// | [isPromo] | `promo_products_viewed` |
  /// | [isReco] or [isSimilarProducts] | `reco_products_viewed` |
  /// | `plpType == 'Product listing'` | `product_listing_viewed` |
  /// | `plpType == 'Boutique'` | `boutique_viewed` |
  /// | otherwise | `products_searched` |
  ///
  /// Fires **once per screen instance** — the caller owns that latch.
  /// Flags: `attribution ✓`.
  ///
  /// ### Properties — common to every plp_type
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `plp_type` | String | BE |
  /// | `feed_size` | int | BE |
  /// | `is_page_xl_tile_eligible` | `"Yes"`/`"No"` | BE |
  /// | `page_eligible_for_clustered_plp` | `"Yes"`/`"No"`, omitted when null | BE |
  /// | `sort_order` | String (`sortName`) | BE |
  /// | `plp` | String — `P<id>` / `B<id>` / search name | BE |
  /// | `from_screen` | String | APP |
  /// | `from_location` | String | APP |
  /// | `from_section` | String | APP |
  /// | `position` | int | APP |
  /// | `add_from_details` | String | APP |
  ///
  /// ### Additional — `plp_type == 'Product listing'`
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `product_listing_id` | int | BE |
  /// | `product_listing_name` | String | BE |
  /// | `product_id` | List\<String\> — first 4 ids | BE |
  ///
  /// ### Additional — `plp_type == 'Boutique'` (skipped when no sale plan)
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `boutique_id` | int | BE |
  /// | `boutique_name` | String | BE |
  /// | `boutique_start_date` | String | BE |
  /// | `boutique_end_date` | String | BE |
  /// | `days_since_boutique_start` | int | BE |
  /// | `boutique_type` | String | BE |
  /// | `product_id` | List\<String\> | BE |
  /// | `row` | int | APP |
  /// | `from_feed_size` | int | APP |
  ///
  /// ### Additional — doorway block (Product listing & Boutique only)
  ///
  /// No doorway → exactly one key: `redirected_from_doorway: false`
  /// (**a real boolean**, not `"No"`). Otherwise all eight: `doorway_id`,
  /// `doorway_name`, `doorway_slice_count`, `doorway_slice_id`,
  /// `collection_name`, `collection_id`, `dominant_pt`,
  /// `redirected_from_doorway: true`. All BE.
  ///
  /// ### Additional — `plp_type == 'Search'`
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | *(suggestion trackingData)* | Map, merged wholesale | BE |
  /// | `promo_code` | String | BE |
  /// | `merch_promo` | `"Yes"`/`"No"` | BE |
  /// | `keyword` \| `category` \| `brand` \| `profile` | String — exactly one | BE |
  /// | `plp_name` | String — `"Search results"` | BE |
  /// | `query_correction` | String, `"none"` fallback | BE |
  /// | `search_result_pids` | List\<String\> — first min(total, 5) | BE |
  /// | `from_screen` | literal `"Search"` | APP |
  /// | `from_section` | String | APP |
  /// | `keyword` | String — the typed query | APP |
  /// | `length` | int | APP |
  /// | `suggestion_index` | int | APP |
  ///
  /// Reco branch adds `reco_type` and re-stamps `plp_type = 'Reco'` (BE).
  /// Similar-products branch sends `product_id` as a **scalar**, not a list.
  ///
  /// ### Promo override
  ///
  /// When [isPromo], Android early-returns a **tight five-key payload** —
  /// `from_screen` (APP), `promo_code`, `merch_promo`, `plp_name`
  /// (= promotion name), `plp_type` (= `'Promotion products'`) — and the
  /// common block never runs. This client cannot enforce that (the blob is
  /// opaque), so **the backend must send the trimmed blob for promo pages.**
  ///
  /// The promo block reaches the wire on **two** Android paths, and only the
  /// first trims:
  ///
  /// 1. `promotionId` non-empty → `getPromotionProperties()` (`:905`) — the
  ///    five-key payload above, event renamed to `promo_products_viewed`.
  /// 2. `plp_type == 'Search'` → `addSearchPageProperties()` (`:836-847`)
  ///    always appends `promo_code` and `merch_promo` (`"Yes"`/`"No"`) from
  ///    `promoPLPSegmentEvents`, on top of the full search payload. Note
  ///    `merch_promo` is present even when there is no promotion at all —
  ///    a null `isMerchRule` yields the literal `"No"`, not an omission.
  ///
  /// A `plp_type == 'Product listing'` page carries **no** promo keys on
  /// Android: `addCommonProductListProperties()` (`:764`) early-returns to the
  /// promo builder or takes the product-listing branch, and that branch never
  /// touches `promoPLPSegmentEvents`. Both paths are backend-owned here.
  Future<void> logListingViewed({
    required String plpType,
    Map<String, dynamic>? trackingMeta,
    bool isPromo = false,
    bool isReco = false,
    bool isSimilarProducts = false,
    String? fromScreen,
    String? fromLocation,
    int? position,
    /// **Boutique only.** Android writes `row` and `from_feed_size` in
    /// `addCommonBoutiqueProperties` (`:828-829`), never in the common block
    /// (`:777-786`) — and that method early-returns when the response carries
    /// no sale-plan detail, so even a boutique without one sends neither.
    /// Pass them only for a boutique; a Product listing or Search payload that
    /// includes them ships keys Android never emits there.
    int? row,
    int? fromFeedSize,
    String? addFromDetails,
    int? suggestionIndex,
    String? keyword,
    Map<String, dynamic>? suggestionTrackingData,
  }) {
    final event = switch (true) {
      _ when isPromo => AnalyticsEvents.promoProductsViewed,
      _ when isReco || isSimilarProducts => AnalyticsEvents.recoProductsViewed,
      _ when plpType == PlpType.productListing => AnalyticsEvents.productListingViewed,
      _ when plpType == PlpType.boutique => AnalyticsEvents.boutiqueViewed,
      _ => AnalyticsEvents.productsSearched,
    };

    return logEvent(
      event,
      _listingProps(
        trackingMeta: trackingMeta,
        fromScreen: fromScreen,
        fromLocation: fromLocation,
        position: position,
        row: row,
        fromFeedSize: fromFeedSize,
        addFromDetails: addFromDetails,
        suggestionIndex: suggestionIndex,
        keyword: keyword,
        suggestionTrackingData: suggestionTrackingData,
      ),
      attribution: true,
    );
  }

  /// Shared builder for [logListingViewed] and [logXlProductCardScrolled] —
  /// Android's `xl_product_card_scrolled` reuses
  /// `addCommonProductListProperties()` wholesale (`:516`).
  Map<String, Object?> _listingProps({
    Map<String, dynamic>? trackingMeta,
    String? fromScreen,
    String? fromLocation,
    int? position,
    int? row,
    int? fromFeedSize,
    String? addFromDetails,
    int? suggestionIndex,
    String? keyword,
    Map<String, dynamic>? suggestionTrackingData,
  }) {
    // Backend blob first so an explicit client value below wins on collision —
    // nav context is authoritative over anything the server guessed about
    // where the user came from. The suggestion blob sits between the two: it is
    // server-shaped like `trackingMeta` but describes *this* navigation, so it
    // overrides the page blob and loses to the explicit keys below (Android
    // orders it the same way, `PLPAnalytics.kt:838`).
    return <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      ..putAllAnalyticsKeys(suggestionTrackingData)
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen)
      ..putAnalyticsKey(AnalyticsProperties.fromLocation, fromLocation)
      ..putAnalyticsKey(AnalyticsProperties.position, position)
      ..putAnalyticsKey(AnalyticsProperties.row, row)
      ..putAnalyticsKey(AnalyticsProperties.fromFeedSize, fromFeedSize)
      ..putAnalyticsKey(AnalyticsProperties.addFromDetails, addFromDetails)
      ..putAnalyticsKey(AnalyticsProperties.suggestionIndex, suggestionIndex)
      ..putAnalyticsKey(AnalyticsProperties.keyword, keyword)
      // Android derives `length` from the query rather than accepting it
      // separately (`PLPAnalytics.kt:877`), so there is nothing for a caller
      // to get out of sync with.
      //
      // Guarded on the keyword being non-empty rather than left to
      // `putAnalyticsKey`: an empty keyword is dropped, but its length is `0`,
      // and this codebase keeps zeros. Ungated, a blank query would ship
      // `length: 0` with no `keyword` beside it — a measurement of nothing.
      ..putAnalyticsKey(
        AnalyticsProperties.length,
        (keyword?.isNotEmpty ?? false) ? keyword!.length : null,
      );
  }

  /// `products_searched` re-fire after a query correction. Mirrors
  /// `PLPAnalytics.addPropertiesAfterQueryCorrection` (`:923`).
  ///
  /// Flags: `attribution ✓`.
  ///
  /// A deliberately **smaller** payload than [logListingViewed] — no
  /// XL-eligible, clustering, suggestion-index, feed-size or promo keys. The
  /// backend blob for this fire should be the trimmed set.
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `keyword` | String — from search params, **not** the raw query | BE |
  /// | `sort_order` | String | BE |
  /// | `search_result_pids` | List\<String\> | BE |
  /// | `plp_type` | String | BE |
  /// | `plp_name` | `"No results"` when 0 records, else `"Search results"` | BE |
  /// | `query_correction` | String — **no `"none"` fallback here** | APP |
  /// | `from_screen` | literal `"Search"` | APP |
  /// | `from_section` | String — 3-way fallback | APP |
  /// | `add_from_details` | String | APP |
  Future<void> logProductsSearchedAfterQueryCorrection({
    Map<String, dynamic>? trackingMeta,
    required String queryCorrection,
    String? addFromDetails,
  }) {
    final props = <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, PlpType.search)
      ..putAnalyticsKey(AnalyticsProperties.addFromDetails, addFromDetails)
      ..putAnalyticsKey(AnalyticsProperties.queryCorrection, queryCorrection);

    return logEvent(AnalyticsEvents.productsSearched, props, attribution: true);
  }

  // ────────────────────────────────────────────────────────────────────
  //  Filter & sort
  // ────────────────────────────────────────────────────────────────────

  /// `filter_clicked`. Mirrors `PLPAnalytics.logFilterCLicked` (`:316`).
  ///
  /// Flags: `attribution ✓`.
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `plp_type` | String | BE |
  /// | `feed_size` | int | BE |
  /// | `product_listing_name` + `plp_name` | String — Product listing only | BE |
  /// | `boutique_name` | String — Boutique only | BE |
  /// | `plp_name` | String — Search only | BE |
  /// | `click_source` | String | APP |
  ///
  /// [clickSource] is one of [FilterClickSource] — `standard_filters`
  /// (default), `genie_filter`, `floating_filter`, `sticky_filter`. It is
  /// client-owned because only the UI knows which control was touched.
  Future<void> logFilterClicked({Map<String, dynamic>? trackingMeta, required String clickSource}) {
    final props = <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      ..putAnalyticsKey(AnalyticsProperties.clickSource, clickSource);

    return logEvent(AnalyticsEvents.filterClicked, props, attribution: true);
  }

  /// `filter_applied` / `filter_cleared`. Mirrors
  /// `PLPAnalytics.logFilterApplied` (`:347`).
  ///
  /// Flags: `filter_applied` → `attribution ✓`; `filter_cleared` →
  /// **`attribution ✗`**. The asymmetry is
  /// Android behaviour (`:378` vs `:386`), not an oversight.
  ///
  /// Fires **after** the listing reloads — the payload reports the *resulting*
  /// feed size, so it cannot fire at tap time.
  ///
  /// The [trackingMeta] passed in is a **merged blob** — the page-level
  /// listing meta with the `/v2/filter` response's own `trackingMeta` layered
  /// on top. Filter-response keys (e.g. `non_preorder_filter`) win on
  /// collision, mirroring the "more specific source wins" convention.
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `from_screen` | String — the **page name**, not a screen enum | BE |
  /// | `feed_size` | int | BE |
  /// | `plp_type` | String | BE |
  /// | `product_listing_name` + `plp_name` / `boutique_name` | String | BE |
  /// | *(filter-response trackingMeta blob)* | — | BE |
  /// | `click_source` | String | APP |
  /// | *(filter segment, below)* | — | BE |
  ///
  /// ### Filter segment map ([filterSegment])
  ///
  /// | Property | Type |
  /// |---|---|
  /// | `<sectionTracking>_filter` | List\<String\> — **dynamic key per section** |
  /// | `filter_attribute` | List\<String\> |
  /// | `filter_attribute_count` | int |
  /// | `filter_section` | List\<String\> — **excludes** `subcategory` / `product_type` sections |
  /// | `filter_section_count` | int |
  /// | `non_preorder_filter` | `"Yes"`/`"No"` — API does not currently supply the source flag |
  ///
  /// The dynamic keys are server-driven (`sectionTracking` arrives on the
  /// filter response), so they are merged generically rather than enumerated.
  Future<void> logFilterApplied({
    required bool isFilterCleared,
    Map<String, dynamic>? trackingMeta,
    required String clickSource,
    Map<String, Object?> filterSegment = const {},
    String? fromScreen,
  }) {
    final props = <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      ..putAllAnalyticsKeys(filterSegment)
      ..putAnalyticsKey(AnalyticsProperties.clickSource, clickSource)
      ..putAnalyticsKey(AnalyticsProperties.fromScreen, fromScreen);

    return logEvent(
      isFilterCleared ? AnalyticsEvents.filterCleared : AnalyticsEvents.filterApplied,
      props,
      attribution: !isFilterCleared,
    );
  }

  /// `sorting_applied`. Mirrors `PLPAnalytics.logSortingApplied` (`:392`).
  /// Fires only when the chosen option's order rule actually differs.
  ///
  /// Flags: `attribution ✓`.
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `plp_type` | String | BE |
  /// | `product_listing_name` + `plp_name` / `boutique_name` | String | BE |
  /// | `from_sort` | String — previous option's `eventSortName` | BE→APP |
  /// | `new_sort` | String — new option's `eventSortName` | BE→APP |
  ///
  /// **`sort_order` and `from_sort`/`new_sort` are different fields.** The
  /// viewed events use `sortName` (the display label); this event uses
  /// `eventSortName`. The backend supplies both on each sort option; the
  /// client composes the from/new pair.
  Future<void> logSortingApplied({
    Map<String, dynamic>? trackingMeta,
    required String fromSort,
    required String newSort,
  }) {
    final props = <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      ..putAnalyticsKey(AnalyticsProperties.fromSort, fromSort)
      ..putAnalyticsKey(AnalyticsProperties.newSort, newSort);

    return logEvent(AnalyticsEvents.sortingApplied, props, attribution: true);
  }

  // ────────────────────────────────────────────────────────────────────
  //  Tile interactions
  // ────────────────────────────────────────────────────────────────────

  /// PLP tile tapped. **Fires no event** — deliberately.
  ///
  /// The tap's job is to install the context the *next* screen needs, so that
  /// `product_viewed`, `product_added_to_cart` and eventually `product_ordered`
  /// carry the funnel that led there. Android does the same: the tile click
  /// writes attribution and navigates; nothing is tracked at tap time.
  ///
  /// ## What gets installed
  ///
  /// A single merged blob pushed onto [ProductAttributionHelper] — the
  /// top-of-stack entry is spread onto every attribution-carrying event
  /// downstream via `AnalyticsHelper._commonEventProperties`.
  ///
  /// * [pageMeta] — the listing's `plpAnalyticsMeta` (root `orderAttribution`
  ///   + `trackingMeta` already merged by the state getter). Without it the
  ///   PDP knows *which product* was tapped but not *which listing* it came
  ///   from.
  /// * [trackingMeta] — the product's blob (`product_id`, `source_tile_type`,
  ///   `position`, …). Wins on collision, being the more specific source.
  ///
  /// ## Why merge here when the Home tile click replaces
  ///
  /// [OrderAttributionHelper.replaceTrackingMeta] exists because two Home tile
  /// types ship *different key shapes* — a Hero click carries `slice_id` and a
  /// CustomTile click does not, so merging would make the CustomTile click look
  /// like it carried Hero's `slice_id`. That reasoning does not transfer to the
  /// PLP for two reasons:
  ///
  /// 1. Every product blob on a listing has the same shape, so there is no
  ///    smaller-blob case to leak through.
  /// 2. The blob already in the store at this moment is the *Home* click that
  ///    brought the user here — `funnel_tile`, `section`, `subsection`,
  ///    `banner_name`, `slice_id`. That is not stale context to be discarded;
  ///    it is the funnel the eventual order has to be attributed to. Replacing
  ///    would silently drop it, and the PDP would report a product with no idea
  ///    how the user reached it.
  ///
  /// A tap is a step *deeper* into a funnel, not a lateral move to a different
  /// one — so it adds to the context rather than substituting for it.
  ///
  /// **Call synchronously and do not await** — navigation starts on the same
  /// frame, and the destination reads attribution during its own build.
  void logPlpTileClicked({
    Map<String, dynamic>? trackingMeta,
    Map<String, dynamic>? pageMeta,
  }) {
    // Root -> leaf: the tile's own trackingMeta wins a collision with the
    // page-level meta it sits inside.
    final merged = buildAnalyticsPayload(nodes: [pageMeta, trackingMeta]);
    if (merged.isEmpty) return;
    // `push` no-ops when there's no active PLP scope, so a Discover
    // home-grid tap flows through here without corrupting an empty stack.
    productAttribution.push(merged);
  }

  /// `xl_product_card_scrolled` — the XL tile's inner carousel was swiped.
  /// Mirrors `PLPAnalytics.logXLProductCardScrolled` (`:514`).
  ///
  /// Flags: `attribution ✓`.
  ///
  /// Carries the **entire listing-viewed common property set** (Android reuses
  /// `addCommonProductListProperties()` verbatim) plus:
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `card_index` | int — **1-based**; the first card reports `1` | APP |
  /// | `swipe_direction` | String | APP |
  ///
  /// `card_index` is 1-based on both platforms — `XlTileViewNew.kt:103` sends
  /// `lastVisibleItemPosition + 1`, and `XLTileWidget` sends `index + 1` — so
  /// it never reaches Android's drop-at-zero rule, and the two agree here
  /// regardless of that rule not being reproduced (see `AnalyticsMap`).
  Future<void> logXlProductCardScrolled({
    Map<String, dynamic>? trackingMeta,
    int? cardIndex,
    String? swipeDirection,
    String? fromScreen,
    String? fromLocation,
    int? position,
    String? addFromDetails,
  }) {
    final props =
        _listingProps(
            trackingMeta: trackingMeta,
            fromScreen: fromScreen,
            fromLocation: fromLocation,
            position: position,
            addFromDetails: addFromDetails,
          )
          ..putAnalyticsKey(AnalyticsProperties.cardIndex, cardIndex)
          ..putAnalyticsKey(AnalyticsProperties.swipeDirection, swipeDirection);

    return logEvent(AnalyticsEvents.xlProductCardScrolled, props, attribution: true);
  }

  // ────────────────────────────────────────────────────────────────────
  //  Search & notification permission
  // ────────────────────────────────────────────────────────────────────

  /// `search_clicked` — the search icon in the PLP toolbar. Mirrors
  /// `AnalyticsHelper.logSearchClickedEvent` (`:1562`) as called from
  /// `ProductListPageActivity.searchProductsListing` (`:3654`).
  ///
  /// Flags: `attribution ✓`.
  ///
  /// | Property | Value | Owner |
  /// |---|---|---|
  /// | `from_screen` | `"Search Plp"`, or `"Search Boutique"` from a boutique | APP |
  /// | `from_location` | `"Search icon"` — supplied by the caller | APP |
  ///
  /// ## Two Android implementations disagree — this follows production
  ///
  /// The newer `hsplp` module puts the **`plp_type`** into `from_screen`
  /// (`PLPAnalytics.logSearchClicked:426`). The `hsapp` screens send a
  /// constant page name instead (`ProductListPageActivity:3654`). Live
  /// payloads show `"Search Plp"`, so the hsapp form is what ships.
  ///
  /// ## The boutique has no Android counterpart
  ///
  /// Android's boutique listing exposes **no search control at all** —
  /// `boutique_plp_menu.xml` inflates only favorite, reminder, cart and
  /// wishlist, which is why `ProductsListingActivity`'s `actionbar_search`
  /// branch (`:1214`) is unreachable. Flutter's boutique app bar does have the
  /// icon, so this event fires where Android never fires it.
  ///
  /// That makes the screen a required argument rather than the hardcoded
  /// `"Search Plp"` it started as: reporting a boutique-originated search as
  /// `"Search Plp"` would silently fold a Flutter-only surface into the
  /// listing's numbers. A boutique sends [FromScreens.searchBoutique], a
  /// Flutter-only value — see its doc for why neither existing screen name fits.
  ///
  /// Both keys come from [SourcePage.analyticsProps], so the
  /// field-to-wire-name mapping is not restated here. Android writes the pair
  /// with a plain `put` (`:1564-1565`); routing through `putAnalyticsKey` would
  /// differ only for an empty value, and the caller supplies constants.
  Future<void> logSearchClicked({
    required SourcePage source,
    Map<String, dynamic>? trackingMeta,
  }) {

    // `trackingMeta` is a node and the source is the payload, so the client
    // keys win a collision. The raw spread had the server blob merging last,
    // which let a `from_screen` in the response overwrite the one this method
    // was given -- the opposite of every other call site's precedence.
    return logEvent(
      AnalyticsEvents.searchClicked,
      buildAnalyticsPayload(
        nodes: [trackingMeta],
        payload: source.analyticsProps,
      ),
      attribution: true,
    );
  }

  /// `notification_permission_accepted` / `notification_permission_rejected`
  /// — the push-permission prompt shown from the PLP. Mirrors
  /// `PLPAnalytics.logNotificationPermission` (`:550`).
  ///
  /// Flags: `attribution ✓`.
  ///
  /// | Property | Value | Owner |
  /// |---|---|---|
  /// | `from_screen` | the **`plp_type`**, not the page name | APP |
  ///
  /// Android writes this with a **raw `put`**, bypassing `putAnalyticsKey`
  /// (`:552`) — so the key ships even when `plp_type` is empty. Mirrored here
  /// with a direct map write rather than [AnalyticsMap.putAnalyticsKey].
  Future<void> logNotificationPermission({required bool accepted, required String plpType}) {
    // Raw write, matching Android — an empty plp_type must still ship the key.
    final props = <String, Object?>{AnalyticsProperties.fromScreen: plpType};

    return logEvent(
      accepted
          ? AnalyticsEvents.notificationPermissionAccepted
          : AnalyticsEvents.notificationPermissionRejected,
      props,
      attribution: true,
    );
  }

  // ────────────────────────────────────────────────────────────────────
  //  Scroll
  // ────────────────────────────────────────────────────────────────────

  /// `plp_scrolled`. Mirrors `PLPAnalytics.sendScrollData` (`:745`) +
  /// `saveScrollMetaData` (`:631`).
  ///
  /// Flags: `attribution ✓`. Dispatched via
  /// [logScrollEvent], so this event carries **no `timestamp`** — matching
  /// Android's scroll contract.
  ///
  /// Note it does **not** require actual scrolling: Android's
  /// `ScrollTrackingHelper.getScrollDepthParams()` also returns params in the
  /// `isUnScrolled && isUnSent` case (`ScrollTrackingHelper.java:74`), so the
  /// event legitimately fires with zero scroll depth. Gate on whether the
  /// tracker produced params, not on a "did the user scroll" flag.
  ///
  /// ### Scroll depth ([scrollDepthParams], from the tracker)
  ///
  /// | Property | Real formula | Owner |
  /// |---|---|---|
  /// | `from_row` | `startScrolledItemIndex + extraRowCount` | APP |
  /// | `scrolled_row` | scrolled row count — **`0` ships** | APP |
  /// | `scrolled_height` | `maxScrolledHeight + extraRowHeight` — **`0` ships on the never-scrolled report** | APP |
  ///
  /// Android writes and merges these three with plain `put`/`putAll`, so its
  /// own drop-at-zero rule never sees them. This codebase keeps zeros anyway,
  /// so the raw spread is belt-and-braces rather than load-bearing — a bounce
  /// off the listing is a real report, and it says the user arrived and left
  /// without scrolling, which is not the same as no event.
  ///
  /// ### Page metadata
  ///
  /// | Property | Type | Owner |
  /// |---|---|---|
  /// | `plp_type`, `plp_name`, `feed_size`, `from_screen` | — | BE |
  /// | `product_listing_name`/`_id` **or** `boutique_name`/`_id` | key chosen by plp_type | BE |
  /// | `screen_height` | int — device display | APP |
  /// | `total_rows` | int — `((totalRecords + 1) / 2) + extraRowCount` | APP |
  ///
  /// ### Viewed-range lists — what the user actually saw
  ///
  /// `brand`, `product_id`, `xl_product_id`, `category`, `subcategory`,
  /// `merch_type`, `product_type` — all APP-owned, derived from rendered
  /// items over the range:
  ///
  /// ```
  /// if start == 0 && end == 0:          [0, itemCount)
  /// else if end*2 <= itemCount:         [start == 1 ? 1 : start*2, end*2)
  /// else:                               [start, itemCount)
  /// ```
  ///
  /// The `*2` is the two-column grid — the tracker counts *rows*, the list
  /// holds *items*. These are de-duplicated **sets**, so they are **not
  /// positionally aligned with each other — do not zip them.**
  Future<void> logPlpScrolled({
    required Map<String, Object?> scrollDepthParams,
    Map<String, dynamic>? trackingMeta,
    int? screenHeight,
    int? totalRows,
    List<String> brand = const [],
    List<String> productIds = const [],
    List<String> xlProductIds = const [],
    List<String> category = const [],
    List<String> subCategory = const [],
    List<String> productType = const [],
    List<String> merchType = const [],
    bool useSavedAttribution = false,
    Map<String, Object>? attribution,
  }) {
    final props = <String, Object?>{}
      ..putAllAnalyticsKeys(trackingMeta)
      // Raw spread, NOT putAllAnalyticsKeys. The scroll-depth trio is the one
      // block Android writes with plain `put`
      // (`ScrollTrackingHelper.getScrollDepthParams:79-88`) and merges with a
      // plain `putAll` (`PLPAnalytics.sendScrollData:748`), so its zeros reach
      // the wire. Filtering them here silently deleted `scrolled_row: 0` and
      // `scrolled_height: 0` from every bounce — exactly the reports that
      // describe a user who opened the listing and left without scrolling, and
      // the tracker had already gone out of its way to emit them.
      ..addAll(scrollDepthParams)
      ..putAnalyticsKey(AnalyticsProperties.screenHeight, screenHeight)
      ..putAnalyticsKey(AnalyticsProperties.totalRows, totalRows)
      ..putAnalyticsKey(AnalyticsProperties.brand, brand)
      ..putAnalyticsKey(AnalyticsProperties.productId, productIds)
      ..putAnalyticsKey(AnalyticsProperties.xlProductId, xlProductIds)
      ..putAnalyticsKey(AnalyticsProperties.category, category)
      ..putAnalyticsKey(AnalyticsProperties.subCategory, subCategory)
      ..putAnalyticsKey(AnalyticsProperties.productType, productType)
      ..putAnalyticsKey(AnalyticsProperties.merchType, merchType)
      ..putAllAnalyticsKeys(attribution);

    return logScrollEvent(
      AnalyticsEvents.plpScrolled,
      props,
      attribution: false,
      useSavedAttribution: useSavedAttribution,
    );
  }
}
