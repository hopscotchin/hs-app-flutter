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
import '../../features/discover/domain/entities/home_page_entity.dart';
import 'cached_image_widget.dart';

class ProductTile extends StatelessWidget {
  final String? imageUrl;
  final String? brandName;
  final String? productName;
  // Pre-rendered text mode (homepage):
  final String? priceText;
  final String? originalPriceText;
  final String? discountText;
  // Structured mode (PLP):
  final double? retailPrice;
  final double? regularPrice;
  final int? discountPercent;
  // Shared:
  final List<VisualCueEntity> visualCues;
  final List<String> colorHexCodes;
  final String? colorVariantsLabel;
  final bool isSoldOut;
  final bool isWishlisted;
  final bool showWishlistIcon;
  final bool showProductInfo;
  final bool isCPT;
  final double? imageAspectRatio;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final bool? hasCPT;

  const ProductTile({
    super.key,
    this.imageUrl,
    this.brandName,
    this.productName,
    this.priceText,
    this.originalPriceText,
    this.discountText,
    this.retailPrice,
    this.regularPrice,
    this.discountPercent,
    this.visualCues = const [],
    this.colorHexCodes = const [],
    this.colorVariantsLabel,
    this.isSoldOut = false,
    this.isWishlisted = false,
    this.showWishlistIcon = false,
    this.showProductInfo = true,
    this.isCPT = false,
    this.imageAspectRatio,
    this.onTap,
    this.onWishlistTap,
    this.hasCPT = false,
  });

  factory ProductTile.fromHomepageProduct(
    HomepageProduct product, {
    Key? key,
    VoidCallback? onTap,
    VoidCallback? onWishlistTap,
    bool showProductInfo = true,
    double? imageAspectRatio,
    String? imageUrl,
  }) {
    final price = product.price;
    final sellingPrice = price?.sellingPrice;
    final mrp = price?.mrp;
    final priceText = sellingPrice != null ? '₹$sellingPrice' : null;
    final originalPriceText = (price?.hasDiscount ?? false) && mrp != null ? '₹$mrp' : null;
    return ProductTile(
      key: key,
      imageUrl: imageUrl ?? product.primaryImageUrl,
      brandName: product.brandName,
      productName: product.name,
      priceText: priceText,
      originalPriceText: originalPriceText,
      discountText: price?.discountLabel,
      visualCues: product.visualCues,
      colorVariantsLabel: product.colorVariants,
      isSoldOut: product.soldOut,
      isWishlisted: product.isWishlisted,
      showWishlistIcon: product.canWishlist,
      showProductInfo: showProductInfo,
      imageAspectRatio: imageAspectRatio,
      onTap: onTap,
      onWishlistTap: onWishlistTap,
    );
  }

  /// Transformer-supplied label wins; falls back to hex-code count for legacy data.
  String? get _resolvedColorLabel {
    if (colorVariantsLabel != null) return colorVariantsLabel;
    return colorHexCodes.length > 1 ? '+${colorHexCodes.length} Colors' : null;
  }

  bool get _hasDiscount {
    if (discountText != null) return true;
    return discountPercent != null && discountPercent! > 5;
  }

  String get _resolvedPriceText {
    if (priceText != null) return priceText!;
    if (retailPrice != null) return '\u20B9${retailPrice!.toInt()}';
    return '';
  }

  String? get _resolvedOriginalPriceText {
    if (originalPriceText != null) return originalPriceText;
    if (_hasDiscount && regularPrice != null) {
      return '\u20B9${regularPrice!.toInt()}';
    }
    return null;
  }

  String? get _resolvedDiscountText {
    if (discountText != null) return discountText;
    if (_hasDiscount && discountPercent != null) {
      return '(${discountPercent!}% off)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const double kDefaultAspectRatio = 5 / 7;
    final effectiveRatio = imageAspectRatio ?? kDefaultAspectRatio;

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
            if (_resolvedPriceText.isNotEmpty) ...[AppSpacing.verticalGapXs, _buildPriceRow()],
            if (_resolvedColorLabel != null || (hasCPT ?? false)) ...[
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
            borderColor: isSoldOut ? bgColor : txtColor,
            borderRadius: 4,
            textStyle: AppTypographyV1.labelMedium.medium.copyWith(color: txtColor),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          );

    return Positioned(bottom: AppSpacing.xs, left: 6, child: badge);
    // switch (cue.location?.toLowerCase()) {
    //   'topright' => Positioned(top: 6, right: AppSpacing.xs, child: badge),
    //   'bottomleft' => Positioned(bottom: AppSpacing.xs, left: 6, child: badge),
    //   'bottomright' => Positioned(bottom: 6, right: AppSpacing.xs, child: badge),
    //   _ => Positioned(bottom: AppSpacing.xs, left: 6, child: badge),
    // };
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
      child: RichText(
        text: TextSpan(
          text: '$_resolvedPriceText\t',
          style: AppTypographyV1.bodySmall.bold.textPrimary(),
          children: [
            if (_resolvedOriginalPriceText != null) ...[
              TextSpan(
                text: '$_resolvedOriginalPriceText',
                style: AppTypographyV1.labelMedium.regular.neutralGrey5().strikeThrough(),
              ),
            ],

            if (_resolvedDiscountText != null) ...[
              TextSpan(
                text: '\t\t$_resolvedDiscountText',
                style: AppTypographyV1.labelMedium.regular.brandSecondary(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
