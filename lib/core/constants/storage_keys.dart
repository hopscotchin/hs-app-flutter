class StorageKeys {
  StorageKeys._();

  // Session Tracking
  static const String sessionCount = 'hs_session_count';
  static const String startSessionId = 'hs_start_session_id';
  static const String currentUserType = 'hs_current_user_type';
  static const String previousExperiments = 'hs_previous_experiments';
  static const String isFirstLogin = 'hs_is_first_login';

  // AppConfig: Sort & Checkout
  static const String sortBarEnabled = 'hs_sort_bar_enabled';
  static const String recentlySortVisible = 'hs_recently_sort_visible';
  static const String upiRefundsEnabled = 'hs_upi_refunds_enabled';
  static const String instantCheckoutVariant = 'hs_instant_checkout_variant';
  static const String customerCareContact = 'hs_customer_care_contact';
  static const String videoAspectRatios = 'hs_video_aspect_ratios';
  static const String cartMessageBars = 'hs_cart_message_bars';

  // Feature Flags
  static const String featureFlagClarity = 'hs_feature_flag_clarity';

  // Remote Config Flags
  static const String featureFlagInAppUpdate = 'hs_feature_flag_in_app_update';
  static const String featureFlagRatingAfterShopping = 'hs_feature_flag_rating_after_shopping';
  static const String featureFlagHomeAnalytics = 'hs_feature_flag_home_analytics';
  static const String featureFlagDeleteAccount = 'hs_feature_flag_delete_account';

  // Hard Update
  static const String isHardUpdate = 'hs_is_hard_update';
  static const String hardUpdateDialogTitle = 'hs_hard_update_dialog_title';
  static const String hardUpdateDialogContent = 'hs_hard_update_dialog_content';

  // Customer Info — stored as a single JSON blob
  static const String customerInfo = 'hs_customer_info';

  // Customer Info — individual keys (updated independently of the blob)
  static const String gender = 'hs_gender';
  static const String hasGuestData = 'hs_has_guest_data';
  static const String cartItemQty = 'hs_cart_item_qty';
  static const String persistentTicket = 'hs_persistent_ticket';
  static const String uuid = 'hs_uuid';
  static const String childCohorts = 'hs_child_cohorts';
  static const String continueBrowsingEligibleVisitor = 'hs_continue_browsing_eligible_visitor';
  static const String productImageConfig = 'hs_product_image_config';
  static const String addressesJson = 'hs_addresses_json';
  static const String lastSelectedPincodeAddressId = 'hs_last_selected_pincode_address_id';

  // Device / Push
  static const String pushToken = 'hs_push_token';
  static const String isDeviceTokenSent = 'hs_is_device_token_sent';

  // Analytics — identity / session traits driven by HTTP cookie interceptor
  static const String cleverTapId = 'hs_clever_tap_id';
  /// JSON-encoded full union of identify traits accumulated across the app's
  /// lifetime. Mirrors the on-disk `Traits` map that Android Segment SDK
  /// persists, so a cold start can hydrate the union and ship it on the very
  /// first identify (instead of rebuilding from delta calls).
  static const String accumulatedTraits = 'hs_accumulated_traits';
  /// Device-derived stable id stamped on every Segment `identify()`. Mirrors
  /// Android `Settings.Secure.ANDROID_ID` and iOS DeviceUID
  /// (UserDefaults/Keychain → identifierForVendor fallback). Persisted so we
  /// have a stable value on the very first cold start before the device
  /// probe completes.
  static const String hsDeviceId = 'hs_device_id';
  /// Advertising identifier — Google GAID on Android, IDFA on iOS. Empty
  /// string when LAT/ATT denies access.
  static const String advertisingId = 'hs_advertising_id';
  static const String userType = 'hs_user_type';
  static const String segmentUserType = 'hs_segment_user_type';
  static const String atcUserType = 'hs_atc_user_type';
  static const String checkoutFlowUserType = 'hs_checkout_flow_user_type';
  static const String lastVisitDate = 'hs_last_visit_date';
  static const String daysSinceLastVisitAnalytics = 'hs_days_since_last_visit';
  static const String isNewVisitor = 'hs_is_new_visitor';

  // Analytics — lifecycle / install detection (set by fireLifeCycleEvents)
  static const String isFirstInstall = 'hs_is_first_install';
  static const String applicationStatusFlag = 'hs_application_status_flag';
  static const String cachedVersionName = 'hs_cached_version_name';
  static const String cachedVersionCode = 'hs_cached_version_code';
  static const String isUpdated = 'hs_is_updated';

  // Analytics — device probes used by application_opened
  static const String deviceProfile = 'hs_device_profile';
  static const String isDeviceProfileSet = 'hs_is_device_profile_set';
  static const String pushEnabled = 'hs_push_enabled';
  static const String isFbAvailable = 'hs_is_fb_available';
  static const String isWaAvailable = 'hs_is_wa_available';
  static const String isFcAvailable = 'hs_is_fc_available';
  static const String isMyAvailable = 'hs_is_my_available';
  static const String isDeviceRooted = 'hs_is_device_rooted';

  // Analytics — homepage skin (set by home page load)
  static const String homePageSkin = 'hs_home_page_skin';

  // Analytics — post-order suppression flag (set by CheckoutObserver)
  static const String isOrderPaid = 'hs_is_order_paid';

  // Analytics — attribution (only the scroll snapshot lives on disk;
  // OrderAttribution + LpAttribution are in-memory only)
  static const String attributionSnapshotForScroll = 'hs_attribution_snapshot_for_scroll';

  // Analytics — UTM (in-memory + disk mirror; UtmHeaderUtil owns)
  static const String utmSource = 'hs_utm_source';
  static const String utmMedium = 'hs_utm_medium';
  static const String utmCampaign = 'hs_utm_campaign';
  static const String utmContent = 'hs_utm_content';
  static const String utmTerm = 'hs_utm_term';
  static const String utmGender = 'hs_utm_gender';
  static const String utmDeeplink = 'hs_utm_deeplink';

  // Environment (debug builds only — release is pinned at compile time)
  static const String selectedEnvironment = 'hs_selected_environment';
}
