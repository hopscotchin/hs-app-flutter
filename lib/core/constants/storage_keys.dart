class StorageKeys {
  StorageKeys._();

  // Session Tracking
  static const String sessionCount = 'hs_session_count';
  static const String startSessionId = 'hs_start_session_id';
  static const String currentUserType = 'hs_current_user_type';
  static const String previousExperiments = 'hs_previous_experiments';

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
  static const String featureFlagRatingAfterShopping =
      'hs_feature_flag_rating_after_shopping';
  static const String featureFlagHomeAnalytics =
      'hs_feature_flag_home_analytics';
  static const String featureFlagDeleteAccount =
      'hs_feature_flag_delete_account';

  // Hard Update
  static const String isHardUpdate = 'hs_is_hard_update';
  static const String hardUpdateDialogTitle = 'hs_hard_update_dialog_title';
  static const String hardUpdateDialogContent = 'hs_hard_update_dialog_content';

  // Customer Info
  static const String userId = 'hs_user_id';
  static const String firstName = 'hs_first_name';
  static const String lastName = 'hs_last_name';
  static const String userName = 'hs_user_name';
  static const String email = 'hs_email';
  static const String phoneNumber = 'hs_phone_number';
  static const String gender = 'hs_gender';
  static const String profileImage = 'hs_profile_image';
  static const String mobileStatus = 'hs_mobile_status';
  static const String isLoggedIn = 'hs_is_logged_in';
  static const String hasGuestData = 'hs_has_guest_data';
  static const String cartItemQty = 'hs_cart_item_qty';
  static const String persistentTicket = 'hs_persistent_ticket';
}
