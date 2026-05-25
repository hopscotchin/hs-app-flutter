import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../../domain/entities/home_page_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/combined_header_delegate.dart';
import '../widgets/page_component_renderer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  static const _kToolbarHeight = 80.0;
  static const _kTabsHeight = 60.0;

  /// Distance from the bottom (in px) at which the next-page fetch fires.
  /// Small on purpose: we want the user to have scrolled through the current
  /// batch of components (pageSize=20) before requesting more — not pre-fetch
  /// while they're still mid-page.
  static const _kPaginationThreshold = 200.0;

  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();

  /// Cached list of sortingOption ids (parallel to the visible tabs). Used so
  /// the bloc receives the API's `pageName` (`Shop_for_Baby`, etc.) on tab tap.
  List<String> _sortOptionIds = const [];

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
    if (position.pixels >= position.maxScrollExtent - _kPaginationThreshold) {
      final bloc = context.read<HomeBloc>();
      final state = bloc.state;
      if (state.isSuccess && state.hasNextPage && !state.isLoadingMore) {
        bloc.add(const LoadNextHomePage());
      }
    }
  }

  void _scrollTabsToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onTabSelected(int index) {
    if (index == _selectedTabIndex) return;
    setState(() => _selectedTabIndex = index);

    // Drive the homepage refresh off the selected sortingOption.id.
    // Fall back to no-op if the API hasn't supplied options yet.
    if (index < _sortOptionIds.length) {
      context.read<HomeBloc>().add(LoadHomePage(pageName: _sortOptionIds[index]));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final sortOptions = state.homePage?.sortingOptions ?? const [];
        if (sortOptions.isNotEmpty) {
          _sortOptionIds = sortOptions.map((o) => o.id).toList(growable: false);
        }
        // Empty until sortingOptions arrive — the header reserves the strip
        // height (see CombinedHeaderDelegate) so this doesn't shift layout.
        final labels = sortOptions
            .map((o) => o.label)
            .toList(growable: false);
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async => context.read<HomeBloc>().add(const RefreshHomePage()),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                cacheExtent: MediaQuery.sizeOf(context).height * 2,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: CombinedHeaderDelegate(
                      labels: labels,
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
                  if (state.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentSliver(BuildContext context, HomeState state) {
    if (state.isLoading) {
      return SliverToBoxAdapter(child: LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 120));
    }

    final mq = MediaQuery.of(context);
    final availableHeight = mq.size.height - mq.padding.top - _kToolbarHeight - _kTabsHeight;

    if (state.isFailure) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: availableHeight,
          child: Center(
            child: ErrorRetryWidget(
              message: state.errorMessage,
              onRetry: () => context.read<HomeBloc>().add(const LoadHomePage()),
            ),
          ),
        ),
      );
    }
    if (state.isSuccess) {
      final components = state.homePage?.pageComponents ?? [];
      if (components.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: availableHeight,
            child: const Center(child: Text(DiscoverStrings.noContentAvailable)),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => PageComponentRenderer(component: components[index]),
          childCount: components.length,
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
