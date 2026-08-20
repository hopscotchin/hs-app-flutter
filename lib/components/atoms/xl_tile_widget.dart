import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/cached_image_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/atoms/strikethrough_text.dart';
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

  /// Caller-supplied (global WishlistCubit) status; falls back to the listing
  /// response status when null.
  final bool? isWishlisted;

  /// Analytics callback — position is 1-based, direction is "L" or "R"
  final void Function(int position, String direction)? onImageScrolled;

  /// Automation key for the main product tap target.
  final Key? tileKey;

  /// Automation key for the wishlist toggle.
  final Key? wishlistKey;

  /// Automation key for the visual-cue overlay at rendered index `j`
  /// (nests under the tile → `plp_tile_<i>_visual_cue_<j>`).
  final Key? Function(int index)? visualCueKeyBuilder;

  /// Automation keys for the info-section text (nest under the tile).
  final Key? nameKey;
  final Key? priceKey;
  final Key? discountKey;
  final Key? colorVariantsKey;

  const XLTileWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlistTap,
    this.onAddToCartTap,
    this.isWishlisted,
    this.onImageScrolled,
    this.tileKey,
    this.wishlistKey,
    this.visualCueKeyBuilder,
    this.nameKey,
    this.priceKey,
    this.discountKey,
    this.colorVariantsKey,
  });

  factory XLTileWidget.fromListingProduct(
    ListingProductEntity product, {
    Key? key,
    required VoidCallback onTap,
    required VoidCallback onWishlistTap,
    VoidCallback? onAddToCartTap,
    bool? isWishlisted,
    void Function(int position, String direction)? onImageScrolled,
    Key? tileKey,
    Key? wishlistKey,
    Key? Function(int index)? visualCueKeyBuilder,
    Key? nameKey,
    Key? priceKey,
    Key? discountKey,
    Key? colorVariantsKey,
  }) {
    return XLTileWidget(
      key: key,
      product: product,
      onTap: onTap,
      onWishlistTap: onWishlistTap,
      onAddToCartTap: onAddToCartTap,
      isWishlisted: isWishlisted,
      onImageScrolled: onImageScrolled,
      tileKey: tileKey,
      wishlistKey: wishlistKey,
      visualCueKeyBuilder: visualCueKeyBuilder,
      nameKey: nameKey,
      priceKey: priceKey,
      discountKey: discountKey,
      colorVariantsKey: colorVariantsKey,
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
      key: widget.tileKey,
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
            for (var i = 0; i < widget.product.visualCues.length; i++)
              _buildVisualCue(widget.product.visualCues[i], i),
            if (widget.product.wishlistInfo.canWishlist) _buildWishlistIcon(),
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
        allowImplicitScrolling: true,
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
        key: widget.wishlistKey,
        onTap: widget.onWishlistTap,
        child: CustomImage(
          path: (widget.isWishlisted ?? widget.product.wishlistInfo.isWishlisted)
              ? ImageConstants.wishlistAdded
              : ImageConstants.addWishlist,
          height: 28,
          width: 28,
        ),
      ),
    );
  }

  static const int _maxVisibleDots = 5;

  Widget _buildPageIndicator() {
    final count = widget.product.imageUrls.length;
    return Positioned(
      right: 12,
      bottom: 12,
      child: ValueListenableBuilder<int>(
        valueListenable: _currentPage,
        builder: (_, page, _) {
          final start = count <= _maxVisibleDots
              ? 0
              : (page - _maxVisibleDots ~/ 2).clamp(0, count - _maxVisibleDots);
          final end = count <= _maxVisibleDots ? count : start + _maxVisibleDots;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [for (var i = start; i < end; i++) _buildDot(i, page, start, end, count)],
          );
        },
      ),
    );
  }

  Widget _buildDot(int i, int page, int start, int end, int count) {
    final isSelected = i == page;

    final isEdge = !isSelected && ((i == start && start > 0) || (i == end - 1 && end < count));
    final double size = isEdge ? 6 : 10;
    return AnimatedContainer(
      key: ValueKey(i),
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isSelected ? 28 : size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSelected ? 85 : 100),
        color: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }

  // ── Visual cues — four corners ────────────────────────────────────────────

  Widget _buildVisualCue(VisualCueEntity cue, int index) {
    final location = cue.location?.toLowerCase() ?? '';
    final isTop = location.contains('top');
    final isLeft = location.contains('left');
    final isTextType = (cue.uiType?.toUpperCase() ?? '') == 'TEXT';
    final edgeMargin = isTextType ? 12.0 : 8.0;
    final bgColor = cue.bgColor.toColorOr(AppColors.neutralGrey2);
    final txtColor = cue.textColor.toColorOr(AppColors.textPrimary);

    return Positioned(
      key: widget.visualCueKeyBuilder?.call(index),
      top: isTop ? edgeMargin : null,
      bottom: !isTop ? edgeMargin : null,
      left: isLeft ? edgeMargin : null,
      right: !isLeft ? edgeMargin : null,
      child: !isTextType && cue.imageUrl.isNotNullOrEmpty
          ? CustomImage(path: cue.imageUrl!, height: 15, width: 64)
          : CustomChipWidget(
              text: (cue.text ?? ''),
              backgroundColor: bgColor,
              borderColor: bgColor,
              borderRadius: 4,
              textStyle: AppTypographyV1.labelMedium.medium.copyWith(color: txtColor),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            ),
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
              key: widget.nameKey,
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
                  key: widget.priceKey,
                  text: TextSpan(
                    text: '${price.sellingPrice}\t\t',
                    style: AppTypographyV1.bodyRegular.bold.textPrimary(),
                    children: [
                      if (price.mrp.isNotNullOrEmpty) ...[
                        // Centred to match the discount span below — the MRP
                        // is smaller than the selling price, so its baseline
                        // sits low against the taller glyphs.
                        StrikethroughText.span(
                          price.mrp ?? '',
                          // height: 1 — see ProductPriceRow; centring the
                          // placeholder only reads right once its box is
                          // collapsed to the glyph height.
                          style: AppTypographyV1.labelMedium.regular
                              .neutralGrey5()
                              .copyWith(height: 1),
                          alignment: PlaceholderAlignment.middle,
                        ),
                      ],

                      if (price.discountLabel.isNotNullOrEmpty) ...[
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              price.discountLabel!,
                              key: widget.discountKey,
                              style: AppTypographyV1.labelMedium.medium
                                  .brandSecondary()
                                  .copyWith(height: 1),
                            ),
                          ),
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
                key: widget.colorVariantsKey,
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
