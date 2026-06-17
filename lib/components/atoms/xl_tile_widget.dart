import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/cached_image_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/entities/visual_cue_entity.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

class XLTileWidget extends StatefulWidget {
  final ListingProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;
  final VoidCallback? onAddToCartTap;

  /// Analytics callback — position is 1-based, direction is "L" or "R"
  final void Function(int position, String direction)? onImageScrolled;

  const XLTileWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlistTap,
    this.onAddToCartTap,
    this.onImageScrolled,
  });

  factory XLTileWidget.fromListingProduct(
    ListingProductEntity product, {
    Key? key,
    required VoidCallback onTap,
    required VoidCallback onWishlistTap,
    VoidCallback? onAddToCartTap,
    void Function(int position, String direction)? onImageScrolled,
  }) {
    return XLTileWidget(
      key: key,
      product: product,
      onTap: onTap,
      onWishlistTap: onWishlistTap,
      onAddToCartTap: onAddToCartTap,
      onImageScrolled: onImageScrolled,
    );
  }

  @override
  State<XLTileWidget> createState() => _XLTileWidgetState();
}

class _XLTileWidgetState extends State<XLTileWidget> {
  final PageController _pageController = PageController();
  final _currentPage = ValueNotifier<int>(0);
  int _previousPage = 0;

  bool get _hasMultipleImages => widget.product.imageUrls.length > 1;

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageSection(screenWidth), _buildInfoSection()],
      ),
    );
  }

  // ── Image section ─────────────────────────────────────────────────────────

  Widget _buildImageSection(double screenWidth) {
    return SizedBox(
      width: screenWidth,
      child: AspectRatio(
        aspectRatio: 3 / 3.93,
        child: Stack(
          children: [
            _buildImagePager(),
            ...widget.product.visualCues.map(_buildVisualCue),
            _buildWishlistIcon(),
            if (_hasMultipleImages) _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  // ── Image pager ───────────────────────────────────────────────────────────

  Widget _buildImagePager() {
    final images = widget.product.imageUrls;
    return SizedBox.expand(
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        dragStartBehavior: DragStartBehavior.down,
        onPageChanged: (index) {
          final direction = index > _previousPage ? 'R' : 'L';
          _previousPage = _currentPage.value;
          _currentPage.value = index;
          widget.onImageScrolled?.call(index + 1, direction);
        },
        itemBuilder: (_, i) => CachedImageWidget(
          borderRadius: BorderRadius.circular(8),
          imageUrl: images[i],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ── Wishlist icon — top-right corner ──────────────────────────────────────

  Widget _buildWishlistIcon() {
    return Positioned(
      right: 28,
      top: 28,
      child: GestureDetector(
        onTap: widget.onWishlistTap,
        child: CustomImage(
          path: widget.product.isWishlisted
              ? ImageConstants.wishlistAdded
              : ImageConstants.addWishlist,
          height: 28,
          width: 28,
        ),
      ),
    );
  }

  // ── Page indicator dots — bottom-right ────────────────────────────────────

  Widget _buildPageIndicator() {
    final count = widget.product.imageUrls.length;
    return Positioned(
      right: 12,
      bottom: 12,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (_, page, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (i) {
            final isSelected = i == page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSelected ? 85 : 100),
                color: Colors.black.withValues(alpha: 0.5),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Visual cues — four corners ────────────────────────────────────────────

  Widget _buildVisualCue(VisualCueEntity cue) {
    final location = cue.location?.toLowerCase() ?? '';
    final isTop = location.contains('top');
    final isLeft = location.contains('left');
    final isTextType = (cue.uiType?.toUpperCase() ?? '') == 'TEXT';
    final edgeMargin = isTextType ? 12.0 : 8.0;

    return Positioned(
      top: isTop ? edgeMargin : null,
      bottom: !isTop ? edgeMargin : null,
      left: isLeft ? edgeMargin : null,
      right: !isLeft ? edgeMargin : null,
      child: isTextType ? _buildTextCueBadge(cue) : _buildImageCueBadge(cue),
    );
  }

  Widget _buildTextCueBadge(VisualCueEntity cue) {
    final bgColor = cue.bgColor.toColor ?? AppColors.neutralGrey2;
    final txtColor = cue.textColor.toColor ?? AppColors.textPrimary;

    final badge = cue.imageUrl.isNotNullOrEmpty
        ? CustomImage(path: cue.imageUrl!, height: 15, width: 64)
        : CustomChipWidget(
            text: (cue.text ?? ''),
            backgroundColor: bgColor,
            borderColor: widget.product.isSoldOut ? bgColor : txtColor,
            borderRadius: 4,
            textStyle: AppTypographyV1.labelMedium.medium.copyWith(color: txtColor),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          );

    return Positioned(bottom: AppSpacing.xs, left: AppSpacing.xs, child: badge);
  }

  Widget _buildImageCueBadge(VisualCueEntity cue) {
    if (cue.imageUrl == null || cue.imageUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 26,
      child: CachedImageWidget(imageUrl: cue.imageUrl!, fit: BoxFit.contain),
    );
  }

  // ── Info section — below image ────────────────────────────────────────────

  Widget _buildInfoSection() {
    final product = widget.product;
    final price = product.price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.name.isNotNullOrEmpty) ...[
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypographyV1.labelLarge.regular.textPrimary(),
            ),
            AppSpacing.verticalGapXxs,
          ],

          if (price != null) ...[
            Wrap(
              spacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: '${price.sellingPrice}\t\t',
                    style: AppTypographyV1.bodyRegular.bold.textPrimary(),
                    children: [
                      if (price.mrp.isNotNullOrEmpty) ...[
                        TextSpan(
                          text: '${price.mrp}',
                          style: AppTypographyV1.labelMedium.regular.neutralGrey5().strikeThrough(),
                        ),
                      ],

                      if (price.discountLabel.isNotNullOrEmpty) ...[
                        TextSpan(
                          text: '\t\t${price.discountLabel!}',
                          style: AppTypographyV1.labelMedium.medium.brandSecondary(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (product.colorVariants.isNotNullOrEmpty) ...[
            AppSpacing.verticalGapXs,
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                product.colorVariants ?? '',
                style: AppTypographyV1.labelMedium.medium.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
