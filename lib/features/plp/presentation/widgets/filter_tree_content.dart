import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/form/app_checkbox.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';

class FilterTreeContent extends StatelessWidget {
  final FilterSectionEntity section;
  final Map<String, String> treeSelections;
  final Map<String, Set<String>> pendingFilters;

  final void Function(String param, String value, int level) onDrillIn;

  final void Function(String param, String value) onLeafToggle;

  final void Function(int level) onPopToLevel;

  const FilterTreeContent({
    super.key,
    required this.section,
    required this.treeSelections,
    required this.pendingFilters,
    required this.onDrillIn,
    required this.onLeafToggle,
    required this.onPopToLevel,
  });

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = _buildBreadcrumbs();
    final items = _itemsForCurrentLevel();
    final currentLevel = breadcrumbs.length;

    if (items.isEmpty && breadcrumbs.isEmpty) {
      return Center(
        child: Text(
          'No options available',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
        ),
      );
    }

    final drillKey = treeSelections.entries.map((e) => '${e.key}=${e.value}').join('|');

    return ListView(
      key: ValueKey(drillKey),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      children: [
        // Breadcrumb rows — stacked, each with its own ⊗.
        for (var i = 0; i < breadcrumbs.length; i++)
          _BreadcrumbRow(
            label: breadcrumbs[i],
            onClose: () => onPopToLevel(i),
            isSubcategory: i > 0,
          ),

        // Children at the current level.
        for (final item in items)
          if (item.filters.isEmpty)
            _LeafRow(
              filter: item,
              isSelected: _isLeafSelected(item),
              onTap: () => onLeafToggle(item.filterKey ?? '', item.filterValue ?? item.label ?? ''),
            )
          else
            _DrillDownRow(
              filter: item,
              onTap: () => onDrillIn(
                item.filterKey ?? '',
                item.filterValue ?? item.label ?? '',
                currentLevel,
              ),
            ),
      ],
    );
  }

  bool _isLeafSelected(FilterEntity leaf) {
    final key = leaf.filterKey ?? '';
    final value = leaf.filterValue ?? leaf.label ?? '';
    return pendingFilters[key]?.contains(value) == true;
  }

  /// Labels of every currently-selected ancestor, in drill order. The
  /// length of this list IS the current drill depth.
  List<String> _buildBreadcrumbs() {
    if (section.filterList.isEmpty) return const [];
    var current = section.filterList.first.filters;
    final labels = <String>[];
    while (current.isNotEmpty) {
      final paramAtLevel = current.first.filterKey ?? '';
      final value = treeSelections[paramAtLevel];
      if (value == null) break;
      final match = current.where((f) => (f.filterValue ?? f.label) == value);
      if (match.isEmpty) break;
      labels.add(match.first.label ?? '');
      current = match.first.filters;
    }
    return labels;
  }

  /// Walks the tree along [treeSelections] and returns the children that
  /// should render below the breadcrumbs (could be parents or leaves).
  List<FilterEntity> _itemsForCurrentLevel() {
    if (section.filterList.isEmpty) return const [];
    var current = section.filterList.first.filters;
    while (current.isNotEmpty) {
      final paramAtLevel = current.first.filterKey ?? '';
      final value = treeSelections[paramAtLevel];
      if (value == null) break;
      final match = current.where((f) => (f.filterValue ?? f.label) == value);
      if (match.isEmpty) break;
      current = match.first.filters;
    }
    return current;
  }
}

// ─── Row widgets ────────────────────────────────────────────────────────────

class _BreadcrumbRow extends StatelessWidget {
  final String label;
  final VoidCallback onClose;
  final bool isSubcategory;

  const _BreadcrumbRow({required this.label, required this.onClose, this.isSubcategory = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.dividerLight, width: 1)),
        ),
        padding: const EdgeInsets.only(
          right: AppSpacing.sm,
          top: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        margin: isSubcategory ? const EdgeInsets.only(left: AppSpacing.sm) : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: AppTypography.semiBold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const CustomImage(path: ImageConstants.filterClose),
          ],
        ),
      ),
    );
  }
}

class _DrillDownRow extends StatelessWidget {
  final FilterEntity filter;
  final VoidCallback onTap;

  const _DrillDownRow({required this.filter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSubCategory = filter.filterKey == 'subCategory';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          // Constant vertical padding so single- and two-line rows share the
          // same spacing (matches _LeafRow). A minHeight only pads short
          // single-line content, which left two-line rows with a smaller gap.
          // Full-width tap comes from the Row's Expanded child filling the list.
          padding: EdgeInsets.only(
            left: isSubCategory ? AppSpacing.sm : 0,
            right: 16,
            top: AppSpacing.xsm,
            bottom: AppSpacing.xsm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  filter.label ?? '',
                  style: isSubCategory
                      ? AppTypographyV1.bodyMedium.regular.textPrimary()
                      : AppTypographyV1.bodyMedium.medium.textPrimary(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (filter.count != null && filter.count! > 0)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Text(
                    '(${filter.count})',
                    style: AppTypographyV1.labelLarge.regular.copyWith(
                      color: Colors.black.withAlpha(50),
                    ),
                  ),
                ),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeafRow extends StatelessWidget {
  final FilterEntity filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _LeafRow({required this.filter, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 26, right: AppSpacing.sm, top: 10, bottom: 10),
            child: AppCheckbox.labeled(
              onChanged: (_) => onTap(),
              isSelected: isSelected,
              label: filter.label ?? '',
              maxLabelLines: 2,
              count: filter.count != null && filter.count! > 0 ? '(${filter.count})' : null,
            ),
          ),
        ),
      ),
    );
  }
}
