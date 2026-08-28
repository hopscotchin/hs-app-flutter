import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

class PdpAppBar extends StatefulWidget {
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
  State<PdpAppBar> createState() => _PdpAppBarState();
}

class _PdpAppBarState extends State<PdpAppBar> {
  // The bar's appearance depends on the scroll offset only through this single
  // bool. Previously the whole AnimatedContainer was rebuilt from a raw
  // ListenableBuilder on the controller, so every scroll tick allocated a fresh
  // BoxDecoration/Border and ran the implicit-animation didUpdateWidget path
  // 60-120x/s to arrive at the same target. Notifying on the bool instead means
  // that happens twice per page — once each way across the threshold.
  //
  // The AnimatedContainer is unchanged and still owns the 200ms easeOut fade:
  // implicit animations are driven by their own controller, not by rebuilds, so
  // rebuilding less often does not alter the transition.
  late final ValueNotifier<bool> _fullyExpanded = ValueNotifier<bool>(_computeFullyExpanded());

  // Stay transparent while the image is in view; turn white once the page has
  // scrolled far enough that the image has largely scrolled off.
  bool _computeFullyExpanded() {
    final offset = widget.scrollController.hasClients ? widget.scrollController.offset : 0.0;
    return offset >= widget.whiteThreshold;
  }

  void _onScroll() => _fullyExpanded.value = _computeFullyExpanded();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(PdpAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
    // whiteThreshold is derived from the layout (carousel height vs. bar
    // height), so a metrics change can move the boundary without a scroll.
    if (oldWidget.whiteThreshold != widget.whiteThreshold ||
        oldWidget.scrollController != widget.scrollController) {
      _onScroll();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _fullyExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: _fullyExpanded,
        builder: (context, fullyExpanded, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.baseDefault.withValues(alpha: fullyExpanded ? 1.0 : 0.0),
            border: fullyExpanded
                ? const Border(bottom: BorderSide(color: AppColors.neutralGrey2))
                : null,
          ),
          child: child,
        ),
        child: PdpAppBarContent(onBack: widget.onBack, cartIconKey: widget.cartIconKey),
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
    // Subscribed here rather than with context.watch at the top of build: the
    // count only affects the badge, but watching in this build method rebuilt
    // the whole bar — SafeArea, Row, back button, heart and all — on every cart
    // change. Scoped to the badge, an add-to-bag rebuilds one widget.
    //
    // This is also the only thing that still rebuilds this subtree, since
    // PdpAppBar passes it as the unchanging `child` of its ValueListenableBuilder.
    final bag = BlocBuilder<CartCountCubit, int>(
      builder: (context, count) => BadgeIcon(
        key: cartIconKey ?? const ValueKey(PdpTestStrings.appBarCartButton),
        iconSize: AppSpacing.iconSm,
        icon: const CustomImage(
          path: ImageConstants.bag,
          height: AppSpacing.iconSm,
          width: AppSpacing.iconSm,
        ),
        count: count,
        padding: EdgeInsets.zero,
        onTap: () => AppNavigator.goToCart(context),
      ),
    );
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              key: const ValueKey(PdpTestStrings.appBarBackButton),
              behavior: HitTestBehavior.opaque,
              onTap: onBack ?? () => AppNavigator.goBack(context),
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
                  key: ValueKey(PdpTestStrings.appBarWishlistButton),
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
