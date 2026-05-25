import 'package:flutter/material.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';

import '../../core/constants/strings/discover_strings.dart';
import '../../core/navigation/action_url_handler.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';
import '../atoms/cta_button_component.dart';

class CustomTilesWidget extends StatelessWidget {
  final CustomTilesData tilesData;
  final ComponentMargins? margins;

  const CustomTilesWidget({super.key, required this.tilesData, this.margins});

  @override
  Widget build(BuildContext context) {
    // Split out title-row tiles (isTitleItem=true) and content rows.
    final List<CustomTilesTile> titleRows = <CustomTilesTile>[];
    final List<CustomTilesTile> contentRows = <CustomTilesTile>[];
    for (final tile in tilesData.tiles) {
      if (tile.tileGrid.isEmpty) continue;
      (tile.isTitleRow ? titleRows : contentRows).add(tile);
    }

    final TitleImage? titleImage = tilesData.title;
    final TileGridItem? titleRowImage =
        titleRows.isNotEmpty ? titleRows.first.tileGrid.first : null;
    final bool hasTitle = titleImage?.url != null || titleRowImage != null;

    if (!hasTitle && contentRows.isEmpty && tilesData.ctaButton == null) {
      return const SizedBox.shrink();
    }

    final double horizontalMargin = margins?.horizontal ?? 16;
    final double innerHorizontalMargin = margins?.innerHorizontalMargin ?? 8;
    final double innerVerticalMargin = margins?.innerVerticalMargin ?? 0;
    final double titleHMargin = hasTitle
        ? (margins?.titleHorizontalMargin ?? 16)
        : 0.0;
    final double titleBMargin = hasTitle
        ? (margins?.titleBottomMargin ?? 16)
        : 0.0;
    // viewConfig.imageCornerRadius (defaults to 4 when not supplied by API).
    final double imageCornerRadius =
        tilesData.viewConfig?.imageCornerRadius ?? 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleImage?.url != null)
          _buildTitleFromTitleImage(titleImage!, titleHMargin, titleBMargin),
        if (titleImage?.url == null && titleRowImage != null)
          _buildTitleFromGridItem(
            titleRowImage,
            titleHMargin,
            titleBMargin,
          ),
        if (contentRows.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < contentRows.length; i++) ...[
                  if (i > 0 && innerVerticalMargin > 0)
                    SizedBox(height: innerVerticalMargin),
                  _buildRow(
                    context,
                    contentRows[i].tileGrid,
                    innerHorizontalMargin,
                    imageCornerRadius,
                  ),
                ],
              ],
            ),
          ),
        if (tilesData.ctaButton != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
            ),
            child: Center(
              child: CtaButtonComponent(
                label: tilesData.ctaButton!.label ?? DiscoverStrings.viewAll,
                style: CtaButtonStyle.fromString(tilesData.ctaButton!.type),
                onPressed: () => ActionUrlHandler.navigate(
                  context,
                  tilesData.ctaButton!.actionUri,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleFromTitleImage(
    TitleImage titleImage,
    double titleHMargin,
    double titleBMargin,
  ) {
    final String url = titleImage.url!;
    final bool hasDimensions =
        (titleImage.width ?? 0) > 0 && (titleImage.height ?? 0) > 0;

    return Padding(
      padding: EdgeInsets.only(
        left: titleHMargin,
        right: titleHMargin,
        bottom: titleBMargin,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (hasDimensions) {
            final double availableWidth = constraints.maxWidth;
            final double aspectRatio = titleImage.width! / titleImage.height!;
            return CachedImageWidget(
              imageUrl: url,
              width: availableWidth,
              height: availableWidth / aspectRatio,
              fit: BoxFit.cover,
            );
          }
          return CachedImageWidget(
            imageUrl: url,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildTitleFromGridItem(
    TileGridItem item,
    double titleHMargin,
    double titleBMargin,
  ) {
    final String url = item.imageUrl ?? '';
    if (url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(
        left: titleHMargin,
        right: titleHMargin,
        bottom: titleBMargin,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          final double aspectRatio = item.aspectRatio;
          return CachedImageWidget(
            imageUrl: url,
            width: availableWidth,
            height: aspectRatio > 0 ? availableWidth / aspectRatio : null,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<TileGridItem> tiles,
    double innerHorizontalMargin,
    double imageCornerRadius,
  ) {
    if (tiles.length == 1) {
      return _buildTile(context, tiles.first, imageCornerRadius);
    }

    return Row(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(width: innerHorizontalMargin),
          Expanded(child: _buildTile(context, tiles[i], imageCornerRadius)),
        ],
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    TileGridItem tile,
    double imageCornerRadius,
  ) {
    final Widget image = AspectRatio(
      aspectRatio: tile.aspectRatio,
      child: CachedImageWidget(
        imageUrl: tile.imageUrl ?? '',
        fit: BoxFit.cover,
      ),
    );
    return GestureDetector(
      onTap: () => ActionUrlHandler.navigate(context, tile.actionUri),
      child: imageCornerRadius > 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(imageCornerRadius),
              child: image,
            )
          : image,
    );
  }
}

