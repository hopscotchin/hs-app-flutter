import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';
import '../../domain/entities/plp_filter_entity.dart';
import '../bloc/filter_bloc.dart';
import 'filter_tree_content.dart';

/// Full-screen filter page matching Android's FiltersActivity.
///
/// Layout: header (title + close + Clear All) → left sidebar (35%) with
/// section names + right content (65%) with filter options → Apply button.
///
/// Navigate via [FilterPage.open] which returns the selected filters map.
class FilterPage extends StatelessWidget {
  final PlpFilterEntity? plpFilter;
  final Map<String, String> appliedFilters;
  final Map<String, dynamic> baseQueryParams;

  const FilterPage({
    super.key,
    this.plpFilter,
    this.appliedFilters = const {},
    this.baseQueryParams = const {},
  });

  /// Opens the filter page and returns the applied filters (or null if dismissed).
  static Future<Map<String, String>?> open(
    BuildContext context, {
    PlpFilterEntity? plpFilter,
    Map<String, String> appliedFilters = const {},
    Map<String, dynamic> baseQueryParams = const {},
  }) {
    return Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<FilterBloc>()
            ..add(
              InitializeFilter(
                plpFilter: plpFilter ?? const PlpFilterEntity(),
                appliedFilters: appliedFilters,
                baseQueryParams: baseQueryParams,
              ),
            ),
          child: FilterPage(
            plpFilter: plpFilter,
            appliedFilters: appliedFilters,
            baseQueryParams: baseQueryParams,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _FilterPageView();
  }
}

class _FilterPageView extends StatefulWidget {
  const _FilterPageView();

  @override
  State<_FilterPageView> createState() => _FilterPageViewState();
}

class _FilterPageViewState extends State<_FilterPageView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context, state),
                    const Divider(height: 1, thickness: 0.5),
                    Expanded(
                      child: Row(
                        children: [
                          _buildSectionSidebar(context, state),
                          const VerticalDivider(width: 1, thickness: 0.5),
                          _buildFilterContent(context, state),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5),
                    _buildApplyButton(context, state),
                  ],
                ),
                if (state.isRefreshing) _buildRefreshingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REFRESHING OVERLAY
  // ---------------------------------------------------------------------------
  Widget _buildRefreshingOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.white.withValues(alpha: 0.5),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER — title + close + clear all
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, FilterState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        AppSpacing.sm,
        AppSpacing.xxs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
          const Expanded(
            child: Text('Filters', style: AppTypography.titleMedium),
          ),
          TextButton(
            onPressed: state.hasSelections
                ? () => context.read<FilterBloc>().add(
                    const ClearAllPendingFilters(),
                  )
                : null,
            child: Text(
              'Clear All',
              style: AppTypography.buttonSmall.copyWith(
                color: state.hasSelections
                    ? AppColors.primary
                    : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LEFT SIDEBAR — filter section names (35% width)
  // ---------------------------------------------------------------------------
  Widget _buildSectionSidebar(BuildContext context, FilterState state) {
    final sections = state.sections;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: ColoredBox(
        color: Colors.grey.shade50,
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            final isSelected = index == state.safeSectionIndex;
            final hasActive = state.isSectionActive(section);

            return InkWell(
              onTap: () => context.read<FilterBloc>().add(
                SwitchSection(sectionIndex: index),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border(
                    left: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        section.name ?? '',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: isSelected
                              ? AppTypography.semiBold
                              : AppTypography.regular,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isSelected && (hasActive || section.hasSelected))
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: AppSpacing.xxs),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RIGHT CONTENT — filter options (65% width)
  // ---------------------------------------------------------------------------
  Widget _buildFilterContent(BuildContext context, FilterState state) {
    final sections = state.sections;
    if (sections.isEmpty) return const Expanded(child: SizedBox.shrink());

    final section = sections[state.safeSectionIndex];
    final uiType = section.uiType?.toLowerCase();

    // Route by uiType
    if (uiType == 'tree') {
      return Expanded(
        child: FilterTreeContent(
          section: section,
          expandedLevel: state.treeExpandedLevel,
          treeSelections: state.treeSelections,
          onItemSelected: (param, value, level) => context
              .read<FilterBloc>()
              .add(SelectTreeItem(param: param, value: value, level: level)),
          onBack: () =>
              context.read<FilterBloc>().add(const NavigateTreeBack()),
        ),
      );
    }

    final isColourMode = uiType == 'colour';
    final allFilters = _flattenFilterList(section.filterList);
    final filtered = _searchQuery.isEmpty
        ? allFilters
        : allFilters
              .where(
                (f) => (f.name ?? '').toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Expanded(
      child: Column(
        children: [
          if (section.showSearch) _buildSearchBar(section.searchBarLabel),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final filter = filtered[index];
                if (filter.isSection) {
                  return _buildSectionHeader(filter);
                }
                return isColourMode
                    ? _buildColourFilterItem(context, state, filter, section)
                    : _buildFilterItem(context, state, filter, section);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FilterEntity> _flattenFilterList(List<FilterEntity> filters) {
    final result = <FilterEntity>[];
    for (final filter in filters) {
      if (filter.filter.isNotEmpty) {
        result.add(
          FilterEntity(name: filter.name, param: filter.param, isSection: true),
        );
        result.addAll(filter.filter);
      } else {
        result.add(filter);
      }
    }
    return result;
  }

  Widget _buildSearchBar(String? hint) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xxs,
      ),
      child: SizedBox(
        height: 36,
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: AppTypography.bodySmall,
          decoration: InputDecoration(
            hintText: hint ?? 'Search',
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 18,
              color: AppColors.textTertiary,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
            ),
            border: const OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusSm,
              borderSide: BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(FilterEntity filter) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md + AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xxs,
      ),
      child: Text(
        filter.name ?? '',
        style: AppTypography.caption.copyWith(
          fontWeight: AppTypography.semiBold,
        ),
      ),
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    FilterState state,
    FilterEntity filter,
    FilterSectionEntity section,
  ) {
    final param = filter.param ?? '';
    final value = filter.id ?? filter.value ?? filter.name ?? '';
    final isChecked =
        _isFilterSelected(state, param, value) || filter.isSelected;

    return InkWell(
      onTap: () => context.read<FilterBloc>().add(
        ToggleFilterItem(
          param: param,
          value: value,
          isMultiSelect: section.isMultiSelect,
        ),
      ),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (_) => context.read<FilterBloc>().add(
                    ToggleFilterItem(
                      param: param,
                      value: value,
                      isMultiSelect: section.isMultiSelect,
                    ),
                  ),
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  filter.name ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: isChecked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isChecked
                        ? AppTypography.semiBold
                        : AppTypography.regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (filter.count != null && filter.count! > 0)
                Text(
                  '(${filter.count})',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColourFilterItem(
    BuildContext context,
    FilterState state,
    FilterEntity filter,
    FilterSectionEntity section,
  ) {
    final param = filter.param ?? '';
    final value = filter.id ?? filter.value ?? filter.name ?? '';
    final isChecked =
        _isFilterSelected(state, param, value) || filter.isSelected;
    final colourHex = filter.value;

    return InkWell(
      onTap: () => context.read<FilterBloc>().add(
        ToggleFilterItem(
          param: param,
          value: value,
          isMultiSelect: section.isMultiSelect,
        ),
      ),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _parseColor(colourHex) ?? Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isChecked ? AppColors.primary : AppColors.border,
                    width: isChecked ? 2 : 0.5,
                  ),
                ),
                child: isChecked
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: _isLightColor(colourHex)
                            ? AppColors.textPrimary
                            : Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  filter.name ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: isChecked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isChecked
                        ? AppTypography.semiBold
                        : AppTypography.regular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (filter.count != null && filter.count! > 0)
                Text(
                  '(${filter.count})',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM — Apply button
  // ---------------------------------------------------------------------------
  Widget _buildApplyButton(BuildContext context, FilterState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeightMd,
        child: ElevatedButton(
          onPressed: state.hasSelections
              ? () => Navigator.of(context).pop(state.flattenFilters())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textTertiary,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusSm,
            ),
          ),
          child: const Text('APPLY', style: AppTypography.buttonMedium),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Selection helpers
  // ---------------------------------------------------------------------------
  bool _isFilterSelected(FilterState state, String param, String value) {
    return state.pendingFilters[param]?.contains(value) == true;
  }

  // ---------------------------------------------------------------------------
  // Colour helpers
  // ---------------------------------------------------------------------------
  static Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceFirst('#', '');
    final intValue = int.tryParse('FF$cleaned', radix: 16);
    if (intValue == null) return null;
    return Color(intValue);
  }

  static bool _isLightColor(String? hex) {
    final color = _parseColor(hex);
    if (color == null) return true;
    return color.computeLuminance() > 0.5;
  }
}
