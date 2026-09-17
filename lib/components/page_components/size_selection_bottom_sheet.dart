import 'package:flutter/material.dart';

import '../../core/constants/image_constants.dart';
import '../../core/constants/strings/auto_test_strings.dart';
import '../../core/constants/strings/pdp_strings.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography/text_style_extensions.dart';
import '../../core/theme/typography/typography_v1.dart';
import '../../features/pdp/domain/entities/sku_entity.dart';
import '../../features/plp/domain/entities/product_price_entity.dart';
import '../atoms/custom_image.dart';
import '../buttons/app_button.dart';
import '../buttons/button_enums.dart';
import 'price_info_row.dart';

// Design tokens from spec
const _kHandleColor = AppColors.brandDefault;
const _kPriceStripBg = AppColors.borderSecondary; // rgba(109, 89, 215, 0.1)
const _kEddStripBg = AppColors.successSecondary; // #D3EDE0
const _kEddIconGap = 6.0; // no spacing token for 6
// Icon tint and text colour of the EDD bar.
const _kEddIconColor = Color(0xFF000000); // solid black, per spec
const _kSellingPriceColor = Color(0xFF333333);
const _kDiscountColor = AppColors.secondary;

// Chip tokens
const _kChipWidth = 89.0;
const _kChipHeight = 47.0;
const _kSelectedBg = Color(0xFFF4E6F5); // #F4E6F5
const _kNormalBg = Color(0xFFF6F6F6); // #F6F6F6
const _kTitleNormal = Color(0xFF000000); // solid black (textPrimary is 80%)
const _kDisabledColor = Color(0x33000000); // rgba(0,0,0,0.2)

/// Size-selection modal shared by PDP and wishlist.
///
/// Purely presentational — it owns only the in-sheet selection. Callers wire
/// the outcome: [onConfirm] fires with the chosen SKU id after the sheet pops,
/// and [onSelectionChanged] lets a caller mirror the selection into its own
/// state (the PDP keeps `selectedSku` on its Bloc so the page reflects it).
Future<void> showSizeSelectionBottomSheet(
  BuildContext context, {
  required List<SkuEntity> skus,
  required String ctaLabel,
  required ValueChanged<String> onConfirm,
  ProductPriceEntity? fallbackPrice,
  String? initialSkuId,
  bool showSizeChart = false,
  VoidCallback? onSizeChartTap,
  ValueChanged<String>? onSelectionChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    showDragHandle: false,
    builder: (_) => SizeSelectionSheet(
      skus: skus,
      ctaLabel: ctaLabel,
      onConfirm: onConfirm,
      fallbackPrice: fallbackPrice,
      initialSkuId: initialSkuId,
      showSizeChart: showSizeChart,
      onSizeChartTap: onSizeChartTap,
      onSelectionChanged: onSelectionChanged,
    ),
  );
}

class SizeSelectionSheet extends StatefulWidget {
  const SizeSelectionSheet({
    super.key,
    required this.skus,
    required this.ctaLabel,
    required this.onConfirm,
    this.fallbackPrice,
    this.initialSkuId,
    this.showSizeChart = false,
    this.onSizeChartTap,
    this.onSelectionChanged,
  });

  final List<SkuEntity> skus;
  final String ctaLabel;

  /// Fired with the selected SKU id after the sheet is popped.
  final ValueChanged<String> onConfirm;

  /// Price shown when the selected SKU carries none (typically the product
  /// level price).
  final ProductPriceEntity? fallbackPrice;

  final String? initialSkuId;
  final bool showSizeChart;
  final VoidCallback? onSizeChartTap;

  /// Fired on every chip tap, before confirmation.
  final ValueChanged<String>? onSelectionChanged;

  @override
  State<SizeSelectionSheet> createState() => _SizeSelectionSheetState();
}

class _SizeSelectionSheetState extends State<SizeSelectionSheet> {
  String? _selectedSkuId;

  @override
  void initState() {
    super.initState();
    _selectedSkuId = widget.initialSkuId;
  }

  SkuEntity? get _selectedSku {
    if (_selectedSkuId == null) return null;
    for (final sku in widget.skus) {
      if (sku.skuId == _selectedSkuId) return sku;
    }
    return null;
  }

  void _onChipTap(String skuId) {
    setState(() => _selectedSkuId = skuId);
    widget.onSelectionChanged?.call(skuId);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedSku;
    final effectivePrice = selected?.priceInfo ?? widget.fallbackPrice;
    final eddText = selected?.eddInfo?.edd;

    // Lift the button clear of the system nav/gesture inset so it isn't
    // hidden behind the navigation bar.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.baseDefault,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 24,
            height: 2,
            decoration: BoxDecoration(
              color: _kHandleColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: AppSpacing.lgMd),

          // Header: "Select Size" + "Size Chart >"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PdpStrings.selectSize,
                key: const ValueKey(PdpTestStrings.sizeSheetTitle),
                style: AppTypographyV1.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.showSizeChart)
                GestureDetector(
                  key: const ValueKey(PdpTestStrings.sizeSheetSizeChartButton),
                  onTap: widget.onSizeChartTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        PdpStrings.sizeChart,
                        style: AppTypographyV1.bodyRegular.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: AppSpacing.iconXs),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Size chips grid
          Wrap(
            spacing: 9,
            runSpacing: 12,
            children: [
              for (int i = 0; i < widget.skus.length; i++)
                SizeChip(
                  key: ValueKey('${PdpTestStrings.sizeSheetChip}_$i'),
                  sku: widget.skus[i],
                  isSelected: _selectedSkuId == widget.skus[i].skuId,
                  onTap:
                      widget.skus[i].enable == true &&
                          widget.skus[i].skuId != null
                      ? () => _onChipTap(widget.skus[i].skuId!)
                      : null,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Price strip
          if (effectivePrice != null) _PriceStrip(price: effectivePrice),

          // Delivery estimate for the selected size, when the SKU carries one.
          if (eddText != null && eddText.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _EddBar(text: eddText),
            const SizedBox(height: AppSpacing.lg),
          ] else
            const SizedBox(height: AppSpacing.sm),

          // Confirm button (Add to Bag / Buy Now / Move to Bag)
          AppButton(
            key: const ValueKey(PdpTestStrings.sizeSheetConfirmButton),
            text: widget.ctaLabel,
            variant: ButtonVariant.primary,
            isFullWidth: true,
            state: selected == null
                ? ButtonState.disabled
                : ButtonState.enabled,
            onTap: selected == null
                ? null
                : () {
                    final skuId = selected.skuId!;
                    Navigator.of(context).pop();
                    widget.onConfirm(skuId);
                  },
          ),
        ],
      ),
    );
  }
}

class _PriceStrip extends StatelessWidget {
  const _PriceStrip({required this.price});

  final ProductPriceEntity price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _kPriceStripBg,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: PriceInfoRow(
        price: price,
        sellingPriceKey: const ValueKey(
          PdpTestStrings.sizeSheetSellingPriceText,
        ),
        mrpKey: const ValueKey(PdpTestStrings.sizeSheetMrpText),
        discountKey: const ValueKey(PdpTestStrings.sizeSheetDiscountText),
        mainAxisAlignment: MainAxisAlignment.center,
        sellingPriceFontSize: 16,
        mrpFontSize: 14,
        discountFontSize: 14,
        sellingPriceColor: _kSellingPriceColor,
        discountColor: _kDiscountColor,
      ),
    );
  }
}

/// Delivery-estimate bar under the price strip (e.g. "Get it in 4-5 days").
class _EddBar extends StatelessWidget {
  const _EddBar({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _kEddStripBg,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomImage(
            path: ImageConstants.pdpPincodeInfo,
            height: AppSpacing.iconSm,
            width: AppSpacing.iconSm,
            fit: BoxFit.contain,
            color: _kEddIconColor,
          ),
          const SizedBox(width: _kEddIconGap),
          Flexible(
            child: Text(
              // 12px / medium / solid black, per spec.
              text,
              style: AppTypographyV1.labelLarge.medium.copyWith(
                color: _kEddIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One size chip: title, optional subtitle, and a stock label underneath.
/// Shared by the PDP inline size selector and [SizeSelectionSheet].
class SizeChip extends StatelessWidget {
  final SkuEntity sku;
  final bool isSelected;
  final VoidCallback? onTap;

  const SizeChip({
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
