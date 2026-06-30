import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../domain/entities/selected_filter_entity.dart';
import '../bloc/plp_bloc.dart';

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

  static const double _height = 42.0;

  @override
  double get minExtent => hasVisible ? _height : 0.0;

  @override
  double get maxExtent => hasVisible ? _height : 0.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (!hasVisible) return const SizedBox.shrink();
    final visibleFilters = selectedFilters.where((f) => f.showOnUi).toList();
    if (visibleFilters.isEmpty) return const SizedBox.shrink();
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
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
                children: visibleFilters
                    .map(
                      (f) => _buildFilterChip(f, () {
                        context.read<PlpBloc>().add(RemoveFilter(filterToRemove: f));
                      }),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _AppliedFiltersPinnedDelegate oldDelegate) =>
      hasVisible != oldDelegate.hasVisible || selectedFilters != oldDelegate.selectedFilters;

  Widget _buildFilterChip(SelectedFilterEntity filter, Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: CustomChipWidget(
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
