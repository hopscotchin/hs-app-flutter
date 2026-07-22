/// Splash screen — debug-only environment selector dialog (Debug / Debug VPN /
/// Release). Keys: `splash_env_<env>_button`.
class SplashTestStrings {
  SplashTestStrings();

  static const String envDebugButton = 'splash_env_debug_button';
  static const String envDebugVpnButton = 'splash_env_debug_vpn_button';
  static const String envProdButton = 'splash_env_prod_button';
}

class AccountTestStrings {
  AccountTestStrings();

  // Footer Section
  static const String accountFooterSignOutButton = 'account_footer_sign_out_button';
  static const String accountFooterLegalButton = 'account_footer_legal_button';
  static const String accountFooterAppVersionTextField = 'account_footer_app_version_text_field';

  // Help Section
  static const String accountHelpItemHelpButton = 'account_help_item_help_button';
  static const String accountHelpItemShareButton = 'account_help_item_share_button';
  static const String accountHelpItemRateButton = 'account_help_item_rate_button';

  // Sign-in header
  static const String accountSignInHeaderGreetingTextField = 'account_sign_in_header_greeting_text_field';
  static const String accountSignInHeaderContactTextField = 'account_sign_in_header_contact_text_field';
  static const String accountSignInHeaderAvatarImage = 'account_sign_in_header_avatar_image';
  static const String accountSignInHeaderAvatarInitials = 'account_sign_in_header_avatar_initials';

  // Sign-out header
  static const String accountSignOutHeaderTitleTextField = 'account_sign_out_header_title_text_field';
  static const String accountSignOutHeaderSubtitleTextField = 'account_sign_out_header_subtitle_text_field';
  static const String accountSignOutHeaderEraseMessageTextField = 'account_sign_out_header_erase_message_text_field';
  static const String accountSignOutHeaderSignInButton = 'account_sign_out_header_sign_in_button';
  static const String accountSignOutHeaderForgetMeButton = 'account_sign_out_header_forget_me_button';
  static const String accountSignOutHeaderJoinUsButton = 'account_sign_out_header_join_us_button';

  // Account menu items
  static const String accountsOrdersMenuItem = 'accounts_orders_menu_item';
  static const String accountsWishlistMenuItem = 'accounts_wishlist_menu_item';
  static const String accountsProfileDetailsMenuItem = 'accounts_profile_details_menu_item';
  static const String accountsSavedAddressesMenuItem = 'accounts_saved_addresses_menu_item';
  static const String accountsManageCardsMenuItem = 'accounts_manage_cards_menu_item';
  static const String accountsCreditsMenuItem = 'accounts_credits_menu_item';
  static const String accountsMyKidsMenuItem = 'accounts_my_kids_menu_item';

  // App bar title
  static const String accountAppBarTitle = 'account_app_bar_title';

  // Forget-me dialog
  static const String accountForgetDialogTitleTextField = 'account_forget_dialog_title_text_field';
  static const String accountForgetDialogDescriptionTextField = 'account_forget_dialog_description_text_field';
  static const String accountForgetDialogCancelButton = 'account_forget_dialog_cancel_button';
  static const String accountForgetDialogConfirmButton = 'account_forget_dialog_confirm_button';
}

class JoinUsTestStrings {
  JoinUsTestStrings();

  /// Screen prefix for shared-component keys (e.g. message bars).
  static const String screen = 'join_us';

  static const String joinUsAppBarTitle = 'join_us_app_bar_title';
  static const String joinUsNameInputField = 'join_us_name_input_field';
  static const String joinUsNameInputHint = 'join_us_name_input_hint';
  static const String joinUsEmailInputField = 'join_us_email_input_field';
  static const String joinUsEmailInputHint = 'join_us_email_input_hint';
  static const String joinUsMobileInputField = 'join_us_mobile_input_field';
  static const String joinUsMobileInputHint = 'join_us_mobile_input_hint';
  static const String joinUsSendOtpButton = 'join_us_send_otp_button';
  static const String joinUsTermsDisclaimerTextField = 'join_us_terms_disclaimer_text_field';
  static const String joinUsTermsAndConditionsButton = 'join_us_terms_and_conditions_button';
  static const String joinUsPrivacyPolicyButton = 'join_us_privacy_policy_button';
  static const String joinUsSignInButton = 'join_us_sign_in_button';
  static const String joinUsBackButton = 'join_us_back_button';
}

class LoginTestStrings {
  LoginTestStrings();

  /// Screen prefix for shared-component keys (e.g. message bars).
  static const String screen = 'login';

  static const String loginAppBarTitle = 'login_app_bar_title';
  static const String loginMobileInputField = 'login_mobile_input_field';
  static const String loginMobileInputHint = 'login_mobile_input_hint';
  static const String loginSendOtpButton = 'login_send_otp_button';
  static const String loginJoinUsButton = 'login_join_us_button';
  static const String loginBackButton = 'login_back_button';
}

class OtpVerificationTestStrings {
  OtpVerificationTestStrings();

  /// Screen prefix for shared-component keys (e.g. message bars).
  static const String screen = 'otp_verification';

  static const String otpVerificationAppBarTitle = 'otp_verification_app_bar_title';
  static const String otpVerificationPromptTextField = 'otp_verification_prompt_text_field';
  static const String otpVerificationLoginIdTextField = 'otp_verification_login_id_text_field';
  static const String otpVerificationChangeButton = 'otp_verification_change_button';
  static const String otpVerificationOtpInputField = 'otp_verification_otp_input_field';
  static const String otpVerificationOtpSlotRow = 'otp_verification_otp_slot_row';
  static const String otpVerificationResendTimerTextField = 'otp_verification_resend_timer_text_field';
  static const String otpVerificationResendButton = 'otp_verification_resend_button';
  static const String otpVerificationBackButton = 'otp_verification_back_button';
}

class DashboardTestStrings {
  DashboardTestStrings();

  // Bottom navigation items
  static const String dashboardHomeNavItem = 'dashboard_home_nav_item';
  static const String dashboardCategoriesNavItem = 'dashboard_categories_nav_item';
  static const String dashboardSearchNavItem = 'dashboard_search_nav_item';
  static const String dashboardAccountNavItem = 'dashboard_account_nav_item';
}

/// Home/landing page components (server-driven, rendered via
/// `PageComponentRenderer`). Keys follow:
///   `<page>_<component>_<compIndex>[_<element>[_<itemIndex>]]`
/// where page = `hp` (home) or `lp_<pageName>` (landing), compIndex = the
/// render index, and repeating items use the `tiles` element with an index.
/// Examples: `hp_pg_2_title`, `hp_pg_2_cta`, `lp_summer-sale_pc_1_tiles_3`.
class HomeComponentTestStrings {
  HomeComponentTestStrings();

  // Page prefixes
  static const String homePage = 'hp';
  static const String landingPage = 'lp'; // suffixed with `_<pageName>`

  // Component abbreviations
  static const String hero = 'hero';
  static const String customTiles = 'ct';
  static const String productGrid = 'pg';
  static const String pageCarousel = 'pc';

  // Element roles
  static const String title = 'title';
  static const String cta = 'cta';
  static const String tiles = 'tiles';

  // Product-tile sub-elements (nest under a tile → `<prefix>_tiles_<i>_<suffix>`).
  static const String tileNameSuffix = 'name'; // → `<prefix>_tiles_<i>_name`
  static const String tilePriceSuffix = 'price'; // → `<prefix>_tiles_<i>_price`
  static const String tileDiscountSuffix = 'discount'; // → `<prefix>_tiles_<i>_discount`
  static const String tileColorVariantsSuffix =
      'color_variants'; // → `<prefix>_tiles_<i>_color_variants`
  static const String tileWishlistSuffix = 'wishlist'; // → `<prefix>_tiles_<i>_wishlist`
  static const String tileVisualCueSuffix = 'visual_cue'; // → `<prefix>_tiles_<i>_visual_cue_<j>`

  // Home page header category tabs — key `hp_tab_<i>`.
  static const String tab = 'tab';

  // Home page header action buttons — key `hp_wishlist_button` / `hp_cart_button`.
  static const String wishlistButton = 'wishlist_button';
  static const String cartButton = 'cart_button';
}

/// Reusable message-bar component. Keys are prefixed with the host screen and
/// suffixed with the bar's list index — e.g. `login_message_bar_message_text_field_0`.
/// The screen prefix comes from `MessageBarsWidget.keyPrefix`.
class MessageBarTestStrings {
  MessageBarTestStrings();

  static const String messageBarMessageTextField = 'message_bar_message_text_field';
  static const String messageBarActionButton = 'message_bar_action_button';
  static const String messageBarLeftButton = 'message_bar_left_button';
  static const String messageBarRightButton = 'message_bar_right_button';
}

/// Pincode-check bottom sheet. Keys are `pincode_sheet_<element>`.
class PincodeTestStrings {
  PincodeTestStrings();

  // Pincode check bottom sheet
  static const String sheetInputHint = 'pincode_sheet_input_hint';
  static const String sheetInputSuffixIcon = 'pincode_sheet_input_suffix_icon';
}

/// Product listing page (PLP). Keys are `plp_<element>[_<index>]`. Dynamic list
/// items (tiles, chips, filter options) carry an index; tile sub-CTAs nest under
/// the tile, e.g. `plp_tile_3`, `plp_tile_3_wishlist`, `plp_tile_3_add_to_cart`.
class PlpTestStrings {
  PlpTestStrings();

  /// Screen prefix for shared-component keys (e.g. message bars → `plp_message_bar_*`).
  static const String screen = 'plp';

  // App bar (standard + boutique variants share keys where they overlap)
  static const String appBarBackButton = 'plp_appbar_back_button';
  static const String appBarTitle = 'plp_appbar_title';
  static const String appBarCollapsedTitle = 'plp_appbar_collapsed_title';
  static const String appBarSubtitle = 'plp_appbar_subtitle';
  static const String appBarSearchButton = 'plp_appbar_search_button';
  static const String appBarWishlistButton = 'plp_appbar_wishlist_button';
  static const String appBarCartButton = 'plp_appbar_cart_button';

  // Header image (boutique banner)
  static const String headerImage = 'plp_header_image';

  // Applied filter chips (dynamic list; ✕ removes that value)
  static const String appliedFilterChip = 'plp_applied_filter_chip'; // + `_<i>`

  // Sticky filter bar
  static const String sortByButton = 'plp_sort_by_button';
  static const String filterByButton = 'plp_filter_by_button';
  static const String stickyFilterChip = 'plp_sticky_filter_chip'; // + `_<i>`

  // Query correction
  static const String queryCorrectionText = 'plp_query_correction_text';
  static const String queryCorrectionSuggestionButton = 'plp_query_correction_suggestion_button';

  // Product tiles (flat product index; sub-CTAs nest under the tile)
  static const String tile = 'plp_tile'; // main tap → `plp_tile_<i>`
  static const String wishlistSuffix = 'wishlist'; // → `plp_tile_<i>_wishlist`
  static const String addToCartSuffix = 'add_to_cart'; // → `plp_tile_<i>_add_to_cart`
  static const String visualCueSuffix = 'visual_cue'; // → `plp_tile_<i>_visual_cue_<j>`
  static const String nameSuffix = 'name'; // → `plp_tile_<i>_name`
  static const String priceSuffix = 'price'; // → `plp_tile_<i>_price`
  static const String colorVariantsSuffix = 'color_variants'; // → `plp_tile_<i>_color_variants`
  static const String discountSuffix = 'discount'; // → `plp_tile_<i>_discount`

  // Floating filter tile (repeats → disambiguated by section position)
  static const String floatingFilter = 'plp_floating_filter'; // + `_<pos>_chip_<i>` / `_<pos>_apply_button`
  static const String floatingFilterChipSuffix = 'chip';
  static const String floatingFilterApplySuffix = 'apply_button';

  // Product count pill (FAB)
  static const String productCountButton = 'plp_product_count_button';

  // Empty state (no products / filtered-empty)
  static const String emptyStateTitle = 'plp_empty_state_title';
  static const String emptyStateSubtitle = 'plp_empty_state_subtitle';
  static const String emptyStateButton = 'plp_empty_state_button';

  // Error state (server error)
  static const String errorStateTitle = 'plp_error_state_title';
  static const String errorStateSubtitle = 'plp_error_state_subtitle';
  static const String errorStateButton = 'plp_error_state_button';

  // Sort bottom sheet
  static const String sortSheetTitle = 'plp_sort_sheet_title';
  static const String sortSheetOption = 'plp_sort_sheet_option'; // + `_<i>`

  // Filter page (full-screen filter surface)
  static const String filterTitle = 'plp_filter_title';
  static const String filterCloseButton = 'plp_filter_close_button';
  static const String filterSection = 'plp_filter_section'; // sidebar → + `_<i>`
  static const String filterSectionBadgeSuffix = 'badge'; // → `plp_filter_section_<i>_badge`
  static const String filterOption = 'plp_filter_option'; // flat content → + `_<i>`
  static const String filterSearchInput = 'plp_filter_search_input';
  static const String filterSearchInputHint = 'plp_filter_search_input_hint';
  static const String filterSearchInputSuffix = 'plp_filter_search_input_suffix';
  static const String filterClearButton = 'plp_filter_clear_button';
  static const String filterApplyButton = 'plp_filter_apply_button';
  // Nested tree filter rows
  static const String filterLeaf = 'plp_filter_leaf'; // + `_<i>`
  static const String filterDrilldown = 'plp_filter_drilldown'; // + `_<i>`
  static const String filterBreadcrumb = 'plp_filter_breadcrumb'; // + `_<i>`

  // Filter section sheet (opened by sticky chips)
  static const String filterSectionSheetTitle = 'plp_filter_section_sheet_title';
  static const String filterSectionSheetOption = 'plp_filter_section_sheet_option'; // + `_<i>`
  // Label / count text inside each option row (nest under the option index).
  static const String filterSectionSheetOptionLabelSuffix =
      'label'; // → `plp_filter_section_sheet_option_<i>_label`
  static const String filterSectionSheetOptionCountSuffix =
      'count'; // → `plp_filter_section_sheet_option_<i>_count`
  static const String filterSectionSheetClearButton = 'plp_filter_section_sheet_clear_button';
  static const String filterSectionSheetApplyButton = 'plp_filter_section_sheet_apply_button';
}

/// Address feature — list page (`address_list_*`) and add/edit form
/// (`address_form_*`). List cards are index-suffixed; edit/remove nest under the
/// card, e.g. `address_list_item_2`, `address_list_item_2_edit`.
class AddressTestStrings {
  AddressTestStrings();

  // ── Address list ──
  static const String listAppBarTitle = 'address_list_app_bar_title';
  static const String listBackButton = 'address_list_back_button';
  static const String listItem = 'address_list_item'; // card → + `_<i>`
  static const String listItemEditSuffix = 'edit'; // → `address_list_item_<i>_edit`
  static const String listItemRemoveSuffix = 'remove'; // → `address_list_item_<i>_remove`
  static const String listAddNewButton = 'address_list_add_new_button';
  static const String listContinueButton = 'address_list_continue_button';
  static const String listEmptyText = 'address_list_empty_text';

  // Delete-confirm bottom sheet
  static const String deleteBottomSheetTitle = 'address_list_delete_bottomsheet_title';
  static const String deleteBottomSheetDescription = 'address_list_delete_bottomsheet_description';
  static const String deleteBottomSheetCancelButton = 'address_list_delete_bottomsheet_cancel_button';
  static const String deleteBottomSheetConfirmButton = 'address_list_delete_bottomsheet_confirm_button';

  // ── Add / edit form ──
  /// Screen prefix for shared-component keys (message bars → `address_form_message_bar_*`).
  static const String formScreen = 'address_form';

  static const String formAppBarTitle = 'address_form_app_bar_title';
  static const String formBackButton = 'address_form_back_button';
  static const String formNameInput = 'address_form_name_input';
  static const String formNameInputHint = 'address_form_name_input_hint';
  static const String formMobileInput = 'address_form_mobile_input';
  static const String formMobileInputHint = 'address_form_mobile_input_hint';
  static const String formAlternateMobileInput = 'address_form_alternate_mobile_input';
  static const String formAlternateMobileInputHint = 'address_form_alternate_mobile_input_hint';
  static const String formPincodeInput = 'address_form_pincode_input';
  static const String formPincodeInputHint = 'address_form_pincode_input_hint';
  static const String formPincodeInputSuffix = 'address_form_pincode_input_suffix';
  static const String formCityInput = 'address_form_city_input';
  static const String formCityInputHint = 'address_form_city_input_hint';
  static const String formStateInput = 'address_form_state_input';
  static const String formStateInputHint = 'address_form_state_input_hint';
  static const String formAddress1Input = 'address_form_address1_input';
  static const String formAddress1InputHint = 'address_form_address1_input_hint';
  static const String formStreetInput = 'address_form_street_input';
  static const String formStreetInputHint = 'address_form_street_input_hint';
  static const String formLandmarkInput = 'address_form_landmark_input';
  static const String formLandmarkInputHint = 'address_form_landmark_input_hint';
  static const String formDefaultCheckbox = 'address_form_default_checkbox';
  static const String formSaveButton = 'address_form_save_button';
  static const String formCancelButton = 'address_form_cancel_button';

  // Discard-changes bottom sheet
  static const String discardBottomSheetTitle = 'address_form_discard_bottomsheet_title';
  static const String discardBottomSheetDescription = 'address_form_discard_bottomsheet_description';
  static const String discardBottomSheetStayButton = 'address_form_discard_bottomsheet_stay_button';
  static const String discardBottomSheetDiscardButton = 'address_form_discard_bottomsheet_discard_button';
}