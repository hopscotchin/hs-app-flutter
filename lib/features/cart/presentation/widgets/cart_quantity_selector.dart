import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

class CartQuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int>? onChanged;
  final bool enabled;

  const CartQuantitySelector({
    super.key,
    required this.quantity,
    this.maxQuantity = 10,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      enabled: enabled,
      onSelected: onChanged,
      offset: const Offset(0, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) {
        return List.generate(
          maxQuantity,
          (index) => PopupMenuItem<int>(
            value: index + 1,
            height: 36,
            child: Text(
              '${index + 1}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: (index + 1) == quantity
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: (index + 1) == quantity
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        );
      },
      child: Text(
        'Quantity: $quantity',
        style: AppTypography.bodySmall.copyWith(
          color: enabled ? AppColors.textSecondary : AppColors.textDisabled,
        ),
      ),
    );
  }
}
