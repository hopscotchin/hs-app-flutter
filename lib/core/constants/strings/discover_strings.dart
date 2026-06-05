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

  // ─── ShopTheLook (add-to-bag snackbar) ────────────────────────────────────
  static const String failedToAddItemsToBag = 'Failed to add items to bag';

  static String itemsAddedToBag(int count) =>
      '$count item${count != 1 ? 's' : ''} added to bag';

  // ─── Page components — ShopTheLook widget ────────────────────────────────
  static const String addToBag = 'Add to Bag';
  static const String outOfStock = 'OUT OF STOCK';

  static String totalPriceForItems(int count) =>
      'Total Price For $count Item${count != 1 ? 's' : ''}';

  // ─── Page components — ShopTheLook bottom sheet ──────────────────────────
  static const String selectSize = 'Select Size';
  static const String atLeastOneItemMustBeSelected =
      'At least one item must be selected';
  static const String itemSoldOut = 'Uh, Oh! The item is sold out';
  static const String viewDetails = 'View Details';
  static const String sizeChart = 'Size Chart';

  // ─── Page components — ProductGrid ───────────────────────────────────────
  static const String viewAll = 'View All';

  // ─── Error messages ───────────────────────────────────────────────────────
  static const String somethingWentWrong =
      'Uh, Oh! Something went wrong. Please try again.';

  // ─── App bar greeting ─────────────────────────────────────────────────────
  static const String greetingFallback = 'there';

  static String hiGreeting(String? name) =>
      'Hi ${name ?? greetingFallback} !';

  static const String backButtonHit = 'Press Back again to exit';
}
