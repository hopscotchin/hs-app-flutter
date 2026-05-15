import 'package:flutter/material.dart';

import '../../core/navigation/action_url_handler.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class CustomTilesWidget extends StatelessWidget {
  final CustomTilesData tilesData;
  final ComponentMargins? margins;

  const CustomTilesWidget({super.key, required this.tilesData, this.margins});

  @override
  Widget build(BuildContext context) {
    final bool hasTitleImage = tilesData.titleImage?.url != null;
    final List<StoreTileDetail> rows = tilesData.tileDetails
        .where((d) => d.tileGrid.isNotEmpty)
        .toList();

    if (!hasTitleImage && rows.isEmpty) return const SizedBox.shrink();

    // Mirrors Android updateItemMargins defaults.
    // Title margins are zeroed by Android when titleImage is null — match that.
    final double horizontalMargin = margins?.horizontal ?? 16;
    final double innerHorizontalMargin = margins?.innerHorizontalMargin ?? 8;
    final double innerVerticalMargin = margins?.innerVerticalMargin ?? 0;
    final double titleHMargin = hasTitleImage
        ? (margins?.titleHorizontalMargin ?? 16)
        : 0.0;
    final double titleBMargin = hasTitleImage
        ? (margins?.titleBottomMargin ?? 16)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTitleImage)
          _buildTitleImage(context, titleHMargin, titleBMargin),
        if (rows.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  // SizedBox only between rows — not before first or after last.
                  if (i > 0 && innerVerticalMargin > 0)
                    SizedBox(height: innerVerticalMargin),
                  _buildRow(context, rows[i].tileGrid, innerHorizontalMargin),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTitleImage(
    BuildContext context,
    double titleHMargin,
    double titleBMargin,
  ) {
    final TitleImageData titleImage = tilesData.titleImage!;
    final String url = titleImage.url!;

    // Mirror Android: compute height from aspect ratio when dimensions are available.
    // Falls back to intrinsic sizing (double.infinity width, no explicit height).
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

  Widget _buildRow(
    BuildContext context,
    List<TileImage> tiles,
    double innerHorizontalMargin,
  ) {
    if (tiles.length == 1) return _buildTile(context, tiles.first);

    return Row(
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          // SizedBox only between tiles — no edge padding against the outer margin.
          if (i > 0) SizedBox(width: innerHorizontalMargin),
          Expanded(child: _buildTile(context, tiles[i])),
        ],
      ],
    );
  }

  Widget _buildTile(BuildContext context, TileImage tile) {
    final double aspectRatio =
        (tile.width != null && tile.height != null && tile.height! > 0)
        ? tile.width! / tile.height!
        : 1.0;
    return GestureDetector(
      onTap: () => ActionUrlHandler.navigate(context, tile.actionUri),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedImageWidget(
          imageUrl: tile.imageUrl ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
