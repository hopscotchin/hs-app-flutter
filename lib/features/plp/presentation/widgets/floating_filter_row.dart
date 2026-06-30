import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/floating_filter_entity.dart';

/// Inline floating-filter section rendered inside the product list.
///
/// Selection is managed locally (multi-select). The parent is notified only
/// when the user taps "Apply Filter".
///
/// [onFiltersApplied] receives:
///   key   → shared filterKey for every chip in this section
///   value → comma-joined selected filterValues, or '' to clear the key
class FloatingFilterRow extends StatefulWidget {
  final FloatingFilterSectionEntity section;
  final void Function(String key, String value) onFiltersApplied;

  const FloatingFilterRow({super.key, required this.section, required this.onFiltersApplied});

  @override
  State<FloatingFilterRow> createState() => _FloatingFilterRowState();
}

class _FloatingFilterRowState extends State<FloatingFilterRow> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late String _filterKey;

  /// Tracks which filterValues are currently selected in the UI.
  /// Initialised from [FloatingFilterChipEntity.isSelected] (API-provided).
  late Set<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _syncFromSection();
  }

  /// Re-seed local state when the section entity changes after an API refresh.
  /// Called by the framework automatically; no setState needed — didUpdateWidget
  /// already schedules a rebuild.
  @override
  void didUpdateWidget(FloatingFilterRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section != widget.section) {
      _syncFromSection();
    }
  }

  void _syncFromSection() {
    _filterKey = _resolveFilterKey();
    _selectedValues = widget.section.chips
        .where((c) => c.isSelected && (c.filterValue ?? '').isNotEmpty)
        .map((c) => c.filterValue!)
        .toSet();
  }

  String _resolveFilterKey() {
    for (final chip in widget.section.chips) {
      if (chip.filterKey != null && chip.filterKey!.isNotEmpty) {
        return chip.filterKey!;
      }
    }
    return '';
  }

  // ── Toggle & apply ────────────────────────────────────────────────────────

  void _toggle(String value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
    });
  }

  /// Sends the full selection set upstream. Empty string clears the filter key.
  void _applyFilter() {
    widget.onFiltersApplied(_filterKey, _selectedValues.join(','));
  }

  // ── Geometry ──────────────────────────────────────────────────────────────

  String get _chipType => widget.section.chipType?.toUpperCase() ?? 'TEXT';

  /// Fixed swatch height for IMAGE and COLOUR chips (design spec: 48 dp → 50).
  static const double _swatchHeight = 48;

  /// Width of the swatch — square for COLOUR, from API tileWidth for IMAGE.
  double get _swatchWidth {
    if (_chipType == 'COLOUR') return _swatchHeight;
    return (widget.section.tileWidth?.toDouble() ?? _swatchHeight).clamp(36.0, 48.0);
  }

  /// Total row height for the horizontal ListView:
  ///   TEXT   → 32 (chip height; label lives inside the chip)
  ///   IMAGE / COLOUR → swatch + 4 gap + 16 label
  double get _rowHeight {
    if (_chipType == 'IMAGE' || _chipType == 'COLOUR') {
      return _swatchHeight + 20;
    }
    return 27;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final section = widget.section;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.lgMd),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lgMd),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.neutralBlack.withAlpha(50),
            blurRadius: 7,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (section.title.isNotNullOrEmpty)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lgMd, bottom: AppSpacing.md),
              child: Text(
                section.title ?? '',
                style: AppTypographyV1.titleMedium.bold.textPrimary(),
              ),
            ),

          SizedBox(
            height: _rowHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgMd),
              itemCount: section.chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (_, index) => _buildChip(section.chips[index]),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: SecondaryButton.defaultType(
                text: PlpStrings.applyFilter,
                state: _selectedValues.isNotEmpty ? ButtonState.enabled : ButtonState.disabled,
                onTap: _applyFilter,
                size: ButtonSize.small,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Chip dispatch ─────────────────────────────────────────────────────────

  Widget _buildChip(FloatingFilterChipEntity chip) {
    final value = chip.filterValue ?? '';
    final isSelected = value.isNotEmpty && _selectedValues.contains(value);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: value.isNotEmpty ? () => _toggle(value) : null,
      child: switch (_chipType) {
        'IMAGE' => _buildImageChip(chip, isSelected),
        'COLOUR' => _buildColourChip(chip, isSelected),
        _ => _buildTextChip(chip, isSelected),
      },
    );
  }

  // ── Chip renderers ────────────────────────────────────────────────────────

  /// TEXT: pill/badge chip. Selected → brand-primary border + tint + text.
  Widget _buildTextChip(FloatingFilterChipEntity chip, bool isSelected) {
    const brand = AppColors.brandPrimary;
    return CustomChipWidget(
      text: (chip.label ?? '').toUpperCase(),
      backgroundColor: isSelected ? brand.withValues(alpha: 0.07) : Colors.transparent,
      borderRadius: 2,
      borderColor: isSelected ? brand : AppColors.neutralGrey1,
      textStyle: AppTypographyV1.labelMedium.bold.copyWith(
        color: isSelected ? brand : AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
    );
  }

  Widget _buildImageChip(FloatingFilterChipEntity chip, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? AppColors.brandPrimary : Colors.transparent,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.neutralGrey1,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedImageWidget(
                imageUrl: chip.imageUrl ?? '',
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: _swatchWidth,
          child: Text(
            chip.label ?? '',
            style: AppTypographyV1.labelMedium.medium.textPrimary(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// COLOUR: solid-colour square + label below.
  /// Selected → 2 px brand-primary border around the square.
  Widget _buildColourChip(FloatingFilterChipEntity chip, bool isSelected) {
    final bgColor = chip.backgroundColor?.toColor ?? Colors.grey.shade300;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 48,
          width: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.brandPrimary : AppColors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutralGrey1, width: 0.5),
              color: bgColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          (chip.label ?? '').truncate(7),
          style: AppTypographyV1.labelMedium.medium.textPrimary(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
