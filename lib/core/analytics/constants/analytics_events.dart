/// Event-name strings sent in Segment `track()` calls.
///
/// Do not rename or tidy up. If a quirk looks like a bug, confirm with the
/// analytics owner before changing it — every change can silently break a
/// dashboard funnel.
class AnalyticsEvents {
  AnalyticsEvents._();

  // ─── Identity / Auth ────────────────────────────────────────────────
  static const String customerLoggedIn = 'customer_logged_in';
  static const String customerRegistered = 'customer_registered';
  static const String customerLoggedOut = 'customer_logged_out';
  static const String loginViewed = 'login_viewed';
  static const String joinViewed = 'join_viewed';
  static const String forgotViewed = 'forgot_viewed';
  static const String otpSent = 'otp_sent';
  static const String otpVerified = 'otp_verified';

  // ─── Lifecycle ──────────────────────────────────────────────────────
  static const String applicationOpened = 'application_opened';
  static const String appLaunched = 'app_launched';
  static const String sessionStarted = 'session_started';
  static const String installReferrer = 'install_referrer';

  // ─── Home ───────────────────────────────────────────────────────────
  static const String homePageViewed = 'homepage_viewed';
  static const String homepageScrolled = 'homepage_scrolled';
  static const String carouselScrolled = 'carousel_scrolled';
  static const String tileImpression = 'tile_impression';
  static const String bannerImpression = 'banner_impression';
  static const String tileClicked = 'tile_clicked';
  static const String ctaButtonClicked = 'cta_button_clicked';
  static const String featureCardViewed = 'feature_card_viewed';

  // ─── Landing page (deep-linked sale plans / collections) ────────────
  static const String lpTileImpression = 'lp_tile_impression';
  static const String lpBannerImpression = 'lp_banner_impression';
  static const String lpTileClicked = 'lp_tile_clicked';
  static const String lpCarouselScrolled = 'lp_carousel_scrolled';

  // ─── Tabs / tabbed pages ────────────────────────────────────────────
  static const String tabClicked = 'tab_clicked';
  static const String tabClickedNavCarousel = 'tab_clicked_nav_carousel';
  static const String tabPageContainerViewed = 'tabbed_page_container_viewed';

  // ─── Continue browsing ──────────────────────────────────────────────
  static const String continueBrowsingLoaded = 'continue_browsing_loaded';
  static const String continueBrowsingClicked = 'continue_browsing_clicked';
  static const String continueBrowsingViewed = 'continue_browsing_viewed';

  // ─── Doorways (homepage component) ──────────────────────────────────
  static const String doorwaysLoaded = 'doorway_loaded';
  static const String doorwaysViewed = 'doorway_viewed';
  static const String doorwaysScrolled = 'doorway_scrolled';
  static const String doorwaysClicked = 'doorway_clicked';

  // ─── PDP ────────────────────────────────────────────────────────────
  static const String productViewed = 'product_viewed';
  static const String cleverTapProductViewed = 'Product viewed'; // CleverTap special
  static const String productExpanded = 'product_expanded';
  static const String productViewMoreClicked = 'product_view_more_clicked';
  static const String productShareClicked = 'product_share_clicked';
  static const String selectSizeClicked = 'select_size_clicked';
  static const String sizeSelected = 'size_selected';
  static const String sizeChartViewed = 'size_chart_viewed';
  static const String sizeChartClicked = 'size_chart_clicked';
  static const String shippingInfoViewed = 'shipping_info_viewed';
  static const String pdpRecoLoaded = 'PDP_reco_loaded'; // uppercase PDP, preserve
  static const String pdpAttributesLoaded = 'pdp_attributes_loaded';
  static const String pdpImagesScrolled = 'pdp_images_scrolled';
  static const String productContentExpanded = 'product_content_expanded';
  static const String productContentCollapsed = 'product_content_collapsed';
  static const String productDetailsExpanded = 'product_details_expanded';
  static const String productDetailsCollapsed = 'product_details_collapsed';
  static const String productDetailsTabClicked = 'product_details_tab_clicked';
  static const String productAttributeTabClicked = 'product_attribute_tab_clicked';
  static const String aPlusContentViewed = 'aplus_content_viewed';
  static const String xlProductCardScrolled = 'xl_product_card_scrolled';
  static const String colorWidgetExpanded = 'color_widget_expanded';
  static const String newColorSelected = 'new_color_selected';
  static const String parentCollectionViewed = 'parent_collection_viewed';
  static const String parentCollectionClicked = 'parent_collection_clicked';
  static const String pincodeFormOpened = 'pincode_form_opened';
  static const String pincodeChange = 'pincode_change';
  static const String couponCodeClicked = 'coupon_code_clicked';
  static const String couponCodeScrolled = 'coupon_code_scrolled';
  static const String recentlyViewedProductsLoaded = 'recently_viewed_products_loaded';
  static const String recentlyViewedProductsScrolled = 'recently_viewed_products_scrolled';
  static const String recentlyViewedProductsClicked = 'recently_viewed_products_clicked';

  // ─── PLP / Boutique / Collections ───────────────────────────────────
  static const String productListingViewed = 'product_listing_viewed';
  static const String boutiqueViewed = 'boutique_viewed';
  static const String plpScrolled = 'plp_scrolled';
  static const String collectionsLoaded = 'collections_loaded';
  static const String collectionsViewed = 'collections_viewed';
  static const String specialPageViewed = 'special_page_viewed';
  static const String recentCollectionsViewed = 'recent_collections_viewed';
  static const String recentProductsViewed = 'recent_products_viewed';
  static const String recoProductsViewed = 'reco_products_viewed';
  static const String promoProductsViewed = 'promo_products_viewed';
  static const String offersViewed = 'offers_viewed';
  static const String bestsellersViewed = 'bestsellers_viewed';
  static const String upcomingCollectionsViewed = 'upcoming_collections_viewed';
  static const String plpGenieIconClicked = 'plp_genie_icon_clicked';
  static const String plpCollectionClicked = 'plp_collection_clicked';
  static const String plpCollectionsExpanded = 'plp_collections_expanded';
  static const String plpCollectionZeroProducts = 'plp_collection_zero_products';
  static const String plpCollectionsViewMoreViewed = 'plp_collection_more_products_loaded';

  // ─── Search ─────────────────────────────────────────────────────────
  static const String productsSearched = 'products_searched';
  static const String searchClicked = 'search_clicked';
  static const String searchCarouselViewed = 'search_carousel_viewed';
  static const String searchCarouselTileClicked = 'search_carousel_tile_clicked';
  static const String tooltipViewed = 'tooltip_viewed';

  // ─── Filters / sorting / pincode ────────────────────────────────────
  static const String smartFilterApplied = 'smart_filter_applied';
  static const String filterApplied = 'filter_applied';
  static const String filterClicked = 'filter_clicked';
  static const String filterCleared = 'filter_cleared';
  static const String sortingApplied = 'sorting_applied';
  static const String sortbarChanged = 'sortbar_changed';
  static const String pincodeCheckClicked = 'pincode_check_clicked';
  static const String pincodeChecked = 'pincode_checked';

  // ─── Brand ──────────────────────────────────────────────────────────
  static const String brandFollowed = 'brand_followed';
  static const String brandUnfollowed = 'brand_unfollowed';

  // ─── Reco ───────────────────────────────────────────────────────────
  static const String recoClicked = 'reco_clicked';
  static const String recoFilter = 'reco_clicked'; // Android alias — same wire value
  static const String recoViewed = 'reco_viewed';
  static const String recoProductClicked = 'reco_product_clicked';
  static const String recoSeeMoreClicked = 'reco_see_more_clicked';
  static const String productRecoViewed = 'product_reco_viewed';
  static const String recoProductsCarouselScrolled = 'reco_products_carousel_scrolled';
  static const String recoCollaborativeProductsCarouselScrolled =
      'reco_collaborative_products_carousel_scrolled';

  // ─── Cart ───────────────────────────────────────────────────────────
  static const String cartViewed = 'cart_viewed';
  static const String productAddedToCart = 'product_added_to_cart';
  static const String productAddedToNotifyList = 'product_added_to_notifylist';
  static const String productAddedToWishlist = 'product_added_to_wishlist';
  static const String productRemovedFromWishlist = 'product_removed_from_wishlist';
  static const String productUpdated = 'product_updated';
  static const String productUpdateClicked = 'product_update_clicked';
  static const String promoCodeApplied = 'promo_code_applied';
  static const String promoCodeFailed = 'promo_code_failed';
  static const String promoCodeRemoved = 'promo_code_removed';
  static const String promoRemovedFailed = 'promo_removed_failed';
  static const String buyNowClicked = 'buynow_clicked';
  static const String buyNowClickedAlt = 'buy_now_clicked'; // components-module variant

  // ─── Checkout ───────────────────────────────────────────────────────
  static const String checkoutClicked = 'checkout_clicked';
  static const String checkoutFailed = 'checkout_failed';
  static const String checkoutStarted = 'checkout_started';
  static const String checkoutMobile = 'checkout_mobile';
  static const String checkoutMobileFailed = 'checkout_mobile_failed';
  static const String checkoutReview = 'checkout_review';
  static const String checkoutReviewFailed = 'checkout_review_failed';
  static const String checkoutDelivery = 'checkout_delivery';
  static const String checkoutDeliveryFailed = 'checkout_delivery_failed';
  static const String checkoutPayment = 'checkout_payment';
  static const String checkoutPaymentFailed = 'checkout_payment_failed';
  static const String checkoutPaymentViewed = 'checkout_payment_viewed';
  static const String orderPlaceClicked = 'order_place_clicked';

  // ─── Order placement (3 terminal events) ────────────────────────────
  static const String orderPlaced = 'order_placed';
  static const String productOrdered = 'product_ordered';
  static const String orderCompleted = 'Order Completed'; // Segment spec, preserve casing+space
  static const String orderFailed = 'order_failed';
  static const String orderPending = 'order_pending';

  // ─── Orders / exchange / return ─────────────────────────────────────
  static const String orderListingViewed = 'order_listing_viewed';
  static const String orderViewed = 'order_viewed';
  static const String exchangeClicked = 'exchange_clicked';
  static const String productExchanged = 'product_exchanged';
  static const String productExchangeClicked = 'product_exchange_clicked';
  static const String exchangeAborted = 'exchange_aborted';
  static const String reasonSelected = 'reason_selected';
  static const String dialogActionClicked = 'dialog_action_clicked';
  static const String orderReturnClicked = 'order_return_clicked';
  static const String exchangeSizeSelectionCtaClicked = 'exchange_size_selection_cta_clicked';
  static const String exchangeAddressSelected = 'exchange_address_selected';
  static const String exchangeOrderPlaced = 'exchange_order_placed';
  static const String returnAddressSelected = 'return_address_selected';
  static const String returnOrderPlaced = 'return_order_placed';
  static const String exchangeNudgeWidgetViewed = 'exchange_nudge_widget_viewed';
  static const String swapWithCorrectSizeClicked = 'swap_with_correct_size_clicked';
  static const String proceedWithReturnClicked = 'proceed_with_return_clicked';

  // ─── Moments ────────────────────────────────────────────────────────
  static const String momentsViewed = 'moments_viewed';
  static const String photoLiked = 'photo_liked';
  static const String photoUndidLike = 'photo_undid_like';
  static const String photoReported = 'photo_reported';
  static const String photoUploaded = 'photo_uploaded';
  static const String photoUploadClicked = 'photo_upload_clicked';
  static const String photoDeleted = 'photo_deleted';
  static const String photoSharedClicked = 'photo_shared_clicked';
  static const String photoViewed = 'photo_viewed';

  // ─── Categories ─────────────────────────────────────────────────────
  static const String categoryTreeViewed = 'category_tree_viewed';

  // ─── Account / profile ──────────────────────────────────────────────
  static const String nameUpdated = 'name_updated';
  static const String emailUpdated = 'email_updated';
  static const String mobileUpdated = 'mobile_updated';
  static const String passwordUpdated = 'password_updated';
  static const String addressUpdated = 'address_updated';
  // Trailing space is INTENTIONAL — matches Android wire bug for dashboard parity.
  static const String profilePhotoUploaded = 'profile_photo_uploaded ';
  static const String accountCardViewed = 'account_card_viewed';

  // ─── Child profile ──────────────────────────────────────────────────
  static const String childProfileAdded = 'child_profile_added';
  static const String childProfileSelected = 'child_profile_selected';
  // Naming asymmetry — Android uses `child_details_deleted` / `child_details_edited`,
  // NOT `child_profile_deleted`/`_edited`. Preserve.
  static const String childProfileDeleted = 'child_details_deleted';
  static const String childProfileEdited = 'child_details_edited';

  // ─── Sharing ────────────────────────────────────────────────────────
  static const String appShareClicked = 'app_share_clicked';
  static const String productListingShareClicked = 'product_listing_share_clicked';
  static const String specialPageShareClicked = 'special_page_share_clicked';

  // ─── Ratings / NPS / app-rating ─────────────────────────────────────
  static const String productRated = 'product_rated';
  static const String npsFeedback = 'nps_feedback';
  static const String ratingReviewViewed = 'rating_review_viewed';
  static const String rateShoppingExperienceShownAt = 'rate_shopping_experience_shown_at';
  static const String rateInPlaystoreUserResponse = 'rate_in_playstore_user_response';
  static const String shoppingExperienceRatingsGiven = 'shopping_experience_ratings_given';
  static const String rateShoppingExperienceDismissedAt = 'rate_shopping_experience_dismissed_at';
  static const String appRatingIgnored = 'app_rating_ignored';
  static const String appRatingShownInterest = 'app_rating_shown_interest';
  static const String appRatingDialogShown = 'app_rating_dialog_shown';

  // ─── In-app update ──────────────────────────────────────────────────
  static const String inAppUpdateDownloadClicked = 'in_app_update_download_clicked';
  static const String inAppUpdateLaterClicked = 'in_app_update_later_clicked';
  static const String inAppUpdateInstallShown = 'in_app_update_install_shown';
  static const String inAppUpdateInstalledSuccess = 'in_app_update_installed_success';
  static const String inAppUpdateInstalledFailed = 'in_app_update_installed_failed';
  // NOT `..._cancelled` — preserve Android short form.
  static const String inAppUpdateUserCancelled = 'in_app_update_user_cancel';
  static const String inAppUpdateInstallClicked = 'in_app_update_install_clicked';

  // ─── Push notification permission ───────────────────────────────────
  static const String notificationPermissionIntentShown = 'notification_permission_intent_shown';
  static const String notificationPermissionAccepted = 'notification_permission_accepted';
  static const String notificationPermissionRejected = 'notification_permission_rejected';
  static const String notificationPermissionDismissed = 'notification_permission_dismissed';

  // ─── Video ──────────────────────────────────────────────────────────
  static const String videoAction = 'video_action';
  static const String videoAppeared = 'video_appeared';
  static const String videoLinkClicked = 'video_link_clicked';

  // ─── Dead / never-fired constants (kept for grep-parity with Android) ───
  /// Android constant exists at `AnalyticsEvents.CLEAR_SEGMENT_USER_TYPE` but is
  /// never fired. Listed here so cross-referencing the Android source does not
  /// produce false "missing event" findings. **Do NOT track this.**
  static const String clearSegmentUserType = 'clear_segment_user_type';
}
