import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/empty_state_widget.dart';
import 'package:hs_app_flutter/components/page_components/message_bars_widget.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/navigation/action_url_handler.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/floating_item_count.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_applied_filters.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_filter_header.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_product_sliver.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_query_correction.dart';

import '../../../../core/di/injection.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_list_item.dart';
import '../../domain/entities/wishlist_info_entity.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../bloc/plp_bloc.dart';
import '../widgets/plp_shimmer_loading.dart';
import '../widgets/plp_sliver_app_bar.dart';

class PlpPage extends StatelessWidget {
  final PageType pageType;
  final int plpId;
  final String? categoryName;
  final String? searchQuery;
  final String? rawSearchParams;

  const PlpPage({
    super.key,
    required this.pageType,
    required this.plpId,
    this.categoryName,
    this.searchQuery,
    this.rawSearchParams,
  });

  Map<String, dynamic> get _baseQueryParams {
    final params = <String, dynamic>{'pageNo': 1, 'pageSize': PlpQueryBuilder.pageSize};
    switch (pageType) {
      case PageType.plp:
        params['id'] = plpId;
        break;
      case PageType.boutique:
        params['salePlanId'] = plpId;
        break;
      case PageType.search:
        if (rawSearchParams != null) {
          params['searchParams'] = base64Encode(utf8.encode(rawSearchParams!));
        } else if (searchQuery != null) {
          params['keyWord'] = searchQuery;
          params['filterQuery'] = 'keyWord=$searchQuery';
        }
        break;
    }
    return params;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlpBloc>()
        ..add(
          LoadPlpData(
            pageType: pageType,
            plpId: plpId,
            searchQuery: searchQuery,
            categoryName: categoryName,
            rawSearchParams: rawSearchParams,
          ),
        ),
      child: _PlpView(
        categoryName: categoryName,
        searchQuery: searchQuery,
        rawSearchParams: rawSearchParams,
        pageType: pageType,
        plpId: plpId,
        baseQueryParams: _baseQueryParams,
      ),
    );
  }
}

class _PlpView extends StatefulWidget {
  final String? categoryName;
  final String? searchQuery;
  final String? rawSearchParams;
  final PageType pageType;
  final int plpId;
  final Map<String, dynamic> baseQueryParams;

  const _PlpView({
    this.categoryName,
    this.searchQuery,
    this.rawSearchParams,
    required this.pageType,
    required this.plpId,
    required this.baseQueryParams,
  });

  @override
  State<_PlpView> createState() => _PlpViewState();
}

class _PlpViewState extends State<_PlpView> {
  static const double _showAfterOffset = 300;

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToTop = ValueNotifier(false);

  /// Last-visible product count for the "X of Y" indicator. Computed from the
  /// product sliver's real geometry so it matches what's actually on screen
  /// (mirrors Android's getActualProductCount(getLastVisiblePosition())).
  final ValueNotifier<int> _visibleCount = ValueNotifier(0);

  /// Key on the product [SliverList] so we can read its render geometry.
  final GlobalKey _productSliverKey = GlobalKey();

  String get _title => widget.categoryName ?? widget.searchQuery ?? '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _showScrollToTop.dispose();
    _visibleCount.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pixels = _scrollController.position.pixels;
    final shouldShow = pixels > _showAfterOffset;
    if (_showScrollToTop.value != shouldShow) {
      _showScrollToTop.value = shouldShow;
    }
    if (shouldShow) {
      final count = _lastVisibleProductCount();
      if (count != null && count != _visibleCount.value) {
        _visibleCount.value = count;
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
    );
  }

  void _resetScroll() {
    _showScrollToTop.value = false;
    _visibleCount.value = 0;
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  /// Number of products up to and including the last item currently visible at
  /// the bottom of the viewport — the "X" in "X of Y". Reads the product
  /// [SliverList]'s real geometry (last laid-out child whose start is within the
  /// visible window) and converts the list-item index to a product count via
  /// [PlpListItem] (a row = 2 products, XL = 1, floating filter = 0). Returns
  /// null when geometry isn't ready so the caller keeps the previous value.
  int? _lastVisibleProductCount() {
    final renderObject = _productSliverKey.currentContext?.findRenderObject();
    if (renderObject is! RenderSliverMultiBoxAdaptor) return null;
    if (renderObject.geometry?.visible != true) return null;

    final constraints = renderObject.constraints;
    final viewportBottom = constraints.scrollOffset + constraints.remainingPaintExtent;

    int? lastIndex;
    RenderBox? child = renderObject.firstChild;
    while (child != null) {
      final parentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      final childStart = parentData.layoutOffset ?? 0;
      if (childStart <= viewportBottom) {
        lastIndex = parentData.index;
        child = renderObject.childAfter(child);
      } else {
        break;
      }
    }
    if (lastIndex == null) return null;

    final listItems = context.read<PlpBloc>().state.listItems;
    var products = 0;
    for (var i = 0; i <= lastIndex && i < listItems.length; i++) {
      products += switch (listItems[i]) {
        ProductRowItem(:final right) => right == null ? 1 : 2,
        ProductXLItem() => 1,
        FloatingFilterItem() => 0,
      };
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showScrollToTop,
        builder: (context, show, _) {
          // Hidden at the top of the list; appears once the user scrolls down.
          if (!show) return const SizedBox.shrink();
          return BlocSelector<PlpBloc, PlpState, int>(
            selector: (s) => s.totalRecords ?? 0,
            builder: (context, total) {
              if (total <= 0) return const SizedBox.shrink();
              return ValueListenableBuilder<int>(
                valueListenable: _visibleCount,
                builder: (context, count, _) {
                  final position = count.clamp(1, total);
                  return FloatingItemCount(
                    key: const ValueKey(PlpTestStrings.productCountButton),
                    position: position,
                    totalCount: total,
                    onTap: _scrollToTop,
                  );
                },
              );
            },
          );
        },
      ),
      body: MultiBlocListener(
        listeners: [
          // Feed the global WishlistCubit with statuses from each page of results
          // so the heart reflects server truth and stays in sync everywhere.
          BlocListener<PlpBloc, PlpState>(
            listenWhen: (prev, curr) =>
                prev.listItems.length != curr.listItems.length || prev.status != curr.status,
            listener: (context, state) => _seedWishlist(context, state.listItems),
          ),
          BlocListener<PlpBloc, PlpState>(
            listenWhen: (prev, curr) => curr.status == PlpStatus.loading,
            listener: (context, state) => _resetScroll(),
          ),
        ],
        child: BlocBuilder<PlpBloc, PlpState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final hasFilters = state.appliedFilters.isNotEmpty;
            return SafeArea(
              top: state.banners.isEmpty,
              bottom: false,
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScroll,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    PlpSliverAppBar(pageType: widget.pageType, title: _title),
                    ...switch (state.status) {
                      PlpStatus.initial ||
                      PlpStatus.loading => const [SliverFillRemaining(child: PlpShimmerLoading())],
                      PlpStatus.error => [
                        SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: EmptyStateWidget(
                                type: EmptyStateType.serverError,
                                titleKey: const ValueKey(PlpTestStrings.errorStateTitle),
                                subtitleKey: const ValueKey(PlpTestStrings.errorStateSubtitle),
                                buttonKey: const ValueKey(PlpTestStrings.errorStateButton),
                                onButtonTap: () => _retry(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                      PlpStatus.empty => [
                        // When filters produced an empty result, keep the
                        // filter bar + applied-filter chips visible so the user
                        // can loosen/remove them instead of being stuck.
                        if (hasFilters) ...[
                          PlpFilterHeader(baseQueryParams: widget.baseQueryParams),
                          const PlpAppliedFilters(),
                        ],
                        SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: EmptyStateWidget(
                                type: EmptyStateType.plp,
                                titleKey: const ValueKey(PlpTestStrings.emptyStateTitle),
                                subtitleKey: const ValueKey(PlpTestStrings.emptyStateSubtitle),
                                buttonKey: const ValueKey(PlpTestStrings.emptyStateButton),
                                subtitle: hasFilters
                                    ? PlpStrings.noProductsFiltered
                                    : PlpStrings.tryAgainAndKeepExploring,
                                onButtonTap: hasFilters
                                    ? () => context.read<PlpBloc>().add(const ClearAllFilters())
                                    : () => _retry(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                      PlpStatus.loaded => [
                        if (state.plpFilter != null) ...[
                          PlpFilterHeader(baseQueryParams: widget.baseQueryParams),
                          const PlpAppliedFilters(),
                        ],
                        PlpQueryCorrectionSliver(pageType: widget.pageType, plpId: widget.plpId),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: state.messageBars.isNotEmpty
                                ? EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    bottom: 0,
                                    top: state.appliedFilters.isNotEmpty ? 0 : 8,
                                  )
                                : EdgeInsets.zero,
                            child: MessageBarsWidget(
                              spaceBetweenMessageBars: 5,
                              messageBars: state.messageBars,
                              cardStyle: true,
                              keyPrefix: PlpTestStrings.screen,
                              onAction: (v, e) {
                                ActionUrlHandler.navigate(context, v);
                              },
                            ),
                          ),
                        ),
                        PlpProductSliver(sliverKey: _productSliverKey),
                        BlocSelector<PlpBloc, PlpState, bool>(
                          selector: (s) => s.isLoadingMore,
                          builder: (context, isLoading) => isLoading
                              ? const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(AppSpacing.md),
                                    child: Center(
                                      child: SizedBox(
                                        width: AppSpacing.lg,
                                        height: AppSpacing.lg,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                )
                              : const SliverToBoxAdapter(child: SizedBox.shrink()),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                      ],
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static const double _paginationTriggerFraction = 0.8;

  bool _handleScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical || metrics.maxScrollExtent <= 0) return false;
    if (metrics.pixels >= metrics.maxScrollExtent * _paginationTriggerFraction) {
      final state = context.read<PlpBloc>().state;
      if (state.status == PlpStatus.loaded && state.hasMore && !state.isLoadingMore) {
        context.read<PlpBloc>().add(const LoadMorePlpData());
      }
    }
    return false;
  }

  void _seedWishlist(BuildContext context, List<PlpListItem> items) {
    final seeds = <WishlistSeed>[];
    for (final item in items) {
      switch (item) {
        case ProductRowItem(:final left, :final right):
          seeds.add(_seedOf(left));
          if (right != null) seeds.add(_seedOf(right));
        case ProductXLItem(:final product):
          seeds.add(_seedOf(product));
        case FloatingFilterItem():
          break;
      }
    }
    if (seeds.isNotEmpty) context.read<WishlistCubit>().seed(seeds);
  }

  WishlistSeed _seedOf(ListingProductEntity p) => WishlistSeed(
    productId: p.id.toString(),
    wished: p.wishlistInfo.isWishlisted,
    wishlistItemId: p.wishlistInfo.wishlistId,
  );

  void _retry(BuildContext context) {
    context.read<PlpBloc>().add(
      LoadPlpData(
        pageType: widget.pageType,
        plpId: widget.plpId,
        categoryName: widget.categoryName,
        searchQuery: widget.searchQuery,
        rawSearchParams: widget.rawSearchParams,
      ),
    );
  }
}
