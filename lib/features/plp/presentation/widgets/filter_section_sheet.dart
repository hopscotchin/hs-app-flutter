import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';

/// Bottom sheet that shows filter options for a single [FilterSectionEntity].
///
/// Used when the user taps an eligible sticky-filter chip (Gender, Age, etc.).
/// Returns a `Map<String, String>` with selected param→values or null if
/// dismissed.
class FilterSectionSheet extends StatefulWidget {
  final FilterSectionEntity section;
  final Map<String, String> appliedFilters;
  final ScrollController? scrollController;
  final DraggableScrollableController? sheetController;

  const FilterSectionSheet({
    super.key,
    required this.section,
    this.appliedFilters = const {},
    this.scrollController,
    this.sheetController,
  });

  /// Opens the bottom sheet and returns the selected filters or null.
  static Future<Map<String, String>?> show(
    BuildContext context, {
    required FilterSectionEntity section,
    Map<String, String> appliedFilters = const {},
  }) {
    final sheetController = DraggableScrollableController();
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // Compute how many items after flattening
    var itemCount = 0;
    for (final f in section.filterList) {
      itemCount += f.filter.isNotEmpty ? f.filter.length : 1;
    }

    // dragHandle(20) + header(65) + divider(1) + items(48 each) + divider(1) + applyButton(72) + bottomSafe
    const fixedHeight = 20.0 + 65.0 + 1.0 + 1.0 + 72.0;
    final contentHeight = fixedHeight + (itemCount * 48.0) + bottomPadding;
    final idealFraction = (contentHeight / screenHeight).clamp(0.25, 0.85);

    // Min height must accommodate at least 2 items
    final minContentHeight = fixedHeight + (2 * 48.0) + bottomPadding;
    final minFraction = (minContentHeight / screenHeight).clamp(
      0.2,
      idealFraction,
    );

    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
        controller: sheetController,
        initialChildSize: idealFraction,
        minChildSize: minFraction,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) => FilterSectionSheet(
          section: section,
          appliedFilters: appliedFilters,
          scrollController: scrollController,
          sheetController: sheetController,
        ),
      ),
    );
  }

  @override
  State<FilterSectionSheet> createState() => _FilterSectionSheetState();
}

class _FilterSectionSheetState extends State<FilterSectionSheet> {
  late Set<String> _selectedValues;
  late String _param;

  @override
  void initState() {
    super.initState();
    // Determine the param key for this section from its filter list.
    // Check both parent and nested child filters for the param key.
    _param = _resolveParam(widget.section.filterList);
    // Seed from already-applied filters.
    final existing = widget.appliedFilters[_param] ?? '';
    _selectedValues = existing.split(',').where((v) => v.isNotEmpty).toSet();
  }

  bool get _isColourMode => widget.section.uiType?.toLowerCase() == 'colour';

  bool get _hasSelections => _selectedValues.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final filters = _flattenFilterList(widget.section.filterList);

    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Drag handle — tap to expand
          GestureDetector(
            onTap: _expandSheet,
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          _buildHeader(),
          const Divider(height: 1, thickness: 0.5),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              itemCount: filters.length,
              itemBuilder: (_, index) {
                final filter = filters[index];
                return _isColourMode
                    ? _buildColourItem(filter)
                    : _buildCheckboxItem(filter);
              },
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          _buildApplyButton(),
        ],
      ),
    );
  }

  /// Resolves the param key from filter list, checking nested children too.
  static String _resolveParam(List<FilterEntity> filters) {
    for (final f in filters) {
      if (f.param != null && f.param!.isNotEmpty) return f.param!;
      for (final child in f.filter) {
        if (child.param != null && child.param!.isNotEmpty) return child.param!;
      }
    }
    return '';
  }

  /// Flattens hierarchical filter lists so nested child options are displayed.
  List<FilterEntity> _flattenFilterList(List<FilterEntity> filters) {
    final result = <FilterEntity>[];
    for (final filter in filters) {
      if (filter.filter.isNotEmpty) {
        result.addAll(filter.filter);
      } else {
        result.add(filter);
      }
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.section.name ?? 'Filter',
              style: AppTypography.titleMedium,
            ),
          ),
          TextButton(
            onPressed: _hasSelections
                ? () => setState(() => _selectedValues.clear())
                : null,
            child: Text(
              'Clear',
              style: AppTypography.buttonSmall.copyWith(
                color: _hasSelections
                    ? AppColors.primary
                    : AppColors.textTertiary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 22),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Checkbox item
  // ---------------------------------------------------------------------------
  Widget _buildCheckboxItem(FilterEntity filter) {
    final value = filter.id ?? filter.value ?? filter.name ?? '';
    final isChecked = _selectedValues.contains(value) || filter.isSelected;

    return InkWell(
      onTap: () => _toggle(value),
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
                  onChanged: (_) => _toggle(value),
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

  // ---------------------------------------------------------------------------
  // Colour item
  // ---------------------------------------------------------------------------
  Widget _buildColourItem(FilterEntity filter) {
    final value = filter.id ?? filter.value ?? filter.name ?? '';
    final isChecked = _selectedValues.contains(value) || filter.isSelected;
    final colourHex = filter.value;

    return InkWell(
      onTap: () => _toggle(value),
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
  // Apply button
  // ---------------------------------------------------------------------------
  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeightMd,
        child: ElevatedButton(
          onPressed: _hasSelections ? _onApply : null,
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
  // Sheet expansion
  // ---------------------------------------------------------------------------
  void _expandSheet() {
    widget.sheetController?.animateTo(
      0.85,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // ---------------------------------------------------------------------------
  // Selection helpers
  // ---------------------------------------------------------------------------
  void _toggle(String value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        if (!widget.section.isMultiSelect) _selectedValues.clear();
        _selectedValues.add(value);
      }
    });
  }

  void _onApply() {
    final result = <String, String>{};
    if (_selectedValues.isNotEmpty) {
      result[_param] = _selectedValues.join(',');
    }
    Navigator.of(context).pop(result);
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
