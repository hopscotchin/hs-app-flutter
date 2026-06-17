import 'package:flutter/material.dart';

class SelectedAccentPainter extends CustomPainter {
  const SelectedAccentPainter({
    required this.color,
    this.width = 3,
    this.verticalInset = 0,
    this.cornerRadius = 0,
  });

  final Color color;
  final double width;
  final double verticalInset;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rect = Rect.fromLTWH(0, verticalInset, width, size.height - verticalInset * 2);
    if (cornerRadius > 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)), paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(SelectedAccentPainter old) =>
      old.color != color ||
      old.width != width ||
      old.verticalInset != verticalInset ||
      old.cornerRadius != cornerRadius;
}

class ScrollThumbPainter extends CustomPainter {
  ScrollThumbPainter({
    required this.controller,
    this.thumbHeight = 50,
    this.thickness = 2,
    this.color = Colors.black,
    this.trackColor = const Color(0x14000000),
    this.rightInset = 0,
  }) : super(repaint: controller);

  final ScrollController controller;
  final double thumbHeight;
  final double thickness;
  final Color color;
  final Color trackColor;

  /// Distance from the parent's right edge to the right edge of the bar.
  final double rightInset;

  @override
  void paint(Canvas canvas, Size size) {
    if (!controller.hasClients) return;

    final pos = controller.position;
    final maxScroll = pos.maxScrollExtent;
    if (maxScroll <= 0) return;

    const trackTop = 0.0;
    final trackBottom = size.height;
    final trackLength = trackBottom - trackTop;

    if (trackLength <= thumbHeight) return;

    final right = size.width - rightInset;
    final left = right - thickness;
    final radius = Radius.circular(thickness / 2);

    // Track
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(left, trackTop, right, trackBottom), radius),
      Paint()..color = trackColor,
    );

    // Thumb
    final travel = trackLength - thumbHeight;
    final progress = (pos.pixels / maxScroll).clamp(0.0, 1.0);
    final top = trackTop + (travel * progress);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(left, top, thickness, thumbHeight), radius),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(ScrollThumbPainter old) =>
      old.controller != controller ||
      old.thumbHeight != thumbHeight ||
      old.thickness != thickness ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.rightInset != rightInset;
}
