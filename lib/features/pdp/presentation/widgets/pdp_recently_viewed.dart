import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../components/page_components/page_carousel_widget.dart';
import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../features/discover/domain/entities/home_page_entity.dart';
import '../../domain/entities/pdp_entry_args.dart';
import '../../domain/entities/recently_viewed_entity.dart';
import '../../../../core/analytics/pdp/pdp_analytics_tracker.dart';

class PdpRecentlyViewed extends StatelessWidget {
  const PdpRecentlyViewed({super.key, required this.recentlyViewed});

  final RecentlyViewedEntity recentlyViewed;

  @override
  Widget build(BuildContext context) {
    final rv = recentlyViewed;
    if (rv.tiles.isEmpty) return const SizedBox.shrink();

    final cfg = rv.viewConfig;
    final m = rv.margins;

    final viewConfig = PageCarouselViewConfig(
      tileWidth: cfg?.tileWidth.round(),
      tileHeight: cfg?.tileHeight.round(),
      minTilesToShow: cfg?.minTilesToShow ?? 3,
      imageCornerRadius: cfg?.imageCornerRadius ?? 4.0,
      navigation: cfg?.navigation ?? false,
      snapping: cfg?.snapping ?? false,
      showPageIndicators: cfg?.showPageIndicators ?? false,
      peepingFactor: cfg?.peepingFactor ?? 0,
    );

    // The shared carousel hands back its own tile type, which has no room for the
    // rail's click block. Indexing the nodes by product id here keeps the lookup
    // in the widget that owns the rail, and hands the tracker a whole node.
    final railTilesById = {for (final t in rv.tiles) t.product.id: t};

    final carouselData = PageCarouselData(
      viewConfig: viewConfig,
      tiles: rv.tiles
          .map((t) => PageCarouselTile(product: t.product))
          .toList(),
      title: rv.heading?.url != null
          ? TitleImage(url: rv.heading!.url, width: rv.heading!.width, height: rv.heading!.height)
          : null,
    );

    final margins = ComponentMargins(
      horizontal: m?.horizontal ?? 16.0,
      innerHorizontalMargin: m?.innerHorizontalMargin ?? 8.0,
      titleBottomMargin: m?.titleBottomMargin ?? 0.0,
      titleHorizontalMargin: m?.titleHorizontalMargin ?? 0.0,
    );

    final tracker = context.read<PdpAnalyticsTracker>();

    return VisibilityDetector(
      key: const Key('pdp_recently_viewed_visibility'),
      // `recently_viewed_products_loaded` is gated on the rail actually being on
      // screen, not on the data arriving — Android checks `isVisibleOnScreen()`
      // (`RecentlyViewedProductsView.kt:97-108`). The tracker enforces
      // once-per-PID.
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          tracker.onRecentlyViewedRailVisible(rv.trackingMeta);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: m?.top ?? 12.0, bottom: m?.bottom ?? 12.0),
        child: PageCarouselWidget(
          keyPrefix: PdpTestStrings.recentlyViewedPrefix,
          carouselData: carouselData,
          margins: margins,
          // Overrides the shared component's homepage logging. Without this the
          // rail would emit `tile_clicked` and write HP attribution from PDP —
          // which Android's hspdp module never does.
          // The shared carousel hands back its own tile type, which has no room
          // for the rail's click block — so the node is looked up here, in the
          // widget that owns the rail, and handed to the tracker whole.
          onTileTapLog: (tile) async {
            final product = tile.product;
            if (product == null) return;
            final railTile = railTilesById[product.id];
            if (railTile != null) {
              tracker.onRecentlyViewedTileTapped(railTile);
            }
          },
          // Same reason: without this the rail's heart would emit nothing at all,
          // since the shared component has no default wishlist analytics.
          onWishlistLog: tracker.onRecentlyViewedTileWishlisted,
          // The destination PDP reports where it came from. Android sends the
          // pair from this rail's own click handler
          // (`RecentlyViewedProductsView.kt:69-81`).
          tapAnalytics: navExtra(
            pdpEntryArgs: const PdpEntryArgs(
              fromScreen: FromScreens.product,
              fromPage: FromPage.recentlyViewed,
            ),
          ),
          // Records only; reported once on exit, matching Android's read of
          // `lastImagePositionAfterScroll` from `onStop`.
          onScrollLog: tracker.onRecentlyViewedSettled,
        ),
      ),
    );
  }
}
