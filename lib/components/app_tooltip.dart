import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';

/// Reusable tooltip bubble with rounded corners and a downward-pointing
/// triangle near the right edge (points at a trailing info icon).
///
/// The [message] wraps to multiple lines when the text is long or the device
/// is narrow; [margin] keeps the bubble [AppSpacing.md] (16px) away from the
/// screen edges so it never touches the device width.
class AppTooltip extends StatelessWidget {
  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode = TooltipTriggerMode.tap,
    this.preferBelow = false,
    this.verticalOffset = 12,
    this.margin = const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    this.arrowRightInset = 12,
  });

  final String message;
  final Widget child;
  final TooltipTriggerMode triggerMode;
  final bool preferBelow;
  final double verticalOffset;

  /// Gap between the bubble and the screen edges. Defaults to 16px each side so
  /// long text wraps instead of touching the device width.
  final EdgeInsetsGeometry margin;

  /// Distance from the bubble's right edge to the arrow's center.
  final double arrowRightInset;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: triggerMode,
      preferBelow: preferBelow,
      verticalOffset: verticalOffset,
      margin: margin,
      decoration: ShapeDecoration(
        color: AppColors.neutralGrey6,
        shape: TooltipBubbleShape(arrowRightInset: arrowRightInset),
      ),
      child: child,
    );
  }
}

/// Tooltip bubble with rounded corners and a downward-pointing triangle
/// at the bottom, positioned near the right edge to point at the info icon.
class TooltipBubbleShape extends ShapeBorder {
  const TooltipBubbleShape({
    this.radius = AppSpacing.xxs,
    this.arrowWidth = 13,
    this.arrowHeight = 11,
    this.arrowRightInset = 12,
  });

  /// Corner radius of the bubble.
  final double radius;

  /// Base width of the triangle.
  final double arrowWidth;

  /// Height the triangle protrudes below the bubble.
  final double arrowHeight;

  /// Distance from the right edge to the triangle's center.
  final double arrowRightInset;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height - arrowHeight);
    final arrowCenter = body.right - arrowRightInset;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(radius)))
      ..moveTo(arrowCenter - arrowWidth / 2, body.bottom)
      ..lineTo(arrowCenter, body.bottom + arrowHeight)
      ..lineTo(arrowCenter + arrowWidth / 2, body.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => TooltipBubbleShape(
    radius: radius * t,
    arrowWidth: arrowWidth * t,
    arrowHeight: arrowHeight * t,
    arrowRightInset: arrowRightInset * t,
  );
}