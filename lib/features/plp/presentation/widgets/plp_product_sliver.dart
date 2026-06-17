import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/product_tile.dart';

import '../../../../components/atoms/xl_tile_widget.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/services/pref_manager.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../bloc/plp_bloc.dart';
import 'floating_filter_row.dart';

class PlpProductSliver extends StatelessWidget {
  const PlpProductSliver({super.key});

  Widget _buildProductRow(
    BuildContext context,
    ListingProductEntity left,
    ListingProductEntity? right,
  ) {
    final hasCPT = left.isCPT || right?.isCPT == true;
    final row = Row(
      crossAxisAlignment: hasCPT ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      children: [
        Expanded(child: _tile(context, left, hasCPT)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: right == null ? const SizedBox.shrink() : _tile(context, right, hasCPT)),
      ],
    );
    return hasCPT ? IntrinsicHeight(child: row) : row;
  }

  Widget _tile(BuildContext context, ListingProductEntity product, bool hasCPT) {
    return ProductTile.fromListingProduct(
      hasCPT: hasCPT,
      product,
      onTap: () {
        if (product.isCPT) {
          ActionUrlHandler.navigate(context, product.actionUri, title: product.name);
        } else {
          AppNavigator.goToPdp(context, product.id.toString());
        }
      },
      onWishlistTap: () => _onWishlistTap(context, product),
    );
  }

  Future<void> _onWishlistTap(BuildContext context, ListingProductEntity product) async {
    if (!sl<PrefManager>().isLoggedIn) {
      final loggedIn = await AppNavigator.showMobileLoginFlow(context);
      if (!loggedIn || !context.mounted) return;
    }
    if (!context.mounted) return;
    context.read<PlpBloc>().add(ToggleWishlistOnProduct(product: product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, List<PlpListItem>>(
      selector: (state) => state.listItems,
      builder: (context, listItems) => SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = listItems[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: switch (item) {
              ProductRowItem(:final left, :final right) => Padding(
                key: ValueKey('row_${left.id}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: _buildProductRow(context, left, right),
              ),
              ProductXLItem(:final product) => Padding(
                key: ValueKey('xl_${product.id}'),
                padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 0, right: 12, left: 12),
                child: XLTileWidget.fromListingProduct(
                  product,
                  onTap: () => AppNavigator.goToPdp(context, product.id.toString()),
                  onWishlistTap: () => _onWishlistTap(context, product),
                  onAddToCartTap: () {},
                ),
              ),
              FloatingFilterItem(:final section) => FloatingFilterRow(
                key: ValueKey('floating_${section.position}_${section.title}'),
                section: section,
                onFiltersApplied: (key, value) =>
                    context.read<PlpBloc>().add(ApplyFloatingFilter(key: key, value: value)),
              ),
            },
          );
        }, childCount: listItems.length),
      ),
    );
  }
}
