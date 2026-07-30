import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/offer_entity.dart';
import 'pdp_snackbar.dart';

// ── Design tokens ────────────────────────────────────────────────────────────
const _kCardBg = Color(0xFFF6F6F6);
const _kCardRadius = 10.0;
const _kCardHeight = 124.0;
const _kChipBg = Color(0x26836EF1); // rgba(131,110,241,0.15)
const _kChipBorder = Color(0xFF836EF1);
const _kOfferPriceColor = Color(0xFF836EF1);
const _kDescColor = Color(0xFF000000);
const _kCopyColor = Color(0xFF000000);
const _kIndicatorActiveColor = AppColors.neutralGrey6;
const _kIndicatorTrackColor = Color(0xFF000000); // opacity 0.2 applied inline
const _kCardGap = 8.0;

class PdpOffers extends StatefulWidget {
  const PdpOffers({super.key, required this.offers});

  final List<OfferEntity> offers;

  @override
  State<PdpOffers> createState() => _PdpOffersState();
}

class _PdpOffersState extends State<PdpOffers> {
  final _scrollController = ScrollController();

  // Notifier-backed snapped card index — mirrors PageCarouselWidget's
  // _currentPage so a scroll tick only rebuilds the indicator (not the whole
  // section), and so the thumb tracks a stable, rounded target instead of
  // raw scroll pixels (which wobble during the snap's spring simulation and
  // read as a jerk/jump, especially scrolling backward).
  final _currentIndex = ValueNotifier<int>(0);

  // Current per-card stride (cardWidth + gap), refreshed from build() so
  // _onScroll can map scroll pixels → card index — mirrors
  // PageCarouselWidget's _snapItemStride.
  double _snapItemStride = 0.0;

  // Auto-scroll — mirrors Android's PromoView (2s interval, wrap to first,
  // pause on user interaction, resume shortly after it ends).
  static const _autoScrollInterval = Duration(seconds: 2);
  static const _resumeAfterInteraction = Duration(seconds: 3);
  static const _advanceDuration = Duration(milliseconds: 400);
  Timer? _autoScrollTimer;
  Timer? _resumeTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _maybeStartAutoScroll();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _resumeTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  // ── Auto-scroll ─────────────────────────────────────────────────────────────

  void _maybeStartAutoScroll() {
    if (widget.offers.length <= 1 || _userInteracting) {
      _stopAutoScroll();
      return;
    }
    _autoScrollTimer ??= Timer.periodic(_autoScrollInterval, (_) => _advance());
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _advance() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0 || _snapItemStride <= 0) return;
    final atEnd = pos.pixels >= pos.maxScrollExtent - 0.5;
    // Wrap back to the first card after the last (matches Android).
    final target = atEnd
        ? 0.0
        : (pos.pixels + _snapItemStride).clamp(0.0, pos.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: _advanceDuration,
      curve: Curves.easeInOut,
    );
  }

  // User drag pauses the loop; it resumes a few seconds after the drag ends.
  bool _onUserScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _userInteracting = true;
      _resumeTimer?.cancel();
      _stopAutoScroll();
    } else if (notification is ScrollEndNotification) {
      _resumeTimer?.cancel();
      _resumeTimer = Timer(_resumeAfterInteraction, () {
        _userInteracting = false;
        _maybeStartAutoScroll();
      });
    }
    return false;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_snapItemStride <= 0) return;
    final pos = _scrollController.position;
    final cardCount = widget.offers.length;
    if (cardCount == 0) return;

    int rounded;
    if (pos.maxScrollExtent > 0 && pos.pixels >= pos.maxScrollExtent - 0.5) {
      rounded = cardCount - 1;
    } else {
      rounded = (pos.pixels / _snapItemStride).round().clamp(0, cardCount - 1);
    }

    if (rounded != _currentIndex.value) {
      _currentIndex.value = rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.sizeOf(context).width;
    // Card fills the visible area minus padding, leaving a ~38px peek of the next card.
    final cardWidth = (screenW - AppSpacing.sm * 2 - _kCardGap - 38).clamp(
      200.0,
      360.0,
    );
    _snapItemStride = cardWidth + _kCardGap;

    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section title ─────────────────────────────────────────────────
          Padding(
            padding: AppSpacing.paddingHorizontalSm,
            child: Text(
              PdpStrings.offersAndDiscounts,
              key: const ValueKey(PdpTestStrings.offersTitle),
              style: AppTypographyV1.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
                height: 1.0,
              ),
            ),
          ),

          AppSpacing.verticalGapLgMd,

          // ── Horizontal card list ──────────────────────────────────────────
          NotificationListener<ScrollNotification>(
            onNotification: _onUserScrollNotification,
            child: _OfferCardList(
              offers: widget.offers,
              scrollController: _scrollController,
              cardWidth: cardWidth,
            ),
          ),

          AppSpacing.verticalGapLgMd,

          // ── Scroll indicator ──────────────────────────────────────────────
          Padding(
            padding: AppSpacing.paddingHorizontalSm,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, index, _) => _ScrollIndicator(
                key: const ValueKey(PdpTestStrings.offersIndicator),
                currentIndex: index,
                cardCount: widget.offers.length,
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// ── Card list ─────────────────────────────────────────────────────────────────

class _OfferCardList extends StatelessWidget {
  const _OfferCardList({
    required this.offers,
    required this.scrollController,
    required this.cardWidth,
  });

  final List<OfferEntity> offers;
  final ScrollController scrollController;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kCardHeight,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: _SnapScrollPhysics(itemStride: cardWidth + _kCardGap),
        padding: AppSpacing.paddingHorizontalSm,
        itemCount: offers.length,
        separatorBuilder: (_, _) => const SizedBox(width: _kCardGap),
        itemBuilder: (context, index) => _OfferCard(
          key: ValueKey('${PdpTestStrings.offerCard}_$index'),
          copyKey: ValueKey(
            '${PdpTestStrings.offerCard}_${index}_${PdpTestStrings.offerCopySuffix}',
          ),
          offer: offers[index],
          width: cardWidth,
        ),
      ),
    );
  }
}

// ── Single offer card ─────────────────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.offer,
    required this.width,
    super.key,
    this.copyKey,
  });

  final OfferEntity offer;
  final double width;
  final Key? copyKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _kCardHeight,
      decoration: const BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
      ),
      padding: AppSpacing.paddingMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top block flexes to fill the space above the copy button; the
          // description clips within whatever room remains so the fixed-height
          // card never overflows on long copy.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coupon chip — only if displayCoupon flag is set
                if (offer.displayCoupon && offer.couponCode != null)
                  _CouponChip(code: offer.couponCode!),

                AppSpacing.verticalGapXsm,

                // Header (bold purple)
                if (offer.header != null)
                  Text(
                    offer.header!,
                    style: AppTypographyV1.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _kOfferPriceColor,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                AppSpacing.verticalGapXsm,

                // Description — Flexible so it ellipsizes to the leftover height.
                if (offer.description != null)
                  Flexible(
                    child: Text(
                      offer.description!,
                      style: AppTypographyV1.labelMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        color: _kDescColor,
                        height: 14 / 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          // Copy button — only if copyCoupon flag is set
          if (offer.copyCoupon && offer.couponCode != null) ...[
            // const SizedBox(height: 10),
            GestureDetector(
              key: copyKey,
              onTap: () {
                Clipboard.setData(ClipboardData(text: offer.couponCode!));
                PdpSnackbar.show(context, '${offer.couponCode} copied!');
              },
              child: Text(
                PdpStrings.copy,
                style: AppTypographyV1.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _kCopyColor,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Coupon chip ───────────────────────────────────────────────────────────────

// Snaps the horizontal card list to card boundaries — mirrors
// PageCarouselWidget's snap physics so the scroll indicator advances one
// card at a time instead of drifting to arbitrary offsets.
class _SnapScrollPhysics extends ScrollPhysics {
  final double itemStride;

  const _SnapScrollPhysics({required this.itemStride, super.parent});

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(
      itemStride: itemStride,
      parent: buildParent(ancestor),
    );
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
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

    if (target > maxExtent) {
      target = maxExtent;
    } else if (pixels > maxExtent - itemStride &&
        (maxExtent - pixels).abs() < (target - pixels).abs()) {
      target = maxExtent;
    }

    return target.clamp(0.0, maxExtent);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}

class _CouponChip extends StatelessWidget {
  const _CouponChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // Dashed border drawn on top of the fill — Flutter's BoxDecoration has no
      // dashed BorderStyle, so we stroke a dashed rounded-rect ourselves.
      foregroundPainter: const _DashedRRectPainter(
        color: _kChipBorder,
        radius: 5,
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: _kChipBg,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          code,
          style: AppTypographyV1.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            color: _kDescColor,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

// Strokes a dashed rounded-rectangle border around the paint bounds.
class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _strokeWidth = 0.5;
  static const double _dash = 2.0;
  static const double _gap = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    // Inset by half the stroke so the dashes sit fully inside the bounds.
    final rect =
        const Offset(_strokeWidth / 2, _strokeWidth / 2) &
        Size(size.width - _strokeWidth, size.height - _strokeWidth);
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        canvas.drawPath(
          metric.extractPath(dist, (dist + _dash).clamp(0.0, metric.length)),
          paint,
        );
        dist += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}

// ── Scroll indicator ──────────────────────────────────────────────────────────

class _ScrollIndicator extends StatelessWidget {
  const _ScrollIndicator({
    required this.currentIndex,
    required this.cardCount,
    super.key,
  });

  final int currentIndex;
  final int cardCount;

  // Matches PageCarouselWidget's _LineBar(animate: true) — the thumb eases
  // to each snapped index instead of tracking raw scroll pixels.
  static const _animDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    if (cardCount <= 1) return const SizedBox.shrink();

    final screenW = MediaQuery.sizeOf(context).width;
    // Indicator represents 1 card as a fraction of all cards (capped at 20% min).
    final indicatorFraction = (1.0 / cardCount).clamp(0.1, 1.0);
    final indicatorWidth = (screenW * indicatorFraction).clamp(40.0, screenW);
    final maxTravel = screenW - indicatorWidth;
    final progress = currentIndex / (cardCount - 1);
    final indicatorOffset = progress.clamp(0.0, 1.0) * maxTravel;

    const activeHeight = 3.0;
    const trackHeight = activeHeight / 3;

    return SizedBox(
      height: activeHeight,
      width: screenW,
      child: Stack(
        children: [
          // Track height is one third of the active thumb height, aligned to the same
          // baseline so the thumb sits above the track instead of overlapping its middle.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: trackHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _kIndicatorTrackColor.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(trackHeight / 2),
                ),
              ),
            ),
          ),
          // Active indicator — eases to the snapped card's position.
          AnimatedPositioned(
            duration: _animDuration,
            curve: Curves.easeOut,
            left: indicatorOffset,
            top: 0,
            width: indicatorWidth,
            height: activeHeight,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: _kIndicatorActiveColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(activeHeight / 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
