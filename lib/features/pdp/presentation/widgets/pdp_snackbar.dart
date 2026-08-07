import 'package:flutter/material.dart';

import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';

/// Snackbars for the PDP, lifted above the floating Buy Now / Go to Bag bar so
/// they never cover it. Use [PdpSnackbar.show] instead of
/// [ScaffoldMessenger.showSnackBar] anywhere on the PDP.
class PdpSnackbar {
  PdpSnackbar._();

  // margin is only honoured with SnackBarBehavior.floating (set in the app
  // theme). Clears the bar's height + its bottom gap + a small margin.
  static const _margin = EdgeInsets.only(
    left: AppSpacing.md,
    right: AppSpacing.md,
    bottom: PdpStrings.addToBagBarHeight + AppSpacing.md,
  );

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: duration, margin: _margin));
  }

  // ── couponCode-Snackbars ───────────────────────────────────────────────────
  // Design tokens for the coupon confirmation. Height is left to the content:
  // 12 + 16 line + 12 = 40, matching the spec's box.
  static const _couponBg = AppColors.neutralGrey6; // #353535
  static const _couponRadius = AppSpacing.borderRadiusXs; // 4
  static const _couponPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md, // 16
    vertical: AppSpacing.sm, // 12
  );

  /// The `couponCode-Snackbars` component: a full-width #353535 bar with the
  /// message centred in Satoshi 12/16 medium, shown after a coupon code is
  /// copied. Distinct from [show], which renders the app-theme snackbar used for
  /// PdpBloc messages.
  ///
  /// The SnackBar is an invisible shell — transparent, no elevation, no padding
  /// — and the visible bar is the child inside it. Flutter's SnackBar enforces a
  /// 48px minimum height, so the spec's 40px box is only achievable this way.
  /// Going through ScaffoldMessenger keeps the queueing and hide-on-replace
  /// behaviour of [show].
  static void showCouponCopied(
    BuildContext context,
    String couponCode, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          duration: duration,
          // Side margins of md leave the spec's 343 width on a 375 screen.
          margin: _margin,
          content: DecoratedBox(
            decoration: const BoxDecoration(color: _couponBg, borderRadius: _couponRadius),
            child: Padding(
              padding: _couponPadding,
              child: Text(
                '${PdpStrings.couponCodeCopied}: $couponCode',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypographyV1.labelLarge.medium.copyWith(
                  color: AppColors.whiteColor,
                  height: 16 / 12,
                ),
              ),
            ),
          ),
        ),
      );
  }
}
