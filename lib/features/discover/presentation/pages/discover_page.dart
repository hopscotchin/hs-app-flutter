import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../components/spring/spring_tab_bar.dart';
import '../../../../core/constants/strings/discover_strings.dart';
import '../bloc/home_bloc.dart';
import '../widgets/combined_header_delegate.dart';
import '../widgets/page_component_renderer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  static const _kToolbarHeight = 80.0;
  static const _kTabsHeight = 60.0;

  static const _tabs = [
    SpringTabItem(label: DiscoverStrings.tabAll),
    SpringTabItem(label: DiscoverStrings.tabBaby),
    SpringTabItem(label: DiscoverStrings.tabBoy),
    SpringTabItem(label: DiscoverStrings.tabGirl),
  ];

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomePage());
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<HomeBloc>().add(const RefreshHomePage()),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                cacheExtent: MediaQuery.sizeOf(context).height * 2,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: CombinedHeaderDelegate(
                      items: _tabs,
                      initialIndex: _selectedTabIndex,
                      onTabSelected: (i) =>
                          setState(() => _selectedTabIndex = i),
                      bgImageUrl: state.homePage?.headerBgImageUrl,
                      isImageDark: false,
                      toolbarHeight: _kToolbarHeight,
                      tabsHeight: _kTabsHeight,
                    ),
                  ),
                  _buildContentSliver(context, state),
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
      return SliverToBoxAdapter(
        child: LoadingShimmer.listShimmer(itemCount: 6, itemHeight: 120),
      );
    }
    if (state.isFailure) {
      return SliverFillRemaining(
        child: ErrorRetryWidget(
          message: state.errorMessage,
          onRetry: () => context.read<HomeBloc>().add(const LoadHomePage()),
        ),
      );
    }
    if (state.isSuccess) {
      final components = state.homePage?.pageComponents ?? [];
      if (components.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text(DiscoverStrings.noContentAvailable)),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              PageComponentRenderer(component: components[index]),
          childCount: components.length,
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
