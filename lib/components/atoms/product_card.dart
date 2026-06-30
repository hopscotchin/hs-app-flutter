import 'package:flutter/material.dart';

import '../../core/entities/visual_cue_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import 'cached_image_widget.dart';
import 'strikethrough_text.dart';

/// A reusable product card that renders product image, brand, name, size,
/// pricing, visual cues, sold-out state, and delivery text.
///
/// Cart-specific or order-specific actions are passed via [trailing] and
/// [actionsWidget] slots.
class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final double imageWidth;
  final double imageHeight;
  final String? brandLabel;
  final String? productName;
  final String? size;
  final bool isSingleSize;
  final int? price;
  final int? regularPrice;
  final String? discount;
  final bool isSoldOut;
  final bool isSizeSoldOut;
  final String? deliveryText;
  final String? lowInventoryText;
  final String? promoDiscountMessage;
  final List<VisualCueEntity> visualCues;
  final bool isLoading;
  final Widget? trailing;
  final Widget? actionsWidget;
  final int? quantity;

  const ProductCard({
    super.key,
    this.imageUrl,
    this.imageWidth = 100,
    this.imageHeight = 150,
    this.brandLabel,
    this.productName,
    this.size,
    this.isSingleSize = false,
    this.price,
    this.regularPrice,
    this.discount,
    this.isSoldOut = false,
    this.isSizeSoldOut = false,
    this.deliveryText,
    this.lowInventoryText,
    this.promoDiscountMessage,
    this.visualCues = const [],
    this.isLoading = false,
    this.trailing,
    this.actionsWidget,
    this.quantity,
  });

  bool get _isCompletelySoldOut => isSoldOut || isSizeSoldOut;

  bool get _isDiscountAvailable =>
      discount != null &&
      discount!.isNotEmpty &&
      regularPrice != null &&
      price != null &&
      regularPrice! > price!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              const SizedBox(width: 12),
              Expanded(child: _buildProductDetails()),
            ],
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.6),
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
        if (_isCompletelySoldOut && !isLoading)
          Positioned.fill(child: Container(color: Colors.white.withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildProductImage() {
    final borderColor = _isCompletelySoldOut
        ? AppColors.error.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.12);

    return SizedBox(
      width: imageWidth,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedImageWidget(
                imageUrl: imageUrl ?? '',
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (deliveryText != null)
            Positioned(
              bottom: 1,
              left: 1,
              right: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Text(
                  deliveryText!,
                  style: AppTypography.overline.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (_isCompletelySoldOut)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.white.withValues(alpha: 0.9),
                  child: Text(
                    'SOLD OUT',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.error),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (brandLabel != null && brandLabel!.isNotEmpty)
                    Text(
                      brandLabel!,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
                    ),
                  if (productName != null)
                    Text(
                      productName!,
                      style: AppTypography.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 4),
        if (size != null && !isSingleSize)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  'Size: $size',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                if (lowInventoryText != null && lowInventoryText!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    lowInventoryText!,
                    style: AppTypography.labelSmall.copyWith(color: const Color(0xFFF57C00)),
                  ),
                ],
              ],
            ),
          )
        else if (lowInventoryText != null && lowInventoryText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              lowInventoryText!,
              style: AppTypography.labelSmall.copyWith(color: const Color(0xFFF57C00)),
            ),
          ),
        if (quantity != null && actionsWidget == null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Quantity: $quantity',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        if (actionsWidget != null)
          Padding(padding: const EdgeInsets.only(bottom: 4), child: actionsWidget!),
        _buildPricingRow(),
        if (visualCues.isNotEmpty) ...[const SizedBox(height: 6), _buildVisualCues()],
        if (promoDiscountMessage != null && promoDiscountMessage!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            promoDiscountMessage!,
            style: AppTypography.bodySmall.copyWith(color: AppColors.success),
          ),
        ],
        if (_isCompletelySoldOut) ...[
          const SizedBox(height: 8),
          Text(
            isSizeSoldOut
                ? 'This size is currently out of stock'
                : 'This item is currently out of stock',
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildPricingRow() {
    return Row(
      children: [
        if (price != null)
          Text(
            '\u20B9$price',
            style: AppTypography.titleSmall.copyWith(
              color: _isCompletelySoldOut ? AppColors.textDisabled : null,
            ),
          ),
        if (_isDiscountAvailable) ...[
          const SizedBox(width: 6),
          StrikethroughText(
            '\u20B9$regularPrice',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(width: 6),
          Text(discount!, style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
        ],
      ],
    );
  }

  Widget _buildVisualCues() {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: visualCues.where((c) => c.text != null).map((cue) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _parseColor(cue.bgColor) ?? AppColors.primaryLight,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            cue.text!,
            style: AppTypography.labelSmall.copyWith(
              color: _parseColor(cue.textColor) ?? AppColors.primary,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
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
