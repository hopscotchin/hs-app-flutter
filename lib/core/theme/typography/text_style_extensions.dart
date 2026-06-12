import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

/// ─────────────────────────────────────────────
/// COLOR EXTENSIONS
/// ─────────────────────────────────────────────
extension TextStyleColorExtensions on TextStyle {
  // ───────── BRAND ─────────
  TextStyle brand() => copyWith(color: AppColors.brandDefault);
  TextStyle brandPrimary() => copyWith(color: AppColors.brandPrimary);
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
  TextStyle textPrimary() => copyWith(color: AppColors.neutralBlack);
  TextStyle textSeconday() => copyWith(color: AppColors.whiteColor);
  TextStyle textTertiary() => copyWith(color: AppColors.textTertiary);

  TextStyle neutralGrey0() => copyWith(color: AppColors.neutralGrey0);
  TextStyle neutralGrey2() => copyWith(color: AppColors.neutralGrey2);
  TextStyle neutralGrey4() => copyWith(color: AppColors.neutralGrey4);
  TextStyle neutralGrey5() => copyWith(color: AppColors.neutralGrey5);
  TextStyle neutralGrey6() => copyWith(color: AppColors.neutralGrey6);

  // ───────── CUSTOM COLORS (optional usage) ─────────
  TextStyle linkColor() => copyWith(color: AppColors.linkDefault);

  TextStyle textSecondary() => copyWith(color: AppColors.neutralGrey5);
}

/// ─────────────────────────────────────────────
/// BEHAVIOR EXTENSIONS
/// ─────────────────────────────────────────────
extension TextStyleBehaviorExtensions on TextStyle {
  /// Link behavior (no color here)
  TextStyle link() => copyWith(decoration: TextDecoration.underline, color: AppColors.linkDefault);

  /// Strike-through (e.g. old price)
  TextStyle strikeThrough() => copyWith(decoration: TextDecoration.lineThrough);
}

extension TypographyX on TextStyle {
  // Weights - these can be used in combination with color extensions
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
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
