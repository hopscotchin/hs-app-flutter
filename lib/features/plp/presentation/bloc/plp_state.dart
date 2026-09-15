part of 'plp_bloc.dart';

enum PlpStatus { initial, loading, loaded, error, empty }

@freezed
abstract class PlpState with _$PlpState {
  const factory PlpState({
    @Default(PlpStatus.initial) PlpStatus status,
    @Default([]) List<ListingProductEntity> products,
    @Default([]) List<PlpListItem> listItems,
    int? totalRecords,
    @Default(0) int currentPage,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    PlpFilterEntity? plpFilter,
    @Default([]) List<BannerEntity> banners,
    @Default({}) Map<String, String> appliedFilters,
    String? screenName,
    String? screenSubtitle,
    String? errorMessage,
    QueryCorrectionEntity? queryCorrection,
    int? currentOrderRule,
    @Default(<MessageBarEntity>[]) List<MessageBarEntity> messageBars,

    /// Which kind of listing this is. Retained from [LoadPlpData] because
    /// analytics needs it: `from_page` on every PDP event is `"boutique"` for a
    /// boutique and `"plp"` for a category listing, and Android distinguishes
    /// them (`PLPProductViewModel.java:171` vs
    /// `ProductListPageActivity.java:794`). Nothing else reads it — the query
    /// builder keeps its own copy for endpoint selection.
    @Default(PageType.plp) PageType pageType,

    /// Page-level analytics blob from the listing response, forwarded to
    /// Segment verbatim. Never read by the UI — it exists so analytics
    /// events fired from this bloc can spread it into their payload.
    /// See PLP_ANALYTICS_BACKEND_CONTRACT.md.
    Map<String, dynamic>? trackingMeta,

    /// Page-level order-attribution blob from the listing response. Pushed
    /// into `ProductAttributionHelper` on tile tap alongside the product's
    /// own trackingMeta so the product-click history keeps the listing's
    /// funnel context.
    Map<String, dynamic>? orderAttribution,

  }) = _PlpState;
}

extension PlpStateX on PlpState {
  bool get hasProducts => products.isNotEmpty;

  /// Merged analytics blob spread onto every PLP event — [orderAttribution]
  /// first, [trackingMeta] wins on collision. Returns `null` when both
  /// backend sources are absent so downstream `putAllAnalyticsKeys` no-ops.
  Map<String, dynamic>? get plpAnalyticsMeta {
    return <String, dynamic>{...?orderAttribution, ...?trackingMeta};
  }

  /// How many products this listing holds in total — the full count, not the
  /// loaded page. Mirrors Android's `totalProductCount`; falls back to what is
  /// loaded so far when the response omits it.
  int get feedSize => totalRecords ?? products.length;

  /// The analytics entry context handed to PDP when a tile on this listing is
  /// tapped.
  ///
  /// Describes the **listing**, not the tapped product — which is why it takes
  /// no arguments. Every field is a fact about this page, and the PLP is the
  /// only screen that knows them.
  ///
  /// Without it, PDP falls back to `const PdpEntryArgs()` and three properties
  /// silently vanish from all 22 PDP events — `from_screen`, `from_page` and
  /// `from_feed_size`. Nothing errors; the funnel just loses its origin.
  ///
  /// Ports Android's listing → PDP handoff
  /// (`hsapp/.../ProductListPageActivity.java:793-830`, which builds the bundle
  /// via `IntentHelper.buildNewPDPAnalyticsData`).
  ///
  /// | Property | Android | Here |
  /// |---|---|---|
  /// | `from_screen` | `plpName` / `boutiqueName`, else the literal | [screenName], falling back to `FromScreens.plp` — see the gap note |
  /// | `from_page` | `"plp"` (`:794`), `"boutique"` (`PLPProductViewModel.java:171`), or `R.string.search` (`:796`) | [pageType], mapped below |
  /// | `from_feed_size` | `totalProductCount` | [feedSize] |
  ///
  /// Android also sends `position` and `source_tile_type` on this hop
  /// (`:829`), which [PdpEntryArgs] no longer models — dropped by develop's PDP
  /// analytics rework, not here.
  ///
  /// Lives here rather than on [PdpEntryArgs] because a `PdpEntryArgs.fromPlp`
  /// factory would make `pdp/domain` depend on `plp/domain` for [PageType] —
  /// the wrong direction. PDP is also entered from reco, deeplinks and nothing
  /// at all, so it must stay ignorant of listings. Each source screen owns its
  /// own translation into the shared contract; this is the listing's.
  ///
  /// ⚠️ **A boutique reports `"Boutique Plp"`, not its own name.** Android
  /// sends `salePlanDetail.name` (`"water yellowA"` in a live capture) and only
  /// falls back to the constant; Flutter always hits the fallback, because
  /// [screenName] comes from `pageMeta.pageTitle` and the search endpoint that
  /// serves boutiques does not return it (`plp_repository_impl.dart:34`). The
  /// route can carry a name — `PlpDestination.navigate` forwards
  /// `title ?? categoryName` into `goToPlp` — but the homepage tile call sites
  /// pass none, and [PlpState] does not retain `categoryName`. Closing it needs
  /// a decision on where the boutique's display name comes from, so it is
  /// recorded as a finding rather than guessed at.
  PdpEntryArgs get pdpEntryArgs =>
      PdpEntryArgs(
        fromScreen: plpFromScreen,
        fromPage: switch (pageType) {
          PageType.plp => FromPage.plp,
          PageType.boutique => FromPage.boutique,
          // Android reuses one localised string for both properties here
          // (`fromScreen = fromPage = getString(R.string.search)`).
          PageType.search => FromPage.search,
        },
        fromFeedSize: feedSize
      );

  /// `from_screen` for events fired *on* this listing (as opposed to events
  /// describing how the user arrived at it).
  ///
  /// Android's PLP wishlist events use `pageName` — the listing's own name —
  /// not the entry screen (`PLPAnalytics.logProductAddedToWishList:440`,
  /// `logProductRemovedFromWishlist:489`).
  ///
  /// The fallback is page-type-aware, mirroring Android's
  /// `salePlanDetail?.name ?: FromScreens.BOUTIQUE`
  /// (`ProductListActivity.kt:716`, `:745`). It matters in practice: a
  /// boutique is served by the search endpoint, which returns no `pageTitle`
  /// (`plp_repository_impl.dart:34`), so [screenName] is routinely empty there
  /// and every such event would otherwise report the listing's `"PLP"` rather
  /// than naming the boutique screen at all.
  String get plpFromScreen {
    if (screenName?.isNotEmpty ?? false) return screenName!;
    return pageType == PageType.boutique
        ? FromScreens.boutique
        : FromScreens.plp;
  }

  /// Entry context for a custom-product-tile tap that routes to another
  /// listing. Mirrors Android's CPT branch (`TileAction.java:940-953`):
  /// `FROM_SCREEN` is the current listing's name, `FROM_LOCATION` is the
  /// literal `"Custom product tile"`, and it is the one path that also carries
  /// `POSITION` and `FROM_FEED_SIZE`.
  ///
  /// Shares [pdpEntryArgs]' `from_screen` fallback and its boutique-name
  /// caveat, for the same reason — [screenName] is empty on the search-served
  /// boutique response.
  PlpEntryArgs plpEntryArgs(int index) => PlpEntryArgs(
    fromScreen: plpFromScreen,
    fromLocation: FromLocations.customProductTile,
    position: index + 1,
    fromFeedSize: feedSize,
  );
}
