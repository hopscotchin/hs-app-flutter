import 'package:flutter/material.dart';

import '../../core/navigation/action_url_handler.dart';
import '../../core/theme/colors.dart';
import '../../features/discover/domain/entities/home_page_entity.dart';
import '../atoms/cached_image_widget.dart';

class ContinueBrowsingWidget extends StatelessWidget {
  final ContinueBrowsingData data;
  final ComponentMargins? margins;

  const ContinueBrowsingWidget({super.key, required this.data, this.margins});

  // Mirrors Android: minTiles=1, peepingFactor=50 → parts=15 → item takes 10/15 of availableWidth.
  static const int _parts = 15;

  static const double _cardPadding = 8.0;
  static const double _imageGap = 4.0;
  static const double _cardRadius = 12.0;
  static const double _titleFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    if (data.items.isEmpty) return const SizedBox.shrink();

    final double screenWidth = MediaQuery.sizeOf(context).width;

    final double horizontalMargin = margins?.horizontal ?? 16;
    final double innerHorizontalMargin = margins?.innerHorizontalMargin ?? 8;
    final double titleBottomMargin = margins?.titleBottomMargin ?? 16;
    final double titleHorizontalMargin = margins?.titleHorizontalMargin ?? 16;

    // Mirrors Android getCarouselWidth: one-sided outer margin because right side shows peeking item.
    final double availableWidth =
        screenWidth - horizontalMargin - innerHorizontalMargin;
    final double itemWidth = availableWidth * 10 / _parts;

    // Images fill the card minus card padding on each side and the gap between them.
    final double imageWidth = (itemWidth - _cardPadding * 2 - _imageGap) / 2;
    final double imageHeight =
        imageWidth / (data.viewConfig?.imageAspectRatio ?? (3 / 4));

    final Widget carousel = ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      itemCount: data.items.length,
      separatorBuilder: (_, _) => SizedBox(width: innerHorizontalMargin),
      itemBuilder: (BuildContext context, int index) => _buildCard(
        context,
        data.items[index],
        itemWidth,
        imageWidth,
        imageHeight,
      ),
    );

    if (data.heading?.url == null) {
      return SizedBox(
        height: _cardHeight(imageHeight, data.items),
        child: carousel,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: titleHorizontalMargin,
            right: titleHorizontalMargin,
            bottom: titleBottomMargin,
          ),
          child: CachedImageWidget(
            imageUrl: data.heading!.url!,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: _cardHeight(imageHeight, data.items), child: carousel),
      ],
    );
  }

  // Card height = top padding + title (if any) + images + bottom padding + 2×border.
  double _cardHeight(double imageHeight, List<ContinueBrowsingItem> items) {
    final bool hasTitle = items.any((item) => item.heading != null);
    final double titleArea = hasTitle
        ? (_titleFontSize * 1.43 + _cardPadding * 2)
        : 0;
    return titleArea +
        imageHeight +
        _cardPadding * 2 +
        2; // +2 for border strokes
  }

  Widget _buildCard(
    BuildContext context,
    ContinueBrowsingItem item,
    double itemWidth,
    double imageWidth,
    double imageHeight,
  ) {
    return GestureDetector(
      onTap: () => ActionUrlHandler.navigate(context, item.actionUri),
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.secondaryInActive, width: 1),
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.heading != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _cardPadding,
                  vertical: _cardPadding,
                ),
                child: Text(
                  item.heading!,
                  style: const TextStyle(
                    fontSize: _titleFontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: _cardPadding,
                right: _cardPadding,
                bottom: _cardPadding,
              ),
              child: Row(
                children: [
                  _buildImage(
                    item.media.elementAtOrNull(0),
                    imageWidth,
                    imageHeight,
                  ),
                  const SizedBox(width: _imageGap),
                  _buildImage(
                    item.media.elementAtOrNull(1),
                    imageWidth,
                    imageHeight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? url, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutralGrey2, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: CachedImageWidget(
          imageUrl: url ?? '',
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
