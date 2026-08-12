import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/analytics/constants/funnel.dart';
import '../../../../core/analytics/events/modules/home_events.dart';
import '../../../../core/analytics/home/home_track_analytic_manager.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/navigation_observer.dart';
import '../../domain/entities/home_page_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/combined_header_delegate.dart';
import '../widgets/loading_more_sliver.dart';
import '../widgets/page_component_renderer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  static const _kToolbarHeight = 80.0;
  static const _kTabsHeight = 60.0;

  static const _kPaginationTrigger = 0.8;

  static const _kCacheExtent = 600.0;

  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  bool _suppressScrollTabsToTop = false;

  /// Cached list of sortingOption ids (parallel to the visible tabs). Used so
  /// the bloc receives the API's `pageName` (`Shop_for_Baby`, etc.) on tab tap.
  List<String> _sortOptionIds = const [];

  /// Cached tab labels — recomputed only when the sortingOptions list itself
  /// changes (identity-checked below). Avoids the per-build `.map().toList()`
  /// allocation that was running on every state emission.
  List<String> _labels = const [];
  List<SortingOption>? _lastSortOptions;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomePage());
    _scrollController.addListener(_onScroll);
    // Re-hydrate the shared tracker with Home's pageComponents whenever
    // Discover becomes the active funnel again (back-nav from LP/PDP/PLP,
    // tab switch). LP overwrites the shared tracker's pageComponents on
    // push; without this, Home would fire impressions against LP's list.
    sl<AppNavigationObserver>().onFunnelActivated = _onFunnelActivated;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    final observer = sl<AppNavigationObserver>();
    if (observer.onFunnelActivated == _onFunnelActivated) {
      observer.onFunnelActivated = null;
    }
    super.dispose();
  }

  void _onFunnelActivated(Funnel funnel) {
    if (funnel != Funnel.discover) return;
    final components = context.read<HomeBloc>().state.homePage?.pageComponents;
    if (components == null || components.isEmpty) return;
    sl<HomeTrackAnalyticManager>().pageComponents = components;
    // `OrderAttributionHelper.setFunnel` builds a fresh AttributionData on
    // cross-funnel change, which wipes sortBar too (Discover-only field).
    // Re-seed it from the currently-selected tab so downstream events on
    // Discover carry the correct sortbar.
    _syncSortbarOnTracker();
  }

  @override
  bool get wantKeepAlive => true;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent * _kPaginationTrigger) {
      final bloc = context.read<HomeBloc>();
      final state = bloc.state;
      if (state.isSuccess && state.hasNextPage && !state.isLoadingMore) {
        bloc.add(const LoadNextHomePage());
      }
    }
  }

  void _scrollTabsToTop() {
    // Deferred so a synchronous `_onTabSelected` (fires after this on tab
    // switch via SegmentedButton.onSelectionChanged) can flip the suppress
    // flag and cancel the animation. Re-taps don't trigger onSelectionChanged,
    // so the flag stays false and the animation runs as intended.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_suppressScrollTabsToTop) {
        _suppressScrollTabsToTop = false;
        return;
      }
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToTopOnReload() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_scrollController.position.pixels > _kToolbarHeight) {
        _scrollController.jumpTo(_kToolbarHeight);
      }
    });
  }

  void _onTabSelected(int index) {
    if (index == _selectedTabIndex) return;
    // Suppress the deferred `_scrollTabsToTop` animation — switching tabs
    // shouldn't re-expose the toolbar like a re-tap does.
    _suppressScrollTabsToTop = true;
    // Drain any pending carousel_scrolled from the old tab before its
    // carousels get replaced.
    unawaited(sl<HomeTrackAnalyticManager>().flushCarouselScrolls());
    setState(() => _selectedTabIndex = index);
    _syncSortbarOnTracker();
    if (index < _labels.length) {
      unawaited(sl<HomeTrackAnalyticManager>()
          .analytics
          .logSortbarChanged(sortBar: _labels[index]));
    }

    if (_scrollController.hasClients && _scrollController.position.pixels > _kToolbarHeight) {
      _scrollController.jumpTo(_kToolbarHeight);
    }

    if (index < _sortOptionIds.length) {
      context.read<HomeBloc>().add(LoadHomePage(pageName: _sortOptionIds[index]));
    }
  }

  void _retryCurrentTab() {
    final pageName =
        (_selectedTabIndex >= 0 && _selectedTabIndex < _sortOptionIds.length)
            ? _sortOptionIds[_selectedTabIndex]
            : null;
    context.read<HomeBloc>().add(LoadHomePage(pageName: pageName));
  }

  Future<void> _handleRefresh() {
    final completer = Completer<void>();
    context.read<HomeBloc>().add(RefreshHomePage(onComplete: completer.complete));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Any full reload (pull-to-refresh / login / unlock / logout) routes
    // through HomeStatus.loading; pagination only flips isLoadingMore. So
    // this single transition covers every refresh trigger.
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) =>
          prev.status != HomeStatus.loading && curr.status == HomeStatus.loading,
      listener: (context, _) => _scrollToTopOnReload(),
      child: BlocBuilder<HomeBloc, HomeState>(
        // Skip rebuilds for pure-pagination flips (isLoadingMore true ↔ false).
        // The spinner sliver below has its own BlocSelector that handles
        // them locally — rebuilding the whole scroll view for a 24×24 spinner
        // was the biggest pagination jank source.
        buildWhen: (prev, curr) =>
            prev.status != curr.status ||
            !identical(prev.homePage, curr.homePage) ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          _syncSortOptions(state.homePage?.sortingOptions);
          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  cacheExtent: _kCacheExtent,
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: CombinedHeaderDelegate(
                        labels: _labels,
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: _onTabSelected,
                        onTabTapped: _scrollTabsToTop,
                        bgImageUrl: state.homePage?.headerImageUrl,
                        isImageDark: state.homePage?.isDarkHeader ?? false,
                        toolbarHeight: _kToolbarHeight,
                        tabsHeight: _kTabsHeight,
                      ),
                    ),
                    _buildContentSliver(context, state),
                    const LoadingMoreSliver(),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Recompute the label/id lists only when the sortingOptions list itself
  /// changes (identity check). The list is rebuilt by the server only on
  /// tab swap, so most state emissions hit the fast path.
  void _syncSortOptions(List<SortingOption>? options) {
    if (options == null || options.isEmpty) return;
    if (identical(options, _lastSortOptions)) return;
    _lastSortOptions = options;
    _sortOptionIds = options.map((o) => o.id).toList(growable: false);
    _labels = options.map((o) => o.label).toList(growable: false);
    _syncSortbarOnTracker();
  }

  /// Stamps the currently-selected tab label onto both the tracker (feeds
  /// `sortbar` on impressions / carousel_scrolled) AND the persisted order
  /// attribution (feeds `sortbar` on every event fired with
  /// `attribution: true`). Called on initial sortOptions load and tab change.
  void _syncSortbarOnTracker() {
    if (_selectedTabIndex < 0 || _selectedTabIndex >= _labels.length) return;
    final label = _labels[_selectedTabIndex];
    final tracker = sl<HomeTrackAnalyticManager>();
    tracker.sortBarName = label;
    tracker.orderAttribution.setSortBar(label);
  }

  Widget _buildContentSliver(BuildContext context, HomeState state) {
    if (state.isLoading) {
      return SliverToBoxAdapter(child: LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 120));
    }

    if (state.isFailure) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: _kToolbarHeight + _kTabsHeight),
          child: Center(
            child: EmptyStateWidget(
              type: EmptyStateType.serverError,
              onButtonTap: _retryCurrentTab,
            ),
          ),
        ),
      );
    }
    if (state.isSuccess) {
      final components = state.homePage?.pageComponents ?? [];
      if (components.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _kToolbarHeight + _kTabsHeight),
            child: Center(
              child: EmptyStateWidget(
                type: EmptyStateType.discover,
                onButtonTap: _retryCurrentTab,
              ),
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => PageComponentRenderer(
            component: components[index],
            index: index,
            pagePrefix: HomeComponentTestStrings.homePage,
          ),
          childCount: components.length,
          // PageComponentRenderer is stateless — no KeepAlive needed and the
          // wrapper element costs add up across many tiles.
          addAutomaticKeepAlives: false,
          // Index semantics aren't useful for a heterogeneous component list;
          // the wrapper element is pure overhead.
          addSemanticIndexes: false,
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
