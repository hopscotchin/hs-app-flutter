import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/selected_filter_entity.dart';
import '../bloc/plp_bloc.dart';
import 'applied_filters_bar.dart';

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

  _AppliedFiltersPinnedDelegate({
    required this.selectedFilters,
    required this.hasVisible,
  });

  // Must match AppliedFiltersBar's Container height (44).
  static const double _height = 44.0;

  @override
  double get minExtent => hasVisible ? _height : 0.0;

  @override
  double get maxExtent => hasVisible ? _height : 0.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    if (!hasVisible) return const SizedBox.shrink();
    return Material(
      // Elevation cue when the bar is pinned over scrolling content.
      elevation: overlapsContent ? 2 : 0,
      color: Colors.white,
      child: AppliedFiltersBar(
        selectedFilters: selectedFilters,
        onRemove: (filter) =>
            context.read<PlpBloc>().add(RemoveFilter(filterToRemove: filter)),
        onClearAll: () => context.read<PlpBloc>().add(const ClearAllFilters()),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _AppliedFiltersPinnedDelegate oldDelegate) =>
      hasVisible != oldDelegate.hasVisible ||
      selectedFilters != oldDelegate.selectedFilters;
}
