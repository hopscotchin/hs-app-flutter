import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Largest font-size multiplier, at or below 1.0, at which *every* string in
/// [texts] fits inside [maxWidth] x [maxLines] when painted in [style].
///
/// Exists so a group of labels that must look alike can share one size. A
/// FittedBox per widget cannot do this: it measures each child against its own
/// box, so the short label stays at full size next to a shrunken neighbour —
/// "Buy Now" at 16px beside a 10px "Add to bag now" reads as a bug. Callers
/// measure the whole group once and hand every member the same resolved style,
/// so the labels are identical by construction whatever their lengths.
///
/// Returns 1.0 when everything already fits, so the common case costs one
/// layout per string and changes nothing.
///
/// [minScale] is the point at which fitting gives up and the text is allowed to
/// truncate after all. It defaults low enough that it is effectively never
/// reached — the contract is that nothing is ever cut — which does mean a long
/// enough string produces very small text. Raise it for a caller that would
/// rather truncate than render microtype.
double sharedTextFitScale({
  required List<String> texts,
  required TextStyle style,
  required double maxWidth,
  required TextScaler textScaler,
  int maxLines = 1,
  double minScale = 0.1,
}) {
  if (maxWidth <= 0 || style.fontSize == null || style.fontSize! <= 0) return 1.0;

  var scale = 1.0;
  for (final text in texts) {
    if (text.isEmpty) continue;
    scale = math.min(scale, _fitScaleFor(text, style, maxWidth, textScaler, maxLines, minScale));
    if (scale <= minScale) return minScale;
  }
  return scale;
}

/// Width of [text] painted at [style]'s own size.
///
/// For a caller that sizes itself to its content and needs to know, before
/// building, how much room that content will ask for.
double textWidth({required String text, required TextStyle style, required TextScaler textScaler}) {
  if (text.isEmpty || style.fontSize == null) return 0;
  return _painter(text, style, 1.0, textScaler, maxLines: null, maxWidth: double.infinity).width;
}

double _fitScaleFor(
  String text,
  TextStyle style,
  double maxWidth,
  TextScaler textScaler,
  int maxLines,
  double minScale,
) {
  if (!_overflows(text, style, 1.0, maxWidth, textScaler, maxLines)) return 1.0;

  // A single line's width is linear in font size, so the exact factor is one
  // division — no search needed, and it lands on a perfect fit rather than an
  // approximation.
  if (maxLines == 1) {
    final width = _painter(
      text,
      style,
      1.0,
      textScaler,
      maxLines: null,
      maxWidth: double.infinity,
    ).width;
    if (width <= 0) return 1.0;
    return math.max(minScale, maxWidth / width);
  }

  // Wrapping is not linear — a smaller size can re-break the lines entirely —
  // so the factor has to be searched for. Eight steps resolve it to <0.4%.
  var low = minScale;
  var high = 1.0;
  for (var i = 0; i < 8; i++) {
    final mid = (low + high) / 2;
    if (_overflows(text, style, mid, maxWidth, textScaler, maxLines)) {
      high = mid;
    } else {
      low = mid;
    }
  }
  return low;
}

bool _overflows(
  String text,
  TextStyle style,
  double scale,
  double maxWidth,
  TextScaler textScaler,
  int maxLines,
) {
  final painter = _painter(text, style, scale, textScaler, maxLines: maxLines, maxWidth: maxWidth);
  // didExceedMaxLines covers wrapping past the line budget; the width check
  // catches a single unbreakable word wider than the box, which does not
  // register as exceeding the line count.
  return painter.didExceedMaxLines || painter.width > maxWidth + 0.5;
}

TextPainter _painter(
  String text,
  TextStyle style,
  double scale,
  TextScaler textScaler, {
  required int? maxLines,
  required double maxWidth,
}) {
  return TextPainter(
    text: TextSpan(
      text: text,
      style: style.copyWith(fontSize: style.fontSize! * scale),
    ),
    textDirection: TextDirection.ltr,
    textScaler: textScaler,
    maxLines: maxLines,
  )..layout(maxWidth: maxWidth);
}
