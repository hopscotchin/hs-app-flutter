import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/analytics/home/home_component_click_handlers.dart';
import '../../core/analytics/home/home_track_analytic_manager.dart';
import '../../core/di/injection.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class HeroCarouselWidget extends StatefulWidget {
  final HeroCarouselData heroData;
  final ComponentMargins? margins;

  /// Component-level automation key prefix, e.g. `hp_hero_0`. Null → unkeyed.
  final String? keyPrefix;

  const HeroCarouselWidget({
    super.key,
    required this.heroData,
    this.margins,
    this.keyPrefix,
  });

  @override
  State<HeroCarouselWidget> createState() => _HeroCarouselWidgetState();
}

class _HeroCarouselWidgetState extends State<HeroCarouselWidget>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  PageController? _controller;

  /// Notifier-backed page index so swipes / auto-scroll only rebuild the
  /// dot indicator — not the PageView, the layout math, or the auto-scroll
  /// timer wiring. Big win when the discover scroll view is repainting.
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  Timer? _timer;

  // Left-scroll budget — same pattern as PageCarouselWidget.
  static const int _leftScrollBudget = 100;

  // Defaults mirror Android: dimension = displayWidth - 40.px() → 20dp per side.
  // Set horizontalMargin = 0 via margins JSON to get a full-screen hero.
  static const double _defaultHorizontalMargin = 20.0;

  // Mirrors Android: heroCarouselList.pageMargin = 12.px()
  static const double _defaultInnerHorizontalMargin = 12.0;

  List<HeroTile> get _tiles => widget.heroData.tiles;

  /// Builds a tile key `<prefix>_tiles_<i>`, or null when unkeyed.
  Key? _tileKey(int i) {
    final prefix = widget.keyPrefix;
    if (prefix == null) return null;
    return ValueKey('${prefix}_${HomeComponentTestStrings.tiles}_$i');
  }

  int get _durationMs => widget.heroData.viewConfig?.scrollDuration ?? 3000;
  double get _cornerRadius => widget.heroData.viewConfig?.imageCornerRadius ?? 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAutoScroll();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelTimer();
    _controller?.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  // Mirrors Android onPause / onResume lifecycle callbacks.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAutoScroll();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _cancelTimer();
    }
  }

  void _startAutoScroll() {
    if (_tiles.length <= 1) return;
    _cancelTimer();
    _timer = Timer.periodic(Duration(milliseconds: _durationMs), (_) {
      if (!mounted || _controller == null) return;
      // Always animate forward — no backward jump needed since itemCount is infinite.
      _controller!.animateToPage(
        _currentPage.value + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<HeroTile> tiles = _tiles;
    if (tiles.isEmpty) return const SizedBox.shrink();

    final double screenWidth = MediaQuery.sizeOf(context).width;

    // horizontalMargin = 0  →  viewportFraction = 1.0  →  full-screen hero
    // horizontalMargin = 20 →  viewportFraction < 1.0  →  adjacent tiles peek on both sides
    final double horizontalMargin = widget.margins?.horizontal ?? _defaultHorizontalMargin;
    final double innerHorizontalMargin =
        widget.margins?.innerHorizontalMargin ?? _defaultInnerHorizontalMargin;

    final double viewportFraction = (screenWidth - horizontalMargin * 2) / screenWidth;

    if (_controller == null) {
      final int initialPage = tiles.length * _leftScrollBudget;
      _controller = PageController(
        viewportFraction: viewportFraction.clamp(0.1, 1.0),
        initialPage: initialPage,
      );
      _currentPage.value = initialPage;
    }

    final double tileWidth = screenWidth * viewportFraction;
    final double aspectRatio = tiles.first.aspectRatio;
    final double tileHeight = aspectRatio > 0 ? tileWidth / aspectRatio : tileWidth;

    // No inner gap when full-screen (viewportFraction = 1.0); adjacent tiles
    // aren't visible so padding would just shrink the image unnecessarily.
    final double tilePadding = horizontalMargin > 0 ? innerHorizontalMargin / 2 : 0.0;

    return SizedBox(
      height: tileHeight,
      // Isolate the carousel's repaints (swipes, auto-scroll, image fades)
      // from the parent CustomScrollView so a hero ticking through pages
      // doesn't re-rasterise the whole homepage.
      child: RepaintBoundary(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                // Pause auto-scroll while the user is swiping; restart when settled.
                if (notification is ScrollStartNotification) _cancelTimer();
                if (notification is ScrollEndNotification) _startAutoScroll();
                return false;
              },
              child: PageView.builder(
                controller: _controller!,
                itemCount: null,
                allowImplicitScrolling: true,
                onPageChanged: (int index) => _currentPage.value = index,
                itemBuilder: (BuildContext context, int index) {
                  final int tileIndex = index % tiles.length;
                  final HeroTile tile = tiles[tileIndex];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: tilePadding),
                    child: GestureDetector(
                      key: _tileKey(tileIndex),
                      onTap: () {
                        // Fire-and-forget: OrderAttribution/LpAttribution
                        // update in-memory synchronously; only the pref
                        // disk write + Segment track is async. Awaiting
                        // blocked navigation by tens/hundreds of ms.
                        unawaited(sl<HomeTrackAnalyticManager>()
                            .onHeroTileTapped(widget.heroData, tile));
                        ActionUrlHandler.navigate(context, tile.actionUri);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_cornerRadius),
                        child: CachedImageWidget(
                          imageUrl: tile.imageUrl,
                          width: double.infinity,
                          height: tileHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (tiles.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 36,
                child: IgnorePointer(
                  child: _DotIndicator(count: tiles.length, currentPage: _currentPage),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Listens to the carousel's page-index notifier and rebuilds only itself
/// when the active dot changes — the PageView, the parent Stack, and the
/// surrounding scroll view all stay put.
class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.currentPage});

  final int count;
  final ValueListenable<int> currentPage;

  static const _duration = Duration(milliseconds: 200);
  static const _margin = EdgeInsets.symmetric(horizontal: 3);
  static final _borderRadius = BorderRadius.circular(3);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (_, page, _) {
        final activeDot = page % count;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (int index) {
            final bool isActive = index == activeDot;
            return AnimatedContainer(
              duration: _duration,
              margin: _margin,
              width: isActive ? 40 : 8,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: _borderRadius,
                color: isActive
                    ? AppColors.baseDefault
                    : AppColors.baseDefault.withValues(alpha: 0.5),
              ),
            );
          }),
        );
      },
    );
  }
}
