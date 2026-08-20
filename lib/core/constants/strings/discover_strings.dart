class DiscoverStrings {
  DiscoverStrings._();

  static const String defaultPageName = 'discover';

  // ─── Discover page ───────────────────────────────────────────────────────────
  static const String discoverTitle = 'Discover';
  static const String noContentAvailable = 'No content available';

  // Tab labels
  static const String tabAll = 'All';
  static const String tabBaby = 'Baby';
  static const String tabBoy = 'Boy';
  static const String tabGirl = 'Girl';

  // ─── Page components — ProductGrid ───────────────────────────────────────
  static const String viewAll = 'View All';

  // ─── Error messages ───────────────────────────────────────────────────────
  static const String somethingWentWrong =
      'Uh, Oh! Something went wrong. Please try again.';

  // ─── App bar greeting ─────────────────────────────────────────────────────
  static const String greetingFallback = 'there';

  static String hiGreeting(String? name) => 'Hi ${name ?? greetingFallback} !';

  static const String backButtonHit = 'Press Back again to exit';
}
