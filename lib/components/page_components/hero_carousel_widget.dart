import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class HeroCarouselWidget extends StatefulWidget {
  final HeroCarouselData heroData;
  final ComponentMargins? margins;

  const HeroCarouselWidget({super.key, required this.heroData, this.margins});

  @override
  State<HeroCarouselWidget> createState() => _HeroCarouselWidgetState();
}

class _HeroCarouselWidgetState extends State<HeroCarouselWidget>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  PageController? _controller;
  int _currentPage = 0;
  Timer? _timer;

  // Left-scroll budget — same pattern as PageCarouselWidget.
  static const int _leftScrollBudget = 100;

  // Defaults mirror Android: dimension = displayWidth - 40.px() → 20dp per side.
  // Set horizontalMargin = 0 via margins JSON to get a full-screen hero.
  static const double _defaultHorizontalMargin = 20.0;

  // Mirrors Android: heroCarouselList.pageMargin = 12.px()
  static const double _defaultInnerHorizontalMargin = 12.0;

  List<HeroTile> get _tiles => widget.heroData.tiles;
  int get _durationMs => widget.heroData.scrollDuration ?? 3000;

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
    super.dispose();
  }

  // Mirrors Android onPause / onResume lifecycle callbacks.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAutoScroll();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
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
        _currentPage + 1,
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
    final double horizontalMargin =
        widget.margins?.horizontal ?? _defaultHorizontalMargin;
    final double innerHorizontalMargin =
        widget.margins?.innerHorizontalMargin ?? _defaultInnerHorizontalMargin;

    final double viewportFraction =
        (screenWidth - horizontalMargin * 2) / screenWidth;

    if (_controller == null) {
      final int initialPage = tiles.length * _leftScrollBudget;
      _controller = PageController(
        viewportFraction: viewportFraction.clamp(0.1, 1.0),
        initialPage: initialPage,
      );
      _currentPage = initialPage;
    }

    final double tileWidth = screenWidth * viewportFraction;
    final double aspectRatio = tiles.first.aspectRatio;
    final double tileHeight = aspectRatio > 0
        ? tileWidth / aspectRatio
        : tileWidth;

    // No inner gap when full-screen (viewportFraction = 1.0); adjacent tiles
    // aren't visible so padding would just shrink the image unnecessarily.
    final double tilePadding = horizontalMargin > 0
        ? innerHorizontalMargin / 2
        : 0.0;

    final int activeDot = _currentPage % tiles.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: tileHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              // Pause auto-scroll while the user is swiping; restart when settled.
              if (notification is ScrollStartNotification) _cancelTimer();
              if (notification is ScrollEndNotification) _startAutoScroll();
              return false;
            },
            child: PageView.builder(
              controller: _controller!,
              itemCount: null,
              onPageChanged: (int index) =>
                  setState(() => _currentPage = index),
              itemBuilder: (BuildContext context, int index) {
                final HeroTile tile = tiles[index % tiles.length];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: tilePadding),
                  child: GestureDetector(
                    onTap: () =>
                        ActionUrlHandler.navigate(context, tile.actionUri),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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
        ),
        if (tiles.length > 1) _buildIndicator(tiles.length, activeDot),
      ],
    );
  }

  Widget _buildIndicator(int count, int activeDot) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (int index) {
          final bool isActive = index == activeDot;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 28 : 8,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isActive ? AppColors.neutralBlack : AppColors.textDisabled,
            ),
          );
        }),
      ),
    );
  }
}
