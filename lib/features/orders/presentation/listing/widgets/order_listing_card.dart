import 'package:flutter/material.dart';

import '../../../../../components/atoms/auto_semantics.dart';
import '../../../../../components/atoms/cached_image_widget.dart';
import '../../../../../components/atoms/custom_image.dart';
import '../../../../../components/action_trigger.dart';
import '../../../../../components/page_components/price_info_row.dart';
import '../../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../../core/constants/strings/orders_strings.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../../core/theme/typography/typography_v1.dart';
import '../../../../cart/domain/entities/cart_item_detail_entity.dart';
import '../../../domain/entities/common/order_status_entity.dart';
import '../../../domain/entities/listing/order_listing_record_entity.dart';
import '../../shared/widgets/order_status_row.dart';

/// One row on either listing.
///
/// Built to `docs/orders/design/listing-spec.md`. Widths there are ratios, not
/// constants — the artboard is a single 375pt frame, so the image is
/// `Expanded(flex: 132)` against text `Expanded(flex: 199)` rather than a fixed
/// 132, and the card takes its height from the image's aspect rather than
/// hardcoding 188. A fixed height would clip at large text scale.
///
/// A pure `StatelessWidget` with a callback — no bloc lookup inside, so the
/// same card works on any screen that has the entity.
///
/// The card branches on nothing but null. Whether a row is a gift card, a free
/// gift or a normal item is expressed entirely in which fields the backend
/// sends: gift cards and free gifts carry no `size`, a free gift's title is
/// already "Free Gift" and its price already "₹0".
class OrderListingCard extends StatelessWidget {
  const OrderListingCard({
    super.key,
    required this.record,
    required this.tabPrefix,
    required this.index,
    this.onTap,
  });

  final OrderListingRecordEntity record;

  /// `orders` or `gift_cards`. Both tabs index from zero, so without it a
  /// driver could not tell `_item_0` on one tab from `_item_0` on the other.
  final String tabPrefix;

  final int index;
  final VoidCallback? onTap;

  // The spec's 343-wide row splits 132 image · 12 gap · 199 text — a 2:3 share
  // of what is left after the gap, landing within half a point of the design
  // at 375pt. Same idiom as CartItemWidget, which uses 1:2 for its own ratio.
  static const int _imageFlex = 2;
  static const int _textFlex = 3;
  static const double _imageAspect = 3 / 4;

  /// 12 between cards, half carried by each. There is no 6 in AppSpacing, and
  /// inventing one for a half-gap would be worse than the literal.
  static const double _halfCardGap = AppSpacing.sm / 2;
  static const double _detailIconSize = 14;

  // Decode hint only — AspectRatio drives the layout, this just keeps the
  // cached bitmap near display size instead of full resolution, which matters
  // in a scrolling list.
  //
  // Width alone, deliberately: CachedImageWidget turns it into `memCacheWidth`
  // and leaves `memCacheHeight` null, so the decode scales proportionally and
  // follows the source's own aspect. Passing a height as well would pin both
  // axes, which over-decodes whenever the source is not 3:4 — the usual case
  // under BoxFit.cover.
  //
  // The value is the design's 132 at 375pt. The real box is 113–152 across
  // phone widths; a hint that close is fine, and without one the widget falls
  // back to the full screen width, decoding roughly eight times the pixels.
  static const double _imageDecodeWidth = 132;

  String get _base => '${tabPrefix}_${OrdersTestStrings.itemSuffix}_$index';
  ValueKey<String> _key(String suffix) => ValueKey('${_base}_$suffix');

  @override
  Widget build(BuildContext context) {
    return AutoSemantics(
      id: _base,
      // The card is one tap target with several labelled children; without
      // this the platform merges the subtree and the row's own id is lost.
      container: true,
      child: Container(
        key: ValueKey(_base),
        // 12 between cards — half on each, so the first and last sit 6 from
        // the list's own padding.
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: _halfCardGap,
        ),
        decoration: const BoxDecoration(
          color: AppColors.neutralGrey1,
          borderRadius: AppSpacing.borderRadiusXs,
        ),
        // A BoxDecoration's borderRadius paints the background but does not
        // clip children. The image sits flush to the card's left, top and
        // bottom and rounds itself at 2, so inside a 4 corner its pixels poke
        // out of the grey at both left corners. Clipping here is what makes
        // the card the artboard's rounded rectangle rather than the image's.
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: record.isTappable ? onTap : null,
          borderRadius: AppSpacing.borderRadiusXs,
          // Right padding only. The image is flush to the card's left, top and
          // bottom; the text column insets its own top and bottom. A uniform
          // EdgeInsets.all gets three sides wrong.
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: _imageFlex, child: _image()),
                AppSpacing.horizontalGapSm,
                Expanded(flex: _textFlex, child: _details()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _image() {
    return AspectRatio(
      aspectRatio: _imageAspect,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXxs),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXxs),
          child: CachedImageWidget(
            key: _key(OrdersTestStrings.itemImageSuffix),
            imageUrl: record.media?.url ?? '',
            fit: BoxFit.cover,
            width: _imageDecodeWidth,
          ),
        ),
      ),
    );
  }

  Widget _details() {
    final price = record.priceInfo;
    final status = record.status;

    return Padding(
      // Both ends, not just the top. The card is as tall as the taller of the
      // two columns, and the text wins more often than the artboard suggests:
      // at 360pt — Pixel, and most mid-range Android — the image is only 168
      // tall against a text column of roughly 176, so the card grows and the
      // last line would otherwise sit flush on the card's bottom edge. Text
      // scaling and a two-line detail row do the same on any width.
      //
      // The card's margin does not help here; it is outside the background.
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (record.title.isNotNullOrEmpty)
            Text(
              record.title!,
              key: _key(OrdersTestStrings.itemTitleSuffix),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypographyV1.labelLarge.regular.copyWith(
                color: AppColors.neutralBlack,
                height: 16 / 12,
              ),
            ),
          if (price != null) ...[
            AppSpacing.verticalGapXs,
            PriceInfoRow(
              price: price,
              sellingPriceFontSize: 13,
              sellingPriceColor: AppColors.neutralBlack,
              sellingPriceKey: _key(OrdersTestStrings.itemPriceSuffix),
            ),
          ],
          if (record.itemDetails != null) ...[
            AppSpacing.verticalGapXs,
            _itemDetail(record.itemDetails!),
          ],
          AppSpacing.verticalGapXsm,
          _labelledValue(
            OrdersStrings.qtyLabel,
            '${record.quantity}',
            _key(OrdersTestStrings.itemQtySuffix),
          ),
          // Absent on gift cards, free gifts and One Size SKUs — the backend
          // omits the field and the row does not render.
          if (record.hasSize) ...[
            AppSpacing.verticalGapXs,
            _labelledValue(
              OrdersStrings.sizeLabel,
              record.size!,
              _key(OrdersTestStrings.itemSizeSuffix),
            ),
          ],
          if (status != null && status.hasContent) ...[
            AppSpacing.verticalGapXs,
            OrderStatusRow(
              status: status,
              titleKey: _key(OrdersTestStrings.itemStatusTitleSuffix),
              subtitleKey: _key(OrdersTestStrings.itemStatusSubtitleSuffix),
            ),
          ],
        ],
      ),
    );
  }

  /// The advisory line under the price — "Non returnable & non exchangeable".
  ///
  /// Colour and copy both arrive resolved; the client only parses the hex.
  /// Wrapped in [ActionTrigger] so the backend decides whether tapping it opens
  /// a tooltip, a sheet or nothing at all — a null action leaves the row inert
  /// rather than needing a branch here.
  Widget _itemDetail(CartItemDetailEntity detail) {
    final color = detail.titleColor.toColorOr(AppColors.secondaryLight);
    final icon = detail.action?.iconUrl;

    return ActionTrigger(
      action: detail.action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon.isNotNullOrEmpty) ...[
            CustomImage(
              path: icon ?? '',
              width: _detailIconSize,
              height: _detailIconSize,
              fit: BoxFit.contain,
            ),
            AppSpacing.horizontalGapXxs,
          ],
          Flexible(
            child: Text(
              detail.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypographyV1.labelLarge.regular.copyWith(
                color: color,
                height: 16 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `Qty:  1` — a regular label and a medium value, 4 apart.
  ///
  /// One `RichText` rather than a Row so a long value ellipsises instead of
  /// wrapping under the label.
  Widget _labelledValue(String label, String value, Key key) {
    final base = AppTypographyV1.labelLarge.copyWith(
      color: AppColors.neutralGrey6,
      height: 16 / 12,
    );
    return RichText(
      key: key,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: label,
        style: base.regular,
        children: [
          // A WidgetSpan gives the spec's 4pt gap exactly; a space character
          // would be font-dependent and would not match between the Qty and
          // Size rows.
          const WidgetSpan(child: SizedBox(width: AppSpacing.xxs)),
          TextSpan(
            text: value,
            style: base.medium.copyWith(letterSpacing: -0.15),
          ),
        ],
      ),
    );
  }
}
