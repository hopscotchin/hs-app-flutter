import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hs_app_flutter/core/constants/strings/common_strings.dart';
import 'package:hs_app_flutter/core/constants/strings/search_strings.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../plp/domain/entities/page_type.dart';
import '../../domain/entities/search_suggestion_entity.dart';
import '../bloc/search_bloc.dart';

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

  void _onSuggestionTap(SearchSuggestionEntity suggestion) {
    FocusScope.of(context).unfocus();

    if (suggestion.searchParams != null && suggestion.searchParams!.isNotEmpty) {
      // Autocorrect suggestion with server-side search params — pass the raw
      // value through; PlpQueryBuilder will base64-encode it before the API call.
      final term = (html_parser.parseFragment(suggestion.term ?? '').text ?? '').trim();
      AppNavigator.goToPlp(
        context,
        pageType: PageType.search,
        plpId: 0,
        categoryName: term.isNotEmpty ? term : null,
        rawSearchParams: suggestion.searchParams,
      );
      return;
    }

    // Plain keyword search — Prefer `term` (always plain text); displayName is
    // HTML-formatted so strip tags before using it as a search keyword.
    final raw = suggestion.term ?? suggestion.displayName ?? '';
    final query = (html_parser.parseFragment(raw).text ?? '').trim();
    if (query.isEmpty) return;
    AppNavigator.goToPlp(
      context,
      pageType: PageType.search,
      plpId: 0,
      searchQuery: query,
    );
  }

  void _onSubmit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _onSuggestionTap(SearchSuggestionEntity(term: query, displayName: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<SearchBloc, SearchState>(builder: _buildBody),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          style: AppTypography.bodyMedium,
          onChanged: (value) => context.read<SearchBloc>().add(QueryChanged(value)),
          onSubmitted: _onSubmit,
          decoration: InputDecoration(
            hintText: SearchStrings.searchHintText,
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
            border: InputBorder.none,
            isDense: true,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (_, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchBloc>().add(const ClearQuery());
                  },
                );
              },
            ),
          ),
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 0.5),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    switch (state.status) {
      case SearchStatus.idle:
        return _buildIdleHint(state);
      case SearchStatus.loading:
        return const Center(
          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        );
      case SearchStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              state.errorMessage ?? CommonStrings.somethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ),
        );
      case SearchStatus.loaded:
        if (state.suggestions.isEmpty) {
          return _buildEmpty(state.query);
        }
        return _buildSuggestionList(state.suggestions);
    }
  }

  Widget _buildIdleHint(SearchState state) {
    // Hint while the user hasn't typed enough characters yet (Android: 3+).
    if (state.query.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(
        SearchStrings.keepTypingTheSuggestions,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildEmpty(String query) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(
        SearchStrings.noResultFound.replaceAll('{query}', query),
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildSuggestionList(List<SearchSuggestionEntity> suggestions) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: suggestions.length,
      separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0.5),
      itemBuilder: (context, index) {
        final s = suggestions[index];
        final raw = s.displayName?.isNotEmpty == true ? s.displayName! : (s.term ?? '');
        if (raw.isEmpty) return const SizedBox.shrink();
        return ListTile(
          leading: const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          title: Text.rich(
            TextSpan(style: AppTypography.bodyMedium, children: _buildHighlightedSpans(raw)),
          ),
          onTap: () => _onSuggestionTap(s),
        );
      },
    );
  }

  List<TextSpan> _buildHighlightedSpans(String html) {
    final fragment = html_parser.parseFragment(html);
    final spans = <TextSpan>[];
    _appendNodeSpans(fragment.nodes, spans, isBold: false);
    if (spans.isEmpty) spans.add(TextSpan(text: html));
    return spans;
  }

  void _appendNodeSpans(List<dom.Node> nodes, List<TextSpan> out, {required bool isBold}) {
    for (final node in nodes) {
      if (node is dom.Text) {
        if (node.text.isEmpty) continue;
        out.add(
          TextSpan(
            text: node.text,
            style: isBold ? const TextStyle(color: Color(0xFF707070)) : null,
          ),
        );
      } else if (node is dom.Element) {
        final descendantsBold = isBold || node.localName == 'b';
        _appendNodeSpans(node.nodes, out, isBold: descendantsBold);
      }
    }
  }
}
