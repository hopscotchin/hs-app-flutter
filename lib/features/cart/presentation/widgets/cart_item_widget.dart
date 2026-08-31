import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/features/cart/presentation/bloc/cart_bloc.dart';

import '../../../../components/action_trigger.dart';
import '../../../../components/atoms/cached_image_widget.dart';
import '../../../../components/atoms/custom_chip_widget.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/product_price_row.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../domain/entities/cart_item_detail_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Cart line-item card.
///
/// Layout:
///   ┌────────────────────────────────────────────┐
///   │ [image]  Product name                    ✕ │
///   │          ₹499  ₹999  50% off               │
///   │          Price dropped by ₹100             │
///   │          Qty:  1                           │
///   │          Size: 8-9 Years   3 left          │
///   │ Arrives 6 Jul            ↗ Move To Wishlist│
///   └────────────────────────────────────────────┘
class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final bool isLoading;

  /// This row's move-to-wishlist call is in flight — the action greys out and
  /// stops responding until it lands, so it can't be fired twice. Mirrors
  /// Android, which locks the row for the same window.
  final bool isMovingToWishlist;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveToWishlist;
  final bool hasMessageBars;

  const CartItemWidget({
    super.key,
    required this.item,
    this.isLoading = false,
    this.isMovingToWishlist = false,
    this.onQuantityChanged,
    this.onRemove,
    this.onMoveToWishlist,
    this.hasMessageBars = false,
  });

  bool get _isSoldOut => item.isCompletelySoldOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xsm,
        AppSpacing.sm,
        AppSpacing.xsm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.neutralGrey1,
        borderRadius: AppSpacing.borderRadiusXs,
      ),
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildImageColumn(context)),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildDetails(), _buildWishlistRow()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sold-out items keep their real colors underneath — a translucent
  // light-grey scrim sits on top instead of a color-matrix transform, so it
  // reads as "disabled" rather than a recolored image. IgnorePointer keeps it
  // purely visual so taps still reach the content underneath (e.g. the ✕
  // remove button and item-detail tooltips).
  Widget _greyedOut(Widget child) {
    if (!_isSoldOut) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(color: AppColors.neutralGrey1.withValues(alpha: 0.4)),
          ),
        ),
      ],
    );
  }

  // ─── Image + delivery estimate ───────────────────────────────

  Future<void> _onImageTap(BuildContext context) async {
    final productId = item.productId;
    if (productId == null) return;
    final cartBloc = context.read<CartBloc>();
    await AppNavigator.goToPdp(context, productId.toString());
    cartBloc.add(const RefreshCart());
  }

  Widget _buildImageColumn(BuildContext context) {
    return _greyedOut(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: isLoading ? null : () => _onImageTap(context),
            child: AspectRatio(
              aspectRatio: 5 / 7,
              child: CachedImageWidget(
                borderRadius: AppSpacing.borderRadiusXs,
                imageUrl: item.imgSrc ?? '',
                fit: BoxFit.cover,
                width: 132,
                height: 176,
              ),
            ),
          ),
          // v6 sends the sold-out item's own status ("Sold out") in this same
          // field instead of an actual delivery estimate — showing it here
          // would read as "Arrives Sold out", so it's suppressed once the
          // item is flagged sold out (the greyed-out image already conveys
          // that state).
          if (!item.isCompletelySoldOut && item.estimatedDelivery.isNotNullOrEmpty) ...[
            AppSpacing.verticalGapXs,
            Text(
              item.estimatedDelivery ?? '',
              maxLines: 2,
              style: AppTypographyV1.labelLarge.regular.textPrimary(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Right-hand details column ──────────────────────────────

  Widget _buildDetails() {
    // When a visual cue is present (e.g. "Out Of Stock"), it takes the
    // product name's usual top-line spot next to the close icon, and the
    // product name drops to its own line underneath — matches PLP's tile
    // layout (see ProductTile._buildVisualCueOverlay), which also lets a
    // cue take priority over the plain name.
    final visualCue = item.visualCue;
    final hasVisualCue = visualCue?.text.isNotNullOrEmpty ?? false;

    // The grey scrim is applied per-block rather than over the whole column:
    // the visual cue badge carries its own server-driven colors and must stay
    // at full strength, so it is deliberately left outside _greyedOut().
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm, top: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (hasVisualCue)
                  _buildVisualCueBadge(visualCue!)
                else
                  Expanded(
                    child: _greyedOut(
                      Text(
                        item.productName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypographyV1.labelLarge.regular.textPrimary(),
                      ),
                    ),
                  ),
                if (hasVisualCue) const Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isLoading ? null : onRemove,
                  child: _greyedOut(
                    const ColoredBox(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.md,
                          right: AppSpacing.md,
                          bottom: 2,
                          top: 5,
                        ),
                        child: CustomImage(path: ImageConstants.closeIcon, height: 11, width: 11),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.xs),
            child: _greyedOut(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasVisualCue) ...[
                    AppSpacing.verticalGapSm,
                    Text(
                      item.productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypographyV1.labelLarge.regular.textPrimary(),
                    ),
                  ],

                  AppSpacing.verticalGapXs,
                  if (item.priceInfo != null)
                    ProductPriceRow(
                      padding: EdgeInsets.zero,
                      priceText: item.priceInfo!.sellingPrice ?? '',
                      originalPriceText: item.priceInfo!.hasDiscount ? item.priceInfo!.mrp : null,
                      discountText: item.priceInfo!.discount,
                      isSoldOut: false,
                    ),
                  for (final detail in item.cartItemDetails) ...[
                    AppSpacing.verticalGapXs,
                    _buildItemDetail(detail),
                  ],

                  AppSpacing.gapXxs,
                  _buildQuantityRow(),
                  AppSpacing.verticalGapXs,
                  _buildSizeRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualCueBadge(VisualCueEntity cue) {
    final bgColor = cue.bgColor.toColorOr(AppColors.neutralGrey2);
    final txtColor = cue.textColor.toColorOr(AppColors.textPrimary);

    return cue.imageUrl.isNotNullOrEmpty
        ? CustomImage(path: cue.imageUrl!, height: 15, width: 64)
        : CustomChipWidget(
            text: (cue.text ?? ''),
            backgroundColor: bgColor,
            borderColor: bgColor,
            borderRadius: AppSpacing.radiusXs,
            textStyle: AppTypographyV1.labelMedium.medium.copyWith(color: txtColor),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs, vertical: 0),
          );
  }

  Widget _buildQuantityRow() {
    final qty = item.quantity ?? 1;
    final maxQty = item.selectMaxValue ?? 10;
    // A single allowed quantity means there's nothing to step between — hide
    // the +/- controls entirely rather than showing them permanently disabled.
    final showStepper = maxQty > 1;
    final canChange = !isLoading && !_isSoldOut && onQuantityChanged != null;
    final canDecrease = canChange && qty > 1;
    final canIncrease = canChange && qty < maxQty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(CartStrings.qty, style: AppTypographyV1.labelLarge.regular.neutralGrey6()),
        AppSpacing.horizontalGapXxs,
        if (showStepper)
          InkWell(
            onTap: canDecrease ? () => onQuantityChanged!(qty - 1) : null,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xxs,
                right: AppSpacing.xs,
                top: AppSpacing.xs,
              ),
              child: CustomImage(
                path: ImageConstants.cartQuantityRemove,
                width: AppSpacing.iconSm,
                height: AppSpacing.iconSm,
                color: canDecrease ? AppColors.textPrimary : AppColors.neutralGrey4,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text('\t\t$qty', style: AppTypographyV1.labelLarge.medium.neutralGrey6()),
        ),
        if (showStepper)
          InkWell(
            onTap: canIncrease ? () => onQuantityChanged!(qty + 1) : null,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lmd,
                right: AppSpacing.xsm,
                top: AppSpacing.xs,
              ),
              child: CustomImage(
                path: ImageConstants.cartQuantityAdd,
                width: AppSpacing.iconSm,
                height: AppSpacing.iconSm,
                color: canIncrease ? AppColors.textPrimary : AppColors.neutralGrey4,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSizeRow() {
    final stockColor = item.stockAvailabilityStatusColor.toColorOr(AppColors.dangerDefault);
    return RichText(
      text: TextSpan(
        text: CartStrings.size,
        style: AppTypographyV1.labelLarge.regular.neutralGrey6(),
        children: [
          TextSpan(
            text: '\t\t${item.size ?? ''}',
            style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
          ),
          if (item.stockAvailabilityStatus.isNotNullOrEmpty)
            TextSpan(
              text: item.stockAvailabilityStatus!.padLeft(10),
              style: AppTypographyV1.labelMedium.regular.copyWith(color: stockColor),
            ),
        ],
      ),
    );
  }

  // ─── Item detail row (price drop / tooltip note / coupon savings) ──

  Widget _buildItemDetail(CartItemDetailEntity detail) {
    final textColor = detail.titleColor.toColorOr(AppColors.textPrimary);
    final icon = detail.action?.iconUrl;
    final label = Text(
      detail.title ?? '',
      maxLines: 2,
      style: AppTypographyV1.labelMedium.medium.copyWith(color: textColor),
    );

    if (icon.isNotNullOrEmpty) {
      // `child` is just the icon — that's where the tooltip's arrow anchors.
      // `tooltipBuilder` wraps it together with the label into one tappable
      // row, so tapping anywhere (not just the icon) opens the tooltip while
      // the arrow still points precisely at the icon.
      return ActionTrigger(
        action: detail.action,
        // The icon sits in the card's right-hand column, left of centre, so a
        // wide bubble centred on it would spill past the card and leave the
        // tail mid-bubble. Pin the bubble's left edge to the icon instead.
        alignTooltipLeftToAnchor: true,
        child: CustomImage(path: icon!, width: AppSpacing.iconXs, height: AppSpacing.iconXs),
        tooltipBuilder: (anchor, showTooltip) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: showTooltip,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [anchor, AppSpacing.horizontalGapXxs, label],
          ),
        ),
      );
    }

    return ActionTrigger(action: detail.action, child: label);
  }

  // ─── Footer ───────────────────────────────────────────────────

  Widget _buildWishlistRow() {
    final isBusy = isLoading || isMovingToWishlist;
    return GestureDetector(
      onTap: isBusy ? null : onMoveToWishlist,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.sm,
          top: AppSpacing.sm,
          right: AppSpacing.xs,
        ),
        child: ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            // Greyed rather than spinner-swapped: the row is about to disappear
            // on success, and a spinner appearing then vanishing with the row
            // reads as a flicker.
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CustomImage(path: ImageConstants.cartWishListArrow),
                Text(
                  CartStrings.moveToWishlistLabel,
                  style: AppTypographyV1.labelLarge.medium.brandPrimary(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
