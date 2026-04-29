import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class AppTextStyles {
  // ───────── TITLES ─────────
  static final titlePrimary = AppTypography.titleLarge.bold.neutral900();

  static final titleSecondary = AppTypography.titleLarge.semiBold.neutral700();

  // ───────── BODY ─────────
  static final bodyPrimary = AppTypography.bodyMedium.regular.neutral900();

  static final bodySecondary = AppTypography.bodyMedium.regular.neutral700();

  static final bodyTertiary = AppTypography.bodySmall.regular.neutral500();

  // ───────── CAPTION ─────────
  static final caption = AppTypography.caption.regular.neutral500();

  // ───────── BUTTON ─────────
  static final buttonPrimary = AppTypography.bodyMedium.semiBold.brand();

  static final buttonDisabled = AppTypography.bodyMedium.semiBold.disabled();

  // ───────── STATUS ─────────
  static final successText = AppTypography.bodyMedium.semiBold.success();

  static final errorText = AppTypography.bodyMedium.semiBold.error();

  static final warningText = AppTypography.bodyMedium.semiBold.warning();
}
