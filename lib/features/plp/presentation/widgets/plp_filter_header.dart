import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/plp_sorting_options_entity.dart';

import '../../domain/entities/plp_filter_entity.dart';
import '../bloc/plp_bloc.dart';
import 'sticky_filter_bar.dart';

typedef _FilterData = ({
  PlpSortingOptionsEntity? sortingOptions,
  PlpFilterEntity? plpFilter,
  Map<String, String> appliedFilters,
  int? currentOrderRule,
});

class PlpFilterHeader extends StatelessWidget {
  final Map<String, dynamic> baseQueryParams;

  const PlpFilterHeader({super.key, required this.baseQueryParams});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, _FilterData>(
      selector: (state) => (
        sortingOptions: state.plpFilter?.sortingOptions,
        plpFilter: state.plpFilter,
        appliedFilters: state.appliedFilters,
        currentOrderRule: state.currentOrderRule,
      ),
      builder: (context, data) {
        // Mirror Android's getBaseParams() — include orderRule whenever it has
        // been seeded from the API response, so the /v2/filter refresh call
        // receives the same base params as the listing API calls.
        final effectiveParams = data.currentOrderRule != null
            ? {...baseQueryParams, 'orderRule': data.currentOrderRule}
            : baseQueryParams;

        return SliverPersistentHeader(
          pinned: true,
          delegate: _StickyFilterBarDelegate(
            child: StickyFilterBar(
              sortingOptions: data.sortingOptions,
              plpFilter: data.plpFilter,
              appliedFilters: data.appliedFilters,
              baseQueryParams: effectiveParams,
              onSortApplied: (orderRule) =>
                  context.read<PlpBloc>().add(ApplySort(orderRule: orderRule)),
              onFiltersApplied: (filters) =>
                  context.read<PlpBloc>().add(ApplyMultipleFilters(filters: filters)),
            ),
          ),
        );
      },
    );
  }
}

class _StickyFilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterBarDelegate({required this.child});

  @override
  double get minExtent => 62;

  @override
  double get maxExtent => 62;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyFilterBarDelegate oldDelegate) => child != oldDelegate.child;
}
