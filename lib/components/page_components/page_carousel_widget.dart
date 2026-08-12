import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';

import '../../core/analytics/home/home_component_click_handlers.dart';
import '../../core/analytics/home/home_track_analytic_manager.dart';
import '../../core/di/injection.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../core/constants/strings/login_redirects.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../../features/plp/domain/entities/listing_product_entity.dart';
import '../../features/wishlist/presentation/widgets/wishlist_status_builder.dart';
import '../../features/wishlist/presentation/wishlist_actions.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/custom_image.dart';
import '../atoms/product_tile.dart';

typedef _LineState = ({double progress, double fraction});

class PageCarouselWidget extends StatefulWidget {
  const PageCarouselWidget({
    super.key,
    required this.carouselData,
    this.margins,
    this.keyPrefix,
  });

  final PageCarouselData carouselData;
  final ComponentMargins? margins;

  /// Component-level automation key prefix, e.g. `hp_pc_1`. Null → unkeyed.
  final String? keyPrefix;

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
  // Sized to fit Satoshi labelLarge (12pt) + bodySmall (13pt) at default
  // font metrics plus the AppSpacing gaps between them. The previous 68/84
  // values overflowed by ~9px on devices where the font's intrinsic line
  // height is on the taller side.
  static const double _productInfoHeight = 60;
  static const double _productInfoHeightNarrow = 76;
  static const double _colorVariantsBuffer = 20;
  static const double _narrowScreenThreshold = 370;

  static const _initialLineState = (progress: 0.0, fraction: 0.3);
  // 32ms ≈ 2 frames. Smooths jitter from tiny dx wobble while
  // staying close enough to feel in sync. Raise if it still jitters, lower
  // if it visibly lags.
  static const _lineUpdateThrottle = Duration(milliseconds: 32);

  final ScrollController _listController = ScrollController();
  final ValueNotifier<_LineState> _lineState = ValueNotifier(_initialLineState);
  Timer? _lineUpdatePending;

  final ScrollController _snapController = ScrollController();

  /// Current per-tile stride (tileWidth + innerHorizontalMargin), refreshed
  /// from `build()` so `_onSnapScroll` can map scroll pixels → tile index
  /// without recomputing layout.
  double _snapItemStride = 0.0;

  /// Stride for the non-snapping ListView.separated variant — same recipe
  /// (tileWidth + innerHorizontalMargin). Used by [_reportCarouselScroll]
  /// to compute the leading-edge tile index on scroll.
  double _listItemStride = 0.0;

  /// Previous pixel offsets for direction detection on each controller.
  /// Positive delta → forward scroll (report last-visible+1); negative →
  /// backward (report first-visible+1). Mirrors Android's dx sign check.
  double _prevListPixels = 0.0;
  double _prevSnapPixels = 0.0;

  /// Notifier-backed page index so swipes only rebuild the indicator,
  /// not the snapping list and its layout math above.
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  late final bool _hasProducts;
  late final bool _hasColorVariants;

  @override
  bool get wantKeepAlive => true;

  Key? _key(String suffix) {
    final prefix = widget.keyPrefix;
    return prefix == null ? null : ValueKey('${prefix}_$suffix');
  }

  Key? _tileKey(int i) => _key('${HomeComponentTestStrings.tiles}_$i');

  /// Sub-element key nested under tile `i` → `<prefix>_tiles_<i>_<suffix>`.
  Key? _tileSubKey(int i, String suffix) =>
      _key('${HomeComponentTestStrings.tiles}_${i}_$suffix');

  @override
  void initState() {
    super.initState();
    _hasProducts = widget.carouselData.tiles.any((tile) => tile.product != null);
    _hasColorVariants = widget.carouselData.tiles
        .any((tile) => tile.product?.colorVariants?.isNotEmpty ?? false);
    _listController.addListener(_onListScroll);
    _snapController.addListener(_onSnapScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _flushLineState();
    });
  }

  @override
  void dispose() {
    _lineUpdatePending?.cancel();
    _listController
      ..removeListener(_onListScroll)
      ..dispose();
    _snapController
      ..removeListener(_onSnapScroll)
      ..dispose();
    _lineState.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _onListScroll() {
    if (!_listController.hasClients) return;
    final pos = _listController.position;
    _reportCarouselScroll(pos, _listItemStride, _prevListPixels);
    _prevListPixels = pos.pixels;
    // Trailing throttle: coalesce bursts of scroll ticks into one indicator
    // update per window. Timer reads the latest position when it fires, so
    // the final resting spot always paints without a lingering stale value.
    if (_lineUpdatePending?.isActive ?? false) return;
    _lineUpdatePending = Timer(_lineUpdateThrottle, _flushLineState);
  }

  void _flushLineState() {
    if (!mounted || !_listController.hasClients) return;
    final pos = _listController.position;
    if (pos.maxScrollExtent <= 0) {
      _lineState.value = const (progress: 0.0, fraction: 1.0);
      return;
    }
    final progress = (pos.pixels / pos.maxScrollExtent).clamp(0.0, 1.0);
    final total = pos.viewportDimension + pos.maxScrollExtent;
    final fraction = total > 0 ? (pos.viewportDimension / total).clamp(0.15, 1.0) : 1.0;
    _lineState.value = (progress: progress, fraction: fraction);
  }

  void _onSnapScroll() {
    if (!_snapController.hasClients) return;
    if (_snapItemStride <= 0) return;
    final pos = _snapController.position;
    _reportCarouselScroll(pos, _snapItemStride, _prevSnapPixels);
    _prevSnapPixels = pos.pixels;
    final tileCount = widget.carouselData.tiles.length;
    if (tileCount == 0) return;

    int rounded;
    if (_hasProducts && pos.maxScrollExtent > 0 && pos.pixels >= pos.maxScrollExtent - 0.5) {
      rounded = tileCount - 1;
    } else {
      rounded = (pos.pixels / _snapItemStride).round();
    }

    if (rounded != _currentPage.value) {
      _currentPage.value = rounded;
    }
  }

  /// Push the current scroll target to the tracker. Last-write-wins per
  /// carousel — the manager keeps the latest and emits ONE
  void _reportCarouselScroll(
    ScrollPosition pos,
    double stride,
    double prevPixels,
  ) {
    if (stride <= 0) return;
    final delta = pos.pixels - prevPixels;
    if (delta.abs() < 0.5) return;

    final tileCount = widget.carouselData.tiles.length;
    if (tileCount == 0) return;
    final firstVisible = (pos.pixels / stride).floor();
    final lastVisible = ((pos.pixels + pos.viewportDimension) / stride)
        .ceil() - 1;
    final target = (delta > 0 ? lastVisible : firstVisible);

    // Merge with root trackingMeta (opaque). Only client-supplied key is
    // `scrolled_tiles` — the scroll target the user reached.
    final meta = <String, dynamic>{
      ...?widget.carouselData.trackingMeta,
      AnalyticsProperties.scrolledTiles: target.toString(),
    };
    sl<HomeTrackAnalyticManager>()
        .logCarouselScrolled(identityHashCode(widget.carouselData), meta);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tiles = widget.carouselData.tiles;
    if (tiles.isEmpty) return const SizedBox.shrink();

    final data = widget.carouselData;
    final viewConfig = data.viewConfig;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalMargin = widget.margins?.horizontal ?? _defaultHorizontalMargin;
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
        ? (screenWidth <= _narrowScreenThreshold ? _productInfoHeightNarrow : _productInfoHeight)
        : 0.0;
    final carouselHeight =
        tileHeight + productInfoHeight + (_hasColorVariants ? _colorVariantsBuffer : 0);

    if (hasSnapping) {
      _snapItemStride = isFullWidth ? screenWidth : tileWidth + innerHorizontalMargin;
    } else {
      _listItemStride = tileWidth + innerHorizontalMargin;
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
            screenWidth: screenWidth,
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
            key: _key(HomeComponentTestStrings.title),
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
    required double screenWidth,
  }) {
    final tileCount = tiles.length;
    final itemStride = _snapItemStride;

    // Bounded for product carousels; large multiplier for banner-only so
    // they still feel infinite.
    final effectiveCount = _hasProducts ? tileCount : tileCount * _forwardCycleBudget;

    // Pre-compute whether the content actually overflows the viewport (only
    // meaningful for bounded product carousels — cycling banners always do).
    // Used to suppress the indicator when there's no scope to scroll.
    final contentExtent =
        horizontalMargin * 2 +
        tileCount * tileWidth +
        (tileCount > 0 ? (tileCount - 1) * innerHorizontalMargin : 0);
    final hasScrollScope = _hasProducts ? contentExtent > screenWidth + 0.5 : true;

    // Trailing list-padding = horizontalMargin minus the inner-margin baked
    // into each item, so after the last tile the gap to the screen edge is
    // still horizontalMargin.
    final trailingListPadding = (horizontalMargin - innerHorizontalMargin).clamp(
      0.0,
      double.infinity,
    );

    final snappingList = SizedBox(
      height: carouselHeight,
      child: RepaintBoundary(
        child: ListView.builder(
          controller: _snapController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: horizontalMargin, right: trailingListPadding),
          physics: _SnapScrollPhysics(itemStride: itemStride),
          itemExtent: itemStride,
          itemCount: effectiveCount,
          itemBuilder: (_, index) => Padding(
            padding: EdgeInsets.only(right: innerHorizontalMargin),
            child: _buildTile(tiles[index % tileCount], index % tileCount, tileWidth,
              tileHeight,
              imageCornerRadius,
              index % tileCount,
            ),
          ),
        ),
      ),
    );

    if (!showIndicators || tileCount <= 1 || !hasScrollScope) {
      return snappingList;
    }

    if (isFullWidth) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          snappingList,
          _DotIndicators(currentPage: _currentPage, count: tileCount),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        snappingList,
        _PageLineIndicator(currentPage: _currentPage, count: tileCount),
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
      child: RepaintBoundary(
        child: ListView.separated(
          controller: _listController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
          itemCount: tiles.length,
          separatorBuilder: (_, _) => SizedBox(width: innerHorizontalMargin),
          itemBuilder: (_, i) => _buildTile(tiles[i], i, tileWidth, tileHeight, imageCornerRadius, i),
        ),
      ),
    );

    // The horizontal ListView is unindexed by snapping, so the full-width dot
    // indicator just shows the first tile (pre-existing behaviour).

    if (!showIndicators || tiles.length <= 1) return tileList;

    if (isFullWidth) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          tileList,
          // Scrollable variant has no snapping page index — _currentPage stays
          // at 0 and the indicator just highlights the first dot. Pre-existing
          // behaviour.
          _DotIndicators(currentPage: _currentPage, count: tiles.length),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tileList,
        _ScrollLineIndicator(state: _lineState),
      ],
    );
  }

  Widget _buildTile(
    PageCarouselTile tile,
    int position,
    double tileWidth,
    double tileHeight,
    double cornerRadius,
    int index,
  ) {
    final product = tile.product;
    final tapUri = tile.actionUri ?? product?.actionUri;

    Future<void> logClick() => sl<HomeTrackAnalyticManager>()
        .onPageCarouselTileTapped(widget.carouselData, tile);

    if (product != null) {
      return SizedBox(
        width: tileWidth,
        child: WishlistStatusBuilder(
          product: product,
          builder: (context, wished) => ProductTile.fromProduct(
            product,
            key: _tileKey(index),
            wishlistKey: _tileSubKey(index, HomeComponentTestStrings.tileWishlistSuffix),
            nameKey: _tileSubKey(index, HomeComponentTestStrings.tileNameSuffix),
            priceKey: _tileSubKey(index, HomeComponentTestStrings.tilePriceSuffix),
            discountKey: _tileSubKey(index, HomeComponentTestStrings.tileDiscountSuffix),
            colorVariantsKey: _tileSubKey(index, HomeComponentTestStrings.tileColorVariantsSuffix),
            visualCueKeyBuilder: (j) =>
                _tileSubKey(index, '${HomeComponentTestStrings.tileVisualCueSuffix}_$j'),
            imageUrl: tile.imageUrl ?? product.displayImage,
            imageAspectRatio: tileHeight > 0 ? tileWidth / tileHeight : null,
            isWishlisted: wished,
            onTap: () {
              unawaited(logClick());
              ActionUrlHandler.navigate(context, tapUri);
            },
            onWishlistTap: () => WishlistActions.toggle(
              context,
              productId: product.id.toString(),
              price: WishlistActions.priceToInt(product.price?.sellingPrice),
              loggedOutMessageBars: const [
                MessageBarEntity(
                  text: LoginRedirects.redirectAddToWishlist,
                  type: 'info',
                  hasIcon: true,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final image = SizedBox(
      height: tileHeight,
      width: tileWidth,
      child: CustomImage(path: tile.imageUrl ?? '', fit: BoxFit.cover),
    );

    return GestureDetector(
      key: _tileKey(index),
      onTap: () {
        unawaited(logClick());
        ActionUrlHandler.navigate(context, tapUri);
      },
      child: SizedBox(
        width: tileWidth,
        child: Align(
          alignment: Alignment.topCenter,
          child: cornerRadius > 0
              ? ClipRRect(borderRadius: BorderRadius.circular(cornerRadius), child: image)
              : image,
        ),
      ),
    );
  }
}

// ─── Indicators ──────────────────────────────────────────────────────────────

class _DotIndicators extends StatelessWidget {
  const _DotIndicators({required this.currentPage, required this.count});

  /// Notifier so a page change rebuilds only this indicator, not the
  /// PageView or the surrounding carousel.
  final ValueListenable<int> currentPage;
  final int count;

  static const _dotDuration = Duration(milliseconds: 200);
  static const _dotMargin = EdgeInsets.symmetric(horizontal: 3);
  static const _padding = EdgeInsets.only(bottom: 10);

  // Decorations hoisted to single allocations — `AnimatedContainer` swaps
  // references and tweens between them, so we don't pay per-build BoxDeco /
  // BorderRadius / Color.withValues allocations per dot per page change.
  static const _borderRadius = BorderRadius.all(Radius.circular(3));
  static const _activeDecoration = BoxDecoration(
    color: AppColors.baseDefault,
    borderRadius: _borderRadius,
  );
  static final _inactiveDecoration = BoxDecoration(
    color: AppColors.baseDefault.withValues(alpha: 0.5),
    borderRadius: _borderRadius,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (_, page, _) {
        final activeIndex = page % count;
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
                decoration: isActive ? _activeDecoration : _inactiveDecoration,
              );
            }),
          ),
        );
      },
    );
  }
}

/// Free-scroll variant: the notifier confines rebuilds to the bar itself, so
/// the carousel above never rebuilds during a swipe.
class _ScrollLineIndicator extends StatelessWidget {
  const _ScrollLineIndicator({required this.state});

  final ValueListenable<_LineState> state;

  // Longer than the scroll throttle so a new target always arrives mid-tween
  // → the thumb glides continuously instead of stepping frame-by-frame.
  static const _smoothing = Duration(milliseconds: 120);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_LineState>(
      valueListenable: state,
      builder: (_, value, _) => _LineBar(
        progress: value.progress,
        fraction: value.fraction,
        duration: _smoothing,
      ),
    );
  }
}

/// Snapping variant: page jumps are discrete, so we tween between values.
class _PageLineIndicator extends StatelessWidget {
  const _PageLineIndicator({required this.currentPage, required this.count});

  final ValueListenable<int> currentPage;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    final fraction = (1.0 / count).clamp(0.15, 1.0);
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (_, page, _) {
        final activeIndex = page % count;
        return _LineBar(
          progress: activeIndex / (count - 1),
          fraction: fraction,
          duration: _LineBar._pageSnapDuration,
        );
      },
    );
  }
}

class _LineBar extends StatelessWidget {
  const _LineBar({
    required this.progress,
    required this.fraction,
    required this.duration,
  });

  final double progress;
  final double fraction;
  final Duration duration;

  static const double _trackWidth = 250;
  static const double _thumbHeight = 3.5;
  static const double _trackHeight = 2;
  static const _trackRadius = BorderRadius.all(Radius.circular(_trackHeight / 2));
  static const _thumbRadius = BorderRadius.all(Radius.circular(_thumbHeight / 2));
  static const _padding = EdgeInsets.only(top: 29);
  static const _pageSnapDuration = Duration(milliseconds: 200);
  static const _trackDecoration = BoxDecoration(
    color: AppColors.lineIndicator,
    borderRadius: _trackRadius,
  );
  static const _thumbDecoration = BoxDecoration(
    color: AppColors.neutralGrey6,
    borderRadius: _thumbRadius,
  );

  @override
  Widget build(BuildContext context) {
    final thumbWidth = _trackWidth * fraction;
    final left = progress.clamp(0.0, 1.0) * (_trackWidth - thumbWidth);

    return Padding(
      padding: _padding,
      child: Center(
        child: SizedBox(
          width: _trackWidth,
          height: _thumbHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: _trackWidth,
                height: _trackHeight,
                child: DecoratedBox(decoration: _trackDecoration),
              ),
              AnimatedPositioned(
                duration: duration,
                curve: Curves.easeOut,
                left: left,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: thumbWidth,
                  height: _thumbHeight,
                  child: const DecoratedBox(decoration: _thumbDecoration),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SnapScrollPhysics extends ScrollPhysics {
  final double itemStride;

  const _SnapScrollPhysics({required this.itemStride, super.parent});

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(itemStride: itemStride, parent: buildParent(ancestor));
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    final pixels = position.pixels;
    final maxExtent = position.maxScrollExtent;
    if (itemStride <= 0 || maxExtent <= 0) return pixels;

    double page = pixels / itemStride;
    if (velocity < -tolerance.velocity) {
      page = page.floorToDouble();
    } else if (velocity > tolerance.velocity) {
      page = page.ceilToDouble();
    } else {
      page = page.roundToDouble();
    }
    double target = page * itemStride;

    // The last reachable snap is `maxExtent` itself (last tile aligned to
    // the trailing padding). If the page snap would overshoot maxExtent,
    // or the user has scrolled past the second-to-last page boundary AND
    // is closer to maxExtent than to the page snap, prefer maxExtent.
    if (target > maxExtent) {
      target = maxExtent;
    } else if (pixels > maxExtent - itemStride &&
        (maxExtent - pixels).abs() < (target - pixels).abs()) {
      target = maxExtent;
    }

    return target.clamp(0.0, maxExtent);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    // Defer to default physics at the edges — let the parent handle the
    // overscroll glow / bounce without injecting our own simulation.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }

  @override
  bool get allowImplicitScrolling => false;
}
