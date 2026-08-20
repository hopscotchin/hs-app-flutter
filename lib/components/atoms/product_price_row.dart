import 'package:flutter/material.dart';

import '../../core/extensions/string_extensions.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import 'strikethrough_text.dart';

/// Single-line price row: selling price, strikethrough MRP, and discount label.
///
/// Shared across product tiles/cards/cart rows so price styling stays
/// consistent app-wide. Renders as one `RichText` (not `Row`+`Text`) so long
/// strings clip instead of wrapping and blowing a fixed layout reserve.
class ProductPriceRow extends StatelessWidget {
  final String priceText;
  final String? originalPriceText;
  final String? discountText;
  final bool isSoldOut;
  final EdgeInsetsGeometry padding;

  const ProductPriceRow({
    super.key,
    required this.priceText,
    this.originalPriceText,
    this.discountText,
    this.isSoldOut = false,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.clip,
        softWrap: false,
        textAlign: TextAlign.start,
        text: TextSpan(
          text: '$priceText\t',
          style: isSoldOut
              ? AppTypographyV1.bodySmall.bold.copyWith(color: Colors.black.withValues(alpha: 0.5))
              : AppTypographyV1.bodySmall.bold.textPrimary(),
          children: [
            if (originalPriceText.isNotNullOrEmpty) ...[
              const WidgetSpan(child: SizedBox(width: 2)),
              StrikethroughText.span(
                originalPriceText ?? '',
                style: AppTypographyV1.labelMedium.regular.neutralGrey5(),
              ),
            ],
            if (discountText != null)
              TextSpan(
                text: originalPriceText != null ? '\t\t$discountText' : '\t$discountText',
                style: isSoldOut
                    ? AppTypographyV1.labelMedium.regular.copyWith(
                        color: Colors.black.withValues(alpha: 0.5),
                      )
                    : AppTypographyV1.labelMedium.regular.brandSecondary(),
              ),
          ],
        ),
      ),
    );
  }
}
