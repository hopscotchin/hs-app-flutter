import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Swallows vertical drag gestures that BEGIN on its subtree so they never reach
/// the enclosing [Scrollable].
///
/// Wrapped around the PLP header controls (app bar, filter bar, applied-filter
/// chips) so dragging on them doesn't scroll the product grid. A drag that
/// starts on the grid is untouched — it scrolls normally, and the app bar /
/// headers still collapse and pin, because that behaviour is driven by the
/// grid's own scroll position, not by drags on the headers.
///
/// Only the vertical axis is claimed, so horizontal chip scrolling and every tap
/// (sort / filter / chip / back / cart) keep working. The recognizer sits deeper
/// in the tree than the scroll view, so for a drag that starts here it wins the
/// gesture arena and then intentionally does nothing with it.
class AbsorbVerticalDrag extends StatelessWidget {
  const AbsorbVerticalDrag({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Match the Scrollable's touch-slop threshold. Without this our recognizer
    // uses the default kTouchSlop (18px) while the grid's Scrollable uses the
    // device-reported slop from MediaQuery — which is smaller on Android (~8px).
    // That let the Scrollable win the gesture arena before our recognizer even
    // triggered, so the absorb worked on iOS but not Android. Sharing the same
    // settings makes our (deeper) recognizer win the arena on both platforms.
    final gestureSettings = MediaQuery.maybeOf(context)?.gestureSettings;

    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
              VerticalDragGestureRecognizer.new,
              (VerticalDragGestureRecognizer instance) {
                // Claim the vertical drag and do nothing with it, so the ancestor
                // Scrollable never receives it.
                instance
                  ..onStart = (_) {}
                  ..onUpdate = (_) {}
                  ..onEnd = (_) {}
                  ..onCancel = () {}
                  ..gestureSettings = gestureSettings;
              },
            ),
      },
      child: child,
    );
  }
}
