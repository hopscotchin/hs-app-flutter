import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';

/// 3-level drill-down tree for category-type filter sections (uiType == "tree").
///
/// Data structure from API:
/// ```
/// FilterSection (uiType="tree")
/// └─ filterList[0] (wrapper)
///    └─ filter[] (Level 0 items)
///       ├─ Filter(name:"Women", param:"category", filter:[...Level1])
///       └─ Filter(name:"Kids",  param:"category", filter:[...Level1])
/// ```
class FilterTreeContent extends StatelessWidget {
  final FilterSectionEntity section;
  final int expandedLevel;
  final Map<String, String> treeSelections;
  final void Function(String param, String value, int level) onItemSelected;
  final VoidCallback onBack;

  const FilterTreeContent({
    super.key,
    required this.section,
    required this.expandedLevel,
    required this.treeSelections,
    required this.onItemSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final items = _getItemsForCurrentLevel();
    final breadcrumbs = _buildBreadcrumbs();

    return Column(
      children: [
        // Breadcrumb header
        if (expandedLevel > 0)
          _BreadcrumbHeader(breadcrumbs: breadcrumbs, onBack: onBack),
        // Items list
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Text(
                    'No options available',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final param = item.param ?? '';
                    final value = item.id ?? item.value ?? item.name ?? '';
                    final isSelected = treeSelections[param] == value;
                    final hasChildren = item.filter.isNotEmpty;

                    return _TreeItem(
                      filter: item,
                      isSelected: isSelected,
                      hasChildren: hasChildren,
                      onTap: () => onItemSelected(param, value, expandedLevel),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Navigate the tree hierarchy to find items at the current expanded level.
  List<FilterEntity> _getItemsForCurrentLevel() {
    if (section.filterList.isEmpty) return [];

    final wrapper = section.filterList.first;
    if (wrapper.filter.isEmpty) return [];

    // Level 0
    List<FilterEntity> current = wrapper.filter;
    if (expandedLevel == 0) return current;

    // Find selected item at level 0 and get its children
    final level0Param = current.first.param ?? '';
    final level0Selection = treeSelections[level0Param];
    if (level0Selection == null) return [];

    final selectedLevel0 = current.where(
      (f) => (f.id ?? f.value ?? f.name) == level0Selection,
    );
    if (selectedLevel0.isEmpty) return [];
    current = selectedLevel0.first.filter;

    if (expandedLevel == 1) return current;

    // Find selected item at level 1 and get its children
    if (current.isEmpty) return [];
    final level1Param = current.first.param ?? '';
    final level1Selection = treeSelections[level1Param];
    if (level1Selection == null) return [];

    final selectedLevel1 = current.where(
      (f) => (f.id ?? f.value ?? f.name) == level1Selection,
    );
    if (selectedLevel1.isEmpty) return [];
    return selectedLevel1.first.filter;
  }

  List<String> _buildBreadcrumbs() {
    final crumbs = <String>[section.name ?? 'Categories'];

    if (section.filterList.isEmpty) return crumbs;
    final wrapper = section.filterList.first;
    if (wrapper.filter.isEmpty) return crumbs;

    final level0Items = wrapper.filter;
    if (level0Items.isEmpty) return crumbs;

    final level0Param = level0Items.first.param ?? '';
    final level0Selection = treeSelections[level0Param];
    if (level0Selection == null || expandedLevel < 1) return crumbs;

    // Find selected level 0 name
    final selectedL0 = level0Items.where(
      (f) => (f.id ?? f.value ?? f.name) == level0Selection,
    );
    if (selectedL0.isNotEmpty) crumbs.add(selectedL0.first.name ?? '');

    if (expandedLevel < 2) return crumbs;

    // Find selected level 1 name
    final level1Items = selectedL0.first.filter;
    if (level1Items.isEmpty) return crumbs;
    final level1Param = level1Items.first.param ?? '';
    final level1Selection = treeSelections[level1Param];
    if (level1Selection == null) return crumbs;

    final selectedL1 = level1Items.where(
      (f) => (f.id ?? f.value ?? f.name) == level1Selection,
    );
    if (selectedL1.isNotEmpty) crumbs.add(selectedL1.first.name ?? '');

    return crumbs;
  }
}

class _BreadcrumbHeader extends StatelessWidget {
  final List<String> breadcrumbs;
  final VoidCallback onBack;

  const _BreadcrumbHeader({required this.breadcrumbs, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: AppSpacing.borderRadiusSm,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < breadcrumbs.length; i++) ...[
                    if (i > 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    Text(
                      breadcrumbs[i],
                      style: AppTypography.caption.copyWith(
                        color: i == breadcrumbs.length - 1
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: i == breadcrumbs.length - 1
                            ? AppTypography.semiBold
                            : AppTypography.regular,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreeItem extends StatelessWidget {
  final FilterEntity filter;
  final bool isSelected;
  final bool hasChildren;
  final VoidCallback onTap;

  const _TreeItem({
    required this.filter,
    required this.isSelected,
    required this.hasChildren,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              // Radio-style indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1.5,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  filter.name ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? AppTypography.semiBold
                        : AppTypography.regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (filter.count != null && filter.count! > 0)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxs),
                  child: Text(
                    '(${filter.count})',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              if (hasChildren)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
