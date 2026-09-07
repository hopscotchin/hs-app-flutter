import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/badge_icon.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/atoms/empty_state_widget.dart';
import 'package:hs_app_flutter/components/atoms/price_summary_widget.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/extensions/context_extension.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/cart_entity.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/delivery_pincode_entity.dart';
import 'package:hs_app_flutter/features/cart/presentation/widgets/cart_slg_widget.dart';
import 'package:hs_app_flutter/features/cart/presentation/widgets/gift_card_banner.dart';
import 'package:hs_app_flutter/features/pincode/presentation/widgets/pincode_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/page_components/message_bars_widget.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/cart_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/constants/strings/login_redirects.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../account/presentation/bloc/account_bloc.dart';
import '../../../promos_offers/presentation/widgets/promo_action_sheet.dart';
import '../../../promos_offers/presentation/widgets/promo_offers_bottom_sheet.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_checkout_bar.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_promo_section.dart';
import '../widgets/cart_shimmer_loading.dart';
import '../widgets/remove_cart_item_sheet.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, this.fromBuyNow = false});

  /// Set when the cart was opened by PDP's Buy Now. The cart then drives itself
  /// to checkout as soon as the first load lands, rather than waiting for the
  /// checkout button — mirroring Android's `CartFragment`, which reads
  /// `IS_FROM_BUYNOW` off the intent and calls `proceedToCheckout()` from
  /// `handleCartResponse`.
  final bool fromBuyNow;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _priceSummaryKey = GlobalKey();

  /// One-shot latch for the buy-now auto-checkout. Android clears its
  /// `isFromBuyNow` flag once the user leaves the checkout flow so the sheet is
  /// not re-opened on every cart refresh; this does the same by firing only on
  /// the first load.
  bool _buyNowCheckoutStarted = false;

  /// Held rather than read from `context` so [dispose] can still reach it.
  late final CartBloc _cartBloc = context.read<CartBloc>();

  @override
  void initState() {
    super.initState();
    // CartBloc lives for the whole app, so buy-now mode is scoped to this
    // page: set on entry, cleared in dispose. Leaving it set would keep every
    // later cart fetch — from anywhere — showing the buy-now item alone.
    _cartBloc.instantCheckout = widget.fromBuyNow;
    _cartBloc.add(const LoadCart());
  }

  @override
  void dispose() {
    _cartBloc.exitBuyNowMode();
    super.dispose();
  }

  void _scrollToPriceSummary() {
    final summaryContext = _priceSummaryKey.currentContext;
    if (summaryContext == null) return;
    Scrollable.ensureVisible(
      summaryContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onEddPincodeTap(BuildContext context) async {
    final result = await PincodeBottomSheet.show(context);
    if (result != null && context.mounted) {
      context.read<CartBloc>().add(const RefreshCart());
    }
  }

  // RefreshCart is a silent background refresh with no loading flag of its
  // own, so completion is detected via `refreshTick` — bumped by the bloc on
  // every RefreshCart outcome (success or failure) — rather than polling
  // `isLoading`.
  Future<void> _onPullToRefresh(BuildContext context) async {
    final bloc = context.read<CartBloc>();
    final tickBeforeRefresh = bloc.state.refreshTick;
    bloc.add(const RefreshCart());
    await bloc.stream.firstWhere((s) => s.refreshTick != tickBeforeRefresh);
  }

  /// The single checkout entry point, shared by the checkout button and the
  /// buy-now auto-start. Fires `orderNow` straight away — login is NOT checked
  /// here. Android does the same: `CartFragment.proceedToCheckout` calls the API
  /// first and only consults the login status once it comes back successful, in
  /// `checkLoginAndCheckout`. See [_openCheckoutOrLogin], which is that gate.
  void _startCheckout() async {
    //* this needs testing will add in next release
    //     context.showSnack(
    //       'Thanks for testing this but checkout is not for this release',
    //       status: SnackStatus.error,
    //     );
  }

  /// Buy Now hand-off from PDP: start checkout once the cart is loaded and
  /// non-empty. Deferred to after the frame so the cart is painted behind the
  /// sheet/login (Android posts it to the view for the same reason).
  void _onCartLoadedForBuyNow(CartState state) {
    if (state.cart?.items.isEmpty ?? true) return;
    _buyNowCheckoutStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startCheckout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      // Buy Now hand-off from PDP — fires only on the first load thanks to the
      // one-shot latch.
      listenWhen: (prev, curr) =>
          widget.fromBuyNow && !_buyNowCheckoutStarted && curr.isLoaded,
      listener: (context, state) => _onCartLoadedForBuyNow(state),
      child: Stack(
        children: [
          Scaffold(
            appBar: _CartAppBar(
              onEddPincodeTap: () => _onEddPincodeTap(context),
            ),
            body: _CartBody(
              priceSummaryKey: _priceSummaryKey,
              onPullToRefresh: () => _onPullToRefresh(context),
            ),
            bottomNavigationBar: _CartCheckoutBar(
              onDetailsTap: _scrollToPriceSummary,
              onCheckout: _startCheckout,
            ),
          ),
          const _CartUpdatingOverlay(),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// APP BAR
/// ─────────────────────────────────────────────────────────

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onEddPincodeTap;

  const _CartAppBar({required this.onEddPincodeTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      leadingWidth: 56,
      leading: GestureDetector(
        key: const ValueKey(CartTestStrings.appBarBackButton),
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.lgMd, right: AppSpacing.md),
          child: CustomImage(
            path: ImageConstants.arrowBack,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Text(
        CartStrings.bag,
        style: AppTypographyV1.titleMedium.bold.textPrimary(),
      ),
      actions: [
        BlocSelector<
          CartBloc,
          CartState,
          (bool, DeliveryPincodeEntity?, CartEntity?)
        >(
          selector: (state) =>
              (state.isLoading, state.cart?.deliveryPincode, state.cart),
          builder: (context, value) {
            final (isLoading, pincode, cartList) = value;

            if (isLoading) {
              return const _AppBarShimmer(width: 132, height: AppSpacing.md);
            }
            if ((cartList?.items ?? []).isEmpty) return const SizedBox.shrink();
            final label = (pincode?.pincode?.isNotEmpty ?? false)
                ? '${pincode?.pincodeMessage ?? CartStrings.deliverTo} ${pincode!.pincode}'
                : CartStrings.enterPincodeForEdd;
            return GestureDetector(
              onTap: onEddPincodeTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: AppTypographyV1.labelLarge.medium.neutralGrey6(),
                    ),
                    AppSpacing.horizontalGapXxs,
                    const CustomImage(
                      path: ImageConstants.arrowDown,
                      height: AppSpacing.iconMd,
                      width: AppSpacing.iconMd,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        BlocSelector<CartBloc, CartState, bool>(
          selector: (state) => state.isLoading,
          builder: (context, isLoading) {
            if (isLoading) {
              return const Padding(
                padding: EdgeInsets.only(left: 2),
                child: _AppBarShimmer(
                  width: AppSpacing.iconSm,
                  height: AppSpacing.iconSm,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppSpacing.iconSm),
                  ),
                ),
              );
            }
            return BadgeIcon(
              key: const ValueKey(PlpTestStrings.appBarWishlistButton),
              iconSize: AppSpacing.iconSm,
              icon: const Padding(
                padding: EdgeInsets.only(left: 2, top: 5, bottom: 5),
                child: CustomImage(
                  path: ImageConstants.heart,
                  width: AppSpacing.iconSm,
                  height: AppSpacing.iconSm,
                ),
              ),
              count: 0,
              onTap: () {},
              iconColor: AppColors.textPrimary,
            );
          },
        ),
        AppSpacing.horizontalGapSm,
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 2, color: AppColors.neutralGrey1),
      ),
    );
  }
}

class _AppBarShimmer extends StatelessWidget {
  const _AppBarShimmer({
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.borderRadiusXs,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Shimmer.fromColors(
        baseColor: AppColors.neutralGrey2,
        highlightColor: AppColors.neutralGrey1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// BODY — loading / error / empty / content states
/// ─────────────────────────────────────────────────────────

class _CartBody extends StatelessWidget {
  final GlobalKey priceSummaryKey;
  final Future<void> Function() onPullToRefresh;

  const _CartBody({
    required this.priceSummaryKey,
    required this.onPullToRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (prev, curr) =>
          (curr.toastMessage != null &&
              curr.toastMessage != prev.toastMessage) ||
          (curr.promoActionSheet != null &&
              curr.promoActionSheet != prev.promoActionSheet),
      listener: (context, state) {
        final cartBloc = context.read<CartBloc>();

        if (state.toastMessage.isNotNullOrEmpty) {
          context.showSnack(
            state.toastMessage!,
            status: state.toastIsError
                ? SnackStatus.error
                : SnackStatus.success,
            duration: state.toastDuration,
          );
          cartBloc.add(const ClearToast());
        }

        // Backend-authored sheet returned by a promo apply/remove.
        if (state.promoActionSheet != null) {
          final sheet = state.promoActionSheet!;
          cartBloc.add(const ClearPromoActionSheet());
          showPromoActionSheet(context, sheet);
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CartShimmerLoading();
          }

          if (state.isError) {
            return ErrorRetryWidget(
              message: state.errorMessage ?? CommonStrings.somethingWentWrong,
              onRetry: () => context.read<CartBloc>().add(const LoadCart()),
            );
          }

          if (!state.isLoaded) {
            return const SizedBox.shrink();
          }

          final cart = state.cart!;
          final hasMergePrompt =
              cart.isCartItemExistInTemp && cart.messageBars.isNotEmpty;
          if (cart.items.isEmpty && !hasMergePrompt) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.height * 0.1),
              child: EmptyStateWidget(
                type: EmptyStateType.cart,
                onButtonTap: () => AppNavigator.goToHome(context),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: onPullToRefresh,
            child: _CartContent(state: state, priceSummaryKey: priceSummaryKey),
          );
        },
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// BOTTOM CHECKOUT BAR
/// ─────────────────────────────────────────────────────────

class _CartCheckoutBar extends StatelessWidget {
  final VoidCallback? onDetailsTap;
  final VoidCallback onCheckout;

  const _CartCheckoutBar({
    required this.onDetailsTap,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (!state.isLoaded || state.cart!.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final cart = state.cart!;
        return CartCheckoutBar(
          itemCount: cart.items.length,
          orderSummary: cart.orderSummary,
          isLoading: state.isCheckoutLoading,
          onDetailsTap: cart.orderSummary != null ? onDetailsTap : null,
          onCheckout: onCheckout,
        );
      },
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// UPDATING OVERLAY — blocks interaction during cart mutations
/// ─────────────────────────────────────────────────────────

class _CartUpdatingOverlay extends StatelessWidget {
  const _CartUpdatingOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, bool>(
      selector: (state) => state.isCartUpdating,
      builder: (context, isCartUpdating) {
        if (!isCartUpdating) return const SizedBox.shrink();
        return Positioned.fill(
          child: AbsorbPointer(
            child: Container(
              // The cart content stays visible (just dimmed) underneath —
              // matches the design's light scrim rather than an opaque
              // black block-out.
              color: Colors.black.withValues(alpha: 0.4),
              child: const Center(
                child: SizedBox(
                  width: AppSpacing.iconMd,
                  height: AppSpacing.iconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation(
                      AppColors.progressActive,
                    ),
                    backgroundColor: AppColors.progressTrack,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ─────────────────────────────────────────────────────────
/// CART CONTENT — items + promo + summary (non-empty cart only)
/// ─────────────────────────────────────────────────────────

class _CartContent extends StatelessWidget {
  final CartState state;
  final GlobalKey priceSummaryKey;

  const _CartContent({required this.state, required this.priceSummaryKey});

  // Same login-gate + resume-in-place shape as CartActions.add /
  // WishlistActions.toggle: stash the code on CartBloc (already app-root
  // scoped, so it survives the login push/pop) and replay it from
  // AppNavigator.redirectAfterLogin once signed in.
  void _applyPromoCode(BuildContext context, String code) {
    final cartBloc = context.read<CartBloc>();
    final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
    if (!loggedIn) {
      //* this needs testing will add in next release
      return;
    }
    cartBloc.add(ApplyPromoCode(promoCode: code));
  }

  /// Same login-gate + resume-in-place shape as [_applyPromoCode] and
  /// `WishlistActions.toggle`: stash the intent on CartBloc (app-root scoped,
  /// so it survives the login push/pop) and let
  /// `AppNavigator.redirectAfterLogin` replay it once signed in.
  ///
  /// It cannot go through `WishlistActions.toggle` — that drives the global
  /// wishlist store, whereas moving from the cart hits an endpoint that also
  /// drops the line from the cart.
  void _moveToWishlist(BuildContext context, MoveToWishlist event) {
    final cartBloc = context.read<CartBloc>();
    final loggedIn = context.read<AccountBloc>().state.account.isLoggedIn;
    if (!loggedIn) {
      cartBloc.setPendingMoveToWishlist(event);
      AppNavigator.goToLogin(
        context,
        redirectType: LoginRedirects.typeAddToWishlist,
      );
      return;
    }
    cartBloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    final cart = state.cart;
    if (cart == null) return const SizedBox.shrink();
    // A plain SingleChildScrollView + Column (not ListView) lays out every
    // child immediately — ListView's sliver machinery only lays out children
    // within the viewport + cache extent, so Scrollable.ensureVisible (used
    // by the checkout bar's "Details" tap) could silently no-op on a section
    // that hasn't been laid out yet.
    return SingleChildScrollView(
      // RefreshIndicator needs an always-scrollable physics to register the
      // pull gesture even when the cart's content is shorter than the
      // viewport (e.g. only 1-2 items).
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          if (cart.messageBars.isNotEmpty)
            // Message bars with merge action support
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                right: AppSpacing.sm,
              ),
              child: MessageBarsWidget(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                messageBars: cart.messageBars,
                onAction: (actionLink, _) {
                  //* this needs testing will add in next release
                },
              ),
            ),

          if (cart.giftCardItem != null)
            GiftCardBanner(giftCardItem: cart.giftCardItem!),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cart.items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return CartItemWidget(
                key: ValueKey(item.sku),
                item: item,
                hasMessageBars: cart.messageBars.isNotEmpty,
                isLoading: state.isItemBusy(item.sku),
                isMovingToWishlist: state.isMovingToWishlist(item.sku),
                onQuantityChanged: (qty) => context.read<CartBloc>().add(
                  UpdateCartItemQuantity(
                    sku: item.sku ?? '',
                    quantity: qty,
                    itemIndex: index,
                  ),
                ),
                onRemove: () =>
                    showRemoveCartItemSheet(context, item.sku ?? ''),
                onMoveToWishlist: () => _moveToWishlist(
                  context,
                  MoveToWishlist(
                    sku: item.sku ?? '',
                    productId: item.productId,
                    price: item.priceInfo?.absoluteValue,
                  ),
                ),
              );
            },
          ),

          // Promo code section
          if (cart.items.isNotEmpty) ...{
            AppSpacing.verticalGapLMd,
            CartPromoSection(
              promotionData: cart.promotionData,
              isLoading: state.isPromoLoading,
              onApply: (code) => _applyPromoCode(context, code),
              onRemove: () => context.read<CartBloc>().add(
                RemovePromoCode(promoCode: cart.promotionData?.promoCode ?? ''),
              ),
              onSeeAllOffers: () async {
                final cartBloc = context.read<CartBloc>();
                final cartChanged = await PromoOffersBottomSheet.show(context);
                if (cartChanged) cartBloc.add(const LoadCart());
              },
            ),
          },

          // Price summary
          if (cart.items.isNotEmpty && cart.orderSummary != null) ...[
            AppSpacing.verticalGapLMd,
            KeyedSubtree(
              key: priceSummaryKey,
              child: PriceSummaryWidget(summary: cart.orderSummary!),
            ),
          ],

          // Bottom message bars (backend-driven, e.g. credits-available note)
          if (cart.bottomMessageBars.isNotEmpty) ...[
            AppSpacing.verticalGapXl,
            Padding(
              padding: AppSpacing.paddingHorizontalSm,
              child: MessageBarsWidget(
                textStyle: AppTypographyV1.labelLarge.regular.copyWith(
                  color: AppColors.neutralGrey6,
                ),
                iconSize: (24, 24),
                messageBars: cart.bottomMessageBars,
                cardStyle: true,
              ),
            ),
          ],
          if (cart.items.isNotEmpty &&
              cart.serviceLevelGuarantee.isNotEmpty) ...{
            if (cart.bottomMessageBars.isEmpty) ...{
              const SizedBox(height: AppSpacing.md),
            },
            SlgWidget(items: cart.serviceLevelGuarantee),
          },
          AppSpacing.verticalGapSm,
        ],
      ),
    );
  }
}
