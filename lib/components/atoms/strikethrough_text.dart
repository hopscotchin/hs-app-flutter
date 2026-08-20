import 'package:flutter/material.dart';

/// Text with a manually-painted strikethrough line.
///
/// Use this instead of `TextDecoration.lineThrough` whenever the text may
/// contain a glyph that's missing from the app font (e.g. ₹ — Satoshi has no
/// Rupee glyph, so Flutter renders it from a fallback font). The built-in
/// decoration is drawn per font-run and uses each font's own metrics, so the
/// line breaks/steps at that fallback boundary. This widget paints one
/// continuous line across the whole text, independent of font runs.
///
/// - As a standalone widget: `StrikethroughText('MRP:₹1,200', style: ...)`.
/// - Inside a `RichText` / `Text.rich`: `StrikethroughText.span('MRP:₹1,200', style: ...)`.
class StrikethroughText extends StatelessWidget {
  const StrikethroughText(
    this.text, {
    super.key,
    this.style,
    this.lineColor,
    this.thickness = 1.0,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;

  /// Strike line colour; defaults to the resolved text colour.
  final Color? lineColor;
  final double thickness;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Convenience for embedding inside a [RichText] / [Text.rich] as an inline
  /// span. Baseline-aligned by default so it flows like the surrounding text;
  /// pass [PlaceholderAlignment.middle] when the span sits beside larger text
  /// and should read as vertically centred against it rather than sharing its
  /// baseline.
  static InlineSpan span(
    String text, {
    TextStyle? style,
    Color? lineColor,
    double thickness = 1.0,
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
  }) {
    return WidgetSpan(
      alignment: alignment,
      baseline: TextBaseline.alphabetic,
      child: StrikethroughText(
        text,
        style: style,
        lineColor: lineColor,
        thickness: thickness,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        lineColor ?? style?.color ?? DefaultTextStyle.of(context).style.color ?? Colors.black;
    return CustomPaint(
      foregroundPainter: _StrikethroughPainter(color: resolvedColor, thickness: thickness),
      child: Text(text, style: style, maxLines: maxLines, overflow: overflow),
    );
  }
}

class _StrikethroughPainter extends CustomPainter {
  const _StrikethroughPainter({required this.color, required this.thickness});

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(_StrikethroughPainter old) =>
      old.color != color || old.thickness != thickness;
}
