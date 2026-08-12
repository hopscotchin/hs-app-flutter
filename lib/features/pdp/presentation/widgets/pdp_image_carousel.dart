import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/media_entity.dart';
import 'pdp_vertical_dot_indicator.dart';

class PdpImageCarousel extends StatefulWidget {
  const PdpImageCarousel({
    super.key,
    required this.media,
    required this.pageScrollPosition,
    this.visualCue,
  });

  final List<MediaEntity> media;
  final VisualCueEntity? visualCue;

  /// The single page scroll position (the whole PDP is one CustomScrollView).
  /// The carousel pages image-to-image while the page is at the top; once the
  /// last image is reached (or the page is already scrolled), a vertical drag on
  /// the image is forwarded straight into this position so the image and the
  /// rest of the page scroll as one continuous, native scroll. Returns null
  /// until that scroll view has been laid out.
  final ScrollPosition? Function() pageScrollPosition;

  @override
  State<PdpImageCarousel> createState() => _PdpImageCarouselState();
}

class _PdpImageCarouselState extends State<PdpImageCarousel> {
  static const double _eps = 0.001;

  int _currentPage = 0;
  late final PageController _pageController;

  // True while the current pointer gesture is being forwarded into the page
  // scroll (rather than paging images). Set by the Listener on each move
  // BEFORE the PageView physics reads it (raw listeners fire before gesture
  // recognizers), so the physics can freeze the carousel in lock-step.
  bool _driving = false;
  // Active drag forwarded into the page scroll position, plus a velocity
  // tracker so releasing an image-drag hands the page the same fling it would
  // get from dragging the page directly.
  Drag? _pageDrag;
  VelocityTracker? _velocityTracker;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageDrag?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // The carousel must not change image whenever the page is scrolled off the
  // top, or while a gesture is actively driving the page.
  //
  // Crucially this checks the page's real scroll position, not just the
  // transient _driving flag: _driving is cleared on pointer-up, but the
  // PageView's fling ballistic runs AFTER that. Keying only on _driving let a
  // flick snap to the next image once the drag ended — the page scrolled and
  // the image swiped at the same time. Reading the position keeps this true
  // through the fling, so the carousel stays put.
  bool get _suppressImagePaging {
    if (_driving) return true;
    final position = widget.pageScrollPosition();
    if (position == null) return false;
    return position.pixels > position.minScrollExtent + 0.5;
  }

  // Should this pointer move scroll the whole page (vs. page image-to-image)?
  // - Page already scrolled below the top → always: the carousel is scrolling
  //   away, so any drag on it just continues the page scroll.
  // - Page at the top → only an up-drag on the LAST image starts scrolling into
  //   the content; earlier images (and down-drags) keep paging image-to-image.
  bool _shouldDrivePage(double dy) {
    final position = widget.pageScrollPosition();
    if (position == null) return false;
    final atTop = position.pixels <= position.minScrollExtent + 0.5;
    if (!atTop) return true;
    final page = _pageController.hasClients
        ? (_pageController.page ?? _currentPage.toDouble())
        : _currentPage.toDouble();
    final atLastImage = page >= (widget.media.length - 1) - _eps;
    return dy < 0 && atLastImage;
  }

  void _onPointerMove(PointerMoveEvent event) {
    _driving = _shouldDrivePage(event.delta.dy);
    if (!_driving) {
      _endPageDrag();
      return;
    }
    final position = widget.pageScrollPosition();
    if (position == null) {
      _endPageDrag();
      return;
    }
    if (_pageDrag == null) {
      _velocityTracker = VelocityTracker.withKind(event.kind);
      _pageDrag = position.drag(
        DragStartDetails(
          sourceTimeStamp: event.timeStamp,
          globalPosition: event.position,
          kind: event.kind,
        ),
        () => _pageDrag = null,
      );
    }
    _velocityTracker!.addPosition(event.timeStamp, event.position);
    _pageDrag!.update(
      DragUpdateDetails(
        sourceTimeStamp: event.timeStamp,
        globalPosition: event.position,
        delta: Offset(0, event.delta.dy),
        primaryDelta: event.delta.dy,
      ),
    );
  }

  void _endPageDrag() {
    final drag = _pageDrag;
    if (drag == null) return;
    _pageDrag = null;
    final velocity = _velocityTracker?.getVelocity() ?? Velocity.zero;
    _velocityTracker = null;
    drag.end(
      DragEndDetails(
        velocity: Velocity(pixelsPerSecond: Offset(0, velocity.pixelsPerSecond.dy)),
        primaryVelocity: velocity.pixelsPerSecond.dy,
      ),
    );
  }

  void _onPointerUp() {
    _endPageDrag();
    _driving = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return _emptySlot();

    final imageWidth = MediaQuery.sizeOf(context).width;
    final imageHeight = imageWidth / PdpStrings.imageAspectRatio;

    return Listener(
      onPointerMove: _onPointerMove,
      onPointerUp: (_) => _onPointerUp(),
      onPointerCancel: (_) => _onPointerUp(),
      child: AspectRatio(
        aspectRatio: PdpStrings.imageAspectRatio,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: _CarouselCoordinationPhysics(suppressPaging: () => _suppressImagePaging),
              itemCount: widget.media.length,
              allowImplicitScrolling: true,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final url = widget.media[index].url;
                if (url == null) return _emptySlot();
                // Tap opens the fullscreen gallery (zoom lives there). No
                // InteractiveViewer here — its opaque scale gesture steals
                // vertical drags from the PageView once the page has scrolled.
                return GestureDetector(
                  key: ValueKey('${PdpTestStrings.carouselImage}_$index'),
                  onTap: () => AppNavigator.goToPdpImageGallery(
                    context,
                    media: widget.media,
                    initialIndex: index,
                  ),
                  child: CachedImageWidget(
                    imageUrl: url,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            if (widget.media.length > 1)
              Positioned(
                right: 14,
                top: 0,
                bottom: 0,
                child: Center(
                  child: PdpVerticalDotIndicator(
                    key: const ValueKey(PdpTestStrings.carouselDotIndicator),
                    count: widget.media.length,
                    currentIndex: _currentPage,
                  ),
                ),
              ),

            // Visual cue badge — positioned so it sits visualCueBottomGap above
            // the content sheet's top edge (which itself sits
            // sheetCarouselOverlap above the carousel's own bottom edge).
            // Static: positioned for the unscrolled page.
            if (widget.visualCue != null)
              Positioned(
                left: 12,
                bottom: PdpStrings.sheetCarouselOverlap + PdpStrings.visualCueBottomGap,
                child: _VisualCueBadge(
                  key: const ValueKey(PdpTestStrings.visualCueBadge),
                  cue: widget.visualCue!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptySlot() => const AspectRatio(
    aspectRatio: PdpStrings.imageAspectRatio,
    child: ColoredBox(
      color: Color(0xFFF5F5F5),
      child: Center(child: Icon(Icons.image_outlined, size: 48, color: Colors.grey)),
    ),
  );
}

class _VisualCueBadge extends StatelessWidget {
  const _VisualCueBadge({super.key, required this.cue});

  final VisualCueEntity cue;

  static Color? _parseColor(String? hex) {
    if (hex == null) return null;
    try {
      return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiType = cue.uiType?.toUpperCase();

    if (uiType == 'IMAGE' && cue.imageUrl != null) {
      // SVG-aware — matches ProductTile's badge (PLP), whose visual cue
      // assets (e.g. trending.svg) are vectors, not raster images. Explicit
      // size so BoxFit.contain has a box to scale within — the enclosing
      // ConstrainedBox alone won't make an unbounded SvgPicture respect a max.
      return CustomImage(path: cue.imageUrl!, fit: BoxFit.contain);
    }

    // TEXT (default)
    final text = cue.text;
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final bg = _parseColor(cue.bgColor) ?? AppColors.brandTertiary;
    final fg = _parseColor(cue.textColor) ?? AppColors.brandDefault;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: bg, borderRadius: AppSpacing.borderRadiusXs),
      child: Text(
        text,
        style: AppTypographyV1.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: fg,
          height: 1.2,
        ),
      ),
    );
  }
}

// Whenever image paging must be suppressed (the page is scrolled off the top,
// or a gesture is driving the page scroll), the carousel must not move at all:
// the drag is being forwarded into the page's scroll position (see
// _onPointerMove), so the PageView freezes in lock-step and any fling is
// neutralised. Otherwise it's a normal vertical PageView (image-to-image
// swiping). suppressPaging reads the page's scroll position, so it stays true
// through the fling that follows a drag — not just during the drag itself.
class _CarouselCoordinationPhysics extends ClampingScrollPhysics {
  const _CarouselCoordinationPhysics({required this.suppressPaging, super.parent});

  final bool Function() suppressPaging;

  @override
  _CarouselCoordinationPhysics applyTo(ScrollPhysics? ancestor) =>
      _CarouselCoordinationPhysics(suppressPaging: suppressPaging, parent: buildParent(ancestor));

  // Always accept the drag. With a single image the PageView has zero scroll
  // extent (minScrollExtent == maxScrollExtent) and the default implementation
  // rejects the drag — so the last-image up-drag that scrolls into the content
  // could never start from a single-image carousel.
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  // An unreachable velocity threshold means no fling ever advances an image —
  // the carousel stays put while the page scrolls, including after release.
  @override
  Tolerance toleranceFor(ScrollMetrics metrics) =>
      suppressPaging() ? const Tolerance(velocity: double.infinity) : super.toleranceFor(metrics);

  // Consume the whole drag so the PageView never moves; the page is scrolled by
  // the forwarded drag instead. Otherwise page images normally.
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) =>
      suppressPaging() ? 0.0 : super.applyPhysicsToUserOffset(position, offset);
}
