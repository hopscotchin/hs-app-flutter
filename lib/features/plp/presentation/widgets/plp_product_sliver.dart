import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/product_tile.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/plp_list_item.dart';
import '../bloc/plp_bloc.dart';
import 'floating_filter_row.dart';

class PlpProductSliver extends StatelessWidget {
  const PlpProductSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, List<PlpListItem>>(
      selector: (state) => state.listItems,
      builder: (context, listItems) => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = listItems[index];
          return switch (item) {
            ProductRowItem(:final left, :final right) => Padding(
              key: ValueKey('row_${left.id}'),
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ProductTile.fromListingProduct(
                      left,
                      onTap: () =>
                          AppNavigator.goToPdp(context, left.id.toString()),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: right != null
                        ? ProductTile.fromListingProduct(
                            right,
                            onTap: () => AppNavigator.goToPdp(
                              context,
                              right.id.toString(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            FloatingFilterItem(:final section) => FloatingFilterRow(
              key: ValueKey('floating_${section.position}_${section.title}'),
              section: section,
              onTileSelected: (key, value) => context.read<PlpBloc>().add(
                ApplyFloatingFilter(key: key, value: value),
              ),
            ),
          };
        }, childCount: listItems.length),
      ),
    );
  }
}
