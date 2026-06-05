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

  // Device / Push
  static const String pushToken = 'hs_push_token';
  static const String isDeviceTokenSent = 'hs_is_device_token_sent';

  // Environment (debug builds only — release is pinned at compile time)
  static const String selectedEnvironment = 'hs_selected_environment';
}
