import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../../../features/plp/domain/entities/listing_product_entity.dart';
import 'home_track_analytic_manager.dart';

/// Root → tile → first detail → first image. Shared by the click path AND
/// the impression path so `tile_clicked` and `banner_impression` for Hero
/// carry the exact same identity keys. Deeper level wins on collision;
/// nulls are filtered by [logTileClick] / `mergeMetaNonNull`.
List<Map<String, dynamic>?> heroTileTrackingMetaChain(
  HeroCarouselData root,
  HeroTile tile,
) {
  final firstDetail =
      tile.tileDetails.isNotEmpty ? tile.tileDetails.first : null;
  return <Map<String, dynamic>?>[
    root.trackingMeta,
    tile.trackingMeta,
    firstDetail?.trackingMeta,
    tile.firstImage?.trackingMeta,
  ];
}

/// Per-component tap helpers. Each collects the backend `trackingMeta` chain
/// (root → tile → deeper levels) and delegates to [logTileClick]. Every wire
/// key — attribution + event payload — comes from the merged blob; the
/// client never reads inside it.
extension HomeComponentClickHandlers on HomeTrackAnalyticManager {
  Future<void> onHeroTileTapped(HeroCarouselData root, HeroTile tile) =>
      logTileClick(trackingMetaChain: heroTileTrackingMetaChain(root, tile));

  Future<void> onCustomTileTapped(
    CustomTilesData root,
    CustomTilesTile row,
    TileGridItem tile,
  ) =>
      logTileClick(
        trackingMetaChain: <Map<String, dynamic>?>[
          root.trackingMeta,
          row.trackingMeta,
          tile.trackingMeta,
        ],
      );

  Future<void> onPageCarouselTileTapped(
    PageCarouselData root,
    PageCarouselTile tile,
  ) =>
      logTileClick(
        trackingMetaChain: <Map<String, dynamic>?>[
          root.trackingMeta,
          tile.trackingMeta,
          tile.product?.trackingMeta,
        ],
      );

  Future<void> onCategoryAccordionTapped(
    CategoryAccordionData root,
    CategoryAccordionTile tile,
  ) =>
      logTileClick(
        trackingMetaChain: <Map<String, dynamic>?>[root.trackingMeta],
      );

  Future<void> onProductGridTileTapped(
    ProductGridData root,
    ListingProductEntity item,
  ) =>
      logTileClick(
        trackingMetaChain: <Map<String, dynamic>?>[
          root.trackingMeta,
          item.trackingMeta,
        ],
      );

  /// CTA-button tap on any component that ships a `ctaButton` block
  /// (CustomTiles, ProductGrid, …). Chain is `root.trackingMeta →
  /// cta.trackingMeta` — deepest wins on collision, nulls dropped by
  /// [logTileClick]. Emits `tile_clicked` on the Discover funnel and
  /// `lp_tile_clicked` on LPs (via the `fromHomePage` branch inside
  /// `logTileClick`).
  Future<void> onCtaButtonTapped({
    required Map<String, dynamic>? rootTrackingMeta,
    required CtaButton cta,
  }) =>
      logTileClick(
        trackingMetaChain: <Map<String, dynamic>?>[
          rootTrackingMeta,
          cta.trackingMeta,
        ],
      );
}
