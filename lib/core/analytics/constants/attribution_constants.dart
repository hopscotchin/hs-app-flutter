/// `add_from_details` values. Android holds these in the `SourceTracker`
/// singleton and `PLPAnalytics.setIntentData` reads it back
/// (`PLPAnalytics.kt:129`) — there is no intent extra, which is why the value
/// has to be supplied explicitly at each navigation here.
///
/// ⚠️ Only the search values are ported. Android's `SourceTracker` is an
/// app-wide mutable singleton with ~25 writers (departments, sale plans,
/// moments, orders, PDP recos, deeplinks) and a `navigationHook` layering rule
/// that rewrites the value on deeplink/app-link entry. Porting that subsystem
/// is its own piece of work; until then every non-search surface ships without
/// `add_from_details`, which is what Flutter did before too.
class AddFromDetails {
  AddFromDetails._();

  /// Every search-originated listing open — suggestion tap, typed submit, and
  /// recent-search tap all set the same value on Android
  /// (`R.string.searchTitle`, `SearchAutocompleteActivity:202`, `:397`).
  static const String search = 'Search';
}
