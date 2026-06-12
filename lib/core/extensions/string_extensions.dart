import 'dart:ui';

extension StringX on String? {
  bool get isNotNullOrEmpty => this?.isNotEmpty == true;

  Color? get toColor {
    final value = this;
    if (value == null || value.isEmpty) return null;

    final cleaned = value.replaceFirst('#', '');

    // Support both RGB (6) and ARGB (8)
    final hex = cleaned.length == 6 ? 'FF$cleaned' : cleaned;

    final intValue = int.tryParse(hex, radix: 16);
    if (intValue == null) return null;

    return Color(intValue);
  }

  String truncate(int maxLength, {String ellipsis = '...'}) {
    final value = this ?? '';
    if (value.length <= maxLength) return value;

    return value.substring(0, maxLength).trimRight() + ellipsis;
  }
}
