import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/router/app_navigator.dart';

import '../../../../components/atoms/product_tile.dart';
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
                  Expanded(
                    child: ProductTile.fromListingProduct(
                      products[leftIndex],
                      onTap: () => AppNavigator.goToPdp(
                        context,
                        products[leftIndex].id.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: rightIndex < products.length
                        ? ProductTile.fromListingProduct(
                            products[rightIndex],
                            onTap: () => AppNavigator.goToPdp(
                              context,
                              products[rightIndex].id.toString(),
                            ),
                          )
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
