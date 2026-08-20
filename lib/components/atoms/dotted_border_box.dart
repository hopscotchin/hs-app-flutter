import 'package:flutter/material.dart';

/// Wraps [child] with a dotted (dashed) rounded-rect border.
///
/// Flutter's [BoxDecoration] has no dotted border, so this paints one via a
/// [CustomPaint] foreground painter. Reuse anywhere a dotted outline is needed.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({
    super.key,
    required this.child,
    required this.color,
    this.strokeWidth = 1,
    this.radius = Radius.zero,
    this.dashOn = 1.5,
    this.dashOff = 2.5,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;

  /// Corner radius. [Radius.zero] = square corners.
  final Radius radius;

  /// Length of each painted dash segment.
  final double dashOn;

  /// Gap between dash segments.
  final double dashOff;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DottedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
        dashOn: dashOn,
        dashOff: dashOff,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  const _DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashOn,
    required this.dashOff,
  });

  final Color color;
  final double strokeWidth;
  final Radius radius;
  final double dashOn;
  final double dashOff;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final rrect = RRect.fromRectAndRadius(rect, radius);
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashOn),
          paint,
        );
        distance += dashOn + dashOff;
      }
    }
  }

  @override
  bool shouldRepaint(_DottedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.radius != radius ||
      old.dashOn != dashOn ||
      old.dashOff != dashOff;
}