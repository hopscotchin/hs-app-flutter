import 'package:flutter/material.dart';
import 'package:hs_app_flutter/components/buttons/app_button_named.dart';
import 'package:hs_app_flutter/components/buttons/button_enums.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/cart_strings.dart';
import 'package:hs_app_flutter/core/entities/order_summary_entity.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';

/// Sticky checkout bar: an optional "You Saved ₹X" ribbon, item count +
/// total (with a "Details" link that opens the full price breakdown), and
/// the "Proceed To Checkout" CTA.
class CartCheckoutBar extends StatelessWidget {
  final int itemCount;
  final bool isLoading;
  final VoidCallback? onCheckout;
  final OrderSummaryEntity? orderSummary;

  /// Scrolls the cart body to the price-summary section — "Details" only
  /// renders when this is provided.
  final VoidCallback? onDetailsTap;

  const CartCheckoutBar({
    super.key,
    required this.itemCount,
    this.isLoading = false,
    this.onCheckout,
    this.orderSummary,
    this.onDetailsTap,
  });

  /// Prefers the backend's preformatted "You saved ₹X on this order" text;
  /// falls back to a computed one from discount-flagged pricing rows.
  String? get _savingsText {
    final message = orderSummary?.savingsMessage;
    if (message != null) return message;
    final savings = orderSummary?.totalSavings ?? 0;
    return savings > 0 ? '${CartStrings.youSaved} ₹$savings ${CartStrings.onThisOrder}' : null;
  }

  @override
  Widget build(BuildContext context) {
    // No horizontal padding here — the savings ribbon must span edge-to-edge
    // so the outer Clip.antiAlias rounds ITS corners too; padding is applied
    // per-section below instead (16px on the CTA row only).
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surfaceHighlight,
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_savingsText != null) _buildSavingsRibbon(_savingsText!),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.borderRadiusSm,
                border: Border.all(color: AppColors.neutralGrey2),
              ),
              padding: AppSpacing.paddingXs,
              child: Row(
                children: [
                  Expanded(flex: 2, child: _buildSummary()),
                  // Flexible (not a bare child) so on narrow screens the button
                  // shrinks — and its own internal Text ellipsizes — instead of
                  // forcing a RenderFlex overflow next to the summary column.
                  Expanded(
                    flex: 4,
                    child: PrimaryButton.defaultType(
                      key: const ValueKey(CartTestStrings.checkoutBarProceedButton),
                      text: CartStrings.proceedToCheckout,
                      size: ButtonSize.large,
                      state: isLoading ? ButtonState.loading : ButtonState.enabled,
                      onTap: onCheckout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsRibbon(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xs,
        left: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        text,
        key: const ValueKey(CartTestStrings.checkoutBarSavingsBanner),
        style: AppTypographyV1.bodyRegular.regular.textPrimary(),
      ),
    );
  }

  Widget _buildSummary() {
    // Prefer the backend's preformatted strings (totalOrderSummary); fall
    // back to computing them from the plain ints when absent.
    final totalSummary = orderSummary?.totalOrderSummary;
    final itemCountText =
        totalSummary?.itemCountText ??
        '$itemCount ${itemCount == 1 ? CartStrings.item : CartStrings.items}';
    final totalAmountText = totalSummary?.totalPrice ?? orderSummary?.totalOrderAmount?.value ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          itemCountText,
          key: const ValueKey(CartTestStrings.checkoutBarItemCountText),
          style: AppTypographyV1.labelLarge.regular.neutralGrey6(),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                totalAmountText,
                key: const ValueKey(CartTestStrings.checkoutBarTotalAmountText),
                style: AppTypographyV1.bodySmall.bold.textPrimary(),
              ),
            ),
            GestureDetector(
              key: const ValueKey(CartTestStrings.checkoutBarDetailsButton),
              behavior: HitTestBehavior.opaque,
              onTap: onDetailsTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  CartStrings.details,
                  style: AppTypographyV1.bodyRegular.regular.brandPrimary(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Formats a number in Indian numbering system (e.g. 4293 → 4,293).
}
