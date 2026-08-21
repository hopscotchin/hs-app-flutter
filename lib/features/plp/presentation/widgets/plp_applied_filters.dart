import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../domain/entities/selected_filter_entity.dart';
import '../bloc/plp_bloc.dart';
import 'absorb_vertical_drag.dart';

class PlpAppliedFilters extends StatelessWidget {
  const PlpAppliedFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, (List<SelectedFilterEntity>, bool)>(
      selector: (state) {
        final selected = state.plpFilter?.selectedFilters ?? const [];
        final hasVisible = selected.any((f) => f.showOnUi);
        return (selected, hasVisible);
      },
      builder: (context, data) {
        final (selectedFilters, hasVisible) = data;
        // Always return SliverPersistentHeader so the sliver type is stable.
        // Height collapses to 0 when no filters, avoiding element remounting.
        return SliverPersistentHeader(
          pinned: true,
          delegate: _AppliedFiltersPinnedDelegate(
            selectedFilters: selectedFilters,
            hasVisible: hasVisible,
          ),
        );
      },
    );
  }
}

class _AppliedFiltersPinnedDelegate extends SliverPersistentHeaderDelegate {
  final List<SelectedFilterEntity> selectedFilters;
  final bool hasVisible;

  _AppliedFiltersPinnedDelegate({required this.selectedFilters, required this.hasVisible});

  static const double _height = 58.0;

  @override
  double get minExtent => hasVisible ? _height : 0.0;

  @override
  double get maxExtent => hasVisible ? _height : 0.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (!hasVisible) return const SizedBox.shrink();
    final visibleFilters = _chipsForDisplay(selectedFilters);
    if (visibleFilters.isEmpty) return const SizedBox.shrink();
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
        // Absorb vertical drags so dragging on the applied-filter chips doesn't
        // scroll the product grid; horizontal chip scroll and ✕ taps still work.
        child: AbsorbVerticalDrag(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 26,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  children: [
                    for (var i = 0; i < visibleFilters.length; i++)
                      _buildFilterChip(visibleFilters[i], i, () {
                        context.read<PlpBloc>().add(
                          RemoveFilter(filterToRemove: visibleFilters[i]),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Splits each raw selected filter (one per key, with comma-joined values and
  /// labels) into one chip per label, pairing each `selectedFilterName` with its
  /// positional `filterValue`. Mirrors Android's `GetAppliedFiltersUseCase`: the
  /// chip carries only its single positional value, so ✕ removes just that value
  /// (see `PlpBloc._onRemoveFilter`) while the full value set stays in the query.
  /// A filter with no labels renders as a single chip for the whole key.
  List<SelectedFilterEntity> _chipsForDisplay(List<SelectedFilterEntity> filters) {
    final chips = <SelectedFilterEntity>[];
    for (final f in filters) {
      if (!f.showOnUi) continue;
      final values = f.filterValue?.split(',') ?? const <String>[];
      final names = f.selectedFilterName?.split(',') ?? const <String>[];
      if (names.isEmpty) {
        chips.add(f);
        continue;
      }
      for (var i = 0; i < names.length; i++) {
        chips.add(
          SelectedFilterEntity(
            filterKey: f.filterKey,
            filterValue: i < values.length ? values[i] : names[i],
            selectedFilterName: names[i],
            showOnUi: f.showOnUi,
          ),
        );
      }
    }
    return chips;
  }

  @override
  bool shouldRebuild(covariant _AppliedFiltersPinnedDelegate oldDelegate) =>
      hasVisible != oldDelegate.hasVisible || selectedFilters != oldDelegate.selectedFilters;

  Widget _buildFilterChip(SelectedFilterEntity filter, int index, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: CustomChipWidget(
        key: ValueKey('${PlpTestStrings.appliedFilterChip}_$index'),
        onPressed: onPressed,
        text: filter.selectedFilterName ?? '',
        borderRadius: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        borderColor: AppColors.brandPrimary,
        trailingIcon: const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Icon(Icons.close_rounded, size: 15, color: AppColors.brandPrimary),
        ),
        textStyle: AppTypographyV1.labelMedium.bold.brandPrimary(),
      ),
    );
  }
}
