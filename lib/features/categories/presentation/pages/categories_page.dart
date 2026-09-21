import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/error_retry_widget.dart';
import '../../../../components/atoms/loading_shimmer.dart';
import '../../../../components/atoms/recent_search_chip.dart';
import '../../../../core/analytics/constants/analytics_defaults.dart';
import '../../../../core/analytics/events/analytics_helper.dart';
import '../../../../core/analytics/events/modules/plp_events.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/constants/strings/categories_strings.dart';
import '../../../../core/constants/strings/common_strings.dart';
import '../../../../core/constants/strings/search_strings.dart';
import '../../../../core/cubits/bottom_nav_visibility_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/nav_destination.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../discover/presentation/widgets/combined_header_delegate.dart';
import '../../../discover/presentation/widgets/page_component_renderer.dart';
import '../../../search/domain/entities/search_suggestion_entity.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/presentation/search_commit.dart';
import '../../../search/presentation/widgets/search_suggestions_list.dart';
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

  // Tapping the search bar swaps the category list for inline search content
  // on this same page instead of navigating to the shared Search page.
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(LoadCategories());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _enterSearch() {
    sl<AnalyticsHelper>().logSearchClicked(
      source: const SourcePage(
        fromScreen: FromScreens.categories,
        fromLocation: FromLocations.searchBox,
      ),
    );
    context.read<SearchBloc>().add(const LoadRecentSearches());
    // Inline search wants the full viewport — same shell-level override the
    // dedicated Search page gets for free by being a separate, nav-bar-less
    // route.
    context.read<BottomNavVisibilityCubit>().hide();
    setState(() => _isSearching = true);
    // Open keyboard on entry — matches the dedicated Search page's autofocus.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _exitSearch() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    // Reset to idle so re-entering search starts fresh, same as the
    // dedicated Search page (which gets a brand-new SearchBloc per visit).
    context.read<SearchBloc>().add(const ClearQuery());
    context.read<BottomNavVisibilityCubit>().show();
    setState(() => _isSearching = false);
  }

  void _onSuggestionTap(SearchSuggestionEntity suggestion, {int? index}) =>
      commitSearch(
        context,
        searchBloc: context.read<SearchBloc>(),
        suggestion: suggestion,
        index: index,
      );

  void _onSearchSubmit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _onSuggestionTap(SearchSuggestionEntity(term: query, displayName: query));
  }

  void _onRecentSearchTap(String term) {
    _searchController.text = term;
    _onSuggestionTap(SearchSuggestionEntity(term: term, displayName: term));
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
                    searchPlaceholder: _isSearching
                        ? SearchStrings.defaultSearchPlaceholder
                        : (categoriesState is CategoriesLoaded
                              ? categoriesState.page.searchPlaceHolder
                              : null),
                    searchActive: _isSearching,
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    onSearchChanged: (value) =>
                        context.read<SearchBloc>().add(QueryChanged(value)),
                    onSearchSubmitted: _onSearchSubmit,
                    onSearchBack: _exitSearch,
                    onSearchClear: () =>
                        context.read<SearchBloc>().add(const ClearQuery()),
                    onSearchTap: _enterSearch,
                    searchInputKey: const ValueKey(
                      CategoriesTestStrings.searchInput,
                    ),
                    searchBackButtonKey: const ValueKey(
                      CategoriesTestStrings.searchBackButton,
                    ),
                    searchClearButtonKey: const ValueKey(
                      CategoriesTestStrings.searchInputClearButton,
                    ),
                  ),
                ),
                if (_isSearching)
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, searchState) => SliverMainAxisGroup(
                      slivers: _buildSearchBody(searchState),
                    ),
                  )
                else
                  ..._buildBody(context, categoriesState),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSearchBody(SearchState state) {
    switch (state.status) {
      case SearchStatus.idle:
        return _buildIdleHint(state);
      case SearchStatus.loading:
        return const [
          SliverFillRemaining(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ];
      case SearchStatus.error:
        return [
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  state.errorMessage ?? CommonStrings.somethingWentWrong,
                  key: const ValueKey(CategoriesTestStrings.searchErrorText),
                  textAlign: TextAlign.center,
                  style: AppTypographyV1.bodyRegular.regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ];
      case SearchStatus.loaded:
        if (state.suggestions.isEmpty) {
          return _buildSearchEmpty();
        }
        return [
          SliverFillRemaining(
            child: SearchSuggestionsList(
              suggestions: state.suggestions,
              onTap: _onSuggestionTap,
              itemKey: (i) =>
                  ValueKey('${CategoriesTestStrings.searchSuggestionItem}_$i'),
            ),
          ),
        ];
    }
  }

  List<Widget> _buildIdleHint(SearchState state) {
    // Hint while the user hasn't typed enough characters yet (Android: 3+).
    if (state.query.isEmpty) {
      if (state.recentSearches.isEmpty) {
        return const [SliverToBoxAdapter(child: SizedBox.shrink())];
      }
      return _buildRecentSearchesSliver(state.recentSearches);
    }
    return const [SliverToBoxAdapter(child: SizedBox.shrink())];
  }

  List<Widget> _buildSearchEmpty() {
    return [
      const SliverFillRemaining(
        child: EmptyStateWidget(
          type: EmptyStateType.search,
          titleKey: ValueKey(CategoriesTestStrings.searchEmptyText),
          buttonLabel:
              '', // no CTA here — the keyboard/search bar is already open
        ),
      ),
    ];
  }

  // Same layout as the dedicated Search page's recent searches — see
  // SearchPage._buildRecentSearches.
  List<Widget> _buildRecentSearchesSliver(List<String> terms) {
    return [
      SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SearchStrings.recentSearchesTitle,
                key: const ValueKey(CategoriesTestStrings.searchRecentTitle),
                style: AppTypographyV1.bodyMedium.medium.textPrimary(),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < terms.length; i++)
                    RecentSearchChip(
                      key: ValueKey(
                        '${CategoriesTestStrings.searchRecentItem}_$i',
                      ),
                      label: terms[i],
                      onTap: () => _onRecentSearchTap(terms[i]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
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
                _expandedAccordionIndex = _expandedAccordionIndex == index
                    ? null
                    : index;
              }),
            ),
            childCount: components.length,
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.bottomNavHeight + AppSpacing.md,
          ),
        ),
      ];
    }

    return const [SliverToBoxAdapter(child: SizedBox.shrink())];
  }
}
