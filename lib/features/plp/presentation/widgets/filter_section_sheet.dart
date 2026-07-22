import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/components/form/app_checkbox.dart';
import 'package:hs_app_flutter/components/form/app_radio.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/extensions/color_extensions.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/theme/spacing.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/filter_section_entity.dart';

class FilterSectionSheet extends StatefulWidget {
  final FilterSectionEntity section;
  final Map<String, String> appliedFilters;

  /// Non-null only when hosted inside a [DraggableScrollableSheet] (the tall
  /// content case); wires the option list to the drag controller so the drag
  /// and the inner scroll behave as one gesture.
  final ScrollController? scrollController;

  const FilterSectionSheet({
    super.key,
    required this.section,
    this.appliedFilters = const {},
    this.scrollController,
  });

  /// Content shorter than this fraction of the screen is shown at its own
  /// height; taller content opens at [_kInitialFraction].
  static const double _kMidFraction = 0.5;

  /// Fraction the sheet opens at when the content is taller than [_kMidFraction].
  static const double _kInitialFraction = 0.5;

  /// Highest fraction the user can drag the sheet up to.
  static const double _kMaxFraction = 0.85;

  static Future<Map<String, String>?> show(
    BuildContext context, {
    required FilterSectionEntity section,
    Map<String, String> appliedFilters = const {},
  }) {
    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AdaptiveFilterSheet(section: section, appliedFilters: appliedFilters),
    );
  }

  @override
  State<FilterSectionSheet> createState() => _FilterSectionSheetState();
}

class _FilterSectionSheetState extends State<FilterSectionSheet> {
  late Set<String> _selectedValues;
  late String _param;
  // Whether the sheet opened with values already applied. Captured once so
  // Apply stays enabled after the user clears them and wants to apply empty.
  late bool _hadInitialSelections;

  @override
  void initState() {
    super.initState();
    // Determine the param key for this section from its filter list.
    // Check both parent and nested child filters for the param key.
    _param = _resolveParam(widget.section.filterList);
    // Seed from already-applied filters.
    final existing = widget.appliedFilters[_param] ?? '';
    _selectedValues = existing.split(',').where((v) => v.isNotEmpty).toSet();
    _hadInitialSelections = _selectedValues.isNotEmpty;
  }

  bool get _hasSelections => _selectedValues.isNotEmpty;

  /// Enabled when there are selections to commit, or when values were applied
  /// before (so a cleared selection can still be applied). Disabled only when
  /// nothing is/was selected.
  bool get _canApply => _hasSelections || _hadInitialSelections;
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
              // Hug the content when hosted at a fixed height; when inside the
              // draggable sheet, fill it and let the drag controller scroll.
              shrinkWrap: !draggable,
              physics: draggable
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              itemCount: filters.length,
              itemBuilder: (_, index) => _buildOptionItem(filters[index], index),
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
        key: const ValueKey(PlpTestStrings.filterSectionSheetTitle),
        style: AppTypographyV1.titleMedium.bold.textPrimary(),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  Widget _buildOptionItem(FilterEntity filter, int index) {
    final value = filter.filterValue ?? filter.label ?? '';
    final isSelected = _selectedValues.contains(value);
    final label = filter.label ?? '';
    final count = filter.count != null && filter.count! > 0 ? '(${filter.count})' : null;
    final optionBase = '${PlpTestStrings.filterSectionSheetOption}_$index';
    final optionKey = ValueKey(optionBase);
    final labelKey = ValueKey('${optionBase}_${PlpTestStrings.filterSectionSheetOptionLabelSuffix}');
    final countKey = ValueKey('${optionBase}_${PlpTestStrings.filterSectionSheetOptionCountSuffix}');

    return widget.section.isMultiSelect
        ? _buildCheckbox(filter, value, isSelected, label, count, optionKey, labelKey, countKey)
        : InkWell(
      highlightColor: Colors.transparent,
      onTap: () => _toggle(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xsm,
        ),
        child: AppRadio.labeled(
          key: optionKey,
          isSelected: isSelected,
          label: label,
          count: count,
          labelKey: labelKey,
          countKey: countKey,
        ),
      ),
    );
  }

  Widget _buildCheckbox(
      FilterEntity filter,
      String value,
      bool isSelected,
      String label,
      String? count,
      Key? optionKey,
      Key? labelKey,
      Key? countKey,
      ) {
    final swatch = _isColourMode ? filter.colorHex.toColor : null;
    final useWhiteTick = swatch == null || swatch.isDarkColor;
    return InkWell(
      highlightColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: () => _toggle(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xsm),
        child: AppCheckbox.labeled(
          key: optionKey,
          border: _isColourMode ? Border.all(color: AppColors.neutralGrey1, width: 0.5) : null,
          checkBoxSelectedColor: swatch,
          checkBoxUnSelectedColor: swatch,
          isSelected: isSelected,
          checkColor: _isColourMode ? (useWhiteTick ? Colors.white : AppColors.neutralGrey6) : null,
          label: label,
          count: count,
          labelKey: labelKey,
          countKey: countKey,
        ),
      ),
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
              key: const ValueKey(PlpTestStrings.filterSectionSheetClearButton),
              text: CommonStrings.clearAll,
              onTap: _hasSelections ? () => setState(() => _selectedValues.clear()) : null,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: PrimaryButton.defaultType(
              key: const ValueKey(PlpTestStrings.filterSectionSheetApplyButton),
              text: CommonStrings.apply,
              // Enabled when there are selections to commit, or when values were
              // applied before (so a cleared selection can still be applied).
              // Disabled only when nothing is/was selected.
              state: _canApply ? ButtonState.enabled : ButtonState.disabled,
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

/// Presents [FilterSectionSheet] based on its *real* on-device content height:
///
///  • content shorter than [FilterSectionSheet._kMidFraction] of the screen is
///    shown at exactly that height (no empty space below it),
///  • taller content uses a [DraggableScrollableSheet] that opens at
///    [FilterSectionSheet._kInitialFraction], drags up to
///    [FilterSectionSheet._kMaxFraction], then scrolls internally.
///
/// The height is *measured* (laid out off-stage for one frame) rather than
/// estimated from row-height constants, so the decision is correct on every
/// device. The measure frame is invisible and runs while the sheet is still
/// off-screen, so there is no visible flash.
class _AdaptiveFilterSheet extends StatefulWidget {
  final FilterSectionEntity section;
  final Map<String, String> appliedFilters;

  const _AdaptiveFilterSheet({required this.section, required this.appliedFilters});

  @override
  State<_AdaptiveFilterSheet> createState() => _AdaptiveFilterSheetState();
}

class _AdaptiveFilterSheetState extends State<_AdaptiveFilterSheet> {
  double? _contentHeight;

  FilterSectionSheet _sheet({ScrollController? controller}) => FilterSectionSheet(
    section: widget.section,
    appliedFilters: widget.appliedFilters,
    scrollController: controller,
  );

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final midH = screenH * FilterSectionSheet._kMidFraction;
    final maxH = screenH * FilterSectionSheet._kMaxFraction;

    // First frame: measure the natural content height off-stage, then rebuild.
    if (_contentHeight == null) {
      return Offstage(
        child: _MeasureSize(
          onChange: (size) {
            if (mounted && _contentHeight != size.height) {
              setState(() => _contentHeight = size.height);
            }
          },
          // Cap the measurement at the tallest the sheet can ever be so a huge
          // list resolves to "taller than mid" instead of an unbounded height.
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: _sheet(),
          ),
        ),
      );
    }

    // Short content → occupy exactly its own height.
    if (_contentHeight! <= midH) {
      return SizedBox(height: _contentHeight, child: _sheet());
    }

    // Tall content → open at mid and let the user drag up, but never past the
    // content's own height (capped at [_kMaxFraction]). Because the sheet can
    // never grow taller than the content, there is no empty space at any drag
    // position — a 70%-tall list stops at 70%, a huge list stops at the cap and
    // scrolls internally.
    final contentFraction = (_contentHeight! / screenH).clamp(0.0, 1.0);
    final maxFraction = math.min(contentFraction, FilterSectionSheet._kMaxFraction);
    final initialFraction = math.min(FilterSectionSheet._kInitialFraction, maxFraction);
    // Deduped + sorted so the snap points are always strictly ascending, even
    // when the content sits right at the initial fraction.
    final snapSizes = <double>{initialFraction, maxFraction}.toList()..sort();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialFraction,
      minChildSize: 0.3,
      maxChildSize: maxFraction,
      snap: true,
      snapSizes: snapSizes,
      builder: (_, controller) => _sheet(controller: controller),
    );
  }
}

/// Reports its child's laid-out size via [onChange] after each layout.
class _MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.onChange, required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _MeasureSizeRenderObject(onChange);

  @override
  void updateRenderObject(BuildContext context, _MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  _MeasureSizeRenderObject(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final size = child?.size ?? Size.zero;
    if (_oldSize != size) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
    }
  }
}
