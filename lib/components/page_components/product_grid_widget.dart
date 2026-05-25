import 'package:flutter/material.dart';

import '../../core/constants/strings/discover_strings.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
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

    final columns = gridData.layoutInfo?.columns ?? 2;
    final horizontalMargin = margins?.horizontal ?? 16;
    final innerHMargin = margins?.innerHorizontalMargin ?? 0;
    final innerVMargin = margins?.innerVerticalMargin ?? 8;
    final titleHMargin = margins?.titleHorizontalMargin ?? 0;
    final titleBMargin = margins?.titleBottomMargin ?? 0;
    final ctaTop = margins?.ctaTopMargin ?? 0;
    final ctaHMargin = margins?.ctaHorizontalMargin ?? 0;

    final rows = _chunk(gridData.tiles, columns);

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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: Column(
            children: [
              for (final row in rows)
                Padding(
                  padding: EdgeInsets.only(bottom: innerVMargin),
                  child: _buildProductRow(context, row, columns, innerHMargin),
                ),
            ],
          ),
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

  List<List<HomepageProduct>> _chunk(
    List<HomepageProduct> items,
    int columns,
  ) {
    if (columns <= 0) return [items];
    final out = <List<HomepageProduct>>[];
    for (int i = 0; i < items.length; i += columns) {
      out.add(
        items.sublist(i, i + columns > items.length ? items.length : i + columns),
      );
    }
    return out;
  }

  Widget _buildProductRow(
    BuildContext context,
    List<HomepageProduct> row,
    int columns,
    double gap,
  ) {
    if (row.isEmpty) return const SizedBox.shrink();

    return Row(
      children: List.generate(columns, (index) {
        if (index >= row.length) {
          return const Expanded(child: SizedBox.shrink());
        }
        final item = row[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: index > 0 ? gap : 0),
            child: _buildProductCard(context, item),
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(BuildContext context, HomepageProduct item) {
    final showInfo = gridData.layoutInfo?.showProductInfo ?? true;
    return ProductTile.fromGridItem(
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
