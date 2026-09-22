import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  /// Optional automation keys. Screens that assert their error state need a
  /// handle on the message and the button; screens that do not can leave both
  /// null, which is why they are not required.
  final Key? messageKey;
  final Key? retryButtonKey;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.messageKey,
    this.retryButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppSpacing.iconXl,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalGapMd,
            Text(
              message,
              key: messageKey,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapLg,
            ElevatedButton.icon(
              key: retryButtonKey,
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
