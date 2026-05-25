import 'package:flutter/material.dart';

import '../../core/entities/visual_cue_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
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
  final bool isSoldOut;
  final bool isWishlisted;
  final bool showWishlistIcon;
  final bool showProductInfo;
  final double imageAspectRatio;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

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
    this.isSoldOut = false,
    this.isWishlisted = false,
    this.showWishlistIcon = false,
    this.showProductInfo = true,
    this.imageAspectRatio = 5 / 7,
    this.onTap,
    this.onWishlistTap,
  });

  factory ProductTile.fromGridItem(
    HomepageProduct product, {
    Key? key,
    VoidCallback? onTap,
    VoidCallback? onWishlistTap,
    bool showProductInfo = true,
  }) {
    final price = product.price;
    final sellingPrice = price?.sellingPrice;
    final mrp = price?.mrp;
    final priceText = sellingPrice != null ? '₹$sellingPrice' : null;
    final originalPriceText = (price?.hasDiscount ?? false) && mrp != null
        ? '₹$mrp'
        : null;
    return ProductTile(
      key: key,
      imageUrl: product.primaryImageUrl,
      brandName: product.brandName,
      productName: product.name,
      priceText: priceText,
      originalPriceText: originalPriceText,
      discountText: price?.discountLabel,
      visualCues: product.visualCues,
      isSoldOut: product.soldOut,
      isWishlisted: product.isWishlisted,
      showWishlistIcon: product.canWishlist,
      showProductInfo: showProductInfo,
      imageAspectRatio: 0.75,
      onTap: onTap,
      onWishlistTap: onWishlistTap,
    );
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          if (showProductInfo) ...[
            AppSpacing.verticalGapXs,
            if (brandName != null && brandName!.isNotEmpty) _buildBrandName(),
            if (productName != null) _buildProductName(),
            if (_resolvedPriceText.isNotEmpty) ...[AppSpacing.verticalGapXxs, _buildPriceRow()],
            if (colorHexCodes.length > 1) ...[AppSpacing.verticalGapXxs, _buildColorDots()],
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: imageAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedImageWidget(imageUrl: imageUrl ?? '', fit: BoxFit.cover),
          if (isSoldOut) _buildSoldOutOverlay(),
          ...visualCues
              .where((cue) => cue.text != null && cue.text!.isNotEmpty)
              .map(_buildVisualCueOverlay),
          if (showWishlistIcon) _buildWishlistIcon(),
        ],
      ),
    );
  }

  Widget _buildSoldOutOverlay() {
    return Container(
      color: Colors.white.withValues(alpha: 0.7),
      child: Center(
        child: Text(
          'SOLD OUT',
          style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildVisualCueOverlay(VisualCueEntity cue) {
    final bgColor = _parseColor(cue.bgColor) ?? AppColors.primary;
    final txtColor = _parseColor(cue.textColor) ?? Colors.white;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(2)),
      child: Text(
        cue.text!,
        style: AppTypography.labelSmall.copyWith(color: txtColor, fontSize: 10),
      ),
    );

    return switch (cue.location?.toLowerCase()) {
      'topright' => Positioned(top: 6, right: 6, child: badge),
      'bottomleft' => Positioned(bottom: 6, left: 6, child: badge),
      'bottomright' => Positioned(bottom: 6, right: 6, child: badge),
      _ => Positioned(top: 6, left: 6, child: badge), // TopLeft / default
    };
  }

  Widget _buildWishlistIcon() {
    return Positioned(
      bottom: AppSpacing.xs,
      right: AppSpacing.xs,
      child: GestureDetector(
        onTap: onWishlistTap,
        child: Container(
          padding: AppSpacing.paddingXxs,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            size: AppSpacing.iconSm,
            color: isWishlisted ? AppColors.error : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Text(
        brandName!,
        style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProductName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Text(
        productName!,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Row(
        children: [
          Text(
            _resolvedPriceText,
            style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
          ),
          if (_resolvedOriginalPriceText != null) ...[
            AppSpacing.horizontalGapXxs,
            Text(
              _resolvedOriginalPriceText!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
          if (_resolvedDiscountText != null) ...[
            AppSpacing.horizontalGapXxs,
            Text(
              _resolvedDiscountText!,
              style: AppTypography.labelSmall.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorDots() {
    final colors = colorHexCodes;
    const maxShow = 4;
    final remaining = colors.length - maxShow;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
      child: Row(
        children: [
          ...colors
              .take(maxShow)
              .map(
                (hex) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: _parseColor(hex),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                ),
              ),
          if (remaining > 0)
            Text(
              '+$remaining',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
            ),
        ],
      ),
    );
  }

  static Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      final hex = colorStr.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
