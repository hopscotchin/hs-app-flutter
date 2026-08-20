import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/auto_semantics.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/atoms/strikethrough_text.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../core/entities/visual_cue_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../features/plp/domain/entities/listing_product_entity.dart';
import '../../features/plp/domain/entities/product_price_entity.dart';
import 'cached_image_widget.dart';

/// Default tile aspect ratio (image-only). Cards in 2-col grids and carousels
/// fall back to this when no aspect ratio is supplied.
const double _kDefaultAspectRatio = 5 / 7;

class ProductTile extends StatelessWidget {
  final String? imageUrl;
  final String? productName;
  final String? priceText;
  final String? originalPriceText;
  final String? discountText;
  final List<VisualCueEntity> visualCues;
  final String? colorVariantsLabel;
  final bool isSoldOut;
  final bool isWishlisted;
  final bool showWishlistIcon;
  final bool showProductInfo;
  final bool isCPT;
  final bool hasCPT;
  final double? imageAspectRatio;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  /// Automation key for the main product tap target.
  final Key? tileKey;

  /// Automation key for the wishlist toggle button.
  final Key? wishlistKey;

  /// Automation key for the visual-cue overlay at rendered index `j`
  /// (nests under the tile → `plp_tile_<i>_visual_cue_<j>`).
  final Key? Function(int index)? visualCueKeyBuilder;

  /// Automation keys for the info-section text (nest under the tile).
  final Key? nameKey;
  final Key? priceKey;
  final Key? discountKey;
  final Key? colorVariantsKey;

  const ProductTile({
    super.key,
    this.imageUrl,
    this.productName,
    this.priceText,
    this.originalPriceText,
    this.discountText,
    this.visualCues = const [],
    this.colorVariantsLabel,
    this.isSoldOut = false,
    this.isWishlisted = false,
    this.showWishlistIcon = false,
    this.showProductInfo = true,
    this.isCPT = false,
    this.hasCPT = false,
    this.imageAspectRatio,
    this.onTap,
    this.onWishlistTap,
    this.tileKey,
    this.wishlistKey,
    this.visualCueKeyBuilder,
    this.nameKey,
    this.priceKey,
    this.discountKey,
    this.colorVariantsKey,
  });

  /// Build a tile from the unified [ListingProductEntity] — the shape used by
  /// PLP records, PageCarousel tiles, PRODUCT_GRID tiles, and PDP recently viewed tiles.
  factory ProductTile.fromProduct(
    ListingProductEntity product, {
    Key? key,
    VoidCallback? onTap,
    VoidCallback? onWishlistTap,
    bool showProductInfo = true,
    bool hasCPT = false,
    double? imageAspectRatio,
    String? imageUrl,
    bool? isWishlisted,
    Key? tileKey,
    Key? wishlistKey,
    Key? Function(int index)? visualCueKeyBuilder,
    Key? nameKey,
    Key? priceKey,
    Key? discountKey,
    Key? colorVariantsKey,
  }) {
    final price = product.price;
    final hasDiscount = price?.hasDiscount ?? false;
    return ProductTile(
      key: key,
      tileKey: tileKey,
      wishlistKey: wishlistKey,
      visualCueKeyBuilder: visualCueKeyBuilder,
      nameKey: nameKey,
      priceKey: priceKey,
      discountKey: discountKey,
      colorVariantsKey: colorVariantsKey,
      imageUrl: imageUrl ?? product.displayImage,
      productName: product.name,
      priceText: price?.sellingPrice,
      originalPriceText: hasDiscount ? price?.mrp : null,
      discountText: price?.discountLabel,
      visualCues: product.visualCues,
      colorVariantsLabel: product.colorVariants,
      isSoldOut: product.isSoldOut,
      isWishlisted: isWishlisted ?? product.wishlistInfo.isWishlisted,
      showWishlistIcon: product.wishlistInfo.canWishlist,
      showProductInfo: showProductInfo,
      isCPT: product.isCPT,
      hasCPT: hasCPT,
      imageAspectRatio: imageAspectRatio,
      onTap: onTap,
      onWishlistTap: onWishlistTap,
    );
  }

  /// Transformer-supplied label wins; falls back to null when nothing's given.
  String? get _resolvedColorLabel => colorVariantsLabel;

  @override
  Widget build(BuildContext context) {
    final effectiveRatio = imageAspectRatio ?? _kDefaultAspectRatio;

    if (isCPT) {
      return AutoSemantics.fromKey(
        tileKey ?? key,
        container: true,
        child: GestureDetector(
          key: tileKey,
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: effectiveRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              child: CachedImageWidget(imageUrl: imageUrl ?? '', fit: BoxFit.fill),
            ),
          ),
        ),
      );
    }

    return AutoSemantics.fromKey(
      tileKey ?? key,
      container: true,
      child: GestureDetector(
        key: tileKey,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(effectiveRatio),
            if (showProductInfo) ...[
              AppSpacing.verticalGapXsm,
              if (productName.isNotNullOrEmpty) _buildBrandName(),
              if (priceText.isNotNullOrEmpty) ...[AppSpacing.verticalGapXs, _buildPriceRow()],
              if (_resolvedColorLabel.isNotNullOrEmpty) ...[
                AppSpacing.verticalGapXsm,
                Text(
                  _resolvedColorLabel ?? '',
                  key: colorVariantsKey,
                  style: AppTypographyV1.labelMedium.regular.copyWith(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double aspectRatio) {
    final cues = visualCues
        .where((cue) => (cue.text.isNotNullOrEmpty || cue.imageUrl.isNotNullOrEmpty))
        .toList();
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          fit: StackFit.expand,
          children: [
            CachedImageWidget(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              imageUrl: imageUrl ?? '',
              fit: BoxFit.cover,
              width: constraints.maxWidth,
            ),
            if (isSoldOut) ColoredBox(color: AppColors.whiteColor.withValues(alpha: 0.5)),
            for (var i = 0; i < cues.length; i++) _buildVisualCueOverlay(cues[i], i),
            if (showWishlistIcon) _buildWishlistIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualCueOverlay(VisualCueEntity cue, int index) {
    final bgColor = cue.bgColor.toColorOr(AppColors.neutralGrey2);
    final txtColor = cue.textColor.toColorOr(AppColors.textPrimary);

    final badge = cue.imageUrl.isNotNullOrEmpty
        ? CustomImage(path: cue.imageUrl!, height: 15, width: 64)
        : CustomChipWidget(
            text: (cue.text ?? ''),
            backgroundColor: bgColor,
            borderColor: bgColor,
            borderRadius: 4,
            textStyle: AppTypographyV1.labelMedium.medium.copyWith(color: txtColor),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          );

    return Positioned(
      key: visualCueKeyBuilder?.call(index),
      bottom: AppSpacing.xs,
      left: AppSpacing.xs,
      child: badge,
    );
  }

  Widget _buildWishlistIcon() {
    // Wraps the IconButton, not the Positioned — a Positioned has to stay a
    // direct child of its Stack.
    return Positioned(
      top: AppSpacing.xxs,
      right: AppSpacing.xxs,
      child: AutoSemantics.fromKey(
        wishlistKey,
        child: IconButton(
          key: wishlistKey,
          icon: CustomImage(
            path: isWishlisted ? ImageConstants.wishlistAdded : ImageConstants.addWishlist,
            height: 16,
            width: 16,
          ),
          onPressed: onWishlistTap,
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Text(
        productName ?? '',
        key: nameKey,
        style: isSoldOut
            ? AppTypographyV1.labelLarge.regular.copyWith(
                color: Colors.black.withValues(alpha: 0.5),
              )
            : AppTypographyV1.labelLarge.regular.textPrimary(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceRow() {
    final priceStyle = isSoldOut
        ? AppTypographyV1.bodySmall.bold.copyWith(color: Colors.black.withValues(alpha: 0.5))
        : AppTypographyV1.bodySmall.bold.textPrimary();
    final mrpStyle = AppTypographyV1.labelMedium.regular.neutralGrey5();
    final discountStyle = isSoldOut
        ? AppTypographyV1.labelMedium.regular.copyWith(color: Colors.black.withValues(alpha: 0.5))
        : AppTypographyV1.labelMedium.regular.brandSecondary();

    // Wrap so a long discount label drops to a second line instead of
    // clipping at the tile edge. price+MRP stay together as one chunk;
    // only the discount can move to the next line.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs, vertical: 0),
      child: Wrap(
        key: priceKey,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 2,
        children: [
          RichText(
            text: TextSpan(
              text: priceText!,
              style: priceStyle,
              children: [
                if (originalPriceText.isNotNullOrEmpty) ...[
                  const WidgetSpan(child: SizedBox(width: 6)),
                  // Centred, not baseline-aligned: the MRP is a smaller size
                  // than the selling price, so sharing its baseline sits it
                  // visibly low against the taller glyphs. The discount is
                  // already centred by the Wrap's crossAxisAlignment.
                  StrikethroughText.span(
                    originalPriceText ?? '',
                    style: mrpStyle,
                    alignment: PlaceholderAlignment.middle,
                  ),
                ],
              ],
            ),
          ),
          if (discountText != null) Text(discountText!, key: discountKey, style: discountStyle),
        ],
      ),
    );
  }
}
