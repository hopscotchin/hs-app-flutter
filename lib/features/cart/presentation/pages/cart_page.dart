import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/app_bottom_sheet.dart';
import 'package:hs_app_flutter/components/atoms/badge_icon.dart';
import 'package:hs_app_flutter/components/atoms/custom_image.dart';
import 'package:hs_app_flutter/components/atoms/empty_state_widget.dart';
import 'package:hs_app_flutter/components/atoms/price_summary_widget.dart';
import 'package:hs_app_flutter/core/constants/image_constants.dart';
import 'package:hs_app_flutter/core/extensions/string_extensions.dart';
import 'package:hs_app_flutter/core/theme/colors.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/core/theme/typography/text_style_extensions.dart';
import 'package:hs_app_flutter/core/theme/typography/typography_v1.dart';
import 'package:hs_app_flutter/features/cart/domain/entities/delivery_pincode_entity.dart';
import 'package:hs_app_flutter/features/cart/presentation/widgets/cart_slg_widget.dart';
import 'package:hs_app_flutter/features/cart/presentation/widgets/gift_card_banner.dart';
import 'package:hs_app_flutter/features/pincode/presentation/widgets/pincode_bottom_sheet.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
        // Only rebuilds when the pincode itself changes — not on every
        // cart mutation (loading flags, toasts, item updates, etc.).
        BlocSelector<CartBloc, CartState, DeliveryPincodeEntity?>(
          selector: (state) => state.cart?.deliveryPincode,
          builder: (context, pincode) {
            final label = (pincode?.pincode?.isNotEmpty ?? false)
                ? '${pincode?.pincodeMessage ?? CartStrings.deliverTo} ${pincode!.pincode}'
                : CartStrings.enterPincodeForEdd;
            return GestureDetector(
              onTap: onEddPincodeTap,
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
            );
          },
        ),

        BadgeIcon(
          key: const ValueKey(PlpTestStrings.appBarWishlistButton),
          iconSize: AppSpacing.iconSm,
          icon: const CustomImage(
            path: ImageConstants.heart,
            width: AppSpacing.iconSm,
            height: AppSpacing.iconSm,
          ),
          count: 0,
          onTap: () {},
          iconColor: AppColors.textPrimary,
        ),
        AppSpacing.horizontalGapSm,
      ],
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
      // One-shot side effects (toast / promo sheet / checkout sheet) are
      // mutually exclusive per emission, so a single listener with an
      // if/else-if chain covers all three instead of three separate
      // BlocListeners each re-scanning every state change.
      listenWhen: (prev, curr) =>
          curr.toastMessage != null || curr.promoActionSheet != null,
      listener: (context, state) {
        final cartBloc = context.read<CartBloc>();

        if (state.toastMessage.isNotNullOrEmpty) {
          context.showSnack(
            state.toastMessage!,
            status: state.toastIsError
                ? SnackStatus.error
                : SnackStatus.success,
          );
          cartBloc.add(const ClearToast());
          return;
        }

        // Backend-authored sheet returned by a promo apply/remove — shown in
        // place of the toast, so it's cleared once presented.
        if (state.promoActionSheet != null) {
          final sheet = state.promoActionSheet!;
          cartBloc.add(const ClearPromoActionSheet());
          showPromoActionSheet(context, sheet);
          return;
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
          // An item-less cart is only worth rendering when there is still
          // something to act on: items pending merge from the temp cart, whose
          // "Update bag" message bar is the sole way to trigger that merge.
          //
          // Both halves are required. `isCartItemExistInTemp` alone is not
          // enough — the backend can leave it set on a genuinely empty cart
          // (e.g. right after the last line is moved to the wishlist), and
          // suppressing the empty state then leaves a blank page: the item
          // list is empty and promo / summary / SLG are all gated on
          // `items.isNotEmpty`.
          final hasMergePrompt =
              cart.isCartItemExistInTemp && cart.messageBars.isNotEmpty;
          if (cart.items.isEmpty && !hasMergePrompt) {
            return EmptyStateWidget(
              type: EmptyStateType.cart,
              onButtonTap: () => AppNavigator.goToHome(context),
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

/// Blocks all interaction on the page while any cart mutation (quantity
/// change, remove, move-to-wishlist, promo apply/remove, merge) and its
/// mandatory follow-up cart refresh is in flight.
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

  void _onRemoveItem(BuildContext context, String sku) {
    AppBottomSheet.show(
      context,
      title: CartStrings.removeItemsTitle,
      description: CartStrings.removeItemsDescription,
      primaryAction: AppBottomSheetAction(
        label: CartStrings.no,
        style: AppBottomSheetButtonStyle.filled,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      ),
      secondaryAction: AppBottomSheetAction(
        label: CommonStrings.remove,
        style: AppBottomSheetButtonStyle.outlined,
        buttonKey: const ValueKey(
          CartTestStrings.removeItemBottomSheetRemoveButton,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.read<CartBloc>().add(RemoveCartItem(sku: sku));
        },
      ),
    );
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
            padding: AppSpacing.paddingVerticalSm,
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return CartItemWidget(
                key: ValueKey(item.sku),
                item: item,
                isLoading: state.loadingItemSku == item.sku,
                onQuantityChanged: (qty) => context.read<CartBloc>().add(
                  UpdateCartItemQuantity(sku: item.sku ?? '', quantity: qty),
                ),
                onRemove: () => _onRemoveItem(context, item.sku ?? ''),
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
          if (cart.items.isNotEmpty)
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

          // Price summary
          if (cart.items.isNotEmpty && cart.orderSummary != null) ...[
            AppSpacing.verticalGapLg,
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
            AppSpacing.verticalGapSm,
          },
        ],
      ),
    );
  }
}
