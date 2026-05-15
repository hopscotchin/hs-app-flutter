import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/sorting_option_entity.dart';
import 'filter_page.dart';
import 'filter_section_sheet.dart';
import 'sort_bottom_sheet.dart';

class StickyFilterBar extends StatelessWidget {
  final List<SortingOptionEntity> sortingOptions;
  final PlpFilterEntity? plpFilter;
  final int? currentOrderRule;
  final Map<String, String> appliedFilters;
  final Map<String, dynamic> baseQueryParams;
  final void Function(int orderRule) onSortApplied;
  final void Function(Map<String, String> filters) onFiltersApplied;

  const StickyFilterBar({
    super.key,
    required this.sortingOptions,
    this.plpFilter,
    this.currentOrderRule,
    this.appliedFilters = const {},
    this.baseQueryParams = const {},
    required this.onSortApplied,
    required this.onFiltersApplied,
  });

  /// Only these filter section names (case-insensitive) are shown as quick-
  /// access chips on the sticky bar. Matches Android's
  /// `ProductListPageActivity.getTopFiltersData` logic.
  static const _eligibleStickyFilters = {'gender', 'age', 'price', 'colour'};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: ListView(
        key: const PageStorageKey('sticky_filter_bar'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        children: [
          // 1) SORT BY chip
          if (sortingOptions.isNotEmpty)
            _buildChip(
              context,
              label: 'SORT BY',
              icon: Icons.swap_vert,
              onTap: () => _showSortSheet(context),
            ),
          // 2) Eligible section chips (Gender, Age, Price, Colour)
          if (plpFilter != null)
            ...plpFilter!.filterSection
                .where(
                  (s) =>
                      s.name != null &&
                      s.filterList.isNotEmpty &&
                      _eligibleStickyFilters.contains(s.name!.toLowerCase()),
                )
                .map((section) {
                  final isActive = section.hasSelected;
                  return _buildChip(
                    context,
                    label: section.name!.toUpperCase(),
                    isActive: isActive,
                    showDropdownArrow: true,
                    onTap: () => _showSectionSheet(context, section),
                  );
                }),
          // 3) FILTERS chip — opens full-screen FilterPage
          if (plpFilter != null)
            _buildChip(
              context,
              label: 'FILTERS',
              icon: Icons.filter_list,
              onTap: () => _showFilterPage(context),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    IconData? icon,
    bool isActive = false,
    bool showDropdownArrow = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusFull,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : Colors.transparent,
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSpacing.iconXs,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (showDropdownArrow) ...[
                const SizedBox(width: AppSpacing.xxs),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: AppSpacing.iconXs,
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (_) => SortBottomSheet(
        sortingOptions: sortingOptions,
        currentOrderRule: currentOrderRule,
        onSelected: onSortApplied,
      ),
    );
  }

  /// Opens a bottom sheet with only the selected section's filter options.
  ///
  /// Merges the section result with existing filters from
  /// [PlpFilterEntity.selectedFilters] so other active filters are preserved.
  /// Matches Android's `onMultiFilterOptionClicked` which seeds `filterParam`
  /// from `plpFilter.getSelectedFilters()` before adding new selections.
  void _showSectionSheet(
    BuildContext context,
    FilterSectionEntity section,
  ) async {
    final result = await FilterSectionSheet.show(
      context,
      section: section,
      appliedFilters: appliedFilters,
    );
    if (result != null) {
      // Seed from API response's selectedFilters (source of truth).
      final merged = <String, String>{};
      if (plpFilter != null) {
        for (final sf in plpFilter!.selectedFilters) {
          if (sf.key != null && sf.param != null) {
            merged[sf.key!] = sf.param!;
          }
        }
      }
      // Overlay new section selections.
      merged.addAll(result);
      // Remove cleared filters.
      merged.removeWhere((_, v) => v.isEmpty);
      onFiltersApplied(merged);
    }
  }

  /// Opens the full-screen FilterPage with all filter sections.
  void _showFilterPage(BuildContext context) async {
    final result = await FilterPage.open(
      context,
      plpFilter: plpFilter,
      appliedFilters: appliedFilters,
      baseQueryParams: baseQueryParams,
    );
    if (result != null) {
      onFiltersApplied(result);
    }
  }
}
