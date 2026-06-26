import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/components/form/app_checkbox.dart';
import 'package:hs_app_flutter/components/form/app_radio.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/theme/spacing.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';

class FilterSectionSheet extends StatefulWidget {
  final FilterSectionEntity section;
  final Map<String, String> appliedFilters;

  final ScrollController? scrollController;

  const FilterSectionSheet({
    super.key,
    required this.section,
    this.appliedFilters = const {},
    this.scrollController,
  });

  static const double _kItemHeight = 48;
  static const double _kHeaderHeight = 28;
  static const double _kApplyHeight = 72;
  static const double _kListVPadding = 8;

  static Future<Map<String, String>?> show(
    BuildContext context, {
    required FilterSectionEntity section,
    Map<String, String> appliedFilters = const {},
  }) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;

    final itemCount = _flatItemCount(section.filterList);
    final naturalH =
        _kHeaderHeight +
        _kListVPadding +
        (itemCount * _kItemHeight) +
        _kApplyHeight +
        mq.padding.bottom;
    final fitsAtMid = naturalH <= screenH * 0.5;

    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        if (fitsAtMid) {
          return FilterSectionSheet(section: section, appliedFilters: appliedFilters);
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          snap: true,
          snapSizes: const [0.5, 0.8],
          builder: (_, controller) => FilterSectionSheet(
            section: section,
            appliedFilters: appliedFilters,
            scrollController: controller,
          ),
        );
      },
    );
  }

  static int _flatItemCount(List<FilterEntity> filters) {
    var n = 0;
    for (final f in filters) {
      n += f.filters.isNotEmpty ? f.filters.length : 1;
    }
    return n;
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

  bool get _hasSelections => _selectedValues.isNotEmpty;
  bool get _isColourMode => widget.section.uiType?.toLowerCase() == 'colour';
  @override
  Widget build(BuildContext context) {
    final filters = _flattenFilterList(widget.section.filterList);

    final draggable = widget.scrollController != null;

    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: ListView.builder(
              controller: widget.scrollController,
              shrinkWrap: !draggable,
              physics: draggable
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              itemCount: filters.length,
              itemBuilder: (_, index) {
                final filter = filters[index];
                return _buildOptionItem(filter);
              },
            ),
          ),

          _buildApplyButton(),
        ],
      ),
    );
  }

  /// Resolves the filterKey from filter list, checking nested children too.
  static String _resolveParam(List<FilterEntity> filters) {
    for (final f in filters) {
      if (f.filterKey != null && f.filterKey!.isNotEmpty) return f.filterKey!;
      for (final child in f.filters) {
        if (child.filterKey != null && child.filterKey!.isNotEmpty) return child.filterKey!;
      }
    }
    return '';
  }

  /// Flattens hierarchical filter lists so nested child options are displayed.
  List<FilterEntity> _flattenFilterList(List<FilterEntity> filters) {
    final result = <FilterEntity>[];
    for (final filter in filters) {
      if (filter.filters.isNotEmpty) {
        result.addAll(filter.filters);
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.xxs, AppSpacing.xs),
      child: Text(
        widget.section.label ?? 'Filter',
        style: AppTypographyV1.titleMedium.bold.textPrimary(),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  Widget _buildOptionItem(FilterEntity filter) {
    final value = filter.filterValue ?? filter.label ?? '';
    final isSelected = _selectedValues.contains(value);
    final label = filter.label ?? '';
    final count = filter.count != null && filter.count! > 0 ? '(${filter.count})' : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xsm),
      child: widget.section.isMultiSelect
          ? _buildCheckbox(filter, value, isSelected, label, count)
          : AppRadio.labeled(
              isSelected: isSelected,
              label: label,
              count: count,
              onTap: () => _toggle(value),
            ),
    );
  }

  Widget _buildCheckbox(
    FilterEntity filter,
    String value,
    bool isSelected,
    String label,
    String? count,
  ) {
    final showBlackCheckColor = const [
      'White',
      'Yellow',
      'Khaki',
      'Cream',
      'Off-White',
      'Ivory',
    ].contains(filter.label);
    return AppCheckbox.labeled(
      checkBoxSelectedColor: _isColourMode ? filter.colorHex.toColor : null,
      checkBoxUnSelectedColor: _isColourMode ? filter.colorHex.toColor : null,
      onChanged: (_) => _toggle(value),
      isSelected: isSelected,
      checkColor: showBlackCheckColor ? Colors.black : null,
      label: label,
      count: count,
    );
  }

  // ---------------------------------------------------------------------------
  // Apply button
  // ---------------------------------------------------------------------------
  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TertiaryButton.defaultType(
              text: CommonStrings.clearAll,
              onTap: _hasSelections ? () => setState(() => _selectedValues.clear()) : null,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: PrimaryButton.defaultType(
              text: CommonStrings.apply,
              // Always enabled — applying commits the current selection (incl.
              // removals) and fires the filter API.
              state: ButtonState.enabled,
              onTap: _onApply,
            ),
          ),
        ],
      ),
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
    } else {
      result[_param] = '';
    }
    Navigator.of(context).pop(result);
  }
}
