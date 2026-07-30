import 'package:flutter/material.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// Fly-to-cart animation for the PDP add-to-bag action.
///
/// Mirrors Android's `AddToBagAnimationHandler`: the product's first media
/// image (reused by URL — never a screenshot) shrinks in place, holds while an
/// "Added to bag" label shows, then flies to the app-bar cart icon while a dim
/// scrim fades out. The cart badge count is updated independently by the bloc
/// (via `CartCountCubit`), exactly as on Android where the badge is decoupled
/// from the animation.
///
/// Presentation-only: [show] inserts a self-removing [OverlayEntry] — there is
/// no bloc/state involvement.
class PdpFlyToCartOverlay {
  const PdpFlyToCartOverlay._();

  // Matches Android's companion-object constants.
  static const int _phase1Ms = 350; // scale 1.0 -> 0.5
  static const int _holdMs = 500; // pause with "Added to bag" label
  static const int _phase2Ms = 350; // fly to cart + scale 0.5 -> 0.05

  /// Launches the flight. [sourceKey] must be attached to the product image
  /// area, [targetKey] to the cart icon. No-op if either render box is missing
  /// (e.g. sheet not laid out yet) or the product has no image.
  static void show(
    BuildContext context, {
    required String imageUrl,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    VoidCallback? onComplete,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);

    final sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null ||
        targetBox == null ||
        !sourceBox.attached ||
        !targetBox.attached) {
      return;
    }

    // Convert global coordinates into the overlay's own coordinate space so the
    // flight is correct even if the overlay is not anchored at the screen origin.
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    Offset toOverlay(Offset global) =>
        overlayBox != null ? overlayBox.globalToLocal(global) : global;

    final sourceTopLeft = toOverlay(sourceBox.localToGlobal(Offset.zero));
    final sourceRect = sourceTopLeft & sourceBox.size;
    final targetCenter = toOverlay(
      targetBox.localToGlobal(targetBox.size.center(Offset.zero)),
    );

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _CartFlyAnimation(
        imageUrl: imageUrl,
        sourceRect: sourceRect,
        targetCenter: targetCenter,
        onComplete: () {
          entry.remove();
          onComplete?.call();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _CartFlyAnimation extends StatefulWidget {
  const _CartFlyAnimation({
    required this.imageUrl,
    required this.sourceRect,
    required this.targetCenter,
    required this.onComplete,
  });

  final String imageUrl;
  final Rect sourceRect;
  final Offset targetCenter;
  final VoidCallback onComplete;

  @override
  State<_CartFlyAnimation> createState() => _CartFlyAnimationState();
}

class _CartFlyAnimationState extends State<_CartFlyAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<Offset> _offset;
  late final Animation<double> _scrim;

  @override
  void initState() {
    super.initState();
    const p1 = PdpFlyToCartOverlay._phase1Ms;
    const hold = PdpFlyToCartOverlay._holdMs;
    const p2 = PdpFlyToCartOverlay._phase2Ms;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: p1 + hold + p2),
    );

    final delta = widget.targetCenter - widget.sourceRect.center;
    final decel = CurveTween(curve: Curves.decelerate);

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.5).chain(decel),
        weight: p1.toDouble(),
      ),
      TweenSequenceItem(tween: ConstantTween(0.5), weight: hold.toDouble()),
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 0.05).chain(decel),
        weight: p2.toDouble(),
      ),
    ]).animate(_controller);

    _offset = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: ConstantTween(Offset.zero),
        weight: (p1 + hold).toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: delta).chain(decel),
        weight: p2.toDouble(),
      ),
    ]).animate(_controller);

    // Scrim fades in over phase one, holds, then fades out as the image flies.
    _scrim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: p1.toDouble(),
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: hold.toDouble()),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0).chain(decel),
        weight: p2.toDouble(),
      ),
    ]).animate(_controller);

    _controller.forward().whenCompleteOrCancel(widget.onComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rect = widget.sourceRect;
    // Label sits just below the image at its held (0.5) scale.
    final labelTop = rect.center.dy + (rect.height * 0.5) / 2 + 12;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return IgnorePointer(
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.4 * _scrim.value),
                ),
              ),
              Positioned(
                left: rect.left,
                top: rect.top,
                width: rect.width,
                height: rect.height,
                child: Transform.translate(
                  offset: _offset.value,
                  child: Transform.scale(
                    scale: _scale.value,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedImageWidget(
                        imageUrl: widget.imageUrl,
                        width: rect.width,
                        height: rect.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: labelTop,
                child: Opacity(
                  opacity: _scrim.value,
                  child: Center(
                    child: Text(
                      PdpStrings.addedToBag,
                      style: AppTypographyV1.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
