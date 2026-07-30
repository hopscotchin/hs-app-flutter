import '../../../features/discover/domain/entities/home_page_entity.dart';
import '../../../features/plp/domain/entities/listing_product_entity.dart';
import 'home_track_analytic_manager.dart';

/// Per-component tap helpers. Each collects the backend `trackingMeta` chain
/// (root → tile → deeper levels) and delegates to [logTileClick]. Every wire
/// key — attribution + event payload — comes from the merged blob; the
/// client never reads inside it.
extension HomeComponentClickHandlers on HomeTrackAnalyticManager {
  Future<void> onHeroTileTapped(HeroCarouselData root, HeroTile tile) {
    final firstDetail =
        tile.tileDetails.isNotEmpty ? tile.tileDetails.first : null;
    return logTileClick(
      trackingMetaChain: <Map<String, dynamic>?>[
        root.trackingMeta,
        tile.trackingMeta,
        firstDetail?.trackingMeta,
        tile.firstImage?.trackingMeta,
      ],
    );
  }

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
}
