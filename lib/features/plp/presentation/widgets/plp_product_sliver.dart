import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/product_tile.dart';

import '../../../../components/atoms/xl_tile_widget.dart';
import '../../../../core/navigation/action_url_handler.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/spacing.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/wishlist_actions.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/plp_list_item.dart';
import '../bloc/plp_bloc.dart';
import 'floating_filter_row.dart';

class PlpProductSliver extends StatelessWidget {
  final Key? sliverKey;

  const PlpProductSliver({super.key, this.sliverKey});

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
    final id = product.id.toString();
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (s) => s.isWishlisted(id),
      builder: (context, wished) => ProductTile.fromProduct(
        product,
        hasCPT: hasCPT,
        isWishlisted: wished,
        onTap: () {
          if (product.isCPT) {
            ActionUrlHandler.navigate(context, product.actionUri, title: product.name);
          } else {
            AppNavigator.goToPdp(context, id);
          }
        },
        onWishlistTap: () => _toggleWishlist(context, product),
      ),
    );
  }

  void _toggleWishlist(BuildContext context, ListingProductEntity product) {
    WishlistActions.toggle(
      context,
      productId: product.id.toString(),
      price: WishlistActions.priceToInt(product.price?.sellingPrice),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlpBloc, PlpState, (List<PlpListItem>, Map<String, String>)>(
      selector: (state) => (state.listItems, state.appliedFilters),
      builder: (context, plp) => SliverList(
        key: sliverKey,
        delegate: SliverChildBuilderDelegate(addSemanticIndexes: false, (context, index) {
          final item = plp.$1[index];
          final appliedFilters = plp.$2;
          return Padding(
            padding: EdgeInsets.only(top: index == 0 && appliedFilters.isNotEmpty ? 0 : 8),
            child: switch (item) {
              ProductRowItem(:final left, :final right) => Padding(
                key: ValueKey('row_${left.id}'),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  index == 0 && appliedFilters.isNotEmpty ? 0 : AppSpacing.xs,
                  AppSpacing.sm,
                  AppSpacing.xs,
                ),

                child: _buildProductRow(context, left, right),
              ),
              ProductXLItem(:final product) => Padding(
                key: ValueKey('xl_${product.id}'),
                padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: 0, right: 12, left: 12),
                child: BlocSelector<WishlistCubit, WishlistState, bool>(
                  selector: (s) => s.isWishlisted(product.id.toString()),
                  builder: (context, wished) => XLTileWidget.fromListingProduct(
                    product,
                    isWishlisted: wished,
                    onTap: () => AppNavigator.goToPdp(context, product.id.toString()),
                    onWishlistTap: () => _toggleWishlist(context, product),
                    onAddToCartTap: () {},
                  ),
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
        }, childCount: plp.$1.length),
      ),
    );
  }
}
