import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../components/atoms/custom_image.dart';
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
    this.visualCue,
    this.onLastImageOverscroll,
  });

  final List<MediaEntity> media;
  final VisualCueEntity? visualCue;
  final VoidCallback? onLastImageOverscroll;

  @override
  State<PdpImageCarousel> createState() => _PdpImageCarouselState();
}

class _PdpImageCarouselState extends State<PdpImageCarousel> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return _emptySlot();

    final imageWidth = MediaQuery.sizeOf(context).width;
    final imageHeight = imageWidth / PdpStrings.imageAspectRatio;

    return AspectRatio(
      aspectRatio: PdpStrings.imageAspectRatio,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: _LastPageOverscrollPhysics(
              onOverscroll: () => widget.onLastImageOverscroll?.call(),
            ),
            itemCount: widget.media.length,
            allowImplicitScrolling: true,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final url = widget.media[index].url;
              if (url == null) return _emptySlot();
              // Tapping any image opens the fullscreen gallery at this index,
              // matching Android's PDP carousel behaviour.
              return GestureDetector(
                onTap: () => AppNavigator.goToPdpImageGallery(
                  context,
                  media: widget.media,
                  initialIndex: index,
                ),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: CachedImageWidget(
                    imageUrl: url,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
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
                  count: widget.media.length,
                  currentIndex: _currentPage,
                ),
              ),
            ),

          // Visual cue badge — positioned so it sits visualCueBottomGap above
          // the collapsed sheet's top edge (which itself sits
          // sheetCarouselOverlap above the carousel's own bottom edge).
          // Static: only accounts for the sheet's unexpanded position.
          if (widget.visualCue != null)
            Positioned(
              left: 12,
              bottom: PdpStrings.sheetCarouselOverlap + PdpStrings.visualCueBottomGap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120, maxHeight: 26),
                child: _VisualCueBadge(cue: widget.visualCue!),
              ),
            ),
        ],
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
  const _VisualCueBadge({required this.cue});

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
      return CustomImage(path: cue.imageUrl!, width: 120, height: 26, fit: BoxFit.contain);
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

// Hooks into ClampingScrollPhysics to detect when the user tries to drag
// past the last page — ClampingScrollPhysics never fires OverscrollNotification.
class _LastPageOverscrollPhysics extends ClampingScrollPhysics {
  const _LastPageOverscrollPhysics({required this.onOverscroll, super.parent});

  final VoidCallback onOverscroll;

  @override
  _LastPageOverscrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _LastPageOverscrollPhysics(onOverscroll: onOverscroll, parent: buildParent(ancestor));

  // Always accept the drag. With a single image the PageView has zero scroll
  // extent (minScrollExtent == maxScrollExtent), and the default implementation
  // rejects the drag in that case — so applyBoundaryConditions never runs and
  // the overscroll-to-open-sheet gesture never fires. Accepting unconditionally
  // lets a swipe on a single-image carousel still report the overscroll.
  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final overscroll = super.applyBoundaryConditions(position, value);
    if (overscroll > 0) onOverscroll();
    return overscroll;
  }
}
