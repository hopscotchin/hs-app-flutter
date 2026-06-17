import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/entities/visual_cue_entity.dart';

class FilterSectionBadge extends StatelessWidget {
  const FilterSectionBadge({
    super.key,
    required this.cue,
    this.height = 22,
    this.foldSize = 6,
    this.notchDepth = 8,
    this.fallbackBgColor = const Color(0xFFBD1550),
    this.fallbackTextColor = Colors.white,
    this.fontSize = 9,
    this.fontWeight = FontWeight.w800,
    this.letterSpacing = 0.4,
    this.foldShadowAlpha = 0.45,
  });

  final VisualCueEntity cue;

  /// Total badge height (fold tail included). Main body is `height - foldSize`.
  final double height;

  /// Bottom-right fold size (`--f` in the CSS reference).
  final double foldSize;

  /// Depth of the left-side V notch (`--r` in the CSS reference).
  final double notchDepth;

  /// Ribbon body colour used when `cue.bgColor` is missing or invalid.
  final Color fallbackBgColor;

  /// Text colour used when `cue.textColor` is missing or invalid.
  final Color fallbackTextColor;

  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  /// Alpha for the dark triangle drawn on the fold. 0 = no shadow, 0.3
  /// = CSS reference depth.
  final double foldShadowAlpha;

  @override
  Widget build(BuildContext context) {
    final url = cue.imageUrl;
    final isImage = cue.uiType?.toUpperCase() == 'IMAGE' && url != null && url.trim().isNotEmpty;

    if (isImage) {
      return SizedBox(
        height: height,
        child: SvgPicture.network(
          url,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => SizedBox(height: height),
        ),
      );
    }

    final text = cue.text?.trim();
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    // CustomPaint sizes to its child. Padding maps directly to the CSS
    // rules: left clears the notch, right is a comfortable gap, bottom
    // clears the fold tail.
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _RibbonPainter(
          color: _parseHex(cue.bgColor) ?? fallbackBgColor,
          foldSize: foldSize,
          notchDepth: notchDepth,
          shadowAlpha: foldShadowAlpha,
        ),
        child: Padding(
          // Left  : clear the V-notch.
          // Right : leave space for the fold-corner triangle so the last
          //         character doesn't dip into the dark fold area.
          // Top/Bottom: keep symmetric vertical padding — body is now a
          //         full rectangle, no fold-tail eating into the bottom.
          // Left   : clear the V-notch on the left edge.
          // Right  : a little breathing room before the right edge.
          // Top    : minimal.
          // Bottom : clear the fold-tail strip (the bottom `foldSize`
          //          px below the body where the fold tail lives).
          // Left   : clear the V-notch on the left edge.
          // Right  : extra breathing room — widens the badge so it
          //          matches the broader footprint of the SVG variant.
          //          Without this the painter renders noticeably
          //          narrower than the SVG-rendered ribbon.
          // Top    : minimal.
          // Bottom : clear the fold-tail strip (the bottom `foldSize`
          //          px below the body where the fold tail lives).
          // Left   : the body STARTS at x = notchDepth (left of that is
          //          the empty area behind the arrow tip). Add a little
          //          inset so the text doesn't hug the body's left edge.
          // Right  : breathing room — keeps the badge visually balanced.
          // Bottom : clear the fold-tail strip (bottom `foldSize` px).
          padding: EdgeInsets.only(left: notchDepth + 5, right: 12, top: 2, bottom: foldSize + 2),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: _parseHex(cue.textColor) ?? fallbackTextColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Accepts `#RRGGBB` or `#AARRGGBB`. Returns null on anything malformed.
  static Color? _parseHex(String? raw) {
    if (raw == null) return null;
    var s = raw.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) s = 'FF$s';
    if (s.length != 8) return null;
    final v = int.tryParse(s, radix: 16);
    return v == null ? null : Color(v);
  }
}

class _RibbonPainter extends CustomPainter {
  const _RibbonPainter({
    required this.color,
    required this.foldSize,
    required this.notchDepth,
    this.shadowAlpha = 0.45,
  });

  final Color color;
  final double foldSize;
  final double notchDepth;

  /// How much darker the fold tail is than the ribbon body.
  ///   0    → no fold-tail shading.
  ///   0.3  → ≈ CSS reference `#0005`. Subtle.
  ///   0.45 → tuned default; reads clearly at small badge sizes.
  final double shadowAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final f = foldSize;
    final r = notchDepth;
    final innerBottom = h - f; // body's bottom edge (fold tail lives below)

    // 1) Body + arrow tip + fold tail.
    //
    // The LEFT side has an arrow POINT extending OUTWARD (not a notch
    // cutting INWARD as the previous version had). The body proper starts
    // at x = notchDepth; the arrow tip sits at x = 0 (the leftmost edge
    // of the badge's bounding box).
    //
    //   (r, 0) ──────────────────────► (w, 0)
    //     ▲                                │
    //      ╲                               ▼
    //       ╲                         (w, h - f)
    //        ●  ← sharp arrow tip          ╲
    //       ╱   at (0, (h-f)/2)             ▼
    //      ╱                           (w - f, h)
    //     ╱                                 ▲
    //   (r, h - f) ◄──────────────── (w - f, h - f)
    //
    // Sharp arrow point on the LEFT — TWO straight `lineTo` calls meeting
    // at (0, (h-f)/2). This matches the backend SVG, which uses crisp
    // angles (not rounded curves). The two diagonal sides converge at a
    // hard tip — same look as the reference.
    final ribbon = Path()
      ..moveTo(r, 0)
      ..lineTo(w, 0)
      ..lineTo(w, innerBottom)
      ..lineTo(w - f, h)
      ..lineTo(w - f, innerBottom)
      ..lineTo(r, innerBottom)
      ..lineTo(0, innerBottom / 2)
      ..close();
    canvas.drawPath(ribbon, Paint()..color = color);

    // 2) Fold-tail darker shade. We pre-blend once and paint a solid
    // darker colour rather than overlay translucent black — at small
    // badge sizes the alpha overlay washes out and the fold reads the
    // same colour as the body.
    //
    //   darkened = body × (1 - α) + black × α   (Color.alphaBlend)
    if (shadowAlpha > 0 && f > 0) {
      final fold = Path()
        ..moveTo(w, innerBottom)
        ..lineTo(w - f, h)
        ..lineTo(w - f, innerBottom)
        ..close();
      final darkened = Color.alphaBlend(Colors.black.withValues(alpha: shadowAlpha), color);
      canvas.drawPath(fold, Paint()..color = darkened);
    }
  }

  @override
  bool shouldRepaint(_RibbonPainter old) =>
      old.color != color ||
      old.foldSize != foldSize ||
      old.notchDepth != notchDepth ||
      old.shadowAlpha != shadowAlpha;
}
