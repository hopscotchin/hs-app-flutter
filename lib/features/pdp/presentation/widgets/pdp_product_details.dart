import 'package:flutter/material.dart';

import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../../features/plp/domain/entities/product_price_entity.dart';
import '../../domain/entities/detail_entity.dart';
import '../../domain/entities/sku_entity.dart';
import '../../../../components/atoms/auto_semantics.dart';

// Design tokens
const _kTabNameColor = Color(0xFF000000);
const _kKeyColor = AppColors.neutralGrey5; // #AEAEB2
const _kValueColor = Color(0xFF000000);
const _kDividerColor = Color(0xFFD9D9D9); // #D9D9D9

// Field within skuAttributes that falls back to the product-level MRP when
// no SKU is selected yet, so the "MRP" row still has something to show.
const _kSkuMrpField = 'skuMrp';

// ── Top-level helpers ────────────────────────────────────────────────────────

List<String> _resolveSkuValues(
  String? fieldPath,
  SkuEntity? sku,
  ProductPriceEntity? productPriceInfo,
) {
  if (fieldPath == null) return [];
  final parts = fieldPath.split('.');

  // Accept either "skuAttributes.<key>" or a bare "<key>" — both resolve
  // against the same skuAttributes map.
  String? key;
  if (parts.length == 2 && parts[0] == 'skuAttributes') {
    key = parts[1];
  } else if (parts.length == 1) {
    key = parts[0];
  }
  if (key == null) return [];

  final val = sku?.skuAttributes?[key];
  if (val != null) return [val.toString()];
  if (key == _kSkuMrpField && productPriceInfo?.mrp != null) {
    return [productPriceInfo!.mrp!];
  }
  return [];
}

bool _itemHasData(
  DetailItemEntity item,
  SkuEntity? sku,
  ProductPriceEntity? productPriceInfo,
) {
  final type = item.type ?? 'keyValue';
  if (type == 'skuValue') {
    return _resolveSkuValues(item.fieldPath, sku, productPriceInfo).isNotEmpty;
  }
  return item.values.any((v) => v.isNotEmpty);
}

// ── Widget ───────────────────────────────────────────────────────────────────

class PdpProductDetails extends StatelessWidget {
  const PdpProductDetails({
    super.key,
    required this.details,
    required this.expandedTabIndex,
    required this.onTabTapped,
    this.selectedSku,
    this.productPriceInfo,
  });

  final List<DetailEntity> details;
  final int expandedTabIndex;
  final ValueChanged<int> onTabTapped;

  /// Needed to resolve skuValue fieldPath (e.g. "skuAttributes.skuMrp").
  final SkuEntity? selectedSku;

  /// Product-level price, used as a fallback for the MRP row before a SKU
  /// is selected.
  final ProductPriceEntity? productPriceInfo;

  @override
  Widget build(BuildContext context) {
    // Mirrors Android's ProductDetailsView: hide the whole section only when
    // there are no tabs at all. A tab with no resolvable data (e.g. a
    // skuValue field before a SKU is selected) still renders — header stays,
    // its expanded body just ends up empty — instead of disappearing.
    if (details.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Section title ─────────────────────────────────────────────────
          Text(
            PdpStrings.productDetails,
            key: const ValueKey(PdpTestStrings.productDetailsTitle),
            style: AppTypographyV1.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              height: 1.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < details.length; i++)
                _DetailTab(
                  // The header carries the tap that fires
                  // product_details_expanded / _collapsed / _tab_clicked.
                  headerKey: ValueKey('${PdpTestStrings.detailTab}_$i'),
                  dividerKey: ValueKey(
                    '${PdpTestStrings.detailTab}_${i}_${PdpTestStrings.detailTabDividerSuffix}',
                  ),
                  detail: details[i],
                  isExpanded: expandedTabIndex == i,
                  onTap: () => onTabTapped(i),
                  selectedSku: selectedSku,
                  productPriceInfo: productPriceInfo,
                ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _DetailTab extends StatelessWidget {
  const _DetailTab({
    required this.detail,
    required this.isExpanded,
    required this.onTap,
    this.selectedSku,
    this.productPriceInfo,
    this.headerKey,
    this.dividerKey,
  });

  final DetailEntity detail;
  final bool isExpanded;
  final VoidCallback onTap;
  final Key? headerKey;
  final Key? dividerKey;
  final SkuEntity? selectedSku;
  final ProductPriceEntity? productPriceInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tab header row ────────────────────────────────────────────
        // container: true — the header owns the tab name and the chevron, which
        // Android merges into one node, losing an annotated identifier.
        AutoSemantics.fromKey(
          headerKey,
          container: true,
          child: GestureDetector(
            key: headerKey,
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: AppSpacing.paddingVerticalLg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    detail.tabName ?? '',
                    style: AppTypographyV1.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _kTabNameColor,
                    ),
                  ),
                  // Chevron — 12×6, rotates up when expanded
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const _Chevron(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Expanded content ─────────────────────────────────────────
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: isExpanded
              ? _buildContent(detail.items, selectedSku, productPriceInfo)
              : const SizedBox(width: double.infinity),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        // Border bottom
        Divider(
          key: dividerKey,
          height: 1,
          thickness: 1,
          color: _kDividerColor,
        ),
      ],
    );
  }

  Widget _buildContent(
    List<DetailItemEntity> items,
    SkuEntity? sku,
    ProductPriceEntity? productPriceInfo,
  ) {
    // Drop items with no resolvable data (e.g. a sku-only field before a
    // SKU has been selected) so they don't leave a blank row behind.
    final visibleItems = items
        .where((item) => _itemHasData(item, sku, productPriceInfo))
        .toList();
    if (visibleItems.isEmpty) return const SizedBox.shrink();

    // Group into display rows respecting span:
    //  span=2 → own row (full width)
    //  span=1 → pair up (2 per row)
    final rows = <List<DetailItemEntity>>[];
    final buffer = <DetailItemEntity>[];

    for (final item in visibleItems) {
      if ((item.span ?? 1) >= 2) {
        if (buffer.isNotEmpty) {
          rows.add(List.from(buffer));
          buffer.clear();
        }
        rows.add([item]);
      } else {
        buffer.add(item);
        if (buffer.length == 2) {
          rows.add(List.from(buffer));
          buffer.clear();
        }
      }
    }
    if (buffer.isNotEmpty) rows.add(buffer);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0) AppSpacing.verticalGapLg,
            _buildRow(rows[i], sku, productPriceInfo),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    List<DetailItemEntity> rowItems,
    SkuEntity? sku,
    ProductPriceEntity? productPriceInfo,
  ) {
    if (rowItems.length == 1) {
      return _buildItem(rowItems.first, sku, productPriceInfo, fullWidth: true);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildItem(
            rowItems[0],
            sku,
            productPriceInfo,
            fullWidth: false,
          ),
        ),
        AppSpacing.horizontalGapLg,
        Expanded(
          child: _buildItem(
            rowItems[1],
            sku,
            productPriceInfo,
            fullWidth: false,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
    DetailItemEntity item,
    SkuEntity? sku,
    ProductPriceEntity? productPriceInfo, {
    required bool fullWidth,
  }) {
    final type = item.type ?? 'keyValue';

    if (type == 'text') {
      return _TextItem(values: item.values);
    }

    final resolvedValues = type == 'skuValue'
        ? _resolveSkuValues(item.fieldPath, sku, productPriceInfo)
        : item.values;

    return _KeyValueItem(
      displayKey: item.displayKey,
      values: resolvedValues,
      showBullet: item.showBullet ?? false,
      showDivider: item.showDivider ?? false,
      displayStyle: item.displayStyle ?? 'block',
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _TextItem extends StatelessWidget {
  const _TextItem({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Text(
      values.join('\n'),
      style: AppTypographyV1.labelLarge.copyWith(
        fontWeight: FontWeight.w400,
        color: _kValueColor,
        height: 1.5,
      ),
    );
  }
}

class _KeyValueItem extends StatelessWidget {
  const _KeyValueItem({
    required this.displayKey,
    required this.values,
    required this.showBullet,
    required this.showDivider,
    required this.displayStyle,
  });

  final String? displayKey;
  final List<String> values;
  final bool showBullet;
  final bool showDivider;
  final String displayStyle;

  @override
  Widget build(BuildContext context) {
    final valueText = values.join(', ');

    final key = displayKey != null
        ? Text(
            displayKey!.toUpperCase(),
            style: AppTypographyV1.labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: _kKeyColor,
            ),
          )
        : null;

    final value = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBullet) ...[
          Padding(
            padding: const EdgeInsets.only(top: 3, right: 4),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: _kValueColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
        Expanded(
          child: Text(
            valueText,
            style: AppTypographyV1.labelLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: _kValueColor,
            ),
          ),
        ),
      ],
    );

    // "inline" — key and value share one row (e.g. "MRP" ... "₹999").
    // "block" — key on its own line, value(s) stacked below.
    final content = displayStyle == 'inline'
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (key != null) ...[key, AppSpacing.horizontalGapXs],
              Expanded(child: value),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [if (key != null) key, AppSpacing.verticalGapXsm, value],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        if (showDivider) ...[
          AppSpacing.verticalGapXsm,
          const Divider(height: 1, thickness: 1, color: _kDividerColor),
        ],
      ],
    );
  }
}

/// 12×6 chevron drawn with a CustomPainter.
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(12, 6), painter: _ChevronPainter());
  }
}

class _ChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _kTabNameColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ChevronPainter oldDelegate) => false;
}
