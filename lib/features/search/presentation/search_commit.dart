import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;

import '../../../core/analytics/constants/analytics_defaults.dart';
import '../../../core/analytics/constants/attribution_constants.dart';
import '../../../core/analytics/events/analytics_helper.dart';
import '../../../core/analytics/events/modules/search_events.dart';
import '../../../core/di/injection.dart';
import '../../../core/router/app_navigator.dart';
import '../../plp/domain/entities/page_type.dart';
import '../../plp/domain/entities/plp_entry_args.dart';
import '../domain/entities/search_suggestion_entity.dart';
import 'bloc/search_bloc.dart';

/// Commits a search — a tapped suggestion, a submitted query, or a re-tapped
/// recent search — the same way on every surface that can trigger one
/// (the Search page, Categories' inline search). Records the plain-text term
/// as a recent search, installs the funnel attribution the PLP (and PDP/ATC/
/// order after it) reads back, then navigates to PLP with the analytics entry
/// context; an autocorrect suggestion with server-side `searchParams` takes
/// priority over the plain keyword path.
///
/// [index] is 1-indexed on the wire, matching Android's
/// `SUGGESTION_INDEX = position + 1`; a submitted query that was never a
/// listed suggestion passes null rather than a fabricated rank.
void commitSearch(
  BuildContext context, {
  required SearchBloc searchBloc,
  required SearchSuggestionEntity suggestion,
  int? index,
}) {
  FocusScope.of(context).unfocus();

  // Synchronous, before navigating — the PLP reads attribution during its
  // own build.
  sl<AnalyticsHelper>().setSearchAttribution(
    funnelTile: suggestion.term?.isNotEmpty == true ? suggestion.term! : '',
  );

  if (suggestion.searchParams != null && suggestion.searchParams!.isNotEmpty) {
    // Autocorrect suggestion with server-side search params — pass the raw
    // value through; PlpQueryBuilder will base64-encode it before the API call.
    final term = (html_parser.parseFragment(suggestion.term ?? '').text ?? '').trim();
    if (term.isNotEmpty) {
      searchBloc.add(RecordRecentSearch(term));
    }
    AppNavigator.goToPlp(
      context,
      pageType: PageType.search,
      plpId: 0,
      categoryName: term.isNotEmpty ? term : null,
      rawSearchParams: suggestion.searchParams,
      args: _entryArgs(suggestion, term, index: index),
    );
    return;
  }

  // Plain keyword search — Prefer `term` (always plain text); displayName is
  // HTML-formatted so strip tags before using it as a search keyword.
  final raw = suggestion.term ?? suggestion.displayName ?? '';
  final query = (html_parser.parseFragment(raw).text ?? '').trim();
  if (query.isEmpty) return;
  searchBloc.add(RecordRecentSearch(query));
  AppNavigator.goToPlp(
    context,
    pageType: PageType.search,
    plpId: 0,
    searchQuery: query,
    args: _entryArgs(suggestion, query, index: index),
  );
}

/// Analytics entry context for a search-driven PLP open.
///
/// Android has no `FROM_SCREEN` intent extra on this path — `PLPAnalytics`
/// hardcodes the literal `"Search"` in its search branch. Flutter's PLP reads
/// the value from the entry args instead of hardcoding it in the event
/// builder, so it is supplied here; the wire value is identical.
PlpEntryArgs _entryArgs(SearchSuggestionEntity suggestion, String query, {int? index}) {
  return PlpEntryArgs(
    fromScreen: PlpType.search,
    suggestionIndex: index == null ? null : index + 1,
    keyword: query,
    suggestionTrackingData: suggestion.trackingMeta,
    // Android sets `SourceTracker.addFromDetails` to `R.string.searchTitle` on
    // every search-originated listing open — suggestion tap, typed submit and
    // recent-search tap alike — and `PLPAnalytics.setIntentData` reads it back
    // into `add_from_details`. There is no intent extra, so it travels here.
    addFromDetails: AddFromDetails.search,
  );
}
