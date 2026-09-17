import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/appbar/hs_appbar.dart';
import '../../../../components/atoms/badge_icon.dart';
import '../../../../components/atoms/custom_image.dart';
import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/product_grid_shimmer.dart';
import '../../../../components/page_components/size_chart_bottom_sheet.dart';
import '../../../../components/page_components/size_selection_bottom_sheet.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/constants/strings/wishlist_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../pdp/presentation/bloc/size_chart_bloc.dart';
import '../../domain/entities/wishlist_product_entity.dart';
import '../bloc/wishlist_listing_bloc.dart';
import '../widgets/wishlist_grid.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // ponytail: bail before dispatch when nothing to load — the bloc guards
    // too, but this stops per-frame event allocation while scrolling.
    final bloc = context.read<WishlistListingBloc>();
    final s = bloc.state;
    if (s.isLoadingMore || s.hasReachedEnd || s.status != WishlistStatus.success) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll * 0.9) {
      bloc.add(const LoadNextWishlistPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      appBar: HsAppbar(
        title: WishlistStrings.title,
        actions: const [_CartAction()],
      ),
      body: SafeArea(
        top: false,
        child: BlocListener<WishlistListingBloc, WishlistListingState>(
          listenWhen: (prev, curr) =>
              curr.message != null && curr.message != prev.message,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
            context.read<WishlistListingBloc>().add(
              const ClearWishlistMessage(),
            );
          },
          child: BlocBuilder<WishlistListingBloc, WishlistListingState>(
            // Skip rebuilds driven by processingIds / message — those affect
            // one tile's spinner (handled by the tile's own selector) or the
            // snackbar (handled by the listener above). Only structural
            // changes redraw the grid.
            buildWhen: (p, c) =>
                p.status != c.status ||
                !identical(p.page, c.page) ||
                p.isLoadingMore != c.isLoadingMore,
            builder: (context, state) {
              switch (state.status) {
                case WishlistStatus.initial:
                case WishlistStatus.loading:
                  // Same grid placeholder as PLP, plus a bar for the
                  // "Move to Bag" CTA the wishlist tile carries.
                  return const ProductGridShimmer(showCtaBar: true);

                case WishlistStatus.error:
                  return EmptyStateWidget(
                    type: EmptyStateType.serverError,
                    onButtonTap: () => context.read<WishlistListingBloc>().add(
                      const LoadWishlist(),
                    ),
                  );

                case WishlistStatus.success:
                  if (state.items.isEmpty) {
                    return EmptyStateWidget(
                      type: EmptyStateType.wishlist,
                      onButtonTap: () => AppNavigator.goToHome(context),
                    );
                  }
                  return _WishlistBody(
                    state: state,
                    scrollController: _scrollController,
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Bag icon with live cart count, mirroring the PDP / PLP app bar action.
class _CartAction extends StatelessWidget {
  const _CartAction();

  @override
  Widget build(BuildContext context) {
    return BadgeIcon(
      iconSize: AppSpacing.iconSm,
      icon: const CustomImage(
        path: ImageConstants.bag,
        height: AppSpacing.iconSm,
        width: AppSpacing.iconSm,
      ),
      count: context.watch<CartCountCubit>().state,
      padding: EdgeInsets.zero,
      iconColor: AppColors.textPrimary,
      onTap: () => AppNavigator.goToCart(context),
    );
  }
}

class _WishlistBody extends StatelessWidget {
  final WishlistListingState state;
  final ScrollController scrollController;

  const _WishlistBody({required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WishlistListingBloc>();
    return RefreshIndicator(
      onRefresh: () async => bloc.add(const RefreshWishlist()),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          WishlistGrid(
            items: state.items,
            onDelete: (item) => bloc.add(RemoveWishlistItem(item)),
            onMoveToBag: (item) => _onMoveToBag(context, bloc, item),
          ),
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  /// Always confirm the size in the shared PDP size sheet (with the size-chart
  /// link) before moving to the bag. Only an item with nothing selectable —
  /// i.e. sold out — falls through to a direct dispatch.
  void _onMoveToBag(
    BuildContext context,
    WishlistListingBloc bloc,
    WishlistProductEntity item,
  ) {
    if (!item.needsSizeSelection) {
      bloc.add(MoveWishlistItemToBag(item));
      return;
    }

    final sizeChartBloc = context.read<SizeChartBloc>();

    showSizeSelectionBottomSheet(
      context,
      skus: item.skus,
      ctaLabel: WishlistStrings.moveToBag,
      // The listing sends a product-level priceInfo and no per-SKU price, so
      // this is what fills the price strip for every size.
      fallbackPrice: item.product.price,
      // Opens on the wishlisted size when it is still selectable; otherwise
      // nothing is picked and the CTA stays disabled, as on the PDP. Sold-out
      // SKUs arrive with `enable: false` and render as untappable chips.
      initialSkuId: item.preselectedSkuId,
      showSizeChart: item.hasSizeChart,
      // The chart goes on the root navigator, so it stacks over the size sheet
      // instead of replacing it: closing the chart reveals the sheet again with
      // the selection intact.
      onSizeChartTap: () => _openSizeChart(context, sizeChartBloc, item),
      onConfirm: (skuId) => bloc.add(MoveWishlistItemToBag(item, skuId: skuId)),
    );
  }

  /// Same sheet the PDP shows, fed by [SizeChartBloc] (the wishlist has no
  /// PdpBloc) over the shared `/sizeChart/{productId}` use case.
  void _openSizeChart(
    BuildContext context,
    SizeChartBloc sizeChartBloc,
    WishlistProductEntity item,
  ) {
    sizeChartBloc.add(SizeChartEvent.load(item.id));

    showSizeChartSheet(
      context,
      productName: item.product.name,
      bodyBuilder: (_) => BlocProvider.value(
        value: sizeChartBloc,
        child: BlocBuilder<SizeChartBloc, SizeChartState>(
          builder: (context, state) => SizeChartStateView(
            isLoading: state.isLoading,
            error: state.errorMessage,
            chart: state.chart,
          ),
        ),
      ),
    );
  }
}
