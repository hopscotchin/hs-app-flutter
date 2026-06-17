import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';

/// Resolved colours for a single button permutation.
class AppButtonStyle {
  const AppButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
}

/// Design-system colour tokens — private to this file.
abstract final class _C {
  // ── Filled (defaultType) ────────────────────────────────────────────────
  static const Color primaryDefaultBg = AppColors.brandDefault;
  static const Color primaryDefaultFg = Colors.white;

  static const Color secondaryDefaultBg = AppColors.whiteColor; // #836EF1
  static const Color secondatDefaultFg = AppColors.brandDefault;

  static const Color secondatDefaultBorder = AppColors.brandDefault;

  static const Color tertiaryDefaultBg = AppColors.brandTertiary; // #B395C4
  static const Color tertiaryDefaultFg = AppColors.brandDefault;

  // ── Outlined (hover) ────────────────────────────────────────────────────
  static const Color primaryHoverBg = AppColors.brandSecondary;
  static const Color primaryHoverFg = AppColors.whiteColor;
  static const Color primaryHoverBorder = AppColors.brandSecondary;

  static const Color secondaryHoverBg = AppColors.brandTertiary; // #F4E6F5
  static const Color secondaryHoverFg = AppColors.brandPrimary;
  static const Color secondaryHoverBorder = AppColors.brandPrimary;

  static const Color tertiaryHoverBg = AppColors.secondaryInActive;
  static const Color tertiaryHoverFg = Colors.white;
  static const Color tertiaryHoverBorder = AppColors.secondaryInActive;

  // ── Ghost / tinted (inactive) ────────────────────────────────────────────
  static const Color primaryInactiveBg = AppColors.disabledDefault;
  static const Color primaryInactiveFg = AppColors.whiteColor;

  static const Color secondaryInactiveBg = AppColors.whiteColor;
  static const Color secondaryInactiveFg = AppColors.disabledDefault;
  static const Color secondaryInactiveBorder = AppColors.disabledDefault;

  static const Color tertiaryInactiveBg = Color(0xFFE8E0F4);
  static const Color tertiaryInactiveFg = AppColors.secondaryInActive;

  // ── Text-only (link / linksmall) ─────────────────────────────────────────
  static const Color linkFg = AppColors.brandSecondary;
}

abstract final class AppButtonTheme {
  static AppButtonStyle resolve({
    required ButtonVariant variant,
    required ButtonStyleType styleType,
  }) {
    return switch ((variant, styleType)) {
      // ── Filled (defaultType) ───────────────────────────────────────────
      (ButtonVariant.primary, ButtonStyleType.defaultType) => const AppButtonStyle(
        backgroundColor: _C.primaryDefaultBg,
        foregroundColor: _C.primaryDefaultFg,
      ),

      // ── Outlined (hover) ───────────────────────────────────────────────
      (ButtonVariant.primary, ButtonStyleType.hover) => const AppButtonStyle(
        backgroundColor: _C.primaryHoverBg,
        foregroundColor: _C.primaryHoverFg,
        borderColor: _C.primaryHoverBorder,
      ),

      // ── Ghost / tinted (inactive) ──────────────────────────────────────
      (ButtonVariant.primary, ButtonStyleType.inactive) => const AppButtonStyle(
        backgroundColor: _C.primaryInactiveBg,
        foregroundColor: _C.primaryInactiveFg,
      ),

      // ── Filled (defaultType) ───────────────────────────────────────────
      (ButtonVariant.secondary, ButtonStyleType.defaultType) => const AppButtonStyle(
        backgroundColor: _C.secondaryDefaultBg,
        foregroundColor: _C.secondatDefaultFg,
        borderColor: _C.secondatDefaultBorder,
      ),

      // ── Outlined (hover) ───────────────────────────────────────────────
      (ButtonVariant.secondary, ButtonStyleType.hover) => const AppButtonStyle(
        backgroundColor: _C.secondaryHoverBg,
        foregroundColor: _C.secondaryHoverFg,
        borderColor: _C.secondaryHoverBorder,
      ),

      // ── Ghost / tinted (inactive) ──────────────────────────────────────
      (ButtonVariant.secondary, ButtonStyleType.inactive) => const AppButtonStyle(
        backgroundColor: _C.secondaryInactiveBg,
        foregroundColor: _C.secondaryInactiveFg,
        borderColor: _C.secondaryInactiveBorder,
      ),

      // ── Filled (defaultType) ───────────────────────────────────────────
      (ButtonVariant.tertiary, ButtonStyleType.defaultType) => const AppButtonStyle(
        backgroundColor: _C.tertiaryDefaultBg,
        foregroundColor: _C.tertiaryDefaultFg,
      ),

      // ── Outlined (hover) ───────────────────────────────────────────────
      (ButtonVariant.tertiary, ButtonStyleType.hover) => const AppButtonStyle(
        backgroundColor: _C.tertiaryHoverBg,
        foregroundColor: _C.tertiaryHoverFg,
        borderColor: _C.tertiaryHoverBorder,
      ),

      // ── Ghost / tinted (inactive) ──────────────────────────────────────
      (ButtonVariant.tertiary, ButtonStyleType.inactive) => const AppButtonStyle(
        backgroundColor: _C.tertiaryInactiveBg,
        foregroundColor: _C.tertiaryInactiveFg,
      ),

      // ── Text-only (link / linksmall — styleType is irrelevant) ─────────
      (ButtonVariant.link, _) || (ButtonVariant.linksmall, _) => const AppButtonStyle(
        backgroundColor: Colors.transparent,
        foregroundColor: _C.linkFg,
      ),
    };
  }
}
