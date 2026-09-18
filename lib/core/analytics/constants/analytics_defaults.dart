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

  /// `quantity_status` for a line that cannot be bought — sold out, or its size
  /// is. Android's `Constants.ZERO`.
  ///
  /// The **string** `"0"`, never the number: Android's `putAnalyticsKey` drops
  /// any number <= 0, so a numeric zero would silently never reach the wire and
  /// the sold-out bucket would be empty on that platform.
  static const String zeroQuantity = '0';
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

  /// The OTP screen, for the `nav_screens` breadcrumb only.
  ///
  /// No Android counterpart: its FromScreens has LOGIN and JOIN and stops
  /// there, because it never names the OTP screen — `otp_verified` hardcodes
  /// FromScreens.ACCOUNT (OTPVerificationActivity.kt:216). `nav_screens` is
  /// itself Flutter-only (finding B5), so nothing on the wire has to agree
  /// with this value.
  ///
  /// Not a `from_screen`: the auth events read that from [AuthEntryArgs], not
  /// from the trail.
  static const String otpVerification = 'OTP verification';
  static const String orderConfirmation = 'Order confirmation';
  static const String productRating = 'Product Rating';
  static const String boutique = 'Boutique Plp';
  static const String productListPage = 'Search Plp';
  static const String productListing = 'Product listing';

  /// The boutique's search icon — **a Flutter-only value with no Android
  /// counterpart.**
  ///
  /// Android's boutique listing has no search control: `boutique_plp_menu.xml`
  /// inflates only favorite, reminder, cart and wishlist, which is why
  /// `ProductsListingActivity`'s `actionbar_search` branch (`:1214`) is
  /// unreachable. Flutter's boutique app bar does have the icon, so
  /// `search_clicked` fires from a surface Android never fires it from and
  /// there is no existing string to reuse.
  ///
  /// Deliberately not [boutique]: that names the screen for events Android
  /// *does* send from there (wishlist add/remove, PDP entry), and reusing it
  /// would make this Flutter-only behaviour indistinguishable from them.
  /// Deliberately not [productListPage] either — despite reading `"Search
  /// Plp"`, that constant is `PRODUCT_LIST_PAGE`, the *listing screen's* name,
  /// which Android also sends on wishlist events
  /// (`ProductListPageActivity:367`, `:3643`, `:4204`). Using it here would
  /// fold boutique searches into the listing's numbers.
  ///
  /// ⚠️ New value — needs to be added to the dashboards; no Android build will
  /// ever emit it.
  static const String searchBoutique = 'Search Boutique';
  static const String categories = 'Categories';
  static const String legal = 'Legal';
  static const String checkout = 'Checkout';
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
  /// `plp_name` value when a search returns zero results. Mirrors Android's
  /// `PLPAnalytics.logListingViewed` (`plp_name = "No results"` when
  /// `totalRecords == 0`) — a property value, not a separate event.
  static const String noSearchResult = 'No results';
  static const String similarProducts = 'Similar products';
  static const String moreRecommendation = 'More Recommendations';
  static const String wishlist = 'Wishlist';
  static const String paymentRetry = 'Payment Retry';
}

/// First-class `from_page` values. From `common/AnalyticsDefaults.kt`.
class FromPage {
  FromPage._();

  /// PLP → PDP. A literal on Android rather than a constant
  /// (`ProductListPageActivity.java:794`), so this is the value it emits.
  static const String plp = 'plp';

  /// Search results → PDP. Android sends the **localised** string resource
  /// (`ProductListPageActivity.java:796` → `R.string.search`), whose en value is
  /// `"Search"` — capitalised, unlike every sibling here. Matching the literal is
  /// what keeps the metric aligned; do not "fix" the casing.
  static const String search = 'Search';

  static const String doorways = 'doorways';
  static const String cart = 'cart';
  static const String recommendation = 'recommendation';
  static const String parentCollection = 'parent_collection';
  static const String recentlyViewed = 'recently_viewed';
  static const String homepage = 'homepage';

  /// A (non-tabbed) landing page. Android writes it as a **literal**
  /// (`SearchResultsShowingBoutiquesActivity:560` — `setFromPage("landingPage")`)
  /// rather than adding it to its own `FromPage` object, so the camelCase is
  /// deliberate and does not match the lowercase siblings around it.
  static const String landingPage = 'landingPage';

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

  /// PDP's recommended rail. All three PDP wishlist surfaces report
  /// `from_screen: "Product details"`, so `from_location` is the only thing
  /// separating them.
  ///
  /// Deliberately not `FromScreens.similarProducts` — that names a whole screen,
  /// and reusing it would make a rail tap indistinguishable from one there.
  /// "Section" rather than "carousel" because the reco rail renders as rows, so
  /// the name survives a layout change.
  ///
  /// ⚠️ New value — Android has no rail wishlist, so there is nothing to match.
  static const String recoSection = 'Reco section';

  /// PDP's recently-viewed rail. See [recoSection].
  static const String recentlyViewedSection = 'Recently viewed section';
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

  /// `from_location` for the price-summary info events — Android's
  /// `FROM_ORDER_SUMMARY`, its only value for this slot. Which fee was opened
  /// is carried by the event name, not by this.
  ///
  /// ⚠️ Android fires off the row's subText link and fires nothing for the ⓘ
  /// icon (`PriceItemAdapter`). We report the ⓘ, the control that actually
  /// opens the fee sheet. Same value, different trigger.
  static const String orderSummary = 'Order Summary';

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

  static const String wishlistProduct = 'Wishlist Product';

  /// Homepage grid tile. Android passes `R.string.segment_custom_tile` as the
  /// PLP intent's `FROM_LOCATION` for every tile tap
  /// (`CollectionsAdapter.kt:688`).
  static const String customTile = 'Custom tile';

  /// Homepage / boutique custom *product* tile —
  /// `R.string.segment_custom_product_tile` (`TileAction.java:946`).
  static const String customProductTile = 'Custom product tile';

  // common-module additions
  static const String sizeListUpfront = 'Size list upfront';

  /// The app-bar bag icon — **how the cart is opened everywhere in Flutter**
  /// (Home, PLP, PDP, wishlist, checkout), so it is the `from_location` of the
  /// `cart_viewed` that a fresh cart entry fires.
  ///
  /// Android splits this across two values because it opens the cart from two
  /// kinds of control: `ProductListActivity:753` and `PaymentStateActivity`
  /// send this one from their app-bar icon, while `WishlistActivity:150` sends
  /// [cartButton] from its own `shoppingBagIcon`. Flutter has one control, so
  /// it sends one value — this one, the majority spelling and the one whose
  /// call sites (a listing's app bar) match Flutter's.
  ///
  /// Note the capital I and B: Android's constant reads `"Cart Icon Button"`
  /// while its sibling reads `"Cart button"`. Both are on the dashboards under
  /// those exact spellings.
  static const String cartIconButton = 'Cart Icon Button';

  /// The wishlist screen's bag icon on Android (`WishlistActivity:150`). Kept
  /// for parity; Flutter routes every cart entry through [cartIconButton].
  static const String cartButton = 'Cart button';
  static const String sizeChartButton = 'Size Chart button';
  static const String productTile = 'Product Tile';
  static const String childrenManager = 'CHILDREN_MANAGER';

  // ─── Cart reloads ───────────────────────────────────────────────────
  // What re-read an already-open cart, reported as `from_location` on the
  // `cart_viewed` that reload fires. A *fresh* cart entry reports
  // [cartIconButton] instead — the control that opened it.
  //
  // Android has no equivalent: its `CartFragment.fromLocation` is set once
  // from the launching intent and never changes, so every reload there
  // repeats the value the cart was opened with. Splitting them is what makes
  // "cart reloaded after a promo change" distinguishable from "user came back
  // to the cart", which is the whole point of `cart_view_state: Cart reload`.

  /// Cart re-read after the user changed the delivery pincode.
  static const String pincodeSelection = 'Pincode selection';

  /// Cart re-read after a promo was **removed**.
  ///
  /// Android's `FromLocations.REMOVE_PROMO`, used only by
  /// `CartViewModel.removePromoCode()` (`:179`). Removal only — see
  /// [applyPromo].
  static const String removePromo = 'Remove promo';

  /// Cart re-read after a promo was **applied**.
  ///
  /// ⚠️ Coined — needs analytics sign-off. Android has no value for this slot:
  /// its apply lives on `PromosActivity` and the return reload is labelled
  /// `MOBILE_VERIFY` = "Mobile verify from message bar" (`CartFragment:105`),
  /// a misnomer not worth matching. Applies previously landed in
  /// [removePromo]'s bucket, so the two stop being summable.
  static const String applyPromo = 'Apply promo';

  /// Cart re-read because checkout reported lines were dropped from the bag.
  /// Android's `FromLocations.REFRESH_CART` (`CartViewModel:260`) — the odd
  /// casing and wording are its literal value.
  static const String refreshCartForRemovedItem = 'Refresh cart for RemoveItem';

  /// Cart re-read after a quantity step, or the `from_location` of the
  /// `product_update_clicked` that a +/- tap fires.
  static const String updateCart = 'Update cart';

  /// Cart re-read after the signed-out/other-device bag was merged in.
  static const String mergeCart = 'Merge cart';

  /// Cart re-read after a line was removed. Android's
  /// `FromLocations.DELETE_CART`, sent from `CartFragment:444` —
  /// `getCartData(DELETE_CART, startLoading = false)`.
  ///
  /// This is the **reload reason**, not the control: it names why the cart was
  /// re-fetched, and rides on the `cart_viewed` that follows. The control that
  /// started it is [removeCartItem].
  static const String deleteCart = 'Delete cart';

  /// The row's remove (✕) control — `from_location` on the
  /// `product_update_clicked` and `product_updated` of a removal.
  ///
  /// ⚠️ **Flutter-only value; no Android build emits it.** Checked against the
  /// full `hscart/.../helper/FromLocations.kt` — its sixteen values include
  /// `SWIPE` and `MORE_BUTTON` for this slot but nothing for a remove button,
  /// because Android has none: a line is removed by swiping it
  /// (`CartProductViewHolder:167`) or through a per-row overflow menu
  /// (`:180`). Neither gesture exists here, and reusing "Swipe" would report
  /// an interaction the user cannot perform — the one thing this property is
  /// meant to distinguish.
  ///
  /// Deliberately not [deleteCart] either: that is the reload reason above, and
  /// sending it here would make the control indistinguishable from the refetch
  /// it triggers on events that carry both.
  ///
  /// Needs adding to the dashboards alongside Android's two.
  static const String removeCartItem = 'Remove cart item';
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
  static const String standardFilter = 'standard_filters';
  static const String floatingFilter = 'floating_filter';
  static const String stickyFilter = 'sticky_filter';
}

/// `plp_type` values. Mirrors PLPAnalytics.kt companion constants.
class PlpType {
  PlpType._();

  static const String productListing = 'Product listing';
  static const String boutique = 'Boutique';
  static const String search = 'Search';
  static const String searchResults = 'Search results';
  static const String noResults = 'No results';
  static const String reco = 'Reco';
  static const String promotionProducts = 'Promotion products';
}

/// `cart_view_state` values. Mirrors Android `CartViewModel.cartViewState`,
/// which is a bare `String` field the fragment writes before each fetch
/// (`CartFragment` sets `Cart load` on first entry, `Cart reload` on every
/// refetch, `Cart back` on return from checkout).
///
/// An empty value falls back to [AnalyticsDefaults.none] on Android
/// (`fireCartViewedEvent`'s `ifEmpty`), so there is no "unset" token here —
/// every fetch names its own state.
class CartViewStates {
  CartViewStates._();

  /// First fetch after the cart screen is opened.
  static const String cartLoad = 'Cart load';

  /// Any subsequent fetch while the screen stays open — promo change,
  /// quantity step, pincode change, merge, pull-to-refresh.
  static const String cartReload = 'Cart reload';

  /// Fetch triggered by returning to the cart from a screen it pushed
  /// (checkout, PDP).
  static const String cartBack = 'Cart back';
}
