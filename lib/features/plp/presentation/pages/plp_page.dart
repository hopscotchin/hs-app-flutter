import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/components/atoms/empty_state_widget.dart';
import 'package:hs_app_flutter/components/atoms/notification_permission_nudge_bar.dart';
import 'package:hs_app_flutter/components/page_components/message_bars_widget.dart';
import 'package:hs_app_flutter/core/constants/strings/auto_test_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/plp_strings.dart';
import 'package:hs_app_flutter/core/navigation/action_url_handler.dart';
import 'package:hs_app_flutter/core/services/notification_permission_service.dart';
import 'package:hs_app_flutter/core/theme/spacing.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/floating_item_count.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_applied_filters.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_filter_header.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_product_sliver.dart';
import 'package:hs_app_flutter/features/plp/presentation/widgets/plp_query_correction.dart';

import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/plp_events.dart';
import '../../../../core/di/injection.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/listing_product_entity.dart';
import '../../domain/entities/page_type.dart';
import '../../domain/entities/plp_entry_args.dart';
import '../../domain/entities/plp_list_item.dart';
import '../../domain/entities/wishlist_info_entity.dart';
import '../../domain/helpers/plp_query_builder.dart';
import '../../domain/helpers/plp_scroll_payload.dart';
import '../bloc/plp_bloc.dart';
import '../helpers/plp_scroll_probe.dart';
import '../widgets/plp_shimmer_loading.dart';
import '../widgets/plp_sliver_app_bar.dart';

class PlpPage extends StatelessWidget {
  final PageType pageType;
  final int plpId;
  final String? categoryName;
  final String? searchQuery;
  final String? rawSearchParams;

  /// Analytics entry context for the listing-viewed payload — `from_screen` /
  /// `from_location` and friends. Null for deeplink-style opens.
  final PlpEntryArgs? entryArgs;

  const PlpPage({
    super.key,
    required this.pageType,
    required this.plpId,
    this.categoryName,
    this.searchQuery,
    this.rawSearchParams,
    this.entryArgs,
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
            entryArgs: entryArgs,
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

  /// Scroll-depth accumulator behind `plp_scrolled`. Fed from the scroll
  /// notification stream; see [PlpScrollProbe] for why that is cheap.
  late final PlpScrollProbe _scrollProbe = PlpScrollProbe(
    sliverKey: _productSliverKey,
  );

  /// Snapshot of the last loaded state, kept so [dispose] can build the
  /// scroll payload without reading the bloc during teardown.
  PlpState? _lastLoadedState;

  /// The bloc's live `localAttribution` map, captured while the element is
  /// still mounted.
  ///
  /// `dispose()` runs after the element is defunct, so **any** ancestor lookup
  /// there — `context.read`, `Provider.of`, `BlocProvider.of` — throws
  /// `"Looking up a deactivated widget's ancestor is unsafe."`. Reading the
  /// bloc inline while assembling the payload is what silently killed
  /// `plp_scrolled`: the throw happened while evaluating an argument, so the
  /// log call was never reached and the only trigger the event has never ran.
  ///
  /// Holding the map reference (not a copy) keeps the late binding the payload
  /// needs — `PlpBloc._onLoadPlpData` fills it *after* emitting `loaded`, so a
  /// snapshot taken when the listener fires would always be empty.
  Map<String, Object>? _localAttribution;

  /// Last-visible product count for the "X of Y" indicator. Computed from the
  /// product sliver's real geometry so it matches what's actually on screen
  /// (mirrors Android's getActualProductCount(getLastVisiblePosition())).
  final ValueNotifier<int> _visibleCount = ValueNotifier(0);

  /// Key on the product [SliverList] so we can read its render geometry.
  final GlobalKey _productSliverKey = GlobalKey();

  /// Product-card index at which Android inserts its notification-permission
  /// nudge card (`NOTIFICATION_INTENT_POSITION`). This app doesn't splice a
  /// card into the grid itself (see `product_grid.dart`'s manual row-pairing
  /// logic) — instead the bar below appears once the shopper has scrolled
  /// this far, matching the trigger point without touching the grid layout.
  static const int _notificationNudgePosition = 12;
  bool _notificationNudgeChecked = false;
  final ValueNotifier<bool> _showNotificationNudge = ValueNotifier(false);

  String get _title => widget.categoryName ?? widget.searchQuery ?? '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceHeight = View.of(context).physicalSize.height.round();
    // Row heights are recorded in logical pixels, so the width they are
    // normalised against must be logical too — the ratio is what carries the
    // meaning, not the unit. See `plpScaledRowHeight`.
    //
    // Only the boutique listing has a collapsing header for Android's
    // extra-row term to describe; the standard PLP toolbar floats.
    final header = widget.pageType == PageType.boutique
        ? PlpSliverAppBar.boutiqueHeaderGeometry(MediaQuery.paddingOf(context).top)
        : null;
    _scrollProbe.configure(
      displayWidth: MediaQuery.sizeOf(context).width,
      collapsingHeader: header?.expandedHeight ?? 0,
      headerCollapseOffset: header?.collapseOffset ?? 0,
    );
    // Captured here, not in dispose — see [_localAttribution].
    _localAttribution = context.read<PlpBloc>().localAttribution;
  }

  @override
  void dispose() {
    // Android sends this from stopScrollTracking() as the PLP goes away
    // (`PLPAnalytics.kt:624`); leaving the screen is the only moment the full
    // depth is known. Fired before the controllers go, and never awaited.
    _sendScrollEvent();
    _scrollController.removeListener(_onScroll);
    _showScrollToTop.dispose();
    _visibleCount.dispose();
    _showNotificationNudge.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _maybeShowNotificationNudge() async {
    _notificationNudgeChecked = true;
    final service = sl<NotificationPermissionService>();
    if (!await service.shouldShowPlpNudge()) return;
    if (!mounted) return;
    service.recordPlpIntentShown();
    _showNotificationNudge.value = true;
  }

  /// Emits `plp_scrolled` if the tracker has anything to report. Gated on the
  /// tracker returning params rather than on a "did they scroll" flag —
  /// a bounced visit legitimately reports zero depth exactly once.
  void _sendScrollEvent() {
    final state = _lastLoadedState;
    if (state == null) return;

    final depth = _scrollProbe.tracker.consumeScrollDepthParams();
    if (depth == null) return;

    final range = plpScrollRange(
      startRow: _scrollProbe.tracker.startScrollIndex,
      endRow: _scrollProbe.tracker.endScrollIndex,
      itemCount: state.products.length,
    );
    final lists = plpScrollLists(productsIn(state.products, range));

    sl<AnalyticsHelper>().logPlpScrolled(
      scrollDepthParams: depth,
      trackingMeta: state.plpAnalyticsMeta,
      // Null, not 0, when unmeasured: this codebase keeps zeros, so a literal
      // `screen_height: 0` would claim a device with no screen rather than
      // "not known". `didChangeDependencies` always runs before `dispose`, so
      // in practice it is set.
      screenHeight: _deviceHeight > 0 ? _deviceHeight : null,
      totalRows: plpTotalRows(
        totalRecords: state.totalRecords ?? 0,
        extraRowCount: _scrollProbe.tracker.extraRowCount,
      ),
      brand: lists.brand,
      productIds: lists.productIds,
      xlProductIds: lists.xlProductIds,
      category: lists.category,
      subCategory: lists.subCategory,
      productType: lists.productType,
      merchType: lists.merchType,
      attribution: _localAttribution,
    );

    // Reopen the window so a later send reports the next stretch rather than
    // repeating from row 1 (Android: resetStartScrollIndex after sending).
    _scrollProbe.tracker.resetStartScrollIndex();
  }

  /// Device display height in physical pixels — Android reports
  /// `DefaultDisplay.displayHeight`, which is raw pixels, not logical ones.
  ///
  /// Captured in [didChangeDependencies] rather than read on demand: the send
  /// happens from [dispose], where looking up an inherited widget is illegal.
  int _deviceHeight = 0;

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
      if (!_notificationNudgeChecked &&
          _visibleCount.value >= _notificationNudgePosition) {
        _maybeShowNotificationNudge();
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
    _scrollProbe.onListReplaced();
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

    // O(1) lookup. This used to sum the list from 0 on every scroll frame,
    // which is O(list items) — ~1,800 iterations per frame on a 3,600-product
    // listing. The running totals are rebuilt once per loaded state instead.
    final prefix = _productCountPrefix;
    if (prefix.isEmpty) return null;
    return prefix[lastIndex.clamp(0, prefix.length - 1)];
  }

  /// Cumulative product count up to and including each list item, rebuilt when
  /// a load completes. A row contributes 1-2 products, an XL tile 1, a floating
  /// filter row 0.
  List<int> _productCountPrefix = const [];

  void _rebuildProductCountPrefix(List<PlpListItem> items) {
    final prefix = List<int>.filled(items.length, 0);
    var running = 0;
    for (var i = 0; i < items.length; i++) {
      running += switch (items[i]) {
        ProductRowItem(:final right) => right == null ? 1 : 2,
        ProductXLItem() => 1,
        FloatingFilterItem() => 0,
      };
      prefix[i] = running;
    }
    _productCountPrefix = prefix;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _showNotificationNudge,
        builder: (context, show, _) {
          if (!show) return const SizedBox.shrink();
          final service = sl<NotificationPermissionService>();
          final nudge = service.plpNudgeCopy;
          return SafeArea(
            top: false,
            child: NotificationPermissionNudgeBar(
              message:
                  nudge?.description ?? 'Turn on notifications for restock alerts and price drops.',
              enableLabel: nudge?.positiveButtonText ?? 'Enable',
              dismissLabel: nudge?.negativeButtonText ?? 'Not now',
              onEnable: () {
                _showNotificationNudge.value = false;
                service.requestPlpPermission();
              },
              onDismiss: () {
                _showNotificationNudge.value = false;
                service.recordPlpDismissed();
              },
            ),
          );
        },
      ),
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
          // Keep a snapshot of the loaded page so the scroll event can be built
          // during dispose, when the bloc is no longer safe to read.
          BlocListener<PlpBloc, PlpState>(
            listenWhen: (prev, curr) =>
                curr.status == PlpStatus.loaded &&
                (prev.status != curr.status ||
                    prev.listItems.length != curr.listItems.length),
            listener: (context, state) {
              _lastLoadedState = state;
              _rebuildProductCountPrefix(state.listItems);
              // After the rows exist, record what fits on screen. A user who
              // bounces straight back produces no scroll notification, and
              // without this the scroll window stays empty — which makes the
              // payload report every loaded product instead of the handful
              // Android reports. See `PlpScrollProbe.seedInitialViewport`.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _scrollProbe.seedInitialViewport();
              });
            },
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
                      PlpStatus.initial || PlpStatus.loading => [
                        SliverFillRemaining(child: PlpShimmerLoading(pageType: widget.pageType)),
                      ],
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
    // Depth sampling first — it self-throttles, and must see the notification
    // even on a list too short to paginate.
    _scrollProbe.onScrollNotification(notification);

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
