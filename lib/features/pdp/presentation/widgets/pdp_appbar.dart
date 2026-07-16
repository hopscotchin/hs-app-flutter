import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

class PdpAppBar extends StatelessWidget {
  const PdpAppBar({
    super.key,
    required this.sheetController,
    required this.minSize,
    required this.maxSize,
    this.onBack,
  });

  final DraggableScrollableController sheetController;
  final double minSize;
  final double maxSize;

  /// Invoked when the back button is tapped. When null, the button just pops
  /// the route. The PDP passes a handler that collapses an expanded sheet
  /// first (matching the system back gesture).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ListenableBuilder(
        listenable: sheetController,
        builder: (context, child) {
          final expansion = sheetController.isAttached
              ? ((sheetController.size - minSize) / (maxSize - minSize)).clamp(0.0, 1.0)
              : 0.0;
          // Stay transparent throughout the drag; only turn white once the sheet
          // is fully expanded, rather than fading in progressively as it opens.
          final fullyExpanded = expansion >= 0.99;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.baseDefault.withValues(alpha: fullyExpanded ? 1.0 : 0.0),
              border: fullyExpanded
                  ? const Border(bottom: BorderSide(color: AppColors.neutralGrey2))
                  : null,
            ),
            child: child,
          );
        },
        child: PdpAppBarContent(onBack: onBack),
      ),
    );
  }
}

/// The static contents of the PDP app bar (back, wishlist, bag). Extracted so
/// it can be reused outside the animated overlay — e.g. on the error view,
/// where there is no draggable sheet to drive the background fade.
class PdpAppBarContent extends StatelessWidget {
  const PdpAppBarContent({super.key, this.onBack});

  /// Back-button handler. Falls back to popping the route when null (e.g. on
  /// the error view, where there is no sheet to collapse).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: PdpStrings.appBarVerticalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: const CustomImage(
                path: ImageConstants.arrowBack,
                height: AppSpacing.lmd,
                width: AppSpacing.lmd,
                color: AppColors.neutralBlack,
              ),
            ),
            Row(
              children: [
                // Static heart — mirrors Android's top-bar wishlist icon,
                // which always shows the same (empty) heart and does not
                // reflect membership state. No-op until a wishlist listing
                // screen exists to navigate to.
                const CustomImage(
                  path: ImageConstants.heart,
                  height: AppSpacing.iconSm,
                  width: AppSpacing.iconSm,
                ),
                AppSpacing.horizontalGapMd,
                BadgeIcon(
                  iconSize: AppSpacing.iconSm,
                  icon: const CustomImage(
                    path: ImageConstants.bag,
                    height: AppSpacing.iconSm,
                    width: AppSpacing.iconSm,
                  ),
                  count: context.watch<CartCountCubit>().state,
                  padding: EdgeInsets.zero,
                  onTap: () => AppNavigator.goToCart(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
