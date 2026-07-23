import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    required this.scrollController,
    required this.whiteThreshold,
    this.onBack,
    this.cartIconKey,
  });

  /// The single page scroll controller. The bar turns white once the page has
  /// scrolled [whiteThreshold] px (i.e. the image has largely scrolled away).
  final ScrollController scrollController;
  final double whiteThreshold;

  /// Invoked when the back button is tapped. When null, the button just pops
  /// the route.
  final VoidCallback? onBack;

  /// Attached to the bag icon so the fly-to-cart animation can locate it as
  /// the flight target. Null on views without an animation (e.g. error view).
  final GlobalKey? cartIconKey;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ListenableBuilder(
        listenable: scrollController,
        builder: (context, child) {
          final offset = scrollController.hasClients
              ? scrollController.offset
              : 0.0;
          // Stay transparent while the image is in view; turn white once the
          // page has scrolled far enough that the image has largely scrolled off.
          final fullyExpanded = offset >= whiteThreshold;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.baseDefault.withValues(
                alpha: fullyExpanded ? 1.0 : 0.0,
              ),
              border: fullyExpanded
                  ? const Border(
                      bottom: BorderSide(color: AppColors.neutralGrey2),
                    )
                  : null,
            ),
            child: child,
          );
        },
        child: PdpAppBarContent(onBack: onBack, cartIconKey: cartIconKey),
      ),
    );
  }
}

/// The static contents of the PDP app bar (back, wishlist, bag). Extracted so
/// it can be reused outside the animated overlay — e.g. on the error view,
/// where there is no scroll controller to drive the background fade.
class PdpAppBarContent extends StatelessWidget {
  const PdpAppBarContent({super.key, this.onBack, this.cartIconKey});

  /// Back-button handler. Falls back to popping the route when null.
  final VoidCallback? onBack;

  /// Attached to the bag icon as the fly-to-cart animation target. Optional —
  /// the error view renders this content without an animation.
  final GlobalKey? cartIconKey;

  @override
  Widget build(BuildContext context) {
    final bag = BadgeIcon(
      key: cartIconKey,
      iconSize: AppSpacing.iconSm,
      icon: const CustomImage(
        path: ImageConstants.bag,
        height: AppSpacing.iconSm,
        width: AppSpacing.iconSm,
      ),
      count: context.watch<CartCountCubit>().state,
      padding: EdgeInsets.zero,
      onTap: () => AppNavigator.goToCart(context),
    );
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBack ?? () => context.pop(),
              child: const Padding(
                // Vertical padding drives the app bar's height — see
                // PdpStrings.appBarHeight, which PdpContent uses as its
                // white-background threshold.
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: PdpStrings.appBarVerticalPadding,
                ),
                child: CustomImage(
                  path: ImageConstants.arrowBack,
                  height: AppSpacing.lmd,
                  width: AppSpacing.lmd,
                  color: AppColors.neutralBlack,
                ),
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
                bag,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
