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
  }) = _PlpState;
}

extension PlpStateX on PlpState {
  bool get hasProducts => products.isNotEmpty;

  /// How many products this listing holds in total — the full count, not the
  /// loaded page. Mirrors Android's `totalProductCount`; falls back to what is
  /// loaded so far when the response omits it.
  int get feedSize => totalRecords ?? products.length;

  /// The analytics entry context handed to PDP when the tile for [product] at
  /// flat index [index] is tapped.
  ///
  /// Without it, PDP falls back to `const PdpEntryArgs()` and **four properties
  /// silently vanish** from all 22 PDP events — `from_screen`, `from_page`,
  /// `from_feed_size` and `position` — while `source_tile_type` reports the
  /// `'other'` default. Nothing errors; the funnel just loses its origin.
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
  /// | `position` | `positionTag + 1` — **1-indexed** | `index + 1` |
  /// | `source_tile_type` | `isXLTile ? XL : NORMAL` | same, lowercase — see below |
  ///
  /// Lives here rather than on [PdpEntryArgs] because a `PdpEntryArgs.fromPlp`
  /// factory would make `pdp/domain` depend on `plp/domain` for [PageType] —
  /// the wrong direction. PDP is also entered from reco, deeplinks and nothing
  /// at all, so it must stay ignorant of listings. Each source screen owns its
  /// own translation into the shared contract; this is the listing's.
  ///
  /// ⚠️ **`source_tile_type` casing.** Android has paths that disagree: the old
  /// PLP sends `hsapp`'s `"XL"` / `"Normal"` (`:827`) while `hsplp` and the
  /// boutique path send `common`'s `"xl"` / `"normal"`
  /// (`ProductListActivity.kt:613`, `PLPProductViewModel.java:171`). The same
  /// tile therefore reports capitalised or not depending on the source screen —
  /// an Android-side metric split. Flutter matches the
  /// lowercase form, which is also what the rest of our constants use.
  ///
  /// ⚠️ **`from_screen` is wrong for boutiques today, and cannot be fixed here.**
  /// Android sends the boutique's name (`"water yellowA"` in a live capture);
  /// Flutter falls back to the literal `"PLP"` because [screenName] is empty. It
  /// comes from `pageMeta.pageTitle`, and a boutique is served by the *search*
  /// endpoint (`plp_repository_impl.dart:34`), which does not return that field.
  /// The route can already carry a name — `PlpDestination.navigate` forwards
  /// `title ?? categoryName` into `goToPlp` — but the homepage tile call sites
  /// pass no title, and [PlpState] does not retain `categoryName` either.
  /// Closing it needs a decision on where the boutique's display name comes
  /// from, so it is recorded as a finding rather than guessed at.
  PdpEntryArgs pdpEntryArgs(ListingProductEntity product, int index) =>
      PdpEntryArgs(
        fromScreen: (screenName?.isNotEmpty ?? false)
            ? screenName
            : FromScreens.plp,
        fromPage: switch (pageType) {
          PageType.plp => FromPage.plp,
          PageType.boutique => FromPage.boutique,
          // Android reuses one localised string for both properties here
          // (`fromScreen = fromPage = getString(R.string.search)`).
          PageType.search => FromPage.search,
        },
        fromFeedSize: feedSize,
        // 1-indexed, matching Android: its PLP passes `positionTag + 1` into the PDP
        // intent (`ProductListPageActivity.java:829`), where `positionTag` is the
        // 0-based grid index. Both PDP modules then forward the value untouched, so
        // `index + 1` here is what keeps the two platforms on the same base. Removing
        // it would shift every Flutter position down by one against Android.
        position: index + 1,
        sourceTileType: product.isXLTile
            ? SourceTileType.xl
            : SourceTileType.normal,
      );
}
