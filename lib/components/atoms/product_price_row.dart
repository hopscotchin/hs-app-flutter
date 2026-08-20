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
    // The MRP and discount are a smaller size than the selling price. Plain
    // `TextSpan`s would share the selling price's *baseline*, which sits them
    // visibly low against its taller glyphs; wrapping them as `WidgetSpan`s
    // lets `PlaceholderAlignment.middle` centre them instead — which is what
    // the design asks for. Still one `RichText` rather than a `Row`, so long
    // strings clip instead of wrapping (see the class doc).
    final mrpStyle = AppTypographyV1.labelMedium.regular.neutralGrey5();
    final discountStyle = isSoldOut
        ? AppTypographyV1.labelMedium.regular.copyWith(color: Colors.black.withValues(alpha: 0.5))
        : AppTypographyV1.labelMedium.regular.brandSecondary();

    return Padding(
      padding: padding,
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.clip,
        softWrap: false,
        textAlign: TextAlign.start,
        text: TextSpan(
          text: priceText,
          style: isSoldOut
              ? AppTypographyV1.bodySmall.bold.copyWith(color: Colors.black.withValues(alpha: 0.5))
              : AppTypographyV1.bodySmall.bold.textPrimary(),
          children: [
            if (originalPriceText.isNotNullOrEmpty) ...[
              const WidgetSpan(child: SizedBox(width: AppSpacing.xs)),
              StrikethroughText.span(
                originalPriceText ?? '',
                style: mrpStyle,
                alignment: PlaceholderAlignment.middle,
              ),
            ],
            if (discountText != null) ...[
              const WidgetSpan(child: SizedBox(width: AppSpacing.xs)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Text(discountText!, style: discountStyle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
