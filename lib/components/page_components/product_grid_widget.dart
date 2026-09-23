import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/analytics/home/home_component_click_handlers.dart';
import '../../core/analytics/home/home_track_analytic_manager.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../core/constants/strings/discover_strings.dart';
import '../../core/constants/strings/login_redirects.dart';
import '../../core/entities/message_bar_entity.dart';
import '../../core/di/injection.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/spacing.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../../features/plp/domain/entities/listing_product_entity.dart';
import '../../features/wishlist/presentation/widgets/wishlist_status_builder.dart';
import '../../features/wishlist/presentation/wishlist_actions.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/cta_button_component.dart';
import '../atoms/product_tile.dart';

class ProductGridWidget extends StatelessWidget {
  final ProductGridData gridData;
  final ComponentMargins? margins;

  /// Component-level automation key prefix, e.g. `hp_pg_2`. Null → unkeyed.
  final String? keyPrefix;

  const ProductGridWidget({
    super.key,
    required this.gridData,
    this.margins,
    this.keyPrefix,
  });

  Key? _key(String suffix) =>
      keyPrefix == null ? null : ValueKey('${keyPrefix}_$suffix');

  /// Sub-element key nested under tile `index` → `<prefix>_tiles_<i>_<suffix>`.
  Key? _tileSubKey(int index, String suffix) =>
      _key('${HomeComponentTestStrings.tiles}_${index}_$suffix');

  @override
  Widget build(BuildContext context) {
    if (gridData.tiles.isEmpty) return const SizedBox.shrink();

    final titleHMargin = margins?.titleHorizontalMargin ?? 0;
    final titleBMargin = margins?.titleBottomMargin ?? 0;
    final ctaTop = margins?.ctaTopMargin ?? 0;
    final ctaHMargin = margins?.ctaHorizontalMargin ?? 0;

    final tiles = gridData.tiles;
    final columns = gridData.layoutInfo?.columns ?? 2;
    final rowCount = (tiles.length / columns).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (gridData.title?.url != null)
          Padding(
            padding: EdgeInsets.only(left: titleHMargin, right: titleHMargin, bottom: titleBMargin),
            child: CachedImageWidget(
              key: _key(HomeComponentTestStrings.title),
              imageUrl: gridData.title!.url!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        for (int row = 0; row < rowCount; row++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
            child: _buildProductRow(context, tiles, row * columns, columns),
          ),
        if (gridData.ctaButton != null)
          Padding(
            padding: EdgeInsets.only(top: ctaTop, left: ctaHMargin, right: ctaHMargin),
            child: _buildCta(context, gridData.ctaButton!),
          ),
      ],
    );
  }

  Widget _buildProductRow(
    BuildContext context,
    List<ListingProductEntity> tiles,
    int startIndex,
    int columns,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < columns; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: startIndex + i < tiles.length
                ? _buildProductCard(context, tiles[startIndex + i], startIndex + i)
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ListingProductEntity item, int index) {
    final showInfo = gridData.layoutInfo?.showProductInfo ?? true;
    return WishlistStatusBuilder(
      product: item,
      builder: (context, wished) => ProductTile.fromProduct(
        item,
        key: _key('${HomeComponentTestStrings.tiles}_$index'),
        wishlistKey: _tileSubKey(index, HomeComponentTestStrings.tileWishlistSuffix),
        nameKey: _tileSubKey(index, HomeComponentTestStrings.tileNameSuffix),
        priceKey: _tileSubKey(index, HomeComponentTestStrings.tilePriceSuffix),
        discountKey: _tileSubKey(index, HomeComponentTestStrings.tileDiscountSuffix),
        colorVariantsKey: _tileSubKey(index, HomeComponentTestStrings.tileColorVariantsSuffix),
        visualCueKeyBuilder: (j) =>
            _tileSubKey(index, '${HomeComponentTestStrings.tileVisualCueSuffix}_$j'),
        showProductInfo: showInfo,
        isWishlisted: wished,
        onTap: () {
          unawaited(sl<HomeTrackAnalyticManager>()
              .onProductGridTileTapped(gridData, item));
          ActionUrlHandler.navigate(context, item.actionUri, title: item.name);
        },
        onWishlistTap: () => WishlistActions.toggle(
          context,
          productId: item.id.toString(),
          price: WishlistActions.priceToInt(item.price?.sellingPrice),
          loggedOutMessageBars: const [
            MessageBarEntity(
              text: LoginRedirects.redirectAddToWishlist,
              type: 'info',
              hasIcon: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCta(BuildContext context, CtaButton cta) {
    return Center(
      child: CtaButtonComponent(
        key: _key(HomeComponentTestStrings.cta),
        label: cta.label ?? DiscoverStrings.viewAll,
        style: CtaButtonStyle.fromString(cta.type),
        onPressed: () => ActionUrlHandler.navigate(context, cta.actionUri),
      ),
    );
  }
}
