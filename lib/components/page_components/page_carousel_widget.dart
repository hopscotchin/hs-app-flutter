import 'package:flutter/material.dart';

import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class PageCarouselWidget extends StatefulWidget {
  final PageCarouselData carouselData;
  final ComponentMargins? margins;

  const PageCarouselWidget({
    super.key,
    required this.carouselData,
    this.margins,
  });

  @override
  State<PageCarouselWidget> createState() => _PageCarouselWidgetState();
}

class _PageCarouselWidgetState extends State<PageCarouselWidget>
    with AutomaticKeepAliveClientMixin {
  PageController? _pageController;
  int _currentPage = 0;
  late bool _hasProducts;

  static const _leftScrollBudget = 100;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hasProducts = widget.carouselData.tiles.any(
      (tile) => tile.product != null,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tiles = widget.carouselData.tiles;
    if (tiles.isEmpty) return const SizedBox.shrink();

    final data = widget.carouselData;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Resolve margins once — mirrors Android updateItemMargins non-null defaults
    final double horizontalMargin = widget.margins?.horizontal ?? 16;
    final double innerHorizontalMargin =
        widget.margins?.innerHorizontalMargin ?? 8;
    final double titleBottomMargin = widget.margins?.titleBottomMargin ?? 0;
    final double titleHorizontalMargin =
        widget.margins?.titleHorizontalMargin ?? 16;

    final int minTilesToShow = data.minTilesToShow ?? 1;
    final int peepingFactor = data.peepingFactor ?? 0;
    final bool isFullWidth = minTilesToShow == 1 && peepingFactor == 0;
    final bool hasSnapping = minTilesToShow == 1 && data.snapBehaviour;

    // Mirror Android's calculateCarouselHeight() formula
    // One-sided horizontal margin when peeking, two-sided otherwise.
    final double availableWidth;
    if (isFullWidth) {
      availableWidth = screenWidth - (horizontalMargin * 2);
    } else {
      availableWidth =
          screenWidth -
          (peepingFactor > 0 ? horizontalMargin : horizontalMargin * 2) -
          (minTilesToShow == 1
              ? (peepingFactor > 0 ? innerHorizontalMargin : 0)
              : (minTilesToShow - 1) * innerHorizontalMargin);
    }

    final double tileWidth = isFullWidth
        ? availableWidth
        : availableWidth * 100 / (minTilesToShow * 100 + peepingFactor);

    final double aspectRatio = data.parsedAspectRatio;
    final double tileHeight = aspectRatio > 0
        ? tileWidth / aspectRatio
        : tileWidth;

    // Mirror Android productInfoHeight: 70dp on narrow screens (≤370), 44dp otherwise
    final double productInfoHeight = _hasProducts
        ? (screenWidth <= 370 ? 70.0 : 44.0)
        : 0.0;
    final double carouselHeight = tileHeight + productInfoHeight;

    if (hasSnapping && _pageController == null) {
      final double slotWidth = isFullWidth
          ? screenWidth
          : tileWidth + innerHorizontalMargin;
      final double viewportFraction = slotWidth / screenWidth;
      final int initialPage = tiles.length * _leftScrollBudget;
      _pageController = PageController(
        viewportFraction: viewportFraction,
        initialPage: initialPage,
      );
      _currentPage = initialPage;
    }

    final Widget carousel = hasSnapping
        ? _buildSnappingCarousel(
            tiles: tiles,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            carouselHeight: carouselHeight,
            horizontalMargin: horizontalMargin,
            innerHorizontalMargin: innerHorizontalMargin,
            isFullWidth: isFullWidth,
            showIndicators: data.showPageIndicators,
          )
        : _buildScrollableCarousel(
            tiles: tiles,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            carouselHeight: carouselHeight,
            horizontalMargin: horizontalMargin,
            innerHorizontalMargin: innerHorizontalMargin,
            isFullWidth: isFullWidth,
            showIndicators: data.showPageIndicators,
          );

    if (data.titleImage?.url == null) return carousel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: titleHorizontalMargin,
            right: titleHorizontalMargin,
            bottom: titleBottomMargin,
          ),
          child: CachedImageWidget(
            imageUrl: data.titleImage!.url!,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        carousel,
      ],
    );
  }

  Widget _buildSnappingCarousel({
    required List<PageCarouselTile> tiles,
    required double tileWidth,
    required double tileHeight,
    required double carouselHeight,
    required double horizontalMargin,
    required double innerHorizontalMargin,
    required bool isFullWidth,
    required bool showIndicators,
  }) {
    final int tileCount = tiles.length;

    final Widget pageView = SizedBox(
      height: carouselHeight,
      child: PageView.builder(
        controller: _pageController!,
        itemCount: null,
        onPageChanged: (int page) => setState(() => _currentPage = page),
        itemBuilder: (BuildContext context, int index) {
          final PageCarouselTile tile = tiles[index % tileCount];
          final Widget tileWidget = _buildTile(tile, tileWidth, tileHeight);
          // Full-width: symmetric margin matches Android's setPadding(hM, 0, hM, 0).
          // Peeping: right-only gap matches Android's HorizontalSpacingDecoration.
          //          padEnds:true (Flutter default) centres the current page so both
          //          the left and right adjacent tiles peek symmetrically.
          return isFullWidth
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: tileWidget,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: innerHorizontalMargin / 2,
                  ),
                  child: tileWidget,
                );
        },
      ),
    );

    if (!showIndicators || tileCount <= 1) return pageView;

    // Full-width: dots overlay inside the image (white, mirrors Android binding.indicator)
    // Peeping:    dots bar below the carousel (primary, mirrors Android binding.indicatorDefault)
    return isFullWidth
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [pageView, _buildDotIndicators(tileCount)],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [pageView, _buildScrollIndicator(tileCount)],
          );
  }

  // ListView-based scrollable carousel.
  // innerHorizontalMargin is passed explicitly so both the geometry formula
  // and the separator use the exact same value.
  Widget _buildScrollableCarousel({
    required List<PageCarouselTile> tiles,
    required double tileWidth,
    required double tileHeight,
    required double carouselHeight,
    required double horizontalMargin,
    required double innerHorizontalMargin,
    required bool isFullWidth,
    required bool showIndicators,
  }) {
    final Widget tileList = SizedBox(
      height: carouselHeight,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification &&
              innerHorizontalMargin > 0) {
            final double tileStep = tileWidth + innerHorizontalMargin;
            final int newPage = (notification.metrics.pixels / tileStep)
                .round()
                .clamp(0, tiles.length - 1);
            if (newPage != _currentPage) setState(() => _currentPage = newPage);
          }
          return false;
        },
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
          itemCount: tiles.length,
          separatorBuilder: (_, _) => SizedBox(width: innerHorizontalMargin),
          itemBuilder: (BuildContext context, int index) =>
              _buildTile(tiles[index], tileWidth, tileHeight),
        ),
      ),
    );

    if (!showIndicators || tiles.length <= 1) return tileList;

    return isFullWidth
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [tileList, _buildDotIndicators(tiles.length)],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [tileList, _buildScrollIndicator(tiles.length)],
          );
  }

  // Animated dot strip overlaid at the bottom — used for full-width snapping carousels
  Widget _buildDotIndicators(int tileCount) {
    final int activeDot = _currentPage % tileCount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tileCount, (int index) {
          final bool isActive = index == activeDot;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 24 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  // 40dp position dots below the list — mirrors Android's indicatorDefault
  Widget _buildScrollIndicator(int tileCount) {
    final int activeDot = _currentPage % tileCount;
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tileCount, (int index) {
          final bool isActive = index == activeDot;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 6 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.neutralBlack
                  : AppColors.neutralBlack.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTile(
    PageCarouselTile tile,
    double tileWidth,
    double tileHeight,
  ) {
    return GestureDetector(
      onTap: () => ActionUrlHandler.navigate(
        context,
        tile.actionUrl,
        title: tile.collectionName,
      ),
      child: SizedBox(
        width: tileWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: tileHeight,
              width: tileWidth,
              child: CachedImageWidget(
                imageUrl: tile.imageUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
            if (tile.product != null) _buildProductInfo(tile.product!),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(PageCarouselProduct product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        if (product.name != null)
          Text(
            product.name!,
            style: AppTypography.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Row(
          children: [
            if (product.retailPrice > 0)
              Text(
                '₹${product.retailPrice.toStringAsFixed(0)}',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            if (product.regularPrice > 0 &&
                product.regularPrice != product.retailPrice) ...[
              AppSpacing.horizontalGapXxs,
              Text(
                '₹${product.regularPrice.toStringAsFixed(0)}',
                style: AppTypography.bodySmall.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
            if (product.discount > 5) ...[
              AppSpacing.horizontalGapXxs,
              Text(
                '${product.discount}% off',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
