import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class PlpEmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback? onClearFilters;

  const PlpEmptyState({
    super.key,
    this.hasFilters = false,
    this.onClearFilters,
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
              Icons.search_off,
              size: AppSpacing.iconXl,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalGapMd,
            Text(
              'No products found',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.verticalGapXs,
            Text(
              hasFilters
                  ? 'Try removing some filters to see more results.'
                  : 'We couldn\'t find any products matching your criteria.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              AppSpacing.verticalGapLg,
              OutlinedButton(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'Clear Filters',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
