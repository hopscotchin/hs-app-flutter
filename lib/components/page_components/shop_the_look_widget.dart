import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';

import '../../core/constants/strings/discover_strings.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/strikethrough_text.dart';
import 'shop_the_look_bottom_sheet.dart';

class ShopTheLookWidget extends StatelessWidget {
  final ShopTheLookData data;
  final ComponentMargins? margins;
  final void Function(List<ShopTheLookSelection>)? onAddToCart;

  const ShopTheLookWidget({super.key, required this.data, this.margins, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final List<ShopTheLookTile> items = data.tiles;
    if (items.isEmpty) return const SizedBox.shrink();

    final double screenWidth = MediaQuery.sizeOf(context).width;

    // Mirrors Android StyleCarouselView.updateItemMargins defaults.
    // titleMargins zeroed when titleImage is null — match that.
    final double horizontalMargin = margins?.horizontal ?? 16;
    final double innerHorizontalMargin = margins?.innerHorizontalMargin ?? 8;
    final double titleBMargin = data.title != null ? (margins?.titleBottomMargin ?? 0) : 0.0;
    final double titleHMargin = data.title != null ? (margins?.titleHorizontalMargin ?? 16) : 0.0;

    final int minTiles = data.viewConfig?.minTilesToShow ?? 1;
    final int peepingFactor = data.viewConfig?.peepingFactor ?? 0;

    // Mirrors Android StyleCarouselView.calculateCarouselHeight()
    final double availableWidth =
        screenWidth -
        (peepingFactor > 0 ? horizontalMargin : horizontalMargin * 2) -
        (minTiles == 1
            ? (peepingFactor > 0 ? innerHorizontalMargin : 0)
            : (minTiles - 1) * innerHorizontalMargin);

    final double tileWidth = availableWidth * 100 / ((minTiles * 100) + peepingFactor);

    // Card height calculation:
    // Content width = tileWidth - 2dp border (each side) - 8dp padding (each side) - 6dp col gap
    // = tileWidth - 24. colWidth = (tileWidth - 24) / 2.
    // Grid height: both columns have equal total AR = 1.65 + 1.35 = 3.0, plus 4dp row gap.
    final double colWidth = (tileWidth - 24) / 2;
    final double gridHeight = colWidth * 3.0 + 4;
    const double priceSectionHeight = 70.0;
    const double dividerAndMargin = 9.0;
    const double cardPaddingVertical = 16.0;
    final double cardHeight =
        cardPaddingVertical + gridHeight + dividerAndMargin + priceSectionHeight;

    final Widget carousel = SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: innerHorizontalMargin),
        itemBuilder: (BuildContext context, int index) {
          return _ShopTheLookCard(
            item: items[index],
            tileWidth: tileWidth,
            onProductTap: (ShopTheLookProduct p) => ActionUrlHandler.navigate(context, p.actionUri),
            onAddToCart: () => _showBottomSheet(context, items[index]),
          );
        },
      ),
    );

    if (data.title?.url == null) return carousel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titleHMargin, right: titleHMargin, bottom: titleBMargin),
          child: CachedImageWidget(
            imageUrl: data.title!.url!,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        carousel,
      ],
    );
  }

  void _showBottomSheet(BuildContext context, ShopTheLookTile item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => ShopTheLookBottomSheet(item: item, onAddToCart: onAddToCart),
    );
  }
}

class _ShopTheLookCard extends StatelessWidget {
  final ShopTheLookTile item;
  final double tileWidth;
  final void Function(ShopTheLookProduct) onProductTap;
  final VoidCallback onAddToCart;

  const _ShopTheLookCard({
    required this.item,
    required this.tileWidth,
    required this.onProductTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final List<ShopTheLookProduct> tiles = item.productTiles;
    if (tiles.length < 4) return SizedBox(width: tileWidth);

    return Container(
      width: tileWidth,
      decoration: BoxDecoration(
        color: AppColors.baseDefault,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dividerLight),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 2×2 product grid — cross aspect ratios mirror item_style_carousel.xml.
          // Left column: 1:1.65 (tall) on top, 1:1.35 (short) on bottom.
          // Right column: 1:1.35 (short) on top, 1:1.65 (tall) on bottom.
          // Expanded ensures each column fills exactly half the available width,
          // accounting for the 1dp border so there is no overflow.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildColumn(tiles[0], tiles[2], [1 / 1.65, 1 / 1.35])),
              const SizedBox(width: 6),
              Expanded(child: _buildColumn(tiles[1], tiles[3], [1 / 1.35, 1 / 1.65])),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
          _buildPriceSection(),
        ],
      ),
    );
  }

  Widget _buildColumn(
    ShopTheLookProduct top,
    ShopTheLookProduct bottom,
    List<double> aspectRatios,
  ) {
    return Column(
      children: [
        _buildTileImage(top, aspectRatios[0]),
        const SizedBox(height: 4),
        _buildTileImage(bottom, aspectRatios[1]),
      ],
    );
  }

  Widget _buildTileImage(ShopTheLookProduct product, double aspectRatio) {
    final bool isOos = product.hasInv == false;
    return GestureDetector(
      onTap: isOos ? null : () => onProductTap(product),
      child: Stack(
        children: [
          Opacity(
            opacity: isOos ? 0.4 : 1.0,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CachedImageWidget(
                imageUrl: product.imageUrl ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isOos)
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.neutralGrey5,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  DiscoverStrings.outOfStock,
                  style: AppTypographyV1.caption.semiBold.copyWith(color: AppColors.baseDefault),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final ShopTheLookPrice? price = item.price;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DiscoverStrings.totalPriceForItems(4),
                  style: AppTypographyV1.bodySmall.semiBold,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (price?.displayValue != null)
                      Text(price?.displayValue ?? '', style: AppTypographyV1.labelLarge.bold),
                    if (price?.mrp.isNotNullOrEmpty ?? false) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: StrikethroughText(
                          price?.mrp ?? '',
                          style: AppTypographyV1.labelLarge.regular.textTertiary(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (price?.discount != null && price!.discount!.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '(${price.discount})',
                          style: AppTypographyV1.labelLarge.regular.success(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: OutlinedButton(
            onPressed: onAddToCart,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.brandDefault),
              foregroundColor: AppColors.brandDefault,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: AppTypographyV1.labelMedium.bold,
            ),
            child: const Text(DiscoverStrings.addToBag),
          ),
        ),
      ],
    );
  }
}
