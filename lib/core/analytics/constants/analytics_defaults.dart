/// Magic-string default values used across analytics payloads.
///
/// Source of truth: Android `hsapp/AnalyticsDefaults.java` plus the shared
/// `common/AnalyticsDefaults.kt`. Casing, spacing, and pluralisation are
/// mirrored verbatim — Amplitude funnels, CleverTap journey filters, and
/// Segment destination mappings all key on these exact tokens.
///
/// **Bug-for-bug parity**: some values are inconsistent on Android (e.g.
/// `OTHER` is `"Other"` in hsapp but `"other"` in common). Both forms are
/// exposed below; pick the one the caller's Android equivalent uses.
class AnalyticsDefaults {
  AnalyticsDefaults._();

  // ─── Funnel names ──────────────────────────────────
  static const String discover = 'Discover';

  // ─── Integration destination names ──────────────────────────────────
  static const String integrationAmplitude = 'Amplitude';

  // ─── Platform values for `hs_site` trait ────────────────────────────
  static const String platformAndroid = 'android';
  static const String platformIos = 'ios';

  // ─── Currency / app brand ───────────────────────────────────────────
  static const String inr = 'INR';
  static const String hopscotch = 'Hopscotch';

  // ─── Yes / No / sentinel values ─────────────────────────────────────
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String none = 'none';

  /// Hsapp-only "no address" sentinel (capitalised). Distinct from [none]
  /// (lowercase, used for empty-string fallbacks on most string keys).
  static const String addressNone = 'None';

  // ─── Visitor types (lowercase with single space — preserve) ─────────
  static const String newVisitor = 'new visitor';
  static const String repeatVisitor = 'repeat visitor';

  // ─── Install / Update lifecycle ─────────────────────────────────────
  static const String newInstall = 'New';
  static const String update = 'Update';
  static const String isOld = 'false'; // mirrors Android boolean false sentinel

  // ─── Auth ───────────────────────────────────────────────────────────
  static const String email = 'Email';
  static const String facebook = 'Facebook';
  static const String mobile = 'Mobile';
  static const String otp = 'OTP';
  static const String password = 'Password';

  // ─── Generic UI / navigation / surfaces ─────────────────────────────
  static const String navigation = 'navigation';
  static const String productDetails = 'Product details';
  static const String standard = 'standard';
  static const String available = 'Available';
  static const String notAvailable = 'Not available';
  static const String defaultValue = 'Default';
  static const String recent = 'Recent';
  static const String popular = 'Popular';
  static const String background = 'Background';
  static const String screen = 'Screen';
  static const String similarProducts = 'Similar products';
  static const String wishlistIcon = 'Wishlist icon';
  static const String soldOut = 'Sold out';
  static const String regular = 'regular';
  static const String buyNow = 'Buy now';
  static const String addToCart = 'Add to cart';
  static const String upcomingCountdown = 'Upcoming countdown';
  static const String endingCountdown = 'Ending countdown';
  static const String xl = 'XL';
  static const String normal = 'Normal';
  static const String other = 'Other'; // hsapp variant
  static const String otherLower = 'other'; // common-module variant
  static const String firstScreen = 'First screen';
  static const String customTile = 'CT';
  static const String customProductTile = 'CPT';
  static const String messageBar = 'Message bar';
  /// Default sort-bar tab name. Mirrors Android common-module
  /// `AnalyticsDefaults.ALL = "All"`. Set by `OrderAttributionHelper.setSortBar`
  /// when the home page loads with no user selection.
  static const String sortBarAll = 'All';
  static const String cta = 'CTA Button';
  static const String cart = 'Cart';

  // ─── Source tags for from_source ────────────────────────────────────
  static const String branch = 'Branch'; // never set on Android — kept for parity
  static const String appsFlyer = 'AppsFlyer';
  static const String push = 'Push';
  static const String deeplink = 'Deeplink';

  // ─── common-module additions ────────────────────────────────────────
  static const String success = 'success';
  static const String failure = 'failure';
  static const String fromOrderSummary = 'Order Summary';
  static const String couponCodeCopied = 'Coupon Code Copied';
  static const String played = 'played';
  static const String unMute = 'Unmute';
  static const String mute = 'Mute';
  static const String all = 'All';
  static const String fullScreen = 'full_screen';
  static const String minimize = 'minimized';
  static const String same = 'Same';
  static const String lower = 'Lower';
  static const String higher = 'Higher';
  static const String bankAccount = 'Bank account';
  static const String hopscotchMerchandisingCredits = 'Hopscotch merchandising credits';
  static const String internal = 'internal';
  static const String external = 'external';
}

/// First-class `from_screen` values. Mirrors `AnalyticsDefaults$FromScreens`
/// (hsapp) merged with `common/AnalyticsDefaults$FromScreens`. The union covers
/// both source-of-truth files.
class FromScreens {
  FromScreens._();

  // hsapp values
  static const String product = 'Product details';
  static const String webview = 'Webview';
  static const String onboarding = 'Onboarding';
  static const String photoDetails = 'Photo details';
  static const String shoppingCart = 'Cart';
  static const String featureCard = 'Feature card';
  static const String discover = 'Discover';
  static const String recentProducts = 'Recent products';
  static const String recentCollections = 'Recent collections';
  static const String specialPage = 'Special page';
  static const String bestsellers = 'Bestsellers';
  static const String upcoming = 'Upcoming';
  static const String account = 'Account';
  static const String orderListing = 'Order listing';
  static const String orderDetails = 'Order details';
  static const String login = 'Login';
  static const String join = 'Join';
  static const String orderConfirmation = 'Order confirmation';
  static const String productRating = 'Product Rating';
  static const String boutique = 'Boutique Plp';
  static const String productListPage = 'Search Plp';
  static const String categories = 'Categories';
  static const String legal = 'Legal';
  static const String orderCheckout = 'Checkout';
  static const String checkoutReview = 'Checkout Review';
  static const String exchangeConfirmation = 'Exchange confirmation';
  static const String orderExchange = 'Order exchange';
  static const String paymentStatus = 'Payment Processing';

  // Screen-level labels used by `AppNavigationObserver` for the `nav_screens`
  // trail. Distinct from other analytics slots so a rename here doesn't ripple
  // through unrelated call sites.
  static const String splash = 'Splash';
  static const String landingPage = 'Landing Page';

  // common-module additions / overrides
  /// common-module uses `"PLP"` (uppercase). Distinct from hsapp's
  /// [boutique]/[productListPage]; pick by call site.
  static const String plp = 'PLP';
  static const String boutiqueLower = 'boutique';
  static const String searchResult = 'Search results';
  static const String similarProducts = 'Similar products';
  static const String moreRecommendation = 'More Recommendations';
  static const String wishlist = 'Wishlist';
  static const String paymentRetry = 'Payment Retry';
}

/// First-class `from_page` values. From `common/AnalyticsDefaults.kt`.
class FromPage {
  FromPage._();

  static const String doorways = 'doorways';
  static const String cart = 'cart';
  static const String recommendation = 'recommendation';
  static const String parentCollection = 'parent_collection';
  static const String recentlyViewed = 'recently_viewed';
  static const String homepage = 'homepage';
  static const String tabbedLandingPage = 'tabbedlandingpage';
  static const String boutique = 'boutique';
  static const String orderDetails = 'order_details';
}

/// First-class `from_location` values. Union of hsapp and common-module.
class FromLocations {
  FromLocations._();

  // hsapp
  static const String addToCartButton = 'Add to cart button';
  static const String reminderButton = 'Reminder button';
  static const String wishlistButton = 'Wishlist button';
  static const String cartIcon = 'Cart icon';
  static const String likeButton = 'Like button';
  static const String signInButton = 'Sign in button';
  static const String signUpButton = 'Join button';
  static const String uploadButton = 'Upload button';
  static const String deeplink = 'Deeplink';
  static const String overlay = 'Overlay';
  static const String sizePicker = 'Size picker';
  static const String imageCarousel = 'Image carousel';
  static const String messageBar = 'Message bar';
  static const String promoCode = 'Promo code application';
  static const String buyNowButton = 'Buy now button';
  static const String cancelButton = 'Cancel button';
  static const String returnButton = 'Return button';
  static const String exchangeButton = 'Exchange button';
  static const String nudge = 'Nudge';
  static const String productRating = 'Product Rating';
  static const String profileDetails = 'Profile Details';
  static const String moveToWishlist = 'Move to wishlist';
  static const String searchIcon = 'Search icon';
  static const String categoryTile = 'Tile';
  static const String searchBox = 'Search box';
  static const String sizeSelectionUpfront = 'upfront';
  static const String sizeSelectionBottomSheet = 'bottom_sheet';
  static const String productAttribute = 'product_attribute';

  // common-module additions
  static const String sizeListUpfront = 'Size list upfront';
  static const String cartIconButton = 'Cart Icon Button';
  static const String cartButton = 'Cart button';
  static const String sizeChartButton = 'Size Chart button';
  static const String productTile = 'Product Tile';
  static const String childrenManager = 'CHILDREN_MANAGER';
}

/// `click_type` values fired on tile/card clicks across the funnel.
class ClickType {
  ClickType._();

  static const String searchCtr = 'Search CTR';
  static const String productListCtr = 'Product list CTR';
  static const String boutiqueCtr = 'Boutique CTR';
  static const String recoCtr = 'Reco CTR';
  static const String rfypCtr = 'RFYP CTR';
  static const String recentCtr = 'Recent CTR';
  static const String directCtr = 'Direct PDP';
  static const String wishlistCtr = 'Wishlist CTR';
  static const String homepageRecentCarouselCtr = 'Homepage Recent Carousel CTR';
  static const String productAttributeCtr = 'Product Attribute CTR';
  static const String similarRecoCtr = 'Similar Reco CTR';
  static const String reviewCart = 'Review Cart';
  static const String cancel = 'Cancel';
}

/// `query_correction` values for search results.
class QueryCorrection {
  QueryCorrection._();

  static const String suggestedCorrection = 'Suggested correction';
  static const String autocorrected = 'Autocorrected';
  static const String autoTrimmed = 'Auto trimmed';
  static const String suggestionUsed = 'Suggestion used';
  static const String autocorrectReverted = 'Autocorrect reverted';
}

/// Redirect-type sentinels used by deeplink routing.
class RedirectTypes {
  RedirectTypes._();

  static const String redirectAddToWishlist = 'REDIRECT_ADD_TO_WISHLIST';
  static const String redirectGoToWishlist = 'REDIRECT_GO_TO_WISHLIST';
  static const String redirectCheckoutSheet = 'REDIRECT_CHECKOUT_SHEET';
  static const String redirectWishlist = 'REDIRECT_WISHLIST';
  static const String redirectWishlistItem = 'REDIRECT_WISHLIST_ITEM';
  static const String redirectWishlistScreen = 'REDIRECT_WISHLIST_SCREEN';
  static const String redirectAddChild = 'REDIRECT_ADD_CHILD';
}

/// `source_tile_type` values used by PDP / PLP attribution.
class SourceTileType {
  SourceTileType._();

  static const String xl = 'xl';
  static const String normal = 'normal';
  static const String other = 'other';
}

/// `video_play_type` values for video components.
class VideoPlayType {
  VideoPlayType._();

  static const String playButton = 'play_button';
  static const String autoPlay = 'auto_play';
}

/// `video_page` placement values.
class VideoPage {
  VideoPage._();

  static const String hp = 'HP';
  static const String lp = 'LP';
}

/// `click_source` filter-section values.
class FilterClickSource {
  FilterClickSource._();

  static const String genieFilter = 'genie_filter';
  static const String standardFilters = 'standard_filters';
  static const String floatingFilters = 'floating_filter';
  static const String stickyFilter = 'sticky_filter';
}
