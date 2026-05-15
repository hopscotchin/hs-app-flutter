import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/selected_filter_entity.dart';

class AppliedFiltersBar extends StatelessWidget {
  final List<SelectedFilterEntity> selectedFilters;
  final void Function(SelectedFilterEntity filter) onRemove;
  final VoidCallback onClearAll;

  const AppliedFiltersBar({
    super.key,
    required this.selectedFilters,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final visibleFilters = selectedFilters.where((f) => f.showOnUi).toList();
    if (visibleFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        children: [
          ...visibleFilters.map(_buildFilterChip),
          _buildClearAllChip(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(SelectedFilterEntity filter) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: Chip(
        label: Text(
          filter.selectedFilterName ?? '',
          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
        ),
        deleteIcon: const Icon(
          Icons.close,
          size: AppSpacing.iconXs,
          color: AppColors.primary,
        ),
        onDeleted: () => onRemove(filter),
        backgroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primary, width: 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildClearAllChip() {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: ActionChip(
        label: Text(
          'Clear All',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        onPressed: onClearAll,
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: AppColors.border),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
