import 'package:flutter/material.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/sku_entity.dart';

// Design tokens from spec
//
// 89 is the *floor*, not the width: apparel sizes ("3-6Y", "XL") sit well
// inside it, but footwear ships labels like "Euro 26 (2.5 UK/US)" that ran past
// it and ellipsised, so the selected chip couldn't be read back. The chip grows
// with its label up to _kChipMaxWidth, past which ellipsis is still the lesser
// evil — a single chip wider than that pushes the rest of the row off-screen.
const _kChipMinWidth = 89.0;
const _kChipMaxWidth = 180.0;
const _kChipHPadding = 10.0;
const _kChipHeight = 47.0;
const _kChipGap = 9.0;
const _kSelectedBg = Color(0xFFF4E6F5); // #F4E6F5
const _kNormalBg = Color(0xFFF6F6F6); // #F6F6F6
const _kTitleNormal = Color(
  0xFF000000,
); // #000000 solid black (not textPrimary which is 80%)
const _kDisabledColor = Color(0x33000000); // rgba(0,0,0,0.2)

class PdpSizeSelector extends StatefulWidget {
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
  State<PdpSizeSelector> createState() => _PdpSizeSelectorState();
}

// Kept alive so the chip row's horizontal offset survives scrolling the PDP.
// The selector is a child of the page's SliverList, so once it leaves the
// viewport's cache extent its element would be unmounted and the chip row's
// scroll position destroyed — coming back it would rebuild at offset 0 with the
// selected chip off-screen. AutomaticKeepAliveClientMixin holds the element
// (SliverChildListDelegate defaults to addAutomaticKeepAlives: true), so the
// position is retained for as long as the user stays on this PDP.
class _PdpSizeSelectorState extends State<PdpSizeSelector>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final skus = widget.skus;
    if (skus.isEmpty) return const SizedBox.shrink();

    // Responsive horizontal padding: 4% of screen width, min 12 max 20
    final hPad = (MediaQuery.sizeOf(context).width * 0.04).clamp(12.0, 20.0);

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Size Chart >" — right-aligned
          if (widget.hasSizeChart)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                key: const ValueKey(PdpTestStrings.sizeChartButton),
                onTap: widget.onSizeChartTap,
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
          if (widget.hasSizeChart) AppSpacing.verticalGapSm,

          // Chips row — horizontal scroll. Clamping, not bouncing: bouncing lets
          // the drag pull the chips past either end and exposes blank space
          // inside the section. Matches the page scroll view and the carousel,
          // and Android's RecyclerView, which don't overscroll either.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < skus.length; i++) ...[
                  if (i > 0) const SizedBox(width: _kChipGap),
                  PdpSizeChip(
                    key: ValueKey('${PdpTestStrings.sizeChip}_$i'),
                    sku: skus[i],
                    isSelected: widget.selectedSku?.skuId == skus[i].skuId,
                    onTap: skus[i].enable == true && skus[i].skuId != null
                        ? () => widget.onSizeSelected(skus[i].skuId!)
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
      // IntrinsicWidth so the chip and the stock label under it share one
      // width driven by whichever is wider — without it the Column sits in
      // the row's unbounded horizontal space and the label would lay out at
      // its full text width, unclipped and detached from the box above it.
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chip box
            Container(
              constraints: const BoxConstraints(
                minWidth: _kChipMinWidth,
                maxWidth: _kChipMaxWidth,
                minHeight: _kChipHeight,
                maxHeight: _kChipHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: _kChipHPadding),
              decoration: BoxDecoration(
                color: isSelected ? _kSelectedBg : _kNormalBg,
                // Always bordered, transparent when unselected. A border is
                // inset padding, so a border that only exists on the selected
                // chip made it 2px wider than the others — invisible when the
                // width was fixed at 89, but now that the chip sizes to its
                // label it would nudge the whole row sideways on every tap.
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandDefault
                      : Colors.transparent,
                  width: 1,
                ),
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
    // The label shares the chip's IntrinsicWidth, so left unbounded a long
    // "Only 2 left in size 26" would widen the box above it — the size, not
    // the stock note, decides how wide a chip is. Capping the label's *max
    // intrinsic* width at the floor keeps it out of that negotiation entirely:
    // 89 is a width the chip is guaranteed anyway, so it can never be the one
    // asking for more. At layout the enclosing tight width still wins, so the
    // label spans the full chip and ellipsises only against the real edge.
    const labelConstraints = BoxConstraints(
      maxWidth: _kChipMinWidth,
      minHeight: labelHeight,
      maxHeight: labelHeight,
    );

    if (!_isEnabled) {
      final label = sku.info?.text ?? PdpStrings.outOfStock;
      return ConstrainedBox(
        constraints: labelConstraints,
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
      return ConstrainedBox(
        constraints: labelConstraints,
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
