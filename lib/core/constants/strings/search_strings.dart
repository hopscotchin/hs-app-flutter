class SearchStrings {
  SearchStrings._();

  static const String searchHintText = 'Search for products, brands and more';

  /// Shown in the search bar on Home and (as a loading-state fallback) on
  /// Categories — Categories otherwise prefers the live
  /// `searchPlaceHolder` from its own page response.
  static const String defaultSearchPlaceholder = 'SEARCH "BDAY DRESSES"';
  static const String keepTypingTheSuggestions =
      'Keep typing to see suggestions…';
  static const String recentSearchesTitle = 'Recent Searches';
  static const String clearAll = 'Clear All';
}
