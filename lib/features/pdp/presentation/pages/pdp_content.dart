import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/login_redirects.dart';
import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/entities/message_bar_entity.dart';
import '../../../../core/navigation/app_share_launcher.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../pincode/presentation/widgets/pincode_bottom_sheet.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/wishlist_actions.dart';
import '../../domain/entities/media_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/pdp_bloc.dart';
import '../widgets/pdp_add_to_bag_bar.dart';
import '../widgets/pdp_appbar.dart';
import '../widgets/pdp_brand_price.dart';
import '../widgets/pdp_color_variants.dart';
import '../widgets/pdp_delivery_info.dart';
import '../widgets/pdp_fly_to_cart_overlay.dart';
import '../widgets/pdp_image_carousel.dart';
import '../widgets/pdp_offers.dart';
import '../widgets/pdp_product_details.dart';
import '../widgets/pdp_recently_viewed.dart';
import '../widgets/pdp_recommended_products.dart';
import '../widgets/pdp_scroll_to_top.dart';
import '../widgets/pdp_size_chart_bottom_sheet.dart';
import '../widgets/pdp_size_selection_bottom_sheet.dart';
import '../widgets/pdp_size_selector.dart';

const double _kSheetRadius = 20.0;
const BorderRadius _kSheetBorderRadius = BorderRadius.vertical(top: Radius.circular(_kSheetRadius));
const List<BoxShadow> _kSheetShadow = [
  BoxShadow(color: Color(0x40000000), blurRadius: 18.5, offset: Offset(0, -1)),
];
// Headroom above the lip for its upward shadow. The lip is bottom-aligned in a
// box this much taller and clipped, so the shadow falls onto the image above
// but is cut off at the lip's bottom edge — otherwise it draws a visible seam
// line across the content below.
const double _kSheetShadowPad = 24.0;

class PdpContent extends StatefulWidget {
  const PdpContent({super.key, required this.state});

  final PdpState state;

  @override
  State<PdpContent> createState() => _PdpContentState();
}

class _PdpContentState extends State<PdpContent> {
  // The whole PDP is ONE CustomScrollView driven by this single controller —
  // the image and the content scroll as one page (no separate sheet).
  final _pageScroll = ScrollController();

  // Key on the docked (in-page) add-to-bag bar, right below product details,
  // and on the outer Stack so we can measure the bar's position relative to
  // it (a stable, screenH-tall coordinate space) rather than the physical
  // screen — SafeArea's top inset would otherwise throw off the comparison.
  final _dockedBarKey = GlobalKey();
  final _stackKey = GlobalKey();
  final _isBarDocked = ValueNotifier<bool>(false);

  // Guards against re-seeding the global WishlistCubit on every rebuild —
  // only seed again when the displayed product actually changes (e.g. after
  // switching color variants, which loads a different product id).
  String? _seededWishlistProductId;

  // Fly-to-cart animation anchors: the carousel key gives the flying image its
  // size (the flight itself starts screen-centered), the cart icon key is the
  // destination. Mirrors Android's AddToBagAnimationHandler.
  final _carouselKey = GlobalKey();
  final _cartIconKey = GlobalKey();

  // System nav/gesture inset, read once per dependency change instead of on
  // every scroll tick. _updateDockedBarVisibility runs on each tick and used to
  // do a MediaQuery lookup there; the value only changes when MediaQuery does,
  // which is exactly when didChangeDependencies fires. The floating bar's
  // resting position is derived from the same field so the two can never
  // disagree — that identity is what makes the docked/floating swap seamless.
  double _bottomInset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageScroll.addListener(_onPageScroll);
    _seedWishlist();
    // Covers the (unlikely but possible) case where the docked slot is
    // already on-screen at first layout, before any scroll fires the listener.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateDockedBarVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bottomInset = MediaQuery.viewPaddingOf(context).bottom;
  }

  @override
  void didUpdateWidget(PdpContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Color-variant switches keep this State alive but load a different
    // product — content above the docked bar (SKU count, offers, etc.) can
    // change height, so re-evaluate the docked state for the new product.
    final oldId = oldWidget.state.productDetail?.product?.id;
    final newId = widget.state.productDetail?.product?.id;
    if (oldId != newId) {
      _isBarDocked.value = false;
    }
    _seedWishlist();
  }

  @override
  void dispose() {
    _pageScroll.removeListener(_onPageScroll);
    _pageScroll.dispose();
    _isBarDocked.dispose();
    super.dispose();
  }

  // Seeds the global WishlistCubit with this product's server-known wishlist
  // status — same role WishlistStatusBuilder plays for PLP tiles, adapted for
  // a single-product page. Keeps the app-bar heart and the price-row heart in
  // sync via one shared source of truth.
  void _seedWishlist() {
    final product = widget.state.productDetail?.product;
    final id = product?.id?.toString();
    if (id == null || id == _seededWishlistProductId) return;
    _seededWishlistProductId = id;

    final wishlistInfo = product!.wishlistInfo;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WishlistCubit>().seed([
        WishlistSeed(
          productId: id,
          wished: wishlistInfo?.isWishlisted == true,
          wishlistItemId: wishlistInfo?.id?.toString(),
        ),
      ]);
    });
  }

  void _onPageScroll() {
    if (!mounted || !_pageScroll.hasClients) return;
    _updateDockedBarVisibility();
    final pos = _pageScroll.position;
    if (pos.pixels < pos.maxScrollExtent - 300) return;
    final bloc = context.read<PdpBloc>();
    if (!bloc.state.isLoadingMoreRecommendations &&
        bloc.state.recommendations?.pageMeta?.hasNextPage == true) {
      bloc.add(const PdpEvent.loadMoreRecommendations());
    }
  }

  // Toggles between the floating overlay bar and the docked in-page bar so
  // exactly one is ever painted (both are gated on _isBarDocked).
  //
  // The swap fires the instant the docked slot's TOP reaches the floating
  // bar's resting TOP (floatingTopY). That's the one scroll position where
  // the two bars would occupy the identical spot, so hiding the floating bar
  // and painting the docked bar at that instant is a pixel-for-pixel swap —
  // no gap, no jump, no fade. The docked slot always reserves its space (see
  // Visibility.maintainSize on it), so its position is measurable even while
  // it's not yet painted, and the swap-in never shifts surrounding content.
  //
  // Measures the docked bar's actual on-screen position each time (rather than
  // a cached scroll offset) so it stays correct regardless of content-height
  // changes above it.
  void _updateDockedBarVisibility() {
    final dockedBox = _dockedBarKey.currentContext?.findRenderObject() as RenderBox?;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (dockedBox == null || !dockedBox.attached || stackBox == null || !stackBox.attached) {
      return;
    }

    final dockedTopY = dockedBox.localToGlobal(Offset.zero, ancestor: stackBox).dy;
    // The floating bar sits AppSpacing.sm + bottom inset above the screen
    // bottom, its top a bar-height higher still. The Stack fills the SafeArea,
    // so its height is the usable viewport; the bottom inset comes from
    // MediaQuery. The docked slot's own vertical padding (md, top+bottom) is
    // inside its measured box, so offset the top edge past that padding to land
    // on the actual button row.
    final screenH = stackBox.size.height;
    final barHeight = dockedBox.size.height - AppSpacing.md * 2;
    final floatingTopY = screenH - _bottomInset - AppSpacing.sm - barHeight;
    // dockedTopY is the padded box top; the button row starts one md below it.
    final dockedContentTopY = dockedTopY + AppSpacing.md;

    // Pure position threshold — the SAME boundary in both directions, so the
    // swap is seamless whichever way you scroll. A hysteresis band here would
    // hold the docked bar a few px past floatingTopY on the way back up, then
    // the floating bar would snap to floatingTopY = a visible upward jump. No
    // flicker risk: the docked and floating bars are the identical widget at
    // the identical position at the boundary, and ValueNotifier no-ops when
    // the value is unchanged.
    _isBarDocked.value = dockedContentTopY <= floatingTopY;
  }

  void _scrollToTop() {
    if (_pageScroll.hasClients) {
      _pageScroll.animateTo(0, duration: const Duration(milliseconds: 700), curve: Curves.easeOut);
    }
  }

  // The single page scroll position, handed to the carousel so a vertical drag
  // on the image can be forwarded straight into it — the image and content then
  // move through one native scroll. Null until the scroll view is laid out.
  ScrollPosition? _pageScrollPosition() => _pageScroll.hasClients ? _pageScroll.position : null;

  // Flies the product image from the carousel to the app-bar bag icon, matching
  // Android's AddToBagAnimationHandler. Uses the first media URL (never a
  // screenshot); no-op when the product has no image. The badge count itself is
  // bumped independently by PdpBloc via CartCountCubit.
  //
  // Only ever called from the success-tick listeners below, so the flight
  // represents a server-confirmed add — a failed call shows the error snackbar
  // and no animation. Covers all four entry points (the bar's Add to Bag and Buy
  // Now buttons and the size sheet's equivalents), since each pair lands on the
  // same bloc event.
  //
  // [onComplete] runs when the flight finishes. Buy Now uses it to hand off to
  // the cart, matching Android, where `AddToBagAnimationHandler`'s end-listener
  // is what calls `goToCart(fromBuyNow = true)` — the navigation waits for the
  // animation rather than racing it.
  void _playFlyToCart(List<MediaEntity> media, {VoidCallback? onComplete}) {
    final imageUrl = media.isNotEmpty ? media.first.url : null;
    if (imageUrl == null) {
      onComplete?.call();
      return;
    }
    PdpFlyToCartOverlay.show(
      context,
      imageUrl: imageUrl,
      // Size only — the flight starts at the screen center regardless of how far
      // the page has scrolled, so it stays visible even with the carousel gone.
      sourceSizeKey: _carouselKey,
      targetKey: _cartIconKey,
      onComplete: onComplete,
    );
  }

  // Buy Now's tail end: the same fly-to-cart flight as Add to Bag, then straight
  // into the cart in buy-now mode, which proceeds to checkout on its own (and
  // routes through login first when logged out).
  void _handleBuyNowSuccess(List<MediaEntity> media) {
    _playFlyToCart(
      media,
      onComplete: () {
        if (mounted) AppNavigator.goToCart(context, fromBuyNow: true);
      },
    );
  }

  void _handleBack() => AppNavigator.goBack(context);

  // Shared bar content for both the floating overlay and the docked in-page
  // copy — same Bloc state, same handlers.
  Widget _buildAddToBagBar(
    ProductEntity product, {
    required Key addToBagKey,
    required Key buyNowKey,
  }) {
    return BlocBuilder<PdpBloc, PdpState>(
      buildWhen: (prev, curr) =>
          prev.isAddingToBag != curr.isAddingToBag ||
          prev.isBuyingNow != curr.isBuyingNow ||
          prev.selectedSku != curr.selectedSku,
      builder: (context, state) => PdpAddToBagBar(
        addToBagKey: addToBagKey,
        buyNowKey: buyNowKey,
        soldOut: product.soldOut == true,
        isAddingToBag: state.isAddingToBag,
        isBuyingNow: state.isBuyingNow,
        isAddedToBag: state.selectedSku?.isAddedToBag == true,
        onAddToBag: () {
          final sku = state.selectedSku;
          if (sku == null) {
            showPdpSizeSelectionBottomSheet(context, fromBuyNow: false);
          } else if (sku.isAddedToBag == true) {
            // Button reads "Go to Bag" once this SKU was added —
            // navigate to cart instead of re-adding (matches Android).
            AppNavigator.goToCart(context);
          } else {
            // No animation here — it plays from the addToBagSuccessTick
            // listener once the API confirms the add.
            context.read<PdpBloc>().add(PdpEvent.addToBag(skuId: sku.skuId!));
          }
        },
        onBuyNow: () {
          // Fires on tap, BEFORE any network call, and even when this only opens
          // the size sheet — matching Android, where `sendEventBuyNowClicked`
          // runs before `addToCart` (`ProductDetailActivity.kt:205`).
          // context.read<PdpAnalyticsTracker>().onBuyNowTapped();
          // final skuId = state.selectedSku?.skuId;
          // if (skuId != null) {
          //   context.read<PdpBloc>().add(PdpEvent.buyNow(skuId: skuId));
          // } else {
          //   showPdpSizeSelectionBottomSheet(context, fromBuyNow: true);
          // }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.state.productDetail?.product;
    if (product == null) return const SizedBox.shrink();

    final productId = product.id?.toString() ?? '';
    final wishlistPrice = WishlistActions.priceToInt(product.priceInfo?.sellingPrice);
    void toggleWishlist() => WishlistActions.toggle(
      context,
      productId: productId,
      price: wishlistPrice,
      sku: widget.state.selectedSku?.skuId,
      loggedOutMessageBars: const [
        MessageBarEntity(text: LoginRedirects.redirectWishlistItem, type: 'info', hasIcon: true),
      ],
    );

    final content = SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final carouselH = screenW / PdpStrings.imageAspectRatio;
          // App bar turns white once the image has largely scrolled off the top.
          final whiteThreshold = (carouselH - PdpStrings.appBarHeight).clamp(0.0, carouselH);

          // Outer SafeArea has bottom: false, so lift the floating bar and
          // scroll-to-top pill above the system nav/gesture inset. Same cached
          // value _updateDockedBarVisibility measures against.
          final bottomInset = _bottomInset;

          return Stack(
            key: _stackKey,
            children: [
              // The whole page is ONE CustomScrollView: the carousel is the top
              // sliver and scrolls away with the content below it (single
              // controller, single continuous scroll). No overscroll bounce.
              ColoredBox(
                color: AppColors.baseDefault,
                // The docked/floating swap depends on where the docked slot
                // sits, which content above it can move WITHOUT any scrolling —
                // collapsing a product-details tab pulls it up by the tab's
                // whole height. Scroll ticks alone would miss that and leave the
                // floating bar painted over the gap until the next drag, which
                // then looked like the bar jumping. ScrollMetricsNotification
                // fires whenever the metrics change without a scroll, including
                // on every frame of the 300ms expand/collapse, so the swap
                // tracks the animation instead of trailing it.
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    if (notification.depth != 0) return false;
                    _updateDockedBarVisibility();
                    return false;
                  },
                  child: CustomScrollView(
                    controller: _pageScroll,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      // Space reserved for the carousel, which is layered on top
                      // of this scroll view rather than being a sliver in it (see
                      // the carousel overlay below). Childless, so it has no hit
                      // target of its own.
                      SliverToBoxAdapter(child: SizedBox(height: carouselH)),
                      // Content — the fixed sections build eagerly in a list
                      // delegate; recommendations follow as a lazy sliver.
                      SliverList(
                        delegate: SliverChildListDelegate([
                          BlocSelector<WishlistCubit, WishlistState, bool>(
                            selector: (s) => s.isWishlisted(productId),
                            builder: (context, wished) => PdpBrandPrice(
                              product: product,
                              skuPrice: widget.state.selectedSku?.priceInfo,
                              isWishlisted: wished,
                              onWishlistTap: toggleWishlist,
                              onShareTap: () => AppShareLauncher.shareProduct(product),
                            ),
                          ),
                          if (product.colorVariants.isNotEmpty)
                            PdpColorVariants(
                              colorVariants: product.colorVariants,
                              currentProductId: product.id,
                              onColorSelected: (productId) => context.read<PdpBloc>().add(
                                PdpEvent.selectColorVariant(productId: productId),
                              ),
                            ),
                          if (product.skus.isNotEmpty)
                            PdpSizeSelector(
                              skus: product.skus,
                              selectedSku: widget.state.selectedSku,
                              hasSizeChart: product.hasSizeChart == true,
                              onSizeSelected: (skuId) =>
                                  context.read<PdpBloc>().add(PdpEvent.selectSku(skuId: skuId)),
                              onSizeChartTap: () =>
                                  showPdpSizeChartBottomSheet(context, productName: product.name),
                            ),
                          // Delivery + EDD info are hidden when the product is
                          // sold out — mirrors Android (DeliveryInfoView / EddInfoView
                          // both gate on soldOut).
                          if (product.soldOut != true)
                            PdpDeliveryInfo(
                              eddInfo: widget.state.selectedSku?.eddInfo ?? product.eddInfo,
                              serviceGuarantees: product.serviceGuarantee,
                              pinCode: widget.state.verifiedPincode,
                              isSizeSelected: widget.state.selectedSku != null,
                              isSoldOut: product.soldOut == true,
                              onVerifyPincode: (pincode) async {
                                final bloc = context.read<PdpBloc>();
                                final startTick = bloc.state.pincodeVerifyTick;
                                bloc.add(PdpEvent.verifyPincode(pincode: pincode));
                                // The tick bumps once verify completes (success or
                                // failure); the error is null only on success.
                                final settled = await bloc.stream.firstWhere(
                                  (s) => s.pincodeVerifyTick != startTick,
                                );
                                final error = settled.pincodeVerifyError;
                                return error == null
                                    ? const PincodeVerifyResult.success()
                                    : PincodeVerifyResult.failure(error);
                              },
                            ),
                          if (widget.state.productDetail?.offersList.isNotEmpty == true)
                            PdpOffers(offers: widget.state.productDetail!.offersList),

                          if (product.details.isNotEmpty)
                            PdpProductDetails(
                              details: product.details,
                              expandedTabIndex: widget.state.expandedDetailTab,
                              selectedSku: widget.state.selectedSku,
                              skus: product.skus,
                              productPriceInfo: product.priceInfo,
                              onTabTapped: (index) => context.read<PdpBloc>().add(
                                PdpEvent.expandDetailTab(tabIndex: index),
                              ),
                            ),
                          // Docked bar — same widget, always occupying its slot in
                          // the flow right below product details (independent of
                          // whether the tabs rendered) so there's always a docking
                          // spot AND a stable box to measure. It only PAINTS once
                          // docked; Visibility.maintainSize keeps the slot reserved
                          // while hidden so measuring it stays valid and swapping in
                          // never shifts surrounding content. Exactly one of this and
                          // the floating overlay is ever painted (both gated on the
                          // same _isBarDocked flag), so the two are never on screen
                          // together.
                          KeyedSubtree(
                            key: _dockedBarKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _isBarDocked,
                                builder: (context, isDocked, child) => Visibility(
                                  visible: isDocked,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: child!,
                                ),
                                child: _buildAddToBagBar(
                                  product,
                                  addToBagKey: const ValueKey(PdpTestStrings.dockedAddToBagButton),
                                  buyNowKey: const ValueKey(PdpTestStrings.dockedBuyNowButton),
                                ),
                              ),
                            ),
                          ),
                          if (widget.state.productDetail?.recentlyViewed != null)
                            PdpRecentlyViewed(
                              recentlyViewed: widget.state.productDetail!.recentlyViewed!,
                            ),
                        ]),
                      ),
                      // Recommendations render as their own sliver so the
                      // grid builds lazily, one row at a time.
                      //
                      // Subscribed here rather than read off widget.state so that
                      // load-more — which fires from the scroll listener 300px
                      // before the bottom, i.e. mid-fling — rebuilds only this
                      // sliver. Taken off the page-level state it re-created every
                      // fixed section above (offers, details, delivery, recently
                      // viewed) in the middle of a scroll, twice per page: once for
                      // the spinner and once for the response. Null recommendations
                      // yield a zero-height sliver, which is what the absent
                      // conditional produced before and what PdpRecommendedProducts
                      // itself returns for an empty record list.
                      BlocBuilder<PdpBloc, PdpState>(
                        buildWhen: (prev, curr) =>
                            prev.recommendations != curr.recommendations ||
                            prev.isLoadingMoreRecommendations != curr.isLoadingMoreRecommendations,
                        builder: (context, state) {
                          final recommendations = state.recommendations;
                          if (recommendations == null) {
                            return const SliverToBoxAdapter(child: SizedBox.shrink());
                          }
                          return PdpRecommendedProducts(
                            recommendations: recommendations,
                            isLoadingMore: state.isLoadingMoreRecommendations,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Carousel — layered ON TOP of the scroll view, not inside it.
              // As a sliver it sat inside the CustomScrollView, so the outer
              // scroll view and the inner vertical PageView both competed for
              // the same vertical drag and the outer won — the carousel never
              // received the gesture and images could not be swiped at all.
              // Out here only the PageView sees drags on the image, while drags
              // on the content below reach the page scroll. Translating it by
              // the scroll offset keeps it locked to the space reserved above,
              // so it still scrolls away as one page.
              _PageScrollOverlay(
                scroll: _pageScroll,
                alignment: Alignment.topCenter,
                // Follows the page: translated up by exactly the scroll offset,
                // so it stays locked to the space reserved for it in the list.
                dyForOffset: (offset) => -offset,
                child: SizedBox(
                  height: carouselH,
                  width: double.infinity,
                  child: KeyedSubtree(
                    key: _carouselKey,
                    child: PdpImageCarousel(
                      media: product.media,
                      visualCue: product.visualCue,
                      pageScrollPosition: _pageScrollPosition,
                    ),
                  ),
                ),
              ),
              // Sheet lip — the rounded top + shadow that makes the content read
              // as a surface lifting over the image. It has to be an overlay
              // rather than part of the scroll view: within a CustomScrollView
              // earlier slivers paint ON TOP of later ones, so the content could
              // never paint over the carousel. Painted here (above the scroll
              // view, below the app bar) its rounded corners reveal the image
              // behind it — a true overlap — and it tracks the content's top
              // edge as the page scrolls. ignorePointer so it never eats a drag.
              _PageScrollOverlay(
                scroll: _pageScroll,
                alignment: Alignment.topLeft,
                ignorePointer: true,
                // Content starts at carouselH in scroll space; lift the lip
                // sheetCarouselOverlap above it so it overlaps the image bottom.
                dyForOffset: (offset) => carouselH - PdpStrings.sheetCarouselOverlap - offset,
                child: const _SheetLip(key: ValueKey(PdpTestStrings.sheetLip)),
              ),
              PdpAppBar(
                scrollController: _pageScroll,
                whiteThreshold: whiteThreshold,
                onBack: _handleBack,
                cartIconKey: _cartIconKey,
              ),
              // Scroll-to-top pill — driven by the SAME flag as the floating
              // bar, inverted, so the two swap in the same frame and exactly
              // one of them is ever on screen. Sits 16px above the bar's
              // resting spot, which is where the docked bar is at the instant
              // of the swap, so the pill never overlaps it.
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset + AppSpacing.sm + PdpStrings.addToBagBarHeight + 16,
                child: Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isBarDocked,
                    builder: (context, isDocked, _) {
                      if (!isDocked) return const SizedBox.shrink();
                      return PdpScrollToTop(
                        key: const ValueKey(PdpTestStrings.scrollToTopButton),
                        onTap: _scrollToTop,
                      );
                    },
                  ),
                ),
              ),
              // Floating bar — last in Stack so it renders above everything else.
              // Hidden the instant the docked in-page copy reaches this exact
              // resting spot (see _updateDockedBarVisibility), shown again on
              // reverse scroll. No animation — the docked bar paints at the
              // identical position at that instant, so an instant swap has no
              // visible gap or jump. Exactly one of the two is ever painted.
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomInset + AppSpacing.sm,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isBarDocked,
                  builder: (context, isDocked, child) =>
                      isDocked ? const SizedBox.shrink() : child!,
                  // The bar carries a 37.7px blur shadow and sits in the same
                  // layer as the scroll view, so it was re-rastering on every
                  // scroll tick along with the page. Caching it as its own layer
                  // is layout-neutral.
                  child: RepaintBoundary(
                    child: _buildAddToBagBar(
                      product,
                      addToBagKey: const ValueKey(PdpTestStrings.addToBagButton),
                      buyNowKey: const ValueKey(PdpTestStrings.buyNowButton),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return MultiBlocListener(
      listeners: [
        // Server-confirmed add-to-bag only: the tick bumps in the bloc's success
        // branch, so a failed call never animates (it just shows the error
        // snackbar) and the animation never runs ahead of the API.
        BlocListener<PdpBloc, PdpState>(
          listenWhen: (prev, curr) => prev.addToBagSuccessTick != curr.addToBagSuccessTick,
          listener: (_, _) => _playFlyToCart(product.media),
        ),
        // Same guarantee for buy-now, with the cart hand-off attached.
        BlocListener<PdpBloc, PdpState>(
          listenWhen: (prev, curr) => prev.buyNowSuccessTick != curr.buyNowSuccessTick,
          listener: (_, _) => _handleBuyNowSuccess(product.media),
        ),
      ],
      child: content,
    );
  }
}

/// A full-bleed overlay that follows the page scroll. Rebuilds only when
/// [scroll] ticks, translating its [child] vertically by [dyForOffset]. The
/// carousel and the sheet lip both ride the scroll this way. The ClipRect
/// confines the upward paint to this box (which sits inside the SafeArea): a
/// Stack only clips on layout overflow, not paint transforms, so without it the
/// translated content would bleed up past the app bar into the status bar.
class _PageScrollOverlay extends StatelessWidget {
  const _PageScrollOverlay({
    required this.scroll,
    required this.alignment,
    required this.dyForOffset,
    required this.child,
    this.ignorePointer = false,
  });

  final ScrollController scroll;
  final Alignment alignment;
  final double Function(double offset) dyForOffset;
  final bool ignorePointer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Both RepaintBoundaries are load-bearing for scroll smoothness; neither
    // affects layout (RenderRepaintBoundary is a proxy box) or hit testing.
    //
    // OUTER: Transform's offset setter calls markNeedsPaint, which dirties the
    // nearest enclosing repaint boundary. Without one here that is the route
    // itself, so every scroll tick re-rastered the whole PDP. This confines the
    // per-tick repaint to the overlay.
    //
    // INNER: Transform only allocates a TransformLayer when a descendant needs
    // compositing. A plain image/DecoratedBox does not, so the child was being
    // re-painted into the parent canvas each tick — for the sheet lip that meant
    // re-rasterising an 18.5px blur every frame. A boundary below the transform
    // makes the child a cached layer that the transform merely re-offsets.
    Widget tree = RepaintBoundary(
      child: ClipRect(
        child: AnimatedBuilder(
          animation: scroll,
          builder: (context, child) => Align(
            alignment: alignment,
            child: Transform.translate(
              offset: Offset(0, dyForOffset(scroll.hasClients ? scroll.offset : 0.0)),
              child: child,
            ),
          ),
          child: RepaintBoundary(child: child),
        ),
      ),
    );
    if (ignorePointer) tree = IgnorePointer(child: tree);
    return Positioned.fill(child: tree);
  }
}

/// The rounded top + shadow of the content sheet. One radius tall; the clipper
/// lets the shadow fall upward onto the image but cuts it off at the sheet's
/// bottom edge so it never draws a seam across the content below.
class _SheetLip extends StatelessWidget {
  const _SheetLip({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClipRect(
      clipper: _TopExtendedRect(_kSheetShadowPad),
      child: SizedBox(
        width: double.infinity,
        height: _kSheetRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.baseDefault,
            borderRadius: _kSheetBorderRadius,
            boxShadow: _kSheetShadow,
          ),
        ),
      ),
    );
  }
}

/// Clips to the child's bounds but extended upward by [topExtension], so an
/// upward shadow is kept while anything below the child is clipped away.
class _TopExtendedRect extends CustomClipper<Rect> {
  const _TopExtendedRect(this.topExtension);

  final double topExtension;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, -topExtension, size.width, size.height);

  @override
  bool shouldReclip(_TopExtendedRect oldClipper) => oldClipper.topExtension != topExtension;
}
