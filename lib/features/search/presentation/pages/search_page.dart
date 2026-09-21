import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/search_strings.dart';

import '../../../../components/atoms/empty_state_widget.dart';
import '../../../../components/atoms/recent_search_chip.dart';
import '../../../../core/constants/strings/auto_test_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography/text_style_extensions.dart';
import '../../../../core/theme/typography/typography_v1.dart';
import '../../../discover/presentation/widgets/combined_header_delegate.dart';
import '../../domain/entities/search_suggestion_entity.dart';
import '../bloc/search_bloc.dart';
import '../search_commit.dart';
import '../widgets/search_suggestions_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(const LoadRecentSearches());
    // Open keyboard on entry — matches Android's autoFocus behavior in
    // SearchAutocompleteActivity.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSuggestionTap(SearchSuggestionEntity suggestion, {int? index}) => commitSearch(
    context,
    searchBloc: context.read<SearchBloc>(),
    suggestion: suggestion,
    index: index,
  );

  void _onSubmit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _onSuggestionTap(SearchSuggestionEntity(term: query, displayName: query));
  }

  void _onRecentSearchTap(String term) {
    _controller.text = term;
    _onSuggestionTap(SearchSuggestionEntity(term: term, displayName: term));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseDefault,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  // Same shared delegate Categories uses for its inline
                  // search — guarantees an identical logo/wishlist/bag row
                  // above the search box, not a page-local re-implementation.
                  delegate: CombinedHeaderDelegate(
                    labels: const [],
                    selectedIndex: 0,
                    onTabSelected: (_) {},
                    onTabTapped: () {},
                    toolbarHeight: CombinedHeaderDelegate.defaultToolbarHeight,
                    tabsHeight: 0,
                    showFilters: false,
                    showSearchBar: true,
                    // Same hint text as Home/Categories' search bars.
                    searchPlaceholder: SearchStrings.defaultSearchPlaceholder,
                    searchActive: true,
                    searchController: _controller,
                    searchFocusNode: _focusNode,
                    onSearchChanged: (value) => context.read<SearchBloc>().add(QueryChanged(value)),
                    onSearchSubmitted: _onSubmit,
                    onSearchBack: () => Navigator.of(context).pop(),
                    onSearchClear: () => context.read<SearchBloc>().add(const ClearQuery()),
                    searchInputKey: const ValueKey(SearchTestStrings.input),
                    searchBackButtonKey: const ValueKey(SearchTestStrings.backButton),
                    searchClearButtonKey: const ValueKey(SearchTestStrings.inputClearButton),
                  ),
                ),
                ..._buildBody(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.idle:
        return _buildIdleHint(state);
      case SearchStatus.loading:
        return const [
          SliverFillRemaining(
            child: Center(
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
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
                  key: const ValueKey(SearchTestStrings.errorText),
                  textAlign: TextAlign.center,
                  style: AppTypographyV1.bodyRegular.regular.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ];
      case SearchStatus.loaded:
        if (state.suggestions.isEmpty) {
          return _buildEmpty();
        }
        return [
          SliverFillRemaining(
            child: SearchSuggestionsList(
              suggestions: state.suggestions,
              onTap: _onSuggestionTap,
              itemKey: (i) => ValueKey('${SearchTestStrings.suggestionItem}_$i'),
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
      return _buildRecentSearches(state.recentSearches);
    }
    return [
      SliverFillRemaining(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            SearchStrings.keepTypingTheSuggestions,
            key: const ValueKey(SearchTestStrings.keepTypingText),
            style: AppTypographyV1.labelLarge.regular.copyWith(color: AppColors.textTertiary),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildEmpty() {
    return [
      const SliverFillRemaining(
        child: EmptyStateWidget(
          type: EmptyStateType.search,
          titleKey: ValueKey(SearchTestStrings.emptyText),
          buttonLabel: '', // no CTA here — the keyboard/search bar is already open
        ),
      ),
    ];
  }

  // Same layout as Categories' inline search — title + a Wrap of
  // RecentSearchChip pills (see CategoriesPage._buildRecentSearchesSliver).
  List<Widget> _buildRecentSearches(List<String> terms) {
    return [
      SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SearchStrings.recentSearchesTitle,
                key: const ValueKey(SearchTestStrings.recentTitle),
                style: AppTypographyV1.bodyLarge.bold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < terms.length; i++)
                    RecentSearchChip(
                      key: ValueKey('${SearchTestStrings.recentItem}_$i'),
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
}
