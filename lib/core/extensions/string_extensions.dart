import 'dart:ui';

extension StringX on String? {
  bool get isNotNullOrEmpty => this?.isNotEmpty == true;

  /// Parses a `#RRGGBB`/`RRGGBB`/`#AARRGGBB`/`AARRGGBB` hex color string, or
  /// `null` if [this] isn't one.
  ///
  /// A bare number ("45"), a wrong-length numeric string, or any other
  /// non-hex string is NOT a color, but every hex digit is also a decimal
  /// digit, so `int.tryParse(_, radix: 16)` would happily "parse" junk like
  /// `"45"` into a near-black, near-invisible `Color` instead of failing.
  /// The length+charset check below rejects that upfront.
  Color? get toColorOrNull {
    final value = this;
    if (value == null || value.isEmpty) return null;

    final cleaned = value.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$').hasMatch(cleaned)) {
      return null;
    }

    // Support both RGB (6) and ARGB (8)
    final hex = cleaned.length == 6 ? 'FF$cleaned' : cleaned;

    final intValue = int.tryParse(hex, radix: 16);
    return intValue != null ? Color(intValue) : null;
  }

  /// [toColorOrNull], falling back to [fallback] when unparseable — use this
  /// when a specific fallback color matters (e.g. a themed default).
  Color toColorOr(Color fallback) => toColorOrNull ?? fallback;

  /// [toColorOrNull], falling back to transparent — use this when the caller
  /// doesn't care to supply its own fallback; use [toColorOr] otherwise.
  Color get toColor => toColorOr(const Color(0x00000000));

  String truncate(int maxLength, {String ellipsis = '...'}) {
    final value = this ?? '';
    if (value.length <= maxLength) return value;

    return value.substring(0, maxLength).trimRight() + ellipsis;
  }
}
