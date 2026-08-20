import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/offer_entity.dart';
import 'pdp_snackbar.dart';
import '../../../../components/atoms/auto_semantics.dart';

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
// How much of each neighbouring card shows alongside the current one — the
// previous card on the left, the next on the right.
const _kCardPeek = 38.0;

class PdpOffers extends StatefulWidget {
  const PdpOffers({super.key, required this.offers});

  final List<OfferEntity> offers;

  @override
  State<PdpOffers> createState() => _PdpOffersState();
}

// Kept alive so the carousel survives leaving the viewport. Without it the
// section's element is unmounted once it passes the page's cache extent, taking
// the scroll offset and _currentIndex with it — scrolling back rebuilt at card 0
// and auto-scroll resumed from there. Android keeps its position because
// PromoView and its inner RecyclerView outlive the PDP scroll, and promoPageNumber
// is a field on it. SliverChildListDelegate defaults to addAutomaticKeepAlives,
// so claiming it here is enough.
//
// VisibilityDetector still reports 0 while kept alive: it checks paintsChild()
// up the ancestor chain, and a kept-alive sliver child is laid out but not
// painted — so the auto-scroll gate and the forcedStop reset both still fire.
class _PdpOffersState extends State<PdpOffers>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  // Shift between the list's leading padding and where a card rests when
  // snapped. See build() for how it is derived; scroll offset for card k is
  // k * stride - _snapOrigin, clamped into range, which is what makes the first
  // and last cards sit flush against the screen edges.
  double _snapOrigin = 0.0;

  // Auto-scroll — ported from Android's PromoView. Its rules, in full:
  //
  //  * 2s between advances, and the first advance is 2s after starting
  //    (`delay` precedes `smoothScrollToPosition` in its loop).
  //  * advances to the next card index, wrapping to the first after the last
  //    (getNextSnappedPosition), continuing from wherever the user left off —
  //    Android reads that index back from the snapped view after a drag, which
  //    is what _currentIndex already tracks here.
  //  * runs only while the section is visible on screen (isVisibleOnScreen) and
  //    the host is resumed (repeatOnLifecycle(RESUMED)).
  //  * any touch on the carousel stops it for good (stopForUserAction sets
  //    forcedStop) — there is no timed resume.
  //  * that stop is cleared only by the section leaving the screen, so it
  //    restarts when scrolled back into view.
  //
  // Android additionally gates on its PDP bottom sheet being EXPANDED; the
  // Flutter PDP is a plain page, so that condition has no counterpart.
  static const _autoScrollInterval = Duration(seconds: 2);

  // Advance timing taken from RecyclerView's LinearSmoothScroller, which is what
  // smoothScrollToPosition drives: 25ms per inch of travel
  // (calculateTimeForScrolling), stretched by 0.3356 for the decelerating
  // approach onto the target (calculateTimeForDeceleration). Android measures in
  // device px against densityDpi; expressed in logical px the device pixel ratio
  // cancels, leaving 25/160 ms per logical px. A one-card advance lands near
  // 135ms — far snappier than a fixed 400ms ease, which is what read as floaty.
  static const _msPerLogicalPx = 25 / 160;
  static const _decelerateFactor = 0.3356;
  Timer? _autoScrollTimer;
  bool _forcedStop = false;
  bool _isVisible = false;
  bool _isHostResumed = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoScrollTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  // ── Auto-scroll ─────────────────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isHostResumed = state == AppLifecycleState.resumed;
    _maybeStartAutoScroll();
  }

  // Android's isVisibleOnScreen() is true when any part of the view intersects
  // the screen, hence `> 0` rather than a fraction threshold.
  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final isVisible = info.visibleFraction > 0;
    // Leaving the screen clears the user's stop — this is the only thing that
    // does, and it is why scrolling away and back restarts the loop.
    if (!isVisible) _forcedStop = false;
    _isVisible = isVisible;
    _maybeStartAutoScroll();
  }

  void _maybeStartAutoScroll() {
    if (widget.offers.length <= 1 ||
        _forcedStop ||
        !_isVisible ||
        !_isHostResumed) {
      _stopAutoScroll();
      return;
    }
    _autoScrollTimer ??= Timer.periodic(_autoScrollInterval, (_) => _advance());
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  // Any touch stops the loop permanently, as Android's per-item touch listener
  // and its DRAGGING scroll state both do.
  void _stopForUserAction() {
    _forcedStop = true;
    _stopAutoScroll();
  }

  // Pointer currently down on a Copy button, which is exempt from stopping the
  // loop. On Android, `copy` is clickable and consumes ACTION_DOWN, so the
  // card's own OnTouchListener — the thing that calls stopForUserAction — is
  // never reached for that touch, and the copy click handler does not stop it
  // either. A Flutter ancestor Listener has no such exemption (pointer events
  // reach every hit-test entry regardless of who handles the gesture), so the
  // pointer is tagged on the way in and skipped on the way out.
  //
  // Dispatch runs innermost first, so this always precedes
  // _onCarouselPointerDown for the same pointer.
  int? _copyPointer;

  void _onCopyPointerDown(PointerDownEvent event) =>
      _copyPointer = event.pointer;

  void _onCarouselPointerDown(PointerDownEvent event) {
    if (event.pointer == _copyPointer) {
      _copyPointer = null;
      return;
    }
    _stopForUserAction();
  }

  void _advance() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0 || _snapItemStride <= 0) return;
    // Next index, wrapping past the last — mirrors getNextSnappedPosition().
    final next = (_currentIndex.value + 1) % widget.offers.length;
    final target = (next * _snapItemStride - _snapOrigin).clamp(
      0.0,
      pos.maxScrollExtent,
    );
    final distance = (target - pos.pixels).abs();
    // Already there (sub-pixel) — animating would compute a 0ms duration.
    if (distance < 0.5) return;
    _scrollController.animateTo(
      target,
      duration: Duration(
        milliseconds: (distance * _msPerLogicalPx / _decelerateFactor).ceil(),
      ),
      // DecelerateInterpolator, as LinearSmoothScroller uses onto its target.
      curve: Curves.decelerate,
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_snapItemStride <= 0) return;
    final pos = _scrollController.position;
    final cardCount = widget.offers.length;
    if (cardCount == 0) return;

    // Inverse of the snap grid in build(): offset = k * stride - _snapOrigin.
    // The end stops are clamped rather than exact, so they still resolve to the
    // first and last index — 0 rounds down from a partial stride, and the last
    // rounds up.
    int rounded;
    if (pos.maxScrollExtent > 0 && pos.pixels >= pos.maxScrollExtent - 0.5) {
      rounded = cardCount - 1;
    } else {
      rounded = ((pos.pixels + _snapOrigin) / _snapItemStride).round().clamp(
        0,
        cardCount - 1,
      );
    }

    if (rounded != _currentIndex.value) {
      _currentIndex.value = rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.sizeOf(context).width;
    // Sized so a card with neighbours on both sides shows a peek of each, which
    // is how it pages one card per fling like Android's PagerSnapHelper.
    final cardWidth = (screenW - (_kCardPeek + _kCardGap) * 2).clamp(
      200.0,
      360.0,
    );
    _snapItemStride = cardWidth + _kCardGap;

    // Where a card rests when it has a neighbour on each side: centred, so both
    // peeks show. The list keeps ordinary edge padding, and the snap grid is
    // shifted by the difference — offset for card k is k * stride - _snapOrigin,
    // clamped to the scroll range.
    //
    // The clamp is the point: card 0's ideal offset is negative and the last
    // card's overshoots maxScrollExtent, so both collapse to the range ends.
    // The first card therefore sits flush at the leading padding with no dead
    // space beside it, the last flush at the trailing padding with the previous
    // card peeking on its left, and every card between them is centred.
    _snapOrigin = (screenW - cardWidth) / 2 - AppSpacing.sm;

    // Wraps the whole section, matching Android's gate on promoViewLayout's own
    // on-screen visibility rather than just the card list's.
    return VisibilityDetector(
      key: const ValueKey(PdpTestStrings.offersSection),
      onVisibilityChanged: _onVisibilityChanged,
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
          // Two stop triggers, matching Android's two exactly:
          //  * pointer down anywhere on a card, from the itemView touch
          //    listener — except on Copy, see _onCarouselPointerDown;
          //  * a drag beginning, from SCROLL_STATE_DRAGGING. This is what stops
          //    the loop when the drag starts on Copy, where the pointer-down
          //    itself is exempt.
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _stopForUserAction();
              }
              return false;
            },
            child: Listener(
              onPointerDown: _onCarouselPointerDown,
              child: _OfferCardList(
                offers: widget.offers,
                scrollController: _scrollController,
                cardWidth: cardWidth,
                snapOrigin: _snapOrigin,
                onCopyPointerDown: _onCopyPointerDown,
              ),
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
    required this.snapOrigin,
    required this.onCopyPointerDown,
  });

  final List<OfferEntity> offers;
  final ScrollController scrollController;
  final double cardWidth;
  final double snapOrigin;

  // Tags a pointer as landing on Copy, exempting it from stopping auto-scroll.
  final ValueChanged<PointerDownEvent> onCopyPointerDown;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kCardHeight,
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: _SnapScrollPhysics(
          itemStride: cardWidth + _kCardGap,
          snapOrigin: snapOrigin,
        ),
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
          onCopyPointerDown: onCopyPointerDown,
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
    required this.onCopyPointerDown,
    super.key,
    this.copyKey,
  });

  final OfferEntity offer;
  final double width;
  final Key? copyKey;
  final ValueChanged<PointerDownEvent> onCopyPointerDown;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _kCardHeight,
      decoration: const BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.all(Radius.circular(_kCardRadius)),
      ),
      // Bottom padding is omitted here and re-applied inside the Copy button so
      // the strip below the label is tappable rather than dead space. Cards
      // without a Copy button close the gap with their own bottom padding.
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
      ),
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
            // Tags the pointer so the carousel's own listener leaves auto-scroll
            // running for this touch — Android's `copy` consumes ACTION_DOWN, so
            // the card touch listener that stops it never fires.
            Listener(
              onPointerDown: onCopyPointerDown,
              // The copy target is what fires `coupon_code_clicked`. Annotated
              // rather than a container: the id belongs on the node carrying the
              // tap, and the label here is a single Text.
              child: AutoSemantics.fromKey(
                copyKey,
                child: GestureDetector(
                  key: copyKey,
                  // The label alone is only ~53x13, well under a comfortable tap
                  // target. Padding grows the hit box to ~69x37 without shifting
                  // the text: bottom is the card's own bottom padding moved in
                  // here, top reclaims blank space the Expanded above never uses,
                  // and right extends past the left-aligned label. opaque is
                  // required — the default deferToChild would only hit the Text.
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: offer.couponCode!));
                    // Android draws its own clipboard confirmation from 13 (API
                    // 33) on, so ours would be a second popup for the same tap.
                    // iOS has no system clipboard UI at all — without this
                    // snackbar the copy would be silent there.
                    if (!Platform.isAndroid) {
                      PdpSnackbar.showCouponCopied(context, offer.couponCode!);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xs,
                      right: AppSpacing.md,
                      bottom: AppSpacing.md,
                    ),
                    child: Text(
                      PdpStrings.copy,
                      style: AppTypographyV1.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _kCopyColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ] else
            // No Copy button to carry it, so restore the card's bottom padding.
            const SizedBox(height: AppSpacing.md),
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

  // Offset of card k is k * itemStride - snapOrigin, clamped to the scroll
  // range — see PdpOffers.build. The clamp is what lets the end cards sit flush
  // against the screen edges while the cards between them stay centred.
  final double snapOrigin;

  const _SnapScrollPhysics({
    required this.itemStride,
    required this.snapOrigin,
    super.parent,
  });

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(
      itemStride: itemStride,
      snapOrigin: snapOrigin,
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

    double page = (pixels + snapOrigin) / itemStride;
    if (velocity < -tolerance.velocity) {
      page = page.floorToDouble();
    } else if (velocity > tolerance.velocity) {
      page = page.ceilToDouble();
    } else {
      page = page.roundToDouble();
    }

    // Clamping is all that is needed to reach either end: card 0's stop is
    // negative and the last card's overshoots maxExtent, so both land exactly on
    // a range end. An earlier version instead pulled to maxExtent whenever it was
    // the nearer of the two, which also hijacked backward flings near the end.
    return (page * itemStride - snapOrigin).clamp(0.0, maxExtent);
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
    // Clamped so the settle can only approach the target, never pass it. The
    // spring is fed the fling's velocity, and even overdamped it overshoots once
    // on a fast fling before coming back — that rebound is the bounce Android
    // does not have: its SnapHelper aligns with a decelerating smoothScrollBy,
    // which is monotone.
    final simulation = ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
    return target > position.pixels
        ? ClampedSimulation(simulation, xMin: position.pixels, xMax: target)
        : ClampedSimulation(simulation, xMin: target, xMax: position.pixels);
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

    // Measured, not taken from MediaQuery: this sits inside the section's
    // horizontal padding, so the track is narrower than the screen. Sizing the
    // thumb and its travel against the screen width overflowed the Stack by the
    // padding, and Stack clips — which cut the right end off the thumb once it
    // reached the far end, making it look shorter on the last card.
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        // Indicator represents 1 card as a fraction of all cards (capped at 20% min).
        final indicatorFraction = (1.0 / cardCount).clamp(0.1, 1.0);
        final indicatorWidth = (trackWidth * indicatorFraction).clamp(
          40.0,
          trackWidth,
        );
        final maxTravel = trackWidth - indicatorWidth;
        final progress = currentIndex / (cardCount - 1);
        final indicatorOffset = progress.clamp(0.0, 1.0) * maxTravel;

        const activeHeight = 3.0;
        const trackHeight = activeHeight / 3;

        return SizedBox(
          height: activeHeight,
          width: trackWidth,
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
      },
    );
  }
}
