import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/utils/snackbar_utils.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../../../core/cubits/cart_count_cubit.dart';
import '../../../../core/cubits/shop_the_look_cubit.dart';
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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
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
    setState(() => _selectedTabIndex = index);

    if (_scrollController.hasClients && _scrollController.position.pixels > _kToolbarHeight) {
      _scrollController.jumpTo(_kToolbarHeight);
    }

    if (index < _sortOptionIds.length) {
      context.read<HomeBloc>().add(LoadHomePage(pageName: _sortOptionIds[index]));
    }
  }

  Future<void> _handleRefresh() {
    final completer = Completer<void>();
    context.read<HomeBloc>().add(RefreshHomePage(onComplete: completer.complete));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ShopTheLookCubit, ShopTheLookCartState>(
          listenWhen: (prev, curr) =>
              prev.status == ShopTheLookCartStatus.loading &&
              curr.status != ShopTheLookCartStatus.loading,
          listener: (context, state) {
            if (state.status == ShopTheLookCartStatus.success) {
              if (state.cartItemQty != null) {
                context.read<CartCountCubit>().set(state.cartItemQty!);
              }

              context.showSnack(
                DiscoverStrings.itemsAddedToBag(state.addedCount),
                status: SnackStatus.success,
              );
            } else if (state.status == ShopTheLookCartStatus.failure) {
              context.showSnack(
                state.errorMessage ?? DiscoverStrings.failedToAddItemsToBag,
                status: SnackStatus.error,
              );
            }
          },
        ),
        // Any full reload (pull-to-refresh / login / unlock / logout) routes
        // through HomeStatus.loading; pagination only flips isLoadingMore. So
        // this single transition covers every refresh trigger.
        BlocListener<HomeBloc, HomeState>(
          listenWhen: (prev, curr) =>
              prev.status != HomeStatus.loading && curr.status == HomeStatus.loading,
          listener: (context, _) => _scrollToTopOnReload(),
        ),
      ],
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
              onButtonTap: () => context.read<HomeBloc>().add(const LoadHomePage()),
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
                onButtonTap: () => context.read<HomeBloc>().add(const LoadHomePage()),
              ),
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => PageComponentRenderer(component: components[index]),
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
