import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../bloc/pdp_bloc.dart';
import '../widgets/pdp_appbar.dart';
import '../widgets/pdp_fly_to_cart_overlay.dart';
import '../widgets/pdp_brand_price.dart';
import '../widgets/pdp_color_variants.dart';
import '../widgets/pdp_delivery_info.dart';
import '../widgets/pdp_offers.dart';
import '../widgets/pdp_image_carousel.dart';
import '../widgets/pdp_recently_viewed.dart';
import '../widgets/pdp_recommended_products.dart';
import '../widgets/pdp_size_chart_bottom_sheet.dart';
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

  // Fly-to-cart animation anchors: source is the product image area, target is
  // the app-bar bag icon. Mirrors Android's AddToBagAnimationHandler.
  final _carouselKey = GlobalKey();
  final _cartIconKey = GlobalKey();

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
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final barHeight = dockedBox.size.height - AppSpacing.md * 2;
    final floatingTopY = screenH - bottomInset - AppSpacing.sm - barHeight;
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

  // The single page scroll position, handed to the carousel so a vertical drag
  // on the image can be forwarded straight into it — the image and content then
  // move through one native scroll. Null until the scroll view is laid out.
  ScrollPosition? _pageScrollPosition() => _pageScroll.hasClients ? _pageScroll.position : null;

  // Flies the product image from the carousel to the app-bar bag icon, matching
  // Android's AddToBagAnimationHandler. Uses the first media URL (never a
  // screenshot); no-op when the product has no image. The badge count itself is
  // bumped independently by PdpBloc via CartCountCubit.
  void _playFlyToCart(List<MediaEntity> media) {
    final imageUrl = media.isNotEmpty ? media.first.url : null;
    if (imageUrl == null) return;
    PdpFlyToCartOverlay.show(
      context,
      imageUrl: imageUrl,
      sourceKey: _carouselKey,
      targetKey: _cartIconKey,
    );
  }

  void _handleBack() => AppNavigator.goBack(context);

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

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final carouselH = screenW / PdpStrings.imageAspectRatio;
          // App bar turns white once the image has largely scrolled off the top.
          final whiteThreshold = (carouselH - PdpStrings.appBarHeight).clamp(0.0, carouselH);

          return Stack(
            key: _stackKey,
            children: [
              // The whole page is ONE CustomScrollView: the carousel is the top
              // sliver and scrolls away with the content below it (single
              // controller, single continuous scroll). No overscroll bounce.
              ColoredBox(
                color: AppColors.baseDefault,
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

                        if (widget.state.productDetail?.recentlyViewed != null)
                          PdpRecentlyViewed(
                            recentlyViewed: widget.state.productDetail!.recentlyViewed!,
                          ),
                      ]),
                    ),
                    // Recommendations render as their own sliver so the
                    // grid builds lazily, one row at a time.
                    if (widget.state.recommendations != null)
                      PdpRecommendedProducts(
                        recommendations: widget.state.recommendations!,
                        isLoadingMore: widget.state.isLoadingMoreRecommendations,
                      ),
                  ],
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
            ],
          );
        },
      ),
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
    Widget tree = ClipRect(
      child: AnimatedBuilder(
        animation: scroll,
        builder: (context, child) => Align(
          alignment: alignment,
          child: Transform.translate(
            offset: Offset(0, dyForOffset(scroll.hasClients ? scroll.offset : 0.0)),
            child: child,
          ),
        ),
        child: child,
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
