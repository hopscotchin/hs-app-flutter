import 'package:flutter/material.dart';

/// App color palette
/// Usage: AppColors.primary, AppColors.secondary, etc.
class AppColors {
  AppColors._();

  // ! we will need to remove this old colors and use the below colors as per our design system

  // Primary Colors
  //Deprecated From
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

  static const Color border = Color(0xFFDDDDDD);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x1A000000);

  // Transparent
  static const Color transparent = Colors.transparent;

  //Container
  static const Color container = Color(0xFFFFFFFF);

  //Deprecated To

  //TODO : we need to use this color palette as per our design system and remove the above colors which are not in use and not as per our design system
  // ─── Design Token Palette NEW  ─────────────────────────────────────────

  // Base
  static const Color baseDefault = Color(0xFFFFFFFF);

  // Disabled
  static const Color disabledDefault = Color(0xFFB395C4);

  // Brand
  static const Color brandDefault = Color(0xFF67218C); // == default
  static const Color brandPrimary = Color(0xFF4C106D); // == primary
  static const Color brandSecondary = Color(0xFF836EF1); // == secondary
  static const Color brandTertiary = Color(0xFFF4E6F5); // == tertiary

  // Neutral
  static const Color neutralBlack = Color(0xFF000000);
  static const Color neutralGrey0 = Color(0xFFD9D9D9);
  static const Color neutralGrey1 = Color(0xFFF6F6F6);
  static const Color neutralGrey2 = Color(0xFFE5E5EA);
  static const Color neutralGrey3 = Color(0xFFD1D1D6);
  static const Color neutralGrey4 = Color(0xFFC7C7CC);
  static const Color neutralGrey5 = Color(0xFFAEAEB2);
  static const Color neutralGrey6 = Color(0xFF353535);

  // Success
  static const Color successDefault = Color(0xFF10900B); // == success
  static const Color successSecondary = Color(0xFFD3EDE0);

  // Warning
  static const Color warningDefault = Color(0xFFFED543); // == warning
  static const Color warningSecondary = Color(0xFFFEF8C4);

  // Danger
  static const Color dangerDefault = Color(0xFFE00000); // == error
  static const Color dangerSecondary = Color(0xFFF4E6F5);

  // Info
  static const Color infoDefault = Color(0xFF3D65F7); // == info
  static const Color infoSecondary = Color(0xFFD1E0FF);

  //Divider
  static const Color divider = Color(0xFFE0E0E0);

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
