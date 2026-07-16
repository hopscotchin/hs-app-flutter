import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/strings/pdp_strings.dart';
import '../../../../core/navigation/app_share_launcher.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/wishlist_actions.dart';
import '../bloc/pdp_bloc.dart';
import '../widgets/pdp_appbar.dart';
import '../widgets/pdp_brand_price.dart';
import '../widgets/pdp_color_variants.dart';
import '../widgets/pdp_image_carousel.dart';

const double _kSheetRadius = 20.0;
// AppBar content height within SafeArea: vertical padding ×2 + icon. Shares
// PdpStrings.appBarVerticalPadding with PdpAppBar's own Padding so this never
// drifts out of sync with the appbar's actual rendered height.
const double _kAppBarH = PdpStrings.appBarVerticalPadding * 2 + AppSpacing.iconSm;

class PdpContent extends StatefulWidget {
  const PdpContent({super.key, required this.state});

  final PdpState state;

  @override
  State<PdpContent> createState() => _PdpContentState();
}

class _PdpContentState extends State<PdpContent> {
  final _sheetController = DraggableScrollableController();

  double _minSize = 0.3;
  double _maxSize = 0.95;

  // Guards against re-seeding the global WishlistCubit on every rebuild —
  // only seed again when the displayed product actually changes (e.g. after
  // switching color variants, which loads a different product id).
  String? _seededWishlistProductId;

  @override
  void initState() {
    super.initState();
    _seedWishlist();
  }

  @override
  void didUpdateWidget(PdpContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seedWishlist();
  }

  @override
  void dispose() {
    _sheetController.dispose();
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

  void _expandSheet() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        _maxSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _collapseSheet() {
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        _minSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Single back handler for both the app-bar back button and the system back
  // gesture — mirrors Android's ProductDetailActivity, where the toolbar back
  // and the OnBackPressedDispatcher both route through
  // SheetAnimationHandler.onBackPressed(). When the sheet is expanded, the
  // first back press collapses it instead of leaving the screen; only a
  // collapsed sheet allows the pop.
  void _handleBack() {
    if (_sheetController.isAttached && _sheetController.size > _minSize + 0.02) {
      _collapseSheet();
    } else {
      Navigator.of(context).pop();
    }
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
    );

    return SafeArea(
      bottom: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _handleBack();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenH = constraints.maxHeight;
            final screenW = constraints.maxWidth;
            final carouselH = screenW / PdpStrings.imageAspectRatio;
            final peekH = (screenH - carouselH + PdpStrings.sheetCarouselOverlap).clamp(
              80.0,
              screenH * 0.9,
            );
            final minSize = (peekH / screenH).clamp(0.1, 0.95);
            final maxSize = ((screenH - _kAppBarH) / screenH).clamp(minSize + 0.01, 0.99);

            _minSize = minSize;
            _maxSize = maxSize;

            return Stack(
              children: [
                PdpImageCarousel(
                  media: product.media,
                  visualCue: product.visualCue,
                  onLastImageOverscroll: _expandSheet,
                ),
                DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: minSize,
                  minChildSize: minSize,
                  maxChildSize: maxSize,
                  snap: true,
                  snapSizes: [minSize, maxSize],
                  builder: (context, scrollController) {
                    return ListenableBuilder(
                      listenable: _sheetController,
                      builder: (context, child) {
                        final expansion = _sheetController.isAttached
                            ? ((_sheetController.size - minSize) / (maxSize - minSize)).clamp(
                                0.0,
                                1.0,
                              )
                            : 0.0;
                        final radius = _kSheetRadius * (1.0 - expansion);
                        final borderRadius = BorderRadius.vertical(top: Radius.circular(radius));
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                blurRadius: 18.5,
                                offset: Offset(0, -1),
                              ),
                            ],
                          ),
                          child: ClipRRect(borderRadius: borderRadius, child: child),
                        );
                      },
                      child: ColoredBox(
                        color: AppColors.baseDefault,
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          children: [
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
                PdpAppBar(
                  sheetController: _sheetController,
                  minSize: minSize,
                  maxSize: maxSize,
                  onBack: _handleBack,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
