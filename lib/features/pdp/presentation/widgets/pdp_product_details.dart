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

// Expand/collapse animation — mirrors Android's View.expand()/collapse()
// (Extentions.kt): a 300ms height tween with AccelerateDecelerateInterpolator,
// which maps to Curves.easeInOut here.
const _kExpandDuration = Duration(milliseconds: 300);
const _kExpandCurve = Curves.easeInOut;

// Field within skuAttributes that falls back to the product-level MRP when no
// SKU is selected yet and the SKUs themselves carry no MRP — a last resort
// behind the cheapest-SKU fallback below.
const _kSkuMrpField = 'skuMrp';
const _kSectionBottomSpacing = 28.0;

// ── Top-level helpers ────────────────────────────────────────────────────────

/// The backend signals a range-priced product by putting the span in
/// `sellingPrice` ("₹1,199-₹1,299") rather than in a separate type field, so a
/// hyphen is the only marker there is. Amounts are comma-grouped and never
/// hyphenated, so this cannot false-positive on a single price.
bool _isRangePrice(ProductPriceEntity? productPriceInfo) {
  final sellingPrice = productPriceInfo?.sellingPrice;
  if (sellingPrice == null) return false;
  return sellingPrice.contains('-') || sellingPrice.contains('–');
}

/// Attributes that `skuValue` rows resolve against before a size is picked.
///
/// Mirrors Android's `GetDefaultSkuUseCase`: fall back to the cheapest SKU's
/// attributes so rows like "MRP" still have something to show on open. Range
/// priced products are excluded exactly as Android excludes `type == "range"`
/// — there the cheapest SKU does not speak for the product, so the row stays
/// hidden until a size is chosen.
Map<String, dynamic>? defaultSkuAttributesFor(
  List<SkuEntity> skus,
  ProductPriceEntity? productPriceInfo,
) {
  if (skus.isEmpty || _isRangePrice(productPriceInfo)) return null;

  // Matches Kotlin's `minByOrNull { it.price?.absoluteValue ?: MAX_VALUE }`:
  // priceless SKUs sort last, and a tie keeps the first one listed.
  var cheapest = skus.first;
  var cheapestValue = cheapest.priceInfo?.absoluteValue ?? double.infinity;
  for (final sku in skus.skip(1)) {
    final value = sku.priceInfo?.absoluteValue ?? double.infinity;
    if (value < cheapestValue) {
      cheapest = sku;
      cheapestValue = value;
    }
  }
  return cheapest.skuAttributes;
}

List<String> _resolveSkuValues(
  String? fieldPath,
  SkuEntity? sku,
  Map<String, dynamic>? defaultSkuAttributes,
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

  // Once a size is picked its own map is authoritative — a key it happens to
  // omit reads as empty rather than borrowing another SKU's value.
  final attributes = sku != null ? sku.skuAttributes : defaultSkuAttributes;
  final val = attributes?[key];
  if (val != null) return [val.toString()];
  // Product-level MRP is a pre-selection aid too, so it obeys the same rules as
  // the cheapest-SKU fallback: silent once a size is picked, silent on a
  // range-priced product.
  if (sku == null &&
      key == _kSkuMrpField &&
      !_isRangePrice(productPriceInfo) &&
      productPriceInfo?.mrp != null) {
    return [productPriceInfo!.mrp!];
  }
  return [];
}

bool _itemHasData(
  DetailItemEntity item,
  SkuEntity? sku,
  Map<String, dynamic>? defaultSkuAttributes,
  ProductPriceEntity? productPriceInfo,
) {
  final type = item.type ?? 'keyValue';
  if (type == 'skuValue') {
    return _resolveSkuValues(
      item.fieldPath,
      sku,
      defaultSkuAttributes,
      productPriceInfo,
    ).isNotEmpty;
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
    this.skus = const [],
    this.productPriceInfo,
  });

  final List<DetailEntity> details;
  final int expandedTabIndex;
  final ValueChanged<int> onTabTapped;

  /// Needed to resolve skuValue fieldPath (e.g. "skuAttributes.skuMrp").
  final SkuEntity? selectedSku;

  /// All SKUs, so sku-scoped rows can fall back to the cheapest one's
  /// attributes before a size is picked. Deliberately separate from
  /// [selectedSku], which stays null until the shopper actually chooses —
  /// the size chips, the price, the EDD and the add-to-bag CTA all read it
  /// as "a size has been selected".
  final List<SkuEntity> skus;

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

    final defaultSkuAttributes = defaultSkuAttributesFor(skus, productPriceInfo);

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
                  defaultSkuAttributes: defaultSkuAttributes,
                  productPriceInfo: productPriceInfo,
                ),
            ],
          ),
          const SizedBox(height: _kSectionBottomSpacing),
        ],
      ),
    );
  }
}

class _DetailTab extends StatefulWidget {
  const _DetailTab({
    required this.detail,
    required this.isExpanded,
    required this.onTap,
    this.selectedSku,
    this.defaultSkuAttributes,
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
  final Map<String, dynamic>? defaultSkuAttributes;
  final ProductPriceEntity? productPriceInfo;

  @override
  State<_DetailTab> createState() => _DetailTabState();
}

class _DetailTabState extends State<_DetailTab> with SingleTickerProviderStateMixin {
  // Driven explicitly instead of through an implicit animation so both
  // directions are symmetric: forward() on expand, reverse() on collapse.
  // Starts settled at its current state, so a tab that is already open on
  // first build doesn't animate itself in on page load.
  late final AnimationController _controller = AnimationController(
    duration: _kExpandDuration,
    vsync: this,
    value: widget.isExpanded ? 1 : 0,
  );

  late final Animation<double> _reveal = CurvedAnimation(
    parent: _controller,
    curve: _kExpandCurve,
    reverseCurve: _kExpandCurve.flipped,
  );

  @override
  void didUpdateWidget(_DetailTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded == oldWidget.isExpanded) return;
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tab header row ────────────────────────────────────────────
        // container: true — the header owns the tab name and the chevron, which
        // Android merges into one node, losing an annotated identifier.
        AutoSemantics.fromKey(
          widget.headerKey,
          container: true,
          child: GestureDetector(
            key: widget.headerKey,
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: AppSpacing.paddingVerticalLg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.detail.tabName ?? '',
                    style: AppTypographyV1.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: _kTabNameColor,
                    ),
                  ),
                  // Chevron — 12×6, rotates up as the body opens. Sharing the
                  // body's animation keeps the two exactly in step.
                  RotationTransition(
                    turns: _reveal.drive(Tween<double>(begin: 0, end: 0.5)),
                    child: const _Chevron(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Expanded content ─────────────────────────────────────────
        // Like Android, the body stays laid out at its full height and is
        // clipped from the bottom as the reveal factor animates 0 → 1, so both
        // directions read as the content sliding in/out rather than a fade.
        AnimatedBuilder(
          animation: _reveal,
          builder: (context, _) {
            final revealFactor = _reveal.value;
            // Fully collapsed: keep the body out of the tree entirely so its
            // rows aren't hit-testable or exposed to accessibility.
            if (revealFactor == 0) {
              return const SizedBox(width: double.infinity);
            }
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: revealFactor,
                child: _buildContent(
                  widget.detail.items,
                  widget.selectedSku,
                  widget.defaultSkuAttributes,
                  widget.productPriceInfo,
                ),
              ),
            );
          },
        ),

        // Border bottom
        Divider(key: widget.dividerKey, height: 1, thickness: 1, color: _kDividerColor),
      ],
    );
  }

  Widget _buildContent(
    List<DetailItemEntity> items,
    SkuEntity? sku,
    Map<String, dynamic>? defaultSkuAttributes,
    ProductPriceEntity? productPriceInfo,
  ) {
    // Drop items with no resolvable data (e.g. a sku-only field before a
    // SKU has been selected) so they don't leave a blank row behind.
    final visibleItems = items
        .where((item) => _itemHasData(item, sku, defaultSkuAttributes, productPriceInfo))
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
            _buildRow(rows[i], sku, defaultSkuAttributes, productPriceInfo),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    List<DetailItemEntity> rowItems,
    SkuEntity? sku,
    Map<String, dynamic>? defaultSkuAttributes,
    ProductPriceEntity? productPriceInfo,
  ) {
    if (rowItems.length == 1) {
      return _buildItem(
        rowItems.first,
        sku,
        defaultSkuAttributes,
        productPriceInfo,
        fullWidth: true,
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildItem(
            rowItems[0],
            sku,
            defaultSkuAttributes,
            productPriceInfo,
            fullWidth: false,
          ),
        ),
        AppSpacing.horizontalGapLg,
        Expanded(
          child: _buildItem(
            rowItems[1],
            sku,
            defaultSkuAttributes,
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
    Map<String, dynamic>? defaultSkuAttributes,
    ProductPriceEntity? productPriceInfo, {
    required bool fullWidth,
  }) {
    final type = item.type ?? 'keyValue';

    if (type == 'text') {
      return _TextItem(values: item.values);
    }

    final resolvedValues = type == 'skuValue'
        ? _resolveSkuValues(item.fieldPath, sku, defaultSkuAttributes, productPriceInfo)
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
              decoration: const BoxDecoration(color: _kValueColor, shape: BoxShape.circle),
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
    return const CustomPaint(
      size: Size(12, 6),
      painter: _ChevronPainter(),
    );
  }
}

class _ChevronPainter extends CustomPainter {
  const _ChevronPainter();

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
