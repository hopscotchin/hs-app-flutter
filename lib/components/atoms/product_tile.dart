import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/custom_chip_widget.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
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
  });

  /// Build a tile from the unified [ListingProductEntity] — the shape used by
  /// PLP records, PageCarousel tiles, and PRODUCT_GRID tiles.
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
  }) {
    final price = product.price;
    final hasDiscount = price?.hasDiscount ?? false;
    return ProductTile(
      key: key,
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
      return GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: effectiveRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            child: CachedImageWidget(imageUrl: imageUrl ?? '', fit: BoxFit.cover),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(effectiveRatio),
          if (showProductInfo) ...[
            AppSpacing.verticalGapXsm,
            if (productName.isNotNullOrEmpty) _buildBrandName(),
            if ((priceText ?? '').isNotEmpty) ...[AppSpacing.verticalGapXs, _buildPriceRow()],
            if (_resolvedColorLabel != null || hasCPT) ...[
              AppSpacing.verticalGapXsm,
              Text(
                _resolvedColorLabel ?? '',
                style: AppTypographyV1.labelMedium.regular.copyWith(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildImage(double aspectRatio) {
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
            ...visualCues
                .where((cue) => (cue.text.isNotNullOrEmpty || cue.imageUrl.isNotNullOrEmpty))
                .map(_buildVisualCueOverlay),
            if (showWishlistIcon) _buildWishlistIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualCueOverlay(VisualCueEntity cue) {
    final bgColor = cue.bgColor.toColor ?? AppColors.neutralGrey2;
    final txtColor = cue.textColor.toColor ?? AppColors.textPrimary;

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

    return Positioned(bottom: AppSpacing.xs, left: AppSpacing.xs, child: badge);
  }

  Widget _buildWishlistIcon() {
    return Positioned(
      top: AppSpacing.xxs,
      right: AppSpacing.xxs,
      child: IconButton(
        icon: CustomImage(
          path: isWishlisted ? ImageConstants.wishlistAdded : ImageConstants.addWishlist,
          height: 16,
          width: 16,
        ),
        onPressed: onWishlistTap,
      ),
    );
  }

  Widget _buildBrandName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Text(
        productName ?? '',
        style: AppTypographyV1.labelLarge.regular.textPrimary(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      // Single-line + clip — longer mrp strings like "MRP:₹2,665" would
      // otherwise wrap and blow the carousel's fixed product-info reserve.
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.clip,
        softWrap: false,
        text: TextSpan(
          text: '${priceText!}\t',
          style: AppTypographyV1.bodySmall.bold.textPrimary(),
          children: [
            if (originalPriceText != null) ...[
              const WidgetSpan(child: SizedBox(width: 2)),
              TextSpan(
                text: originalPriceText,
                style: AppTypographyV1.labelMedium.regular.neutralGrey5().strikeThrough(),
              ),
            ],
            if (discountText != null) ...[
              TextSpan(
                text: originalPriceText != null ? '\t\t$discountText' : '\t$discountText',
                style: AppTypographyV1.labelMedium.regular.brandSecondary(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
