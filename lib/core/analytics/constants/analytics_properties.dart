/// Property-key strings sent in Segment event payloads.
///
/// Source of truth: Android `hsapp/AnalyticsProperties.java` and the shared
/// `common/AnalyticsProperties.kt` + `components/AnalyticsEvents.kt` modules.
/// Strings are mirrored verbatim — including quirks like the `[time] ` prefix
/// on time keys and mixed-case CleverTap trait names. Dashboards key on these
/// exact tokens; renaming silently breaks funnels.
///
/// Some property keys collide on the wire but live as separate Dart fields here
/// to mirror Android's structural separation (e.g. `atcFrom` and `atcSite` both
/// serialize to `atc_site`; `tabbedPageTabName` and `tabName` both serialize to
/// `tab_name`). Tabbed-page-specific keys are grouped inside the nested
/// [TabbedPageProperties] class for parity with `AnalyticsProperties$TabbedPageProperties`.
class AnalyticsProperties {
  AnalyticsProperties._();

  // ─── Identity / device / common ─────────────────────────────────────
  static const String hsSite = 'hs_site';
  static const String hsDeviceId = 'hs_device_id';
  static const String afUserId = 'afUserId';
  static const String cleverTapId = 'cleverTapId';
  // Android stamps `advertisingId` + `advertisingIdType=AAID`; iOS stamps the
  // same pair with type `IDFA`. Type is omitted when the id is unavailable
  // (LAT/ATT denied).
  static const String advertisingId = 'advertisingId';
  static const String advertisingIdType = 'advertisingIdType';
  static const String userType = 'user_type';
  static const String userStatus = 'user_status';
  static const String visitorType = 'visitor_type';
  static const String uploadEligibility = 'upload_eligibility';
  static const String installType = 'install_type';
  static const String lastVisitDate = 'last_visit_date';
  static const String daysSinceLastVisit = 'days_since_last_visit';
  static const String continueBrowsingEligibleVisitor = 'continue_browsing_eligible_visitor';
  static const String fromSource = 'from_source';
  static const String deviceProfile = 'device_profile';
  static const String pushEnabled = 'push_enabled';
  static const String fmessenger = 'fmessenger';
  static const String fcInstalled = 'fc';
  static const String waInstalled = 'wa';
  static const String myInstalled = 'my';
  static const String rooted = 'rooted';
  static const String deviceCpuArch = 'cpu_arch';
  static const String versionName = 'version';
  static const String versionCode = 'build';
  static const String previousVersionName = 'previous_version';
  static const String previousVersionCode = 'previous_build';
  static const String authenticationType = 'authentication_type';
  static const String fromAuthenticationType = 'from_authentication_type';

  // ─── Session + experiments ──────────────────────────────────────────
  static const String sessionId = 'session_id';
  static const String experiments = 'experiments';
  static const String sessionUtmSource = 'session_utm_source';
  static const String sessionUtmMedium = 'session_utm_medium';
  static const String sessionUtmCampaign = 'session_utm_campaign';
  static const String sessionUtmGender = 'session_utm_gender';
  static const String sessionDeeplink = 'session_deeplink';
  static const String utmSource = 'utm_source';
  static const String utmMedium = 'utm_medium';
  static const String utmCampaign = 'utm_campaign';
  static const String utmContent = 'utm_content';
  static const String utmTerm = 'utm_term';
  static const String utmDate = 'utm_date';
  static const String utmGender = 'utm_gender';
  static const String deeplink = 'deeplink';

  // ─── Time-bucket fields (preserve `[time] ` prefix verbatim) ────────
  static const String hourOfDay = '[time] hour_of_day';
  static const String dayOfWeek = '[time] day_of_week';
  static const String dayOfMonth = '[time] day_of_month';
  static const String monthOfYear = '[time] month_of_year';
  static const String weekOfYear = '[time] week_of_year';
  static const String year = 'year';
  static const String timestamp = 'timestamp';

  // ─── Performance ────────────────────────────────────────────────────
  static const String tti = 'tti';
  static const String ttl = 'ttl';
  static const String firstLoad = 'first_load';
  static const String skin = 'skin';

  // ─── Universal (CommonPropertiesHelper buffer) ──────────────────────
  static const String universal = 'universal';

  // ─── Cart / Product / Pricing ───────────────────────────────────────
  static const String productId = 'product_id';
  static const String xlProductId = 'xl_product_id';
  static const String productCategory = 'product_category';
  static const String ctaButtonName = 'cta_button_name';
  static const String name = 'name';
  static const String brand = 'brand';
  static const String price = 'price';
  static const String mrp = 'mrp';
  static const String discount = 'discount';
  static const String discountPercentage = 'discount_percentage';
  static const String quantity = 'quantity';
  static const String newQuantity = 'new_quantity';
  static const String newSku = 'new_sku';
  static const String newPrice = 'new_price';
  static const String revenue = 'revenue';
  static const String currency = 'currency';
  static const String shipping = 'shipping';
  static const String fromShipping = 'from_shipping';
  static const String products = 'products';
  static const String boutiqueId = 'boutique_id';
  static const String boutiqueName = 'boutique_name';
  static const String boutiqueStartDate = 'boutique_start_date';
  static const String boutiqueEndDate = 'boutique_end_date';
  static const String daysSinceBoutiqueStart = 'days_since_boutique_start';
  static const String boutiqueType = 'boutique_type';
  static const String sortOrder = 'sort_order';
  static const String addFromDetails = 'add_from_details';
  static const String category = 'category';
  static const String subCategory = 'subcategory';
  static const String productType = 'product_type';
  static const String subProductType = 'subproduct_type';
  static const String preOrder = 'preorder';
  static const String preOrderInfo = 'preorder_info';
  static const String sale = 'sale';
  static const String gender = 'gender';
  static const String size = 'size';
  static const String skuSize = 'sku_size';
  static const String colour = 'colour';
  static const String lowInventory = 'low_inventory';
  static const String deliveryDate = 'delivery_date';
  static const String deliveryDays = 'delivery_days';
  static const String fromAge = 'from_age';
  static const String toAge = 'to_age';
  static const String age = 'age';
  static const String countryOfOrigin = 'country_of_origin';
  static const String subtotal = 'subtotal';
  static const String productListingId = 'product_listing_id';
  static const String productListingName = 'product_listing_name';
  static const String totalAmount = 'total_amount';
  static const String totalItemPrice = 'total_item_price';
  static const String netAmount = 'net_amount';
  static const String fromNetAmount = 'from_net_amount';
  static const String skuCount = 'sku_count';
  static const String totalQuantity = 'total_quantity';
  static const String itemPrice = 'item_price';
  static const String itemDiscount = 'item_discount';
  static const String credit = 'credit';
  static const String bestPrice = 'best_price';
  static const String soldoutCount = 'soldout_count';
  static const String shippingMinimum = 'shipping_minimum';
  static const String sku = 'sku';

  // ─── Address / location ─────────────────────────────────────────────
  static const String city = 'city';
  static const String state = 'state';
  static const String pincode = 'pincode';
  static const String fromPincode = 'from_pincode';
  static const String shippedAddress = 'shipped_address';
  static const String edd = 'edd';
  static const String defaultEdd = 'default_edd';
  static const String defaultAddress = 'default_address';
  static const String address = 'address';
  static const String codAvailable = 'cod_available';
  static const String deliveryAvailable = 'delivery_available';
  static const String deliveryCity = 'delivery_city';
  static const String hasAddressServiceable = 'has_address_serviceable';
  static const String pincodeCheckStatus = 'pincode_check_status';

  // ─── Payment / checkout ─────────────────────────────────────────────
  static const String paymentMethod = 'payment_method';
  static const String paymentMode = 'payment_mode';
  static const String paymentRetry = 'payment_retry';
  static const String paymentStatus = 'payment_status';
  static const String netbankingBank = 'netbanking_bank';
  static const String payuTime = 'payu_time';
  static const String card = 'card';
  static const String error = 'error';
  static const String errorMessage = 'error_message';
  static const String stepDuration = 'step_duration';
  static const String totalDuration = 'total_duration';
  static const String backgroundTime = 'background_time';
  static const String message = 'message';
  static const String messageBar = 'message_bar';
  static const String messageCount = 'message_count';
  static const String quantityStatus = 'quantity_status';
  static const String priceStatus = 'price_status';
  static const String cartFillerReco = 'cart_filler_reco';
  static const String cartViewState = 'cart_view_state';
  static const String hasGift = 'has_gift_pid';
  static const String orderedFromReattemptScreen = 'ordered_from_reattempt_screen';
  static const String orderReattemptScreenShown = 'order_reattempt_screen_shown';
  static const String gokwikRiskScore = 'gokwik_risk_score';
  static const String gokwikRiskFactor = 'gokwik_risk_factor';

  // ─── Promo codes ────────────────────────────────────────────────────
  static const String promoCode = 'promo_code';
  static const String promoCodes = 'promo_codes';
  static const String promoError = 'promo_error';
  static const String promoAppliedCount = 'promo_applied_count';
  static const String fromPromoCode = 'from_promo_code';
  static const String removedPromoCode = 'removed_promo_code';
  static const String failedPromoCode = 'failed_promo_code';
  static const String promoApplied = 'promoApplied';
  static const String promotionDiscount = 'promotion_discount';
  static const String merchPromo = 'merch_promo';
  static const String paymentOffersActive = 'paymentOffersActive';
  static const String couponCode = 'coupon_code';
  static const String couponApplicable = 'coupon_applicable';
  static const String offerCardCount = 'offer_card_count';

  // ─── ATC / checkout user / shipping ─────────────────────────────────
  static const String atcUser = 'atc_user';
  static const String checkoutUser = 'checkout_user';
  /// `atc_site` — there is an Android constant `ATC_FROM` aliasing this value.
  static const String atcSite = 'atc_site';
  /// Alias of [atcSite] used at the Android `addAtcFrom` call sites.
  static const String atcFrom = 'atc_site';
  static const String atcDate = 'atc_date';

  // ─── Funnel / attribution ───────────────────────────────────────────
  static const String funnel = 'funnel';
  static const String funnelTile = 'funnel_tile';
  static const String funnelSection = 'funnel_section';
  static const String funnelRow = 'funnel_row';
  static const String section = 'section';
  static const String fromSection = 'from_section';
  static const String subSection = 'subsection';
  static const String plp = 'plp';
  static const String plpName = 'plp_name';
  static const String plpType = 'plp_type';
  static const String type = 'type';
  static const String propertyType = 'property_type';
  static const String cta = 'cta';
  static const String fromScreen = 'from_screen';
  static const String fromPage = 'from_page';
  static const String fromLocation = 'from_location';
  static const String fromCollection = 'from_collection';
  static const String collectionId = 'collection_id';
  static const String collectionName = 'collection_name';
  static const String collectionCount = 'collection_count';
  static const String productCount = 'product_count';
  static const String firstOrder = 'first_order';
  static const String filters = 'filters';
  static const String flow = 'flow';
  static const String source = 'source';
  static const String sourceTileType = 'source_tile_type';
  static const String clickSource = 'click_source';
  static const String bannerName = 'banner_name';
  static const String banner = 'banner';
  static const String sliceId = 'slice_id';

  // ─── Search ─────────────────────────────────────────────────────────
  static const String keyword = 'keyword';
  static const String length = 'length';
  static const String searchResultPids = 'search_result_pids';
  static const String queryCorrection = 'query_correction';
  static const String suggestionIndex = 'suggestion_index';

  // ─── Browse / categories ────────────────────────────────────────────
  static const String browseCategories = 'browsecategory';
  static const String departmentName = 'department_name';
  static const String product = 'product';

  // ─── Recos ──────────────────────────────────────────────────────────
  static const String recoType = 'reco_type';
  static const String recoFilter = 'reco_filter';
  static const String profile = 'profile';

  // ─── Sorting / filter UI ────────────────────────────────────────────
  static const String fromSort = 'from_sort';
  static const String fromSortBy = 'from_sort_by';
  static const String newSort = 'new_sort';
  static const String sortbar = 'sortbar';
  static const String fromSortbar = 'from_sortbar';
  static const String fromSortbarGroup = 'from_sortbar_group';
  static const String recentlySelectedSort = 'recently_selected_sort';
  static const String selectedSortBy = 'selected_sort_by';
  static const String selectedSortbar = 'selected_sortbar';
  static const String selectedSortbarGroup = 'selected_sortbar_group';
  static const String stickyFilter = 'sticky_filter';
  static const String standardFilter = 'standard_filters';
  static const String floatingFilter = 'floating_filter';
  static const String genieFilter = 'genie_filter';
  static const String nonPreorderFilter = 'non_preorder_filter';
  static const String filterAttribute = 'filter_attribute';
  static const String attributeCount = 'attribute_count';
  static const String filterSection = 'filter_section';
  static const String filterSectionCount = 'filter_section_count';
  static const String filterAttributeCount = 'filter_attribute_count';

  // ─── Smart filters ──────────────────────────────────────────────────
  static const String sfName = 'sf_name';
  static const String sfSegment = 'sf_segment';
  static const String sfCount = 'sf_count';
  static const String sfPosition = 'sf_position';
  static const String sfSegmentOrder = 'sf_segment_order';
  static const String sfSegmentPosition = 'sf_segment_position';
  static const String sfRule = 'sf_rule';
  static const String sfApplied = 'sf_applied';
  static const String sfAppliedCount = 'sf_applied_count';
  static const String sfCheckoutToken = 'sf_checkout_token';

  // ─── Scrolling / list metrics ───────────────────────────────────────
  static const String feedSize = 'feed_size';
  static const String fromFeedSize = 'from_feed_size';
  static const String fromRow = 'from_row';
  static const String row = 'row';
  static const String totalRows = 'total_rows';
  static const String scrolledRow = 'scrolled_row';
  static const String screenHeight = 'screen_height';
  static const String scrolledHeight = 'scrolled_height';
  static const String scrolledRfycRow = 'scrolled_rfyc_row';
  static const String scrolledSections = 'scrolled_sections';
  static const String scrolledFunnelTiles = 'scrolled_funnel_tiles';
  static const String scrolledTrigger = 'trigger';
  static const String totalTiles = 'total_tiles';
  static const String scrolledTiles = 'scrolled_tiles';
  static const String carouselRowPosition = 'row';
  static const String scrollDepth = 'scroll_depth';
  static const String uniqueImagesScrolled = 'unique_images_scrolled';

  // ─── Page components / tiles / carousels ────────────────────────────
  static const String tileGridId = 'tile_grid_id';
  static const String tileName = 'tile_name';
  static const String tileId = 'tile_id';
  static const String tileDetailId = 'tile_detail_id';
  static const String tileGridPosition = 'tile_grid_position';
  static const String tilePosition = 'tile_position';
  static const String actionUri = 'action_uri';
  static const String actionType = 'action_type';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String pageName = 'page_name';
  static const String width = 'width';
  static const String height = 'height';
  static const String carouselId = 'carousel_id';
  static const String carouselType = 'carousel_type';
  static const String transitionType = 'transition_type';
  static const String scrollDuration = 'scroll_duration';
  static const String cardIndex = 'card_index';
  static const String swipeDirection = 'swipe_direction';

  // ─── Tabs (root level — also see TabbedPageProperties for tabbed-page subkeys) ───
  static const String tabId = 'tab_id';
  static const String tabName = 'tab_name';
  static const String cbtId = 'cbt_id';
  static const String selectedTabId = 'selected_tab_id';

  // ─── XL product / page eligibility ──────────────────────────────────
  static const String imageCount = 'image_count';
  static const String isPageXlTileEligible = 'is_page_xl_tile_eligible';
  static const String pageEligibleForClusteredPlp = 'page_eligible_for_clustered_plp';

  // ─── A+ content ─────────────────────────────────────────────────────
  static const String isPidAplus = 'is_pid_aplus';
  static const String aPlusVirtualGroupName = 'aplus_virtual_group_name';
  static const String aPlusUspList = 'aplus_usp_list';
  static const String aPlusContentType = 'aplus_content_type';

  // ─── Color / style attribution ──────────────────────────────────────
  static const String styleCodePidCount = 'count_of_pids_in_style_code';
  static const String styleCode = 'style_code';
  static const String redirectedFromColorWidget = 'redirected_from_colour_widget';
  static const String newProductIdSelected = 'new_product_id_selected';
  static const String redirectedFromTabPage = 'redirected_from_tab_page';
  static const String redirectedFromDoorway = 'redirected_from_doorway';

  /// PDP: always emitted. Flutter has no shop-the-look entry path, so it ships
  /// the constant `"No"` — Android always emits a `"Yes"`/`"No"` string here, so
  /// dropping the key would be a divergence.
  static const String redirectedFromShopTheLook =
      'redirected_from_shop_the_look';

  // ─── Tabbed-page block (PDP: product_viewed + product_added_to_cart) ─
  static const String tabbedPageContainerName = 'tabbed_page_container_name';
  static const String tabbedPageContainerId = 'tabbed_page_container_id';
  static const String tabPosition = 'tab_position';
  static const String totalSlicesInContinueBrowsingWidget =
      'total_slices_in_continue_browsing_widget';

  // ─── Doorways ───────────────────────────────────────────────────────
  static const String doorwaysId = 'doorway_id';
  static const String doorwaysName = 'doorway_name';
  static const String doorwaysSlicesCount = 'doorway_slice_count';
  static const String doorwaysScrollCount = 'doorway_scroll_count';
  static const String doorwaysSliceId = 'doorway_slice_id';
  static const String dominantPt = 'dominant_pt';

  // ─── Product attribute tabs ─────────────────────────────────────────
  static const String productAttributeAvailable = 'product_attribute_available';
  static const String totalProductAttributes = 'total_product_attributes';
  static const String productAttributeName = 'product_attribute_name';
  static const String productAttributeValue = 'product_attribute_value';

  // ─── Style / merch / curation tags (from ProductTrackingData) ───────
  static const String hbt = 'hbt';
  static const String taste = 'taste';
  static const String merchType = 'merch_type';
  static const String country = 'v_country';
  static const String style = 'style';
  static const String season = 'season';
  static const String character = 'character';
  static const String pattern = 'pattern';
  static const String weave = 'weave';

  // ─── Orders / exchange ──────────────────────────────────────────────
  static const String orderCount = 'order_count';
  static const String activeOrders = 'active_orders';
  static const String parentOrderId = 'parent_order_id';
  static const String orderId = 'order_id';
  static const String orderStatus = 'order_status';
  static const String orderNumber = 'order_number';
  static const String orderBarCode = 'order_bar_code';
  static const String customTileType = 'custom_tile_type';
  static const String daysSinceOrder = 'days_since_order';
  static const String daysSinceShipped = 'days_since_shipped';
  static const String daysSinceDelivery = 'days_since_delivery';
  static const String exchangeReason = 'exchange_reason';
  static const String sizeAvailability = 'size_availability';
  static const String reason = 'reason';
  static const String reportedBy = 'reported_by';

  // ─── Exchange nudge / return ────────────────────────────────────────
  static const String returnReason = 'return_reason';
  static const String returnQuantity = 'return_qty';
  static const String proceedWithReturnClicked = 'proceed_with_return_clicked';
  static const String defaultExchangeSize = 'default_exchange_size';
  static const String otherButtonClicked = 'other_button_clicked';
  static const String cantFindSizeReturnPdt = 'cant_find_size_return_pdt';
  static const String exchangeSizeSelected = 'exchange_size_selected';
  static const String exchangeSize = 'exchange_size';
  static const String exchangeQuantity = 'exchange_qty';
  static const String exchangeDays = 'exchange_days';
  static const String sizeChartViewed = 'size_chart_viewed';
  static const String refundAmount = 'refund_amount';
  static const String refundedTo = 'refunded_to';
  static const String returnProperty = 'return';

  // ─── Photo / Moments ────────────────────────────────────────────────
  static const String photoId = 'photo_id';
  static const String photoSource = 'photo_source';
  static const String photoFrom = 'photo_from';
  static const String photoType = 'photo_type';
  static const String photoStatus = 'photo_status';
  static const String imageSize = 'image_size';
  static const String kids = 'kids';
  static const String uploadedDate = 'uploaded_date';
  static const String position = 'position';
  static const String imageUrl = 'image_url';

  // ─── Account / contact info ─────────────────────────────────────────
  static const String mobile = 'mobile';
  static const String email = 'email';
  static const String fromName = 'from_name';
  static const String fromEmail = 'from_email';
  static const String fromMobile = 'from_mobile';
  static const String fromPassword = 'from_password';
  static const String mobileStatus = 'mobile_status';
  static const String validationType = 'validation_type';
  static const String fromValidationType = 'from_validation_type';
  static const String fromRedirect = 'from_redirect';
  static const String fromPhoto = 'from_photo';
  static const String verificationReason = 'verification_reason';
  static const String isNotifiable = 'is_notifiable';
  static const String featureType = 'feature_type';
  static const String title = 'title';

  // ─── Child profile ──────────────────────────────────────────────────
  static const String childProfileName = 'child_profile_name';
  static const String childProfileAge = 'child_profile_age';
  static const String childProfileGender = 'child_profile_gender';
  static const String childProfileDob = 'child_profile_dob';
  static const String childProfileCohort = 'child_age_gender_cohort';
  static const String totalChildProfiles = 'total_child_profiles';

  // ─── Ratings / NPS ──────────────────────────────────────────────────
  static const String rating = 'rating';
  static const String review = 'review';
  static const String nps = 'nps';
  static const String npsFeedback = 'nps_feedback';
  static const String npsReview = 'nps_review';
  static const String averageRating = 'average_rating';
  static const String productsToReview = 'products_to_review';
  static const String rateShoppingExperienceShownTime = 'rate_shopping_experience_shown_time';
  static const String ratingsGivenForShoppingExperience = 'ratings_given_for_shopping_experience';
  static const String rateShoppingExperienceDismissedTime =
      'rate_shopping_experience_dismissed_time';
  static const String rateInPlaystoreUserAction = 'rate_in_playstore_user_action';
  static const String homePageNudge = 'homepage_nudge';

  // ─── Click types / generic actions ──────────────────────────────────
  static const String clickType = 'click_type';
  static const String action = 'action';
  static const String sizeSelection = 'size_selection';
  static const String id = 'id';
  static const String sizes = 'sizes';
  static const String productSize = 'pdt_size';
  static const String callToAction = 'call_to_action';

  // ─── Video (page components) ────────────────────────────────────────
  static const String videoPage = 'video_page';
  static const String aspectRatio = 'aspect_ratio';
  static const String videoLength = 'video_length';
  static const String videoIdentifier = 'video_identifier';
  static const String autoplayEnabled = 'autoplay_enabled';
  static const String preview = 'preview';
  static const String createdDate = 'created_date';
  static const String played = 'played';
  static const String cachePercentage = 'cache_percentage';
  static const String componentType = 'component_type';

  // ─── Misc / clicked product context ─────────────────────────────────
  static const String clickedProductPid = 'clicked_product_pid';
  static const String clickedProductType = 'clicked_product_type';
  static const String clickedSubcategory = 'clicked_product_subcategory';
  static const String clickedCategory = 'clicked_product_category';

  // ─── CleverTap traits / channel constants ───────────────────────────
  static const String cleverTapFirstName = 'FirstName';
  static const String cleverTapLastName = 'LastName';
  static const String cleverTapIdentity = 'Identity';
  static const String cleverTapVisitorId = 'VisitorId';
  static const String cleverTapEmail = 'Email';
  static const String cleverTapTz = 'Tz';
  static const String cleverTapAsiaKolkata = 'Asia/Kolkata';
  static const String cleverTapMsgPush = 'MSG-push';
  static const String cleverTapMsgEmail = 'MSG-email';
  static const String cleverTapMsgSms = 'MSG-sms';
  static const String cleverTapPhoto = 'Photo';
  static const String cleverTapPhone = 'Phone';
  static const String channelNameAccount = 'Account';
  static const String channelNameOffers = 'Offers';
  static const String channelNameRecommendations = 'Recommendations';
  static const String channelNameTrends = 'Trends';
  static const String channelIdAccount = 'Account & Orders';
  static const String channelIdOffers = 'Offers & Sales';
  static const String channelIdRecommendations = 'Recommendations';
  static const String channelIdTrends = 'Trends & Deals';
  static const String hopscotchChannelDescription = 'Hopscotch';
  static const String cleverTapDeepLinkKey = 'wzrk_dl';
  static const String cleverTapAccountId = 'wzrk_acct_id';

  /// Navigation breadcrumb — JSON array of screen labels, most-recent first,
  /// stamped on every event by `AppNavigationObserver`.
  static const String navScreens = 'nav_screens';

  // ─── Scrolled-trigger sentinels (string values used inside payloads) ───
  /// Value emitted when a scroll event is triggered by sortbar change.
  static const String scrolledTriggerSortbarChanged = 'Sortbar changed';

  /// Value emitted when a scroll event is triggered by app backgrounding.
  static const String scrolledTriggerBackground = 'App moved background';

  // ─── Yes/No/New/Updated value sentinels (kept here for grep parity
  //     with Android's AnalyticsProperties.YES/NO/NEW/UPDATED). The
  //     canonical home for these magic values is AnalyticsDefaults. ───
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String newValue = 'New';
  static const String updatedValue = 'Updated';

  /// Tabbed-page-specific subkeys (mirrors Android
  /// `AnalyticsProperties$TabbedPageProperties`). Kept in a nested class so
  /// `AnalyticsProperties.TabbedPageProperties.tabName` collides cleanly with
  /// the root-level `AnalyticsProperties.tabName` despite sharing the same wire
  /// value `"tab_name"`.
  // ignore: camel_case_types
  static const TabbedPageProperties tabbedPage = TabbedPageProperties();
}

/// Tabbed-page-specific property keys. Some of these (`tab_name`) collide on
/// the wire with top-level `AnalyticsProperties` keys but are scoped here to
/// match Android's namespacing.
class TabbedPageProperties {
  const TabbedPageProperties();

  String get tabbedPageContainerName => 'tabbed_page_container_name';
  String get tabbedPageContainerId => 'tabbed_page_container_id';
  String get tabName => 'tab_name';
  String get tabPosition => 'tab_position';
  String get source => 'source';
  String get directedTo => 'directed_to';
}

class LandingPageProperties {
  LandingPageProperties._();

  static const String lpId = 'lp_id';
  static const String lpName = 'lp_name';
}
