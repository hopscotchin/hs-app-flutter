import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

typedef _LineState = ({double progress, double fraction});

class PageCarouselWidget extends StatefulWidget {
  const PageCarouselWidget({
    super.key,
    required this.carouselData,
    this.margins,
  });

  final PageCarouselData carouselData;
  final ComponentMargins? margins;

  @override
  State<PageCarouselWidget> createState() => _PageCarouselWidgetState();
}

class _PageCarouselWidgetState extends State<PageCarouselWidget>
    with AutomaticKeepAliveClientMixin {
  // Snapping PageView is forward-bounded (so the first paint has no leftward
  // peep) but the budget is large enough to feel infinite in normal use.
  static const int _forwardCycleBudget = 1000;

  // Defaults match the JSON contract's typical values; ?? falls back here.
  static const double _defaultHorizontalMargin = 16;
  static const double _defaultInnerHorizontalMargin = 8;
  static const double _defaultTitleHorizontalMargin = 16;

  // Vertical space reserved under each tile for brand + name + price.
  static const double _productInfoHeight = 68;
  static const double _productInfoHeightNarrow = 84;
  static const double _narrowScreenThreshold = 370;

  static const _initialLineState = (progress: 0.0, fraction: 0.3);

  final ScrollController _listController = ScrollController();
  final ValueNotifier<_LineState> _lineState = ValueNotifier(_initialLineState);

  PageController? _pageController;
  int _currentPage = 0;
  late final bool _hasProducts;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hasProducts = widget.carouselData.tiles.any(
      (tile) => tile.product != null,
    );
    _listController.addListener(_onListScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onListScroll();
    });
  }

  @override
  void dispose() {
    _listController
      ..removeListener(_onListScroll)
      ..dispose();
    _pageController?.dispose();
    _lineState.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_listController.hasClients) return;
    final pos = _listController.position;
    if (pos.maxScrollExtent <= 0) {
      _lineState.value = const (progress: 0.0, fraction: 1.0);
      return;
    }
    final progress = (pos.pixels / pos.maxScrollExtent).clamp(0.0, 1.0);
    final total = pos.viewportDimension + pos.maxScrollExtent;
    final fraction = total > 0
        ? (pos.viewportDimension / total).clamp(0.15, 1.0)
        : 1.0;
    _lineState.value = (progress: progress, fraction: fraction);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tiles = widget.carouselData.tiles;
    if (tiles.isEmpty) return const SizedBox.shrink();

    final data = widget.carouselData;
    final viewConfig = data.viewConfig;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalMargin =
        widget.margins?.horizontal ?? _defaultHorizontalMargin;
    final innerHorizontalMargin =
        widget.margins?.innerHorizontalMargin ?? _defaultInnerHorizontalMargin;
    final titleBottomMargin = widget.margins?.titleBottomMargin ?? 0;
    final titleHorizontalMargin =
        widget.margins?.titleHorizontalMargin ?? _defaultTitleHorizontalMargin;

    final minTilesToShow = viewConfig?.minTilesToShow ?? 1;
    final peepingFactor = viewConfig?.peepingFactor ?? 0;
    final isFullWidth = minTilesToShow == 1 && peepingFactor == 0;
    final hasSnapping = viewConfig?.snapping ?? false;
    final showIndicators = viewConfig?.showPageIndicators ?? false;
    final imageCornerRadius = viewConfig?.imageCornerRadius ?? 0;

    // Mirrors Android calculateCarouselHeight().
    final double availableWidth;
    if (isFullWidth) {
      availableWidth = screenWidth - horizontalMargin * 2;
    } else {
      availableWidth =
          screenWidth -
          (peepingFactor > 0 ? horizontalMargin : horizontalMargin * 2) -
          (minTilesToShow == 1
              ? (peepingFactor > 0 ? innerHorizontalMargin : 0)
              : (minTilesToShow - 1) * innerHorizontalMargin);
    }

    final tileWidth = isFullWidth
        ? availableWidth
        : availableWidth * 100 / (minTilesToShow * 100 + peepingFactor);
    final aspectRatio = data.parsedAspectRatio;
    final tileHeight = aspectRatio > 0 ? tileWidth / aspectRatio : tileWidth;

    final productInfoHeight = _hasProducts
        ? (screenWidth <= _narrowScreenThreshold
              ? _productInfoHeightNarrow
              : _productInfoHeight)
        : 0.0;
    final carouselHeight = tileHeight + productInfoHeight;

    // Shifts the snapping PageView right so the first tile lands at
    // `horizontalMargin`. Inner per-tile padding covers the remaining offset.
    // Clamped to >= 0 — full-bleed configs can otherwise produce a negative
    // Padding and trip the framework assertion.
    final double leadingShift = (isFullWidth || !hasSnapping)
        ? 0.0
        : (horizontalMargin - innerHorizontalMargin / 2).clamp(
            0.0,
            double.infinity,
          );

    if (hasSnapping && _pageController == null) {
      final slotWidth = isFullWidth
          ? screenWidth
          : tileWidth + innerHorizontalMargin;
      _pageController = PageController(
        viewportFraction: slotWidth / (screenWidth - leadingShift),
      );
      _currentPage = 0;
    }

    final carousel = hasSnapping
        ? _buildSnappingCarousel(
            tiles: tiles,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            carouselHeight: carouselHeight,
            horizontalMargin: horizontalMargin,
            innerHorizontalMargin: innerHorizontalMargin,
            isFullWidth: isFullWidth,
            showIndicators: showIndicators,
            imageCornerRadius: imageCornerRadius,
            leadingShift: leadingShift,
          )
        : _buildScrollableCarousel(
            tiles: tiles,
            tileWidth: tileWidth,
            tileHeight: tileHeight,
            carouselHeight: carouselHeight,
            horizontalMargin: horizontalMargin,
            innerHorizontalMargin: innerHorizontalMargin,
            isFullWidth: isFullWidth,
            showIndicators: showIndicators,
            imageCornerRadius: imageCornerRadius,
          );

    final titleUrl = data.title?.url;
    if (titleUrl == null) return carousel;

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
            imageUrl: titleUrl,
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
    required double imageCornerRadius,
    required double leadingShift,
  }) {
    final tileCount = tiles.length;
    final tilePadding = isFullWidth
        ? horizontalMargin
        : innerHorizontalMargin / 2;

    final pageView = SizedBox(
      height: carouselHeight,
      child: Padding(
        padding: EdgeInsets.only(left: leadingShift),
        child: PageView.builder(
          controller: _pageController!,
          padEnds: false,
          itemCount: tileCount * _forwardCycleBudget,
          onPageChanged: (page) => setState(() => _currentPage = page),
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: tilePadding),
            child: _buildTile(
              tiles[index % tileCount],
              tileWidth,
              tileHeight,
              imageCornerRadius,
            ),
          ),
        ),
      ),
    );

    if (!showIndicators || tileCount <= 1) return pageView;
    final activeIndex = _currentPage % tileCount;

    if (isFullWidth) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          pageView,
          _DotIndicators(activeIndex: activeIndex, count: tileCount),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        pageView,
        _PageLineIndicator(activeIndex: activeIndex, count: tileCount),
      ],
    );
  }

  Widget _buildScrollableCarousel({
    required List<PageCarouselTile> tiles,
    required double tileWidth,
    required double tileHeight,
    required double carouselHeight,
    required double horizontalMargin,
    required double innerHorizontalMargin,
    required bool isFullWidth,
    required bool showIndicators,
    required double imageCornerRadius,
  }) {
    final tileList = SizedBox(
      height: carouselHeight,
      child: ListView.separated(
        controller: _listController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        itemCount: tiles.length,
        separatorBuilder: (_, _) => SizedBox(width: innerHorizontalMargin),
        itemBuilder: (_, i) =>
            _buildTile(tiles[i], tileWidth, tileHeight, imageCornerRadius),
      ),
    );

    if (!showIndicators || tiles.length <= 1) return tileList;

    if (isFullWidth) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          tileList,
          _DotIndicators(activeIndex: 0, count: tiles.length),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [tileList, _ScrollLineIndicator(state: _lineState)],
    );
  }

  Widget _buildTile(
    PageCarouselTile tile,
    double tileWidth,
    double tileHeight,
    double cornerRadius,
  ) {
    final product = tile.product;
    final tapUri = tile.actionUri ?? product?.actionUri;
    final image = SizedBox(
      height: tileHeight,
      width: tileWidth,
      child: CachedImageWidget(
        imageUrl: tile.imageUrl ?? product?.primaryImageUrl ?? '',
        fit: BoxFit.cover,
      ),
    );

    return GestureDetector(
      onTap: () => ActionUrlHandler.navigate(context, tapUri),
      child: SizedBox(
        width: tileWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cornerRadius > 0)
              ClipRRect(
                borderRadius: BorderRadius.circular(cornerRadius),
                child: image,
              )
            else
              image,
            if (product != null) _ProductInfo(product: product),
          ],
        ),
      ),
    );
  }
}

// ─── Indicators ──────────────────────────────────────────────────────────────

class _DotIndicators extends StatelessWidget {
  const _DotIndicators({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  static const _dotDuration = Duration(milliseconds: 200);
  static const _dotMargin = EdgeInsets.symmetric(horizontal: 3);
  static const _padding = EdgeInsets.only(bottom: 10);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) {
          final isActive = i == activeIndex;
          return AnimatedContainer(
            duration: _dotDuration,
            margin: _dotMargin,
            width: isActive ? 45 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.baseDefault
                  : AppColors.baseDefault.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}

/// Free-scroll variant: the notifier confines rebuilds to the bar itself, so
/// the carousel above never rebuilds during a swipe.
class _ScrollLineIndicator extends StatelessWidget {
  const _ScrollLineIndicator({required this.state});

  final ValueListenable<_LineState> state;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_LineState>(
      valueListenable: state,
      builder: (_, value, _) => _LineBar(
        progress: value.progress,
        fraction: value.fraction,
        animate: false,
      ),
    );
  }
}

/// Snapping variant: page jumps are discrete, so we tween between values.
class _PageLineIndicator extends StatelessWidget {
  const _PageLineIndicator({required this.activeIndex, required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return _LineBar(
      progress: activeIndex / (count - 1),
      fraction: (1.0 / count).clamp(0.15, 1.0),
      animate: true,
    );
  }
}

class _LineBar extends StatelessWidget {
  const _LineBar({
    required this.progress,
    required this.fraction,
    required this.animate,
  });

  final double progress;
  final double fraction;
  final bool animate;

  static const double _trackWidth = 250;
  static const double _trackHeight = 3;
  static const _radius = BorderRadius.all(Radius.circular(_trackHeight / 2));
  static const _padding = EdgeInsets.symmetric(vertical: 14);
  static const _animDuration = Duration(milliseconds: 200);
  static const _trackDecoration = BoxDecoration(
    color: AppColors.neutralGrey0,
    borderRadius: _radius,
  );
  static const _thumbDecoration = BoxDecoration(
    color: AppColors.neutralBlack,
    borderRadius: _radius,
  );

  @override
  Widget build(BuildContext context) {
    final thumbWidth = _trackWidth * fraction;
    final left = progress.clamp(0.0, 1.0) * (_trackWidth - thumbWidth);
    final thumb = SizedBox(
      width: thumbWidth,
      height: _trackHeight,
      child: const DecoratedBox(decoration: _thumbDecoration),
    );

    return Padding(
      padding: _padding,
      child: Center(
        child: SizedBox(
          width: _trackWidth,
          height: _trackHeight,
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(decoration: _trackDecoration),
              ),
              if (animate)
                AnimatedPositioned(
                  duration: _animDuration,
                  curve: Curves.easeOut,
                  left: left,
                  top: 0,
                  bottom: 0,
                  child: thumb,
                )
              else
                Positioned(left: left, top: 0, bottom: 0, child: thumb),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tile product info ───────────────────────────────────────────────────────

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});

  final HomepageProduct product;

  @override
  Widget build(BuildContext context) {
    final brand = product.brandName;
    final name = product.name;
    final price = product.price;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        if (brand != null && brand.isNotEmpty)
          Text(
            brand,
            style: AppTypographyV1.labelMedium.semiBold.textSecondary(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (name != null && name.isNotEmpty)
          Text(
            name,
            style: AppTypographyV1.labelLarge.regular,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (price != null) _PriceRow(price: price),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.price});

  final HomepageProductPrice price;

  @override
  Widget build(BuildContext context) {
    final selling = price.sellingPrice;
    final mrp = price.mrp;
    final discount = price.discountLabel;
    final hasDiscount = price.hasDiscount;
    final showMrp = hasDiscount && mrp != null && mrp.isNotEmpty;
    final showDiscount = hasDiscount && discount != null;

    return Row(
      children: [
        if (selling != null && selling.isNotEmpty)
          Text(
            '₹$selling',
            style: AppTypographyV1.labelLarge.semiBold.textPrimary(),
          ),
        if (showMrp) ...[
          AppSpacing.horizontalGapXxs,
          Text(
            '₹$mrp',
            style: AppTypographyV1.labelLarge.regular
                .textTertiary()
                .strikeThrough(),
          ),
        ],
        if (showDiscount) ...[
          AppSpacing.horizontalGapXxs,
          Text(
            discount,
            style: AppTypographyV1.labelMedium.semiBold.success(),
          ),
        ],
      ],
    );
  }
}
