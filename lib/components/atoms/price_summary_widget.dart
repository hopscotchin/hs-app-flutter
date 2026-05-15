import 'package:flutter/material.dart';

import '../../core/entities/order_summary_entity.dart';
import '../../core/entities/pricing_item_entity.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

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

  const PriceSummaryWidget({
    super.key,
    required this.summary,
    this.title,
    this.subtitle,
    this.postTotalRows = const [],
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? summary.sectionTitle ?? 'Price Summary';
    final displaySubtitle = subtitle ?? summary.subText ?? 'Includes GST and all government taxes';
    final total = summary.totalOrderAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.container,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(displayTitle, style: AppTypography.titleSmall),
              if (summary.itemCount != null) ...[
                const SizedBox(width: 4),
                Text(
                  '(${summary.itemCount} ${summary.itemCount == 1 ? 'item' : 'items'})',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            displaySubtitle,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11),
          ),
          const SizedBox(height: 12),
          ...summary.pricingData.map(_buildPricingRow),
          if (summary.pricingData.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: AppColors.divider, height: 1),
            ),
          ],
          if (total != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(total.label?.trim() ?? 'Total', style: AppTypography.titleSmall),
                Text(
                  total.value ?? '\u20B9${summary.totalAmount ?? 0}',
                  style: AppTypography.titleSmall,
                ),
              ],
            )
          else if (summary.totalAmount != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: AppTypography.titleSmall),
                Text('\u20B9${summary.totalAmount}', style: AppTypography.titleSmall),
              ],
            ),
          ...postTotalRows.map(_buildPricingRow),
        ],
      ),
    );
  }

  Widget _buildPricingRow(PricingItemEntity item) {
    final isDiscount = _isDiscountRow(item);
    final textColor = _parseColor(item.textColor);
    final labelColor = isDiscount ? AppColors.success : textColor ?? AppColors.textSecondary;
    final valueColor = isDiscount ? AppColors.success : textColor ?? AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label ?? '',
                    style: AppTypography.bodyMedium.copyWith(color: labelColor),
                  ),
                  if (item.hasInfoIcon == true) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.info_outline, size: 14, color: AppColors.textTertiary),
                  ],
                ],
              ),
              Text(item.value ?? '', style: AppTypography.bodyMedium.copyWith(color: valueColor)),
            ],
          ),
        ),
        if (item.subText != null && item.subText!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item.subText!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11),
            ),
          ),
        ],
        if (item.actionTextToolTip != null && item.actionTextToolTip!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item.actionTextToolTip!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  bool _isDiscountRow(PricingItemEntity item) {
    final value = item.value;
    if (value != null && value.contains('-')) return true;
    final type = item.type?.toLowerCase() ?? '';
    if (type.contains('discount') || type.contains('saving')) return true;
    return false;
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
