import 'package:flutter/material.dart';

/// App color palette
/// Usage: AppColors.primary, AppColors.secondary, etc.
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF67218C);
  static const Color primaryLight = Color(0x1A67218C);
  static const Color primaryDark = Color(0xFF3700B3);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Secondary Colors
  static const Color secondary = Color(0xFF6D59D7);
  static const Color secondaryLight = Color(0xFF836EF1);
  static const Color secondaryHover = Color(0xFFF0E9F3);
  static const Color secondaryInActive = Color(0xFFB395C4);
  static const Color secondaryExtra = Color(0xFFF4E6F5);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Error Colors
  static const Color error = Color(0xFFE00000);
  static const Color onError = Color(0x4DE00000);

  // Success Colors
  static const Color success = Color(0xFF10900B);
  static const Color onSuccess = Color(0x4D10900B);

  // Warning Colors
  static const Color warning = Color(0xFFFED543);
  static const Color onWarning = Color(0x4DFED543);

  // Info Colors
  static const Color info = Color(0xFF3D65F7);
  static const Color onInfo = Color(0x4D3D65F7);

  // Text Colors
  static const Color textPrimary = Color(0xCC000000);
  static const Color textSecondary = Color(0x8F000000);
  static const Color textTertiary = Color(0x5C000000);
  static const Color textDisabled = Color(0x42000000);

  // Divider & Border Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFDDDDDD);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x1A000000);

  // Transparent
  static const Color transparent = Colors.transparent;

  //Container
  static const Color container = Color(0xFFFFFFFF);

  // ─── Design Token Palette NEW  ─────────────────────────────────────────

  // Base
  static const Color baseDefault = Color(0xFFFFFFFF);

  // Disabled
  static const Color disabledDefault = Color(0xFFB395C4);

  // Brand
  static const Color brandDefault = Color(0xFF67218C); // == primary
  static const Color brandSecondary = Color(0xFF4C106D); // == secondary
  static const Color brandDark = Color(0xFF3D0070);
  static const Color brandLight = Color(0xFFF4E6F5); // == secondaryExtra

  // Neutral
  static const Color neutral900 = Color(0xFF0A0A0A);
  static const Color neutral700 = Color(0xFF8C8C8C);
  static const Color neutral600 = Color(0xFFABABAB);
  static const Color neutral500 = Color(0xFFBDBDBD);
  static const Color neutral400 = Color(0xFFCCCCCC);
  static const Color neutral200 = Color(0xFFE8E8E8);
  static const Color neutral100 = Color(0xFFF2F2F2);

  // Success
  static const Color successDefault = Color(0xFF10900B); // == success
  static const Color successSecondary = Color(0xFFD3EDE0);

  // Warning
  static const Color warningDefault = Color(0xFFFED543); // == warning
  static const Color warningSecondary = Color(0xFFFEF8C4);

  // Danger
  static const Color dangerDefault = Color(0xFFE00000); // == error
  static const Color dangerSecondary = Color(0xFFF4E6F5);

  /// Light color scheme for Material 3
  static ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryLight,
    onPrimaryContainer: primaryDark,
    error: error,
    onError: onError,
  );

  /// Dark color scheme for Material 3
  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: primaryLight,
    onPrimary: primaryDark,
    primaryContainer: primary,
    onPrimaryContainer: onPrimary,
    error: error,
    onError: onError,
  );
}
