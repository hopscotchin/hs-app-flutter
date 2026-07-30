import 'package:flutter/material.dart';

import '../atoms/strikethrough_text.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/plp/domain/entities/product_price_entity.dart';

// Design tokens from spec
const _kPriceColor = Color(0xFF070707); // selling price
const _kMrpColor = AppColors.neutralGrey5; // #AEAEB2
const _kDiscountColor = AppColors.secondaryLight; // #836EF1

/// Reusable price row rendering selling price, strikethrough MRP and a
/// discount label. Font sizes for each element are configurable and default
/// to the PDP brand-price spec (20px / 16px / 10px).
class PriceInfoRow extends StatelessWidget {
  final ProductPriceEntity price;

  /// Font size for the selling price. Defaults to `titleMedium` (20px).
  final double? sellingPriceFontSize;

  /// Font size for the strikethrough MRP. Defaults to `bodyLarge` (16px).
  final double? mrpFontSize;

  /// Font size for the discount label. Defaults to `labelMedium` (10px).
  final double? discountFontSize;

  /// Color for the selling price. Defaults to `#070707`.
  final Color sellingPriceColor;

  /// Color for the strikethrough MRP. Defaults to `neutralGrey5` (#AEAEB2).
  final Color mrpColor;

  /// Color for the discount label. Defaults to `secondaryLight` (#836EF1).
  final Color discountColor;

  /// Horizontal alignment of the row. Defaults to `MainAxisAlignment.start`.
  final MainAxisAlignment mainAxisAlignment;

  /// Optional automation keys for the individual price texts.
  final Key? sellingPriceKey;
  final Key? mrpKey;
  final Key? discountKey;

  const PriceInfoRow({
    super.key,
    required this.price,
    this.sellingPriceFontSize,
    this.mrpFontSize,
    this.discountFontSize,
    this.sellingPriceColor = _kPriceColor,
    this.mrpColor = _kMrpColor,
    this.discountColor = _kDiscountColor,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.sellingPriceKey,
    this.mrpKey,
    this.discountKey,
  });

  @override
  Widget build(BuildContext context) {
    // Pure pass-through: each element renders only when the backend sends it.
    // No client-side comparison decides whether an MRP is worth striking out.
    final hasMrp = price.mrp.isNotNullOrEmpty;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Selling price — 20px w700
        if (price.sellingPrice.isNotNullOrEmpty)
          Text(
            price.sellingPrice!,
            key: sellingPriceKey,
            style: AppTypographyV1.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: sellingPriceColor,
              fontSize: sellingPriceFontSize,
            ),
          ),

        if (hasMrp || price.hasDiscount) ...[
          const SizedBox(width: AppSpacing.lgMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MRP strikethrough — 16px w400.
              // Hand-painted line rather than TextDecoration.lineThrough:
              // Satoshi has no ₹ glyph, so the built-in decoration steps at the
              // fallback-font boundary instead of running straight through.
              if (hasMrp)
                StrikethroughText(
                  price.mrp!,
                  key: mrpKey,
                  style: AppTypographyV1.bodyLarge.copyWith(
                    fontWeight: FontWeight.w400,
                    color: mrpColor,
                    fontSize: mrpFontSize,
                  ),
                  lineColor: mrpColor,
                ),

              // Discount — 10px w400
              if (price.hasDiscount) ...[
                const SizedBox(width: AppSpacing.xsm),
                Text(
                  price.discountLabel!,
                  key: discountKey,
                  style: AppTypographyV1.labelMedium.copyWith(
                    fontWeight: FontWeight.w400,
                    color: discountColor,
                    fontSize: discountFontSize,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
