import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/product_tile.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/listing_product_entity.dart';

class ProductGrid extends StatelessWidget {
  final List<ListingProductEntity> products;
  final bool isLoadingMore;

  const ProductGrid({
    super.key,
    required this.products,
    this.isLoadingMore = false,
  });

  // Per-tile automation keys, flat product index (mirrors `plp_product_sliver`).
  Key _tileKey(int i) => ValueKey('${PlpTestStrings.tile}_$i');
  Key _wishlistKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.wishlistSuffix}');
  Key _nameKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.nameSuffix}');
  Key _priceKey(int i) => ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.priceSuffix}');
  Key _discountKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.discountSuffix}');
  Key _colorVariantsKey(int i) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.colorVariantsSuffix}');
  Key _visualCueKey(int i, int j) =>
      ValueKey('${PlpTestStrings.tile}_${i}_${PlpTestStrings.visualCueSuffix}_$j');

  ProductTile _tile(BuildContext context, ListingProductEntity product, int index) {
    return ProductTile.fromProduct(
      product,
      tileKey: _tileKey(index),
      wishlistKey: _wishlistKey(index),
      nameKey: _nameKey(index),
      priceKey: _priceKey(index),
      discountKey: _discountKey(index),
      colorVariantsKey: _colorVariantsKey(index),
      visualCueKeyBuilder: (j) => _visualCueKey(index, j),
      onTap: () => AppNavigator.goToPdp(context, product.id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rowCount = (products.length / 2).ceil();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final leftIndex = index * 2;
          final rightIndex = leftIndex + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _tile(context, products[leftIndex], leftIndex)),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: rightIndex < products.length
                        ? _tile(context, products[rightIndex], rightIndex)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }, childCount: rowCount),
      ),
    );
  }
}
