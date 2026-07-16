import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class CartEmptyView extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartEmptyView({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppColors.textTertiary.withValues(alpha: 0.5),
            ),
            AppSpacing.verticalGapLg,
            Text(
              'Your bag is empty',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.verticalGapXs,
            Text(
              'Looks like you haven\'t added anything to your bag yet',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalGapXl,
            SizedBox(
              width: 200,
              height: AppSpacing.buttonHeightLg,
              child: ElevatedButton(
                onPressed: onStartShopping,
                child: Text(
                  'START SHOPPING',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
