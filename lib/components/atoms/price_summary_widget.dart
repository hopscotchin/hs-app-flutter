import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/atoms/strikethrough_text.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

import '../../core/entities/order_summary_entity.dart';
import '../../core/entities/pricing_item_entity.dart';
import '../../core/theme/colors.dart';
import '../action_trigger.dart';
import 'custom_image.dart';

/// A reusable price summary widget that renders a title + item count,
/// tax disclaimer, dynamic pricing rows, divider, and total row.
///
/// Used by Cart ("Price Summary") and Orders ("Order Summary").
class PriceSummaryWidget extends StatelessWidget {
  final OrderSummaryEntity summary;
  final String? title;
  final String? subtitle;

  /// Optional rows rendered after the total (e.g. payment method breakdowns).
  final List<PricingItemEntity> postTotalRows;

  /// Automation-key prefix supplied by the host screen (e.g. `cart_price_summary`).
  /// Null → unkeyed, so existing call sites are unaffected.
  final String? keyPrefix;

  /// Called with the row whose ⓘ just opened its bottom sheet.
  ///
  /// The host reports it, not this widget — the same summary renders on order
  /// confirmation, which has no `shipping_info_viewed`. Null there.
  final ValueChanged<PricingItemEntity>? onRowActionOpened;

  const PriceSummaryWidget({
    super.key,
    required this.summary,
    this.title,
    this.subtitle,
    this.postTotalRows = const [],
    this.keyPrefix,
    this.onRowActionOpened,
  });

  /// `<keyPrefix>_<suffix>`, or null when the host passed no prefix.
  ValueKey<String>? _key(String suffix) =>
      keyPrefix == null ? null : ValueKey('${keyPrefix!}_$suffix');

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? summary.sectionTitle ?? 'Price Summary';
    final displaySubtitle = subtitle ?? summary.subText ?? 'Includes GST and all government taxes';

    return Column(
      children: [
        Center(
          child: Text(
            displayTitle,
            key: _key('title'),
            style: AppTypographyV1.titleMedium.bold.textPrimary(),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            displaySubtitle,
            key: _key('subtitle'),
            style: AppTypographyV1.labelLarge.regular.neutralGrey6(),
          ),
        ),
        const SizedBox(height: 28),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.container,
            border: Border.all(color: AppColors.neutralGrey2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...summary.pricingData.indexed.map((e) => _buildPricingRow(e.$2, e.$1))],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingRow(PricingItemEntity item, int index) {
    final valueColor = item.textColor.toColor;
    final rowKey = keyPrefix == null ? null : '${keyPrefix!}_row_$index';

    return Column(
      key: rowKey == null ? null : ValueKey(rowKey),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label ?? '',
                    key: rowKey == null ? null : ValueKey('${rowKey}_label'),
                    style: AppTypographyV1.bodyRegular.regular.textPrimary(),
                  ),
                  if (item.action != null) ...[
                    const SizedBox(width: 4),
                    ActionTrigger(
                      action: item.action,
                      onOpen: onRowActionOpened == null ? null : () => onRowActionOpened!(item),
                      child: item.action!.iconUrl.isNotNullOrEmpty
                          ? CustomImage(path: item.action!.iconUrl!, width: 20, height: 20)
                          : const Icon(Icons.info_outline, size: 20, color: AppColors.textTertiary),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (item.originalValue.isNotNullOrEmpty) ...[
                    StrikethroughText(
                      item.originalValue!,
                      style: AppTypographyV1.labelLarge.regular.copyWith(
                        color: item.originalColor.toColorOr(AppColors.neutralGrey4),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    item.value ?? '',
                    key: rowKey == null ? null : ValueKey('${rowKey}_value'),
                    style: AppTypographyV1.bodySmall.bold.textPrimary().copyWith(color: valueColor),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (item.subText.isNotNullOrEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxs, right: 60),
            child: Text(
              item.subText!,
              style: AppTypographyV1.labelMedium.medium.feedback().copyWith(
                color: item.subTextColor.toColorOrNull,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
