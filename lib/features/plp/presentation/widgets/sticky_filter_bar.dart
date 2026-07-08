import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/plp_sorting_options_entity.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import 'filter_page.dart';
import 'filter_section_sheet.dart';
import 'sort_bottom_sheet.dart';

class StickyFilterBar extends StatelessWidget {
  final PlpSortingOptionsEntity? sortingOptions;
  final PlpFilterEntity? plpFilter;
  final Map<String, String> appliedFilters;
  final Map<String, dynamic> baseQueryParams;
  final void Function(int orderRule) onSortApplied;
  final void Function(Map<String, String> filters) onFiltersApplied;

  const StickyFilterBar({
    super.key,
    required this.sortingOptions,
    this.plpFilter,
    this.appliedFilters = const {},
    this.baseQueryParams = const {},
    required this.onSortApplied,
    required this.onFiltersApplied,
  });

  @override
  Widget build(BuildContext context) {
    // Drive from quickFilters (populated by API response ).
    // Fall back to all sections if quickFilters is empty.
    final qfs = plpFilter?.quickFilters ?? const [];
    final sections = plpFilter?.filterSections ?? const [];
    // When quickFilters is empty no chips are shown — only Sort By / Filter By remain.
    final filterList = qfs
        .map((qf) => _findSection(sections, qf.filterKey))
        .whereType<FilterSectionEntity>()
        .toList();

    final sortingOption = sortingOptions?.options ?? [];
    final hasFiltersAvailable = sortingOption.isNotEmpty || plpFilter != null;
    final hasSelectedFilterAvailable = (plpFilter?.selectedFilters ?? []).isNotEmpty;
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.neutralGrey1)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          /// LEFT SCROLLABLE FILTERS
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: 29,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filterList.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final filter = filterList[index];
                      return Padding(
                        padding: EdgeInsets.only(right: index == filterList.length - 1 ? 10 : 0),
                        child: _FilterChip(
                          label: filter.label ?? '',
                          isActive: filter.hasSelected,
                          onTap: () {
                            _showSectionSheet(context, filter);
                          },
                        ),
                      );
                    },
                  ),
                ),

                if (hasFiltersAvailable)
                  /// RIGHT FADE EFFECT
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.white.withAlpha(0), Colors.white],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (hasFiltersAvailable)
            /// RIGHT FIXED ACTIONS
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 10),
              child: Row(
                children: [
                  if (sortingOption.isNotEmpty)
                    actionButton(
                      icon: ImageConstants.sortBy,
                      showFilterSelected: true,
                      label: PlpStrings.sortBy,
                      onTap: () {
                        _showSortSheet(context);
                      },
                    ),

                  if (sortingOption.isNotEmpty && plpFilter != null) ...[
                    const SizedBox(width: 8),
                    const VerticalDivider(
                      endIndent: 20,
                      indent: 15,
                      width: 1,
                      thickness: 1,
                      color: AppColors.brandPrimary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (plpFilter != null)
                    actionButton(
                      showFilterSelected: hasSelectedFilterAvailable,
                      icon: ImageConstants.filter,
                      label: PlpStrings.fileterBy,
                      onTap: () {
                        _showFilterPage(context);
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static FilterSectionEntity? _findSection(List<FilterSectionEntity> sections, String? filterKey) {
    if (filterKey == null || filterKey.isEmpty) return null;
    for (final s in sections) {
      if (s.filterKey == filterKey && s.filterList.isNotEmpty) {
        return s;
      }
    }
    return null;
  }

  Widget actionButton({
    required String icon,
    required String label,
    final VoidCallback? onTap,
    final bool showFilterSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImage(path: icon, height: 20, width: 20),
              if (showFilterSelected) ...[
                const SizedBox(width: 2),
                const CircleAvatar(radius: 2, backgroundColor: AppColors.brandSecondary),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypographyV1.caption.bold.disabled()),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (_) =>
          SortBottomSheet(sortingOptions: sortingOptions?.options ?? [], onSelected: onSortApplied),
    );
  }

  void _showSectionSheet(BuildContext context, FilterSectionEntity section) async {
    final result = await FilterSectionSheet.show(
      context,
      section: section,
      appliedFilters: appliedFilters,
    );
    if (result != null) {
      // Seed from appliedFilters — already comma-joined, no multi-value overwrite risk.
      final merged = Map<String, String>.from(appliedFilters);
      merged.addAll(result);
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

/// FILTER CHIP
class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  const _FilterChip({required this.label, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.neutralGrey0,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isActive) ...[
              const CircleAvatar(radius: 2, backgroundColor: AppColors.brandSecondary),
              const SizedBox(width: 4),
            ],
            Text(label, style: AppTypographyV1.labelLarge.bold.textPrimary()),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}
