import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

/// ─────────────────────────────────────────────
/// COLOR EXTENSIONS
/// ─────────────────────────────────────────────
extension TextStyleColorExtensions on TextStyle {
  // ───────── BRAND ─────────
  TextStyle brand() => copyWith(color: AppColors.brandDefault);
  TextStyle brandSecondary() => copyWith(color: AppColors.brandSecondary);

  // ───────── SUCCESS ─────────
  TextStyle success() => copyWith(color: AppColors.successDefault);
  TextStyle successLight() => copyWith(color: AppColors.successSecondary);

  // ───────── WARNING ─────────
  TextStyle warning() => copyWith(color: AppColors.warningDefault);
  TextStyle warningLight() => copyWith(color: AppColors.warningSecondary);

  // ───────── ERROR / DANGER ─────────
  TextStyle error() => copyWith(color: AppColors.dangerDefault);
  TextStyle errorLight() => copyWith(color: AppColors.dangerSecondary);

  // ───────── DISABLED ─────────
  TextStyle disabled() => copyWith(color: AppColors.disabledDefault);

  // ───────── NEUTRAL (optional usage) ─────────
  TextStyle neutral900() => copyWith(color: AppColors.neutral900);
  TextStyle neutral700() => copyWith(color: AppColors.neutral700);
  TextStyle neutral500() => copyWith(color: AppColors.neutral500);
}

/// ─────────────────────────────────────────────
/// BEHAVIOR EXTENSIONS
/// ─────────────────────────────────────────────
extension TextStyleBehaviorExtensions on TextStyle {
  /// Link behavior (no color here)
  TextStyle link() => copyWith(decoration: TextDecoration.underline);

  /// Strike-through (e.g. old price)
  TextStyle strikeThrough() => copyWith(decoration: TextDecoration.lineThrough);
}

extension TypographyX on TextStyle {
  // Weights - these can be used in combination with color extensions
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
}




//USAGE EXAMPLE:
/*
// Normal text
 AppTypography.bodyMd.regular

// error 
AppTypography.bodyMd.regular.error()

// brand text
AppTypography.bodyMd.semiBold.brand()

*/