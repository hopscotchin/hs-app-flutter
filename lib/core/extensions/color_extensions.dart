import 'package:flutter/material.dart';

/// Colour brightness helpers, mirroring the Android app's `Util` so colour-filter
/// checkmark/border logic stays consistent across platforms.
///
/// Uses the Rec. 601 perceived-luma formula on a 0–255 scale:
/// `luma = 0.299·R + 0.587·G + 0.114·B`.
extension ColorBrightnessX on Color {
  /// Perceived luminance, 0 (black) – 255 (white).
  double get perceivedLuma => (r * 0.299 + g * 0.587 + b * 0.114) * 255.0;

  /// Dark enough that a white foreground (e.g. a checkmark) reads best on it.
  /// Matches Android `Util.isColourLight` (luma ≤ 120) — a dark swatch.
  bool get isDarkColor => perceivedLuma <= 120;

  /// Near-white — needs a border to be visible on a white background.
  /// Matches Android `Util.isColourVeryLight` (luma ≥ 233).
  bool get isVeryLightColor => perceivedLuma >= 233;
}
