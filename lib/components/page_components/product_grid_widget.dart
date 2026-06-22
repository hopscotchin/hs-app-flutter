import 'package:flutter/material.dart';

import '../../core/constants/strings/discover_strings.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/spacing.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../../features/plp/domain/entities/listing_product_entity.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/cta_button_component.dart';
import '../atoms/product_tile.dart';

class ProductGridWidget extends StatelessWidget {
  final ProductGridData gridData;
  final ComponentMargins? margins;

  const ProductGridWidget({super.key, required this.gridData, this.margins});

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
            padding: EdgeInsets.only(
              left: titleHMargin,
              right: titleHMargin,
              bottom: titleBMargin,
            ),
            child: CachedImageWidget(
              imageUrl: gridData.title!.url!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        for (int row = 0; row < rowCount; row++)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: _buildProductRow(context, tiles, row * columns, columns),
          ),
        if (gridData.ctaButton != null)
          Padding(
            padding: EdgeInsets.only(
              top: ctaTop,
              left: ctaHMargin,
              right: ctaHMargin,
            ),
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
                ? _buildProductCard(context, tiles[startIndex + i])
                : const SizedBox.shrink(),
          ),
        ],
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ListingProductEntity item) {
    final showInfo = gridData.layoutInfo?.showProductInfo ?? true;
    return ProductTile.fromProduct(
      item,
      showProductInfo: showInfo,
      onTap: () =>
          ActionUrlHandler.navigate(context, item.actionUri, title: item.name),
    );
  }

  Widget _buildCta(BuildContext context, CtaButton cta) {
    return Center(
      child: CtaButtonComponent(
        label: cta.label ?? DiscoverStrings.viewAll,
        style: CtaButtonStyle.fromString(cta.type),
        onPressed: () => ActionUrlHandler.navigate(context, cta.actionUri),
      ),
    );
  }
}
