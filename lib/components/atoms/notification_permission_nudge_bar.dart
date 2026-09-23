import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';

/// Slim inline nudge bar for screens that don't warrant a full dialog (PLP
/// grid, in-app WebView). Equivalent in intent to Android's per-screen
/// notification message bar, without a matching design-system component to
/// port pixel-for-pixel.
class NotificationPermissionNudgeBar extends StatelessWidget {
  const NotificationPermissionNudgeBar({
    super.key,
    required this.message,
    required this.onEnable,
    required this.onDismiss,
    this.enableLabel = 'Enable',
    this.dismissLabel = 'Not now',
  });

  final String message;
  final String enableLabel;
  final String dismissLabel;
  final VoidCallback onEnable;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brandTertiary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: AppTypographyV1.labelMedium.regular.textPrimary(),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              child: Text(
                dismissLabel,
                style: AppTypographyV1.labelMedium.semiBold.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
            TextButton(
              onPressed: onEnable,
              child: Text(
                enableLabel,
                style: AppTypographyV1.labelMedium.semiBold.copyWith(
                  color: AppColors.brandDefault,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
