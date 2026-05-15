import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/sorting_option_entity.dart';
import '../bloc/plp_bloc.dart';
import 'sticky_filter_bar.dart';

typedef _FilterData = ({
  List<SortingOptionEntity> sortingOptions,
  PlpFilterEntity? plpFilter,
  int? orderRule,
  Map<String, String> appliedFilters,
});

class PlpFilterHeader extends StatelessWidget {
  final Map<String, dynamic> baseQueryParams;

  const PlpFilterHeader({super.key, required this.baseQueryParams});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, _FilterData>(
      selector: (state) => (
        sortingOptions: state.sortingOptions,
        plpFilter: state.plpFilter,
        orderRule: state.orderRule,
        appliedFilters: state.appliedFilters,
      ),
      builder: (context, data) => SliverPersistentHeader(
        floating: true,
        delegate: _StickyFilterBarDelegate(
          child: StickyFilterBar(
            sortingOptions: data.sortingOptions,
            plpFilter: data.plpFilter,
            currentOrderRule: data.orderRule,
            appliedFilters: data.appliedFilters,
            baseQueryParams: baseQueryParams,
            onSortApplied: (orderRule) =>
                context.read<PlpBloc>().add(ApplySort(orderRule: orderRule)),
            onFiltersApplied: (filters) => context.read<PlpBloc>().add(
              ApplyMultipleFilters(filters: filters),
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyFilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterBarDelegate({required this.child});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyFilterBarDelegate oldDelegate) =>
      child != oldDelegate.child;
}
