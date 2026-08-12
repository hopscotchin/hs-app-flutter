import 'package:flutter/material.dart';

import '../../../../components/page_components/page_carousel_widget.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../features/discover/domain/entities/home_page_entity.dart';
import '../../domain/entities/recently_viewed_entity.dart';

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

    final carouselData = PageCarouselData(
      viewConfig: viewConfig,
      tiles: rv.tiles.map((p) => PageCarouselTile(product: p)).toList(),
      title: rv.heading?.url != null
          ? TitleImage(
              url: rv.heading!.url,
              width: rv.heading!.width,
              height: rv.heading!.height,
            )
          : null,
    );

    final margins = ComponentMargins(
      horizontal: m?.horizontal ?? 16.0,
      innerHorizontalMargin: m?.innerHorizontalMargin ?? 8.0,
      titleBottomMargin: m?.titleBottomMargin ?? 0.0,
      titleHorizontalMargin: m?.titleHorizontalMargin ?? 0.0,
    );

    return Padding(
      padding: EdgeInsets.only(top: m?.top ?? 12.0, bottom: m?.bottom ?? 12.0),
      child: PageCarouselWidget(
        keyPrefix: PdpTestStrings.recentlyViewedPrefix,
        carouselData: carouselData,
        margins: margins,
      ),
    );
  }
}
