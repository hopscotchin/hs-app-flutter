import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/product_tile.dart';

import '../../../../components/atoms/xl_tile_widget.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
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

  /// Main tap key for the product at flat index [i] → `plp_tile_<i>`.
  Key _tileKey(int i) => ValueKey('${PlpTestStrings.tile}_$i');

  /// Wishlist key nested under the tile → `plp_tile_<i>_wishlist`.
  Key _wishlistKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.wishlistSuffix}');

  /// Visual-cue key nested under the tile → `plp_tile_<i>_visual_cue_<j>`.
  Key _visualCueKey(int i, int j) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.visualCueSuffix}_$j');

  /// Info-section keys nested under the tile.
  Key _nameKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.nameSuffix}');
  Key _priceKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.priceSuffix}');
  Key _discountKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.discountSuffix}');
  Key _colorVariantsKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.colorVariantsSuffix}');

  Widget _buildProductRow(
    BuildContext context,
    ListingProductEntity left,
    ListingProductEntity? right,
    int startIndex,
  ) {
    final hasCPT = left.isCPT || right?.isCPT == true;
    final row = Row(
      crossAxisAlignment: hasCPT ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
      children: [
        Expanded(child: _tile(context, left, hasCPT, startIndex)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: right == null
              ? const SizedBox.shrink()
              : _tile(context, right, hasCPT, startIndex + 1),
        ),
      ],
    );
    return hasCPT ? IntrinsicHeight(child: row) : row;
  }

  Widget _tile(BuildContext context, ListingProductEntity product, bool hasCPT, int index) {
    final id = product.id.toString();
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (s) => s.isWishlisted(id),
      builder: (context, wished) => ProductTile.fromProduct(
        product,
        hasCPT: hasCPT,
        isWishlisted: wished,
        tileKey: _tileKey(index),
        wishlistKey: _wishlistKey(index),
        visualCueKeyBuilder: (j) => _visualCueKey(index, j),
        nameKey: _nameKey(index),
        priceKey: _priceKey(index),
        discountKey: _discountKey(index),
        colorVariantsKey: _colorVariantsKey(index),
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
      builder: (context, plp) {
        final listItems = plp.$1;
        final appliedFilters = plp.$2;
        // Flat product index per list item — rows contribute 1-2 products, XL
        // one, floating filters none. Precomputed once so per-tile keys stay
        // stable (`plp_tile_<i>`) without an O(n²) scan in the item builder.
        final productStarts = <int>[];
        var running = 0;
        for (final it in listItems) {
          productStarts.add(running);
          running += switch (it) {
            ProductRowItem(:final right) => right == null ? 1 : 2,
            ProductXLItem() => 1,
            _ => 0,
          };
        }
        return SliverList(
          key: sliverKey,
          delegate: SliverChildBuilderDelegate(addSemanticIndexes: false, (context, index) {
            final item = listItems[index];
            final productStart = productStarts[index];
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

                  child: _buildProductRow(context, left, right, productStart),
                ),
                ProductXLItem(:final product) => Padding(
                  key: ValueKey('xl_${product.id}'),
                  padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: 0, right: 12, left: 12),
                  child: BlocSelector<WishlistCubit, WishlistState, bool>(
                    selector: (s) => s.isWishlisted(product.id.toString()),
                    builder: (context, wished) => XLTileWidget.fromListingProduct(
                      product,
                      isWishlisted: wished,
                      tileKey: _tileKey(productStart),
                      wishlistKey: _wishlistKey(productStart),
                      visualCueKeyBuilder: (j) => _visualCueKey(productStart, j),
                      nameKey: _nameKey(productStart),
                      priceKey: _priceKey(productStart),
                      discountKey: _discountKey(productStart),
                      colorVariantsKey: _colorVariantsKey(productStart),
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
          }, childCount: listItems.length),
        );
      },
    );
  }
}
