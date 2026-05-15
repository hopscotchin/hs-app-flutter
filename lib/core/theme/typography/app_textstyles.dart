import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

class AppTextStyles {
  // ───────── BUTTON ─────────
  static final buttonPrimary = AppTypographyV1.bodyMedium.semiBold.brand();

  static final buttonDisabled = AppTypographyV1.bodyMedium.semiBold.disabled();

  // ───────── STATUS ─────────
  static final successText = AppTypographyV1.bodyMedium.semiBold.success();

  static final errorText = AppTypographyV1.bodyMedium.semiBold.error();

  static final warningText = AppTypographyV1.bodyMedium.semiBold.warning();
}
