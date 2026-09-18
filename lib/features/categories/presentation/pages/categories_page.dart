import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/plp_events.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/categories_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/spacing.dart';
import '../../../discover/presentation/widgets/combined_header_delegate.dart';
import '../../../discover/presentation/widgets/page_component_renderer.dart';
import '../bloc/categories_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Index (into the sorted page-components list) of the one top-level
  // accordion section currently expanded, so opening a new section
  // collapses whichever one was open before. Null → all collapsed.
  int? _expandedAccordionIndex;

  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, categoriesState) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CombinedHeaderDelegate(
                    labels: const [],
                    selectedIndex: 0,
                    onTabSelected: (_) {},
                    onTabTapped: () {},
                    toolbarHeight: CombinedHeaderDelegate.defaultToolbarHeight,
                    tabsHeight: 0,
                    // Categories has no gender tab bar (design update,
                    // SEARCH_CATEGORIES_MIGRATION.md) — reuse the shared
                    // header for logo/icons + search bar only.
                    showFilters: false,
                    showSearchBar: true,
                    searchPlaceholder: categoriesState is CategoriesLoaded
                        ? categoriesState.page.searchPlaceHolder
                        : null,
                    // Navigates to the shared Search page (same as Home)
                    // instead of swapping the category list for inline
                    // results in place — gives Search its own screen-view/
                    // funnel tracking rather than hiding it inside a
                    // Categories-scoped state toggle.
                    onSearchTap: () {
                      sl<AnalyticsHelper>().logSearchClicked(
                        source: const SourcePage(
                          fromScreen: FromScreens.categories,
                          fromLocation: FromLocations.searchBox,
                        ),
                      );
                      AppNavigator.goToSearch(context);
                    },
                  ),
                ),
                ..._buildBody(context, categoriesState),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, CategoriesState state) {
    if (state is CategoriesLoading || state is CategoriesInitial) {
      // Not SliverFillRemaining — its child (a ListView, even shrinkWrap)
      // is itself scrollable, and hasScrollBody:false can't host a nested
      // scrollable (crashes with "Null check operator used on a null
      // value" during sliver layout).
      return [
        SliverToBoxAdapter(
          child: KeyedSubtree(
            key: const ValueKey(CategoriesTestStrings.loadingShimmer),
            child: LoadingShimmer.listShimmer(),
          ),
        ),
      ];
    }

    if (state is CategoriesError) {
      return [
        SliverFillRemaining(
          child: ErrorRetryWidget(
            key: const ValueKey(CategoriesTestStrings.errorRetryButton),
            message: state.message,
            onRetry: () => context.read<CategoriesBloc>().add(LoadCategories()),
          ),
        ),
      ];
    }

    if (state is CategoriesLoaded) {
      final components = [...state.page.pageComponents]
        ..sort((a, b) => a.position.compareTo(b.position));

      if (components.isEmpty) {
        return const [
          SliverFillRemaining(
            child: Center(child: Text(CategoriesStrings.noCategoriesAvailable)),
          ),
        ];
      }

      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => PageComponentRenderer(
              component: components[index],
              index: index,
              pagePrefix: CategoriesTestStrings.screen,
              isAccordionExpanded: _expandedAccordionIndex == index,
              onAccordionToggle: () => setState(() {
                _expandedAccordionIndex =
                    _expandedAccordionIndex == index ? null : index;
              }),
            ),
            childCount: components.length,
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(bottom: AppSpacing.bottomNavHeight + AppSpacing.md),
        ),
      ];
    }

    return const [SliverToBoxAdapter(child: SizedBox.shrink())];
  }
}
