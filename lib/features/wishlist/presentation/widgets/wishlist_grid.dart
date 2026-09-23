import 'package:flutter/material.dart';

import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/entities/wishlist_product_entity.dart';
import 'wishlist_product_tile.dart';

/// Two-column wishlist grid, mirroring the PLP `ProductGrid` layout: a
/// [SliverList] of two-tile rows kept equal-height via [IntrinsicHeight].
class WishlistGrid extends StatelessWidget {
  final List<WishlistProductEntity> items;
  final void Function(WishlistProductEntity item) onDelete;
  final void Function(WishlistProductEntity item) onMoveToBag;

  const WishlistGrid({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onMoveToBag,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = (items.length / 2).ceil();
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
                  Expanded(child: _tile(context, items[leftIndex], leftIndex)),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: rightIndex < items.length
                        ? _tile(context, items[rightIndex], rightIndex)
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

  Widget _tile(BuildContext context, WishlistProductEntity item, int index) {
    return WishlistProductTile(
      index: index,
      item: item,
      onTap: () => AppNavigator.goToPdp(context, item.id.toString()),
      onDelete: () => onDelete(item),
      onMoveToBag: () => onMoveToBag(item),
    );
  }
}
