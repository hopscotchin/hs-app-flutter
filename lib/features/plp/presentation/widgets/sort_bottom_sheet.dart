import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/sorting_option_entity.dart';

class SortBottomSheet extends StatelessWidget {
  final List<SortingOptionEntity> sortingOptions;
  final int? currentOrderRule;
  final void Function(int orderRule) onSelected;

  const SortBottomSheet({
    super.key,
    required this.sortingOptions,
    this.currentOrderRule,
    required this.onSelected,
  });

  int? get _activeOrderRule =>
      currentOrderRule ??
      sortingOptions
          .where((o) => o.isSelected)
          .map((o) => o.orderRule)
          .firstOrNull;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Text('Sort By', style: AppTypography.titleMedium),
          ),
          const Divider(height: 1),
          ...sortingOptions.map((option) {
            final isSelected = option.orderRule == _activeOrderRule;
            return ListTile(
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
              title: Text(
                option.sortName ?? '',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isSelected
                      ? AppTypography.semiBold
                      : AppTypography.regular,
                ),
              ),
              onTap: () {
                onSelected(option.orderRule);
                Navigator.of(context).pop();
              },
            );
          }),
          AppSpacing.verticalGapSm,
        ],
      ),
    );
  }
}
