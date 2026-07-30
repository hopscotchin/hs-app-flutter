import 'package:flutter/material.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/sku_entity.dart';

// Design tokens from spec
const _kChipWidth = 89.0;
const _kChipHeight = 47.0;
const _kChipGap = 9.0;
const _kSelectedBg = Color(0xFFF4E6F5); // #F4E6F5
const _kNormalBg = Color(0xFFF6F6F6); // #F6F6F6
const _kTitleNormal = Color(
  0xFF000000,
); // #000000 solid black (not textPrimary which is 80%)
const _kDisabledColor = Color(0x33000000); // rgba(0,0,0,0.2)

class PdpSizeSelector extends StatelessWidget {
  final List<SkuEntity> skus;
  final SkuEntity? selectedSku;
  final bool hasSizeChart;
  final ValueChanged<String> onSizeSelected;
  final VoidCallback? onSizeChartTap;

  const PdpSizeSelector({
    super.key,
    required this.skus,
    this.selectedSku,
    this.hasSizeChart = false,
    required this.onSizeSelected,
    this.onSizeChartTap,
  });

  @override
  Widget build(BuildContext context) {
    if (skus.isEmpty) return const SizedBox.shrink();

    // Responsive horizontal padding: 4% of screen width, min 12 max 20
    final hPad = (MediaQuery.sizeOf(context).width * 0.04).clamp(12.0, 20.0);

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Size Chart >" — right-aligned
          if (hasSizeChart)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                key: const ValueKey(PdpTestStrings.sizeChartButton),
                onTap: onSizeChartTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      PdpStrings.sizeChart,
                      style: AppTypographyV1.bodyRegular.copyWith(
                        color: _kTitleNormal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AppSpacing.horizontalGapXs,
                    const Icon(
                      Icons.chevron_right,
                      size: AppSpacing.iconXs,
                      color: _kTitleNormal,
                    ),
                  ],
                ),
              ),
            ),
          if (hasSizeChart) AppSpacing.verticalGapSm,

          // Chips row — horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < skus.length; i++) ...[
                  if (i > 0) const SizedBox(width: _kChipGap),
                  PdpSizeChip(
                    key: ValueKey('${PdpTestStrings.sizeChip}_$i'),
                    sku: skus[i],
                    isSelected: selectedSku?.skuId == skus[i].skuId,
                    onTap: skus[i].enable == true && skus[i].skuId != null
                        ? () => onSizeSelected(skus[i].skuId!)
                        : null,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class PdpSizeChip extends StatelessWidget {
  final SkuEntity sku;
  final bool isSelected;
  final VoidCallback? onTap;

  const PdpSizeChip({
    super.key,
    required this.sku,
    required this.isSelected,
    this.onTap,
  });

  bool get _isEnabled => sku.enable == true;

  @override
  Widget build(BuildContext context) {
    final titleColor = _isEnabled
        ? (isSelected ? AppColors.brandDefault : _kTitleNormal)
        : _kDisabledColor;

    final subtitleColor = _isEnabled
        ? (isSelected ? const Color(0xFF070707) : _kTitleNormal)
        : _kDisabledColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _kChipWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Chip box
            Container(
              width: _kChipWidth,
              height: _kChipHeight,
              decoration: BoxDecoration(
                color: isSelected ? _kSelectedBg : _kNormalBg,
                border: isSelected
                    ? Border.all(color: AppColors.brandDefault, width: 1)
                    : null,
                borderRadius: AppSpacing.borderRadiusXs,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title (e.g. "3-6Y") — 13px w500
                  Text(
                    sku.title ?? '',
                    style: AppTypographyV1.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (sku.subTitle != null) ...[
                    const SizedBox(height: 4),
                    // Subtitle (e.g. "Waist : 32cm") — 8px w500
                    Text(
                      sku.subTitle!,
                      style: AppTypographyV1.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            AppSpacing.verticalGapXs,

            // Stock label below chip
            _buildStockLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildStockLabel() {
    const labelHeight = 14.0;

    if (!_isEnabled) {
      final label = sku.info?.text ?? PdpStrings.outOfStock;
      return SizedBox(
        height: labelHeight,
        child: Text(
          label,
          style: AppTypographyV1.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            color: _kDisabledColor,
            height: 1.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (sku.info?.text != null) {
      final color = _parseColor(sku.info!.textColor) ?? AppColors.error;
      return SizedBox(
        height: labelHeight,
        child: Text(
          sku.info!.text!,
          style: AppTypographyV1.labelMedium.copyWith(
            fontWeight: FontWeight.w400,
            color: color,
            height: 1.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox(height: labelHeight);
  }

  Color? _parseColor(String? colorStr) {
    if (colorStr == null) return null;
    try {
      final hex = colorStr.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}
