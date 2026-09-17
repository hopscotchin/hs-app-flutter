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
  static const String accountSignInHeaderGreetingTextField =
      'account_sign_in_header_greeting_text_field';
  static const String accountSignInHeaderContactTextField =
      'account_sign_in_header_contact_text_field';
  static const String accountSignInHeaderAvatarImage = 'account_sign_in_header_avatar_image';
  static const String accountSignInHeaderAvatarInitials = 'account_sign_in_header_avatar_initials';

  // Sign-out header
  static const String accountSignOutHeaderTitleTextField =
      'account_sign_out_header_title_text_field';
  static const String accountSignOutHeaderSubtitleTextField =
      'account_sign_out_header_subtitle_text_field';
  static const String accountSignOutHeaderEraseMessageTextField =
      'account_sign_out_header_erase_message_text_field';
  static const String accountSignOutHeaderSignInButton = 'account_sign_out_header_sign_in_button';
  static const String accountSignOutHeaderForgetMeButton =
      'account_sign_out_header_forget_me_button';
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
  static const String accountForgetDialogDescriptionTextField =
      'account_forget_dialog_description_text_field';
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
  static const String otpVerificationResendTimerTextField =
      'otp_verification_resend_timer_text_field';
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
  static const String messageBarTitleTextField = 'message_bar_title_text_field';
  static const String messageBarActionButton = 'message_bar_action_button';
  static const String messageBarLeftButton = 'message_bar_left_button';
  static const String messageBarRightButton = 'message_bar_right_button';
}

/// Pincode-check bottom sheet. Keys are `pincode_sheet_<element>`.
/// Delivery-pincode bottom sheet. It is one widget shown from three places
/// (the cart's app bar, PDP's delivery block and — soon — checkout), so a bare
/// `pincode_sheet_*` key would match whichever copy happened to be open. Every
/// key is therefore composed as `<host>_pincode_sheet_<element>`, with the host
/// slug taken from `PincodeSheetSource`: a cart test asserts on
/// `cart_pincode_sheet_apply_button` and can never hit PDP's sheet.
class PincodeTestStrings {
  PincodeTestStrings();

  /// Host slugs, one per `PincodeSheetSource`.
  static const String cartHost = 'cart';
  static const String pdpHost = 'pdp';
  static const String checkoutHost = 'checkout';

  /// Screen prefix for the sheet's backend-driven bars →
  /// `cart_pincode_sheet_message_bar_message_text_field_<i>`.
  static const String screen = 'pincode_sheet'; // → `<host>_pincode_sheet`

  static const String sheet = 'pincode_sheet'; // → `<host>_pincode_sheet`
  static const String sheetTitle = 'pincode_sheet_title'; // → `<host>_pincode_sheet_title`
  static const String sheetInput = 'pincode_sheet_input'; // → `<host>_pincode_sheet_input`
  static const String sheetInputHint =
      'pincode_sheet_input_hint'; // → `<host>_pincode_sheet_input_hint`
  static const String sheetInputSuffixIcon =
      'pincode_sheet_input_suffix_icon'; // → `<host>_pincode_sheet_input_suffix_icon`
  static const String sheetApplyButton =
      'pincode_sheet_apply_button'; // → `<host>_pincode_sheet_apply_button`

  /// Spinner that replaces "Apply" while serviceability is being checked.
  static const String sheetApplyLoader =
      'pincode_sheet_apply_loader'; // → `<host>_pincode_sheet_apply_loader`

  /// Inline verify-failure text under the input (PDP flow).
  static const String sheetErrorText =
      'pincode_sheet_error_text_field'; // → `<host>_pincode_sheet_error_text_field`
  static const String sheetToastSnackBar =
      'pincode_sheet_toast_snackbar'; // → `<host>_pincode_sheet_toast_snackbar`
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
  static const String floatingFilter =
      'plp_floating_filter'; // + `_<pos>_chip_<i>` / `_<pos>_apply_button`
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
  static const String filterSectionSheetClearButton = 'plp_filter_section_sheet_clear_button';
  static const String filterSectionSheetApplyButton = 'plp_filter_section_sheet_apply_button';
  // Label / count text inside each option row (nest under the option index).
  static const String filterSectionSheetOptionLabelSuffix =
      'label'; // → `plp_filter_section_sheet_option_<i>_label`
  static const String filterSectionSheetOptionCountSuffix =
      'count'; // → `plp_filter_section_sheet_option_<i>_count`
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
  static const String deleteBottomSheetCancelButton =
      'address_list_delete_bottomsheet_cancel_button';
  static const String deleteBottomSheetConfirmButton =
      'address_list_delete_bottomsheet_confirm_button';

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
  static const String discardBottomSheetDescription =
      'address_form_discard_bottomsheet_description';
  static const String discardBottomSheetStayButton = 'address_form_discard_bottomsheet_stay_button';
  static const String discardBottomSheetDiscardButton =
      'address_form_discard_bottomsheet_discard_button';
}

/// Cart screen.
class PromoOffersTestStrings {
  PromoOffersTestStrings();

  /// Inline rejection bar shown under the sheet title on a failed apply.
  static const String actionErrorBar = 'promo_offers_action_error_bar';

  /// Sheet root — presence assertion for "the offers sheet is open".
  static const String sheet = 'promo_offers_sheet';
  static const String sheetTitle = 'promo_offers_sheet_title';

  /// Card-shaped placeholders shown while the list loads.
  static const String loadingShimmer = 'promo_offers_loading_shimmer';

  /// Scrollable list of sections, and one key per section.
  static const String list = 'promo_offers_list';
  static const String section = 'promo_offers_section'; // + `_<i>`

  /// Success toast for an apply/remove that answered with a plain message.
  static const String actionSnackBar = 'promo_offers_action_snackbar';

  static const String emptyStateTitle = 'promo_offers_empty_state_title';
  static const String emptyStateSubtitle = 'promo_offers_empty_state_subtitle';
  static const String emptyStateButton = 'promo_offers_empty_state_button';

  /// One card per offer, flat-indexed across both (applicable /
  /// non-applicable) sections.
  static const String card = 'promo_offers_card'; // + `_<i>`
  static const String codeSuffix = 'code'; // → `promo_offers_card_<i>_code`
  static const String titleSuffix = 'title'; // → `promo_offers_card_<i>_title`
  static const String descriptionSuffix = 'description'; // → `promo_offers_card_<i>_description`
  static const String validitySuffix =
      'validity_text_field'; // → `promo_offers_card_<i>_validity_text_field`
  static const String savingsSuffix =
      'savings_text_field'; // → `promo_offers_card_<i>_savings_text_field`
  // Apply and Remove are mutually exclusive, but keyed separately on purpose:
  // which one renders *is* the applied-state assertion.
  static const String applyButtonSuffix = 'apply_button'; // → `promo_offers_card_<i>_apply_button`
  static const String removeButtonSuffix =
      'remove_button'; // → `promo_offers_card_<i>_remove_button`
  static const String termsButtonSuffix = 'terms_button'; // → `promo_offers_card_<i>_terms_button`
  /// Backend-driven deeplink CTA.
  static const String ctaButtonSuffix = 'cta_button'; // → `promo_offers_card_<i>_cta_button`
}

/// Backend-authored bottom sheet returned by promo apply/remove
/// (`showPromoActionSheet`). Shown from both the cart and the offers sheet.
class PromoActionSheetTestStrings {
  PromoActionSheetTestStrings();

  static const String title = 'promo_action_bottomsheet_title';
  static const String description = 'promo_action_bottomsheet_description';
  static const String primaryButton = 'promo_action_bottomsheet_primary_button';
  static const String secondaryButton = 'promo_action_bottomsheet_secondary_button';
}

class PromoDetailsTestStrings {
  PromoDetailsTestStrings();

  static const String loadingShimmer = 'promo_details_loading_shimmer';
  static const String appBarTitle = 'promo_details_app_bar_title';
  static const String backButton = 'promo_details_back_button';
  static const String code = 'promo_details_code';
  static const String title = 'promo_details_title';
  static const String description = 'promo_details_description';
  static const String validityText = 'promo_details_validity_text_field';
  static const String savingsText = 'promo_details_savings_text_field';

  /// Backend-driven deeplink CTA.
  static const String ctaButton = 'promo_details_cta_button';

  static const String aboutTitle = 'promo_details_about_title';
  static const String aboutText = 'promo_details_about_text_field';
  static const String termsTitle = 'promo_details_terms_title';
  static const String termsItem = 'promo_details_terms_item'; // + `_<i>`
  static const String faqTitle = 'promo_details_faq_title';
  static const String faqItem = 'promo_details_faq_item'; // + `_<i>`
  static const String faqQuestionSuffix = 'question'; // → `promo_details_faq_item_<i>_question`
  static const String faqAnswerSuffix = 'answer'; // → `promo_details_faq_item_<i>_answer`
  static const String errorText = 'promo_details_error_text_field';
}

class CartTestStrings {
  CartTestStrings();

  /// Screen prefix — passed to `MessageBarsWidget` for the top (merge /
  /// promo) bars → `cart_message_bar_message_text_field_<i>`.
  static const String screen = 'cart';

  /// Screen prefix for the backend-driven bars under the price summary →
  /// `cart_bottom_message_bar_message_text_field_<i>`.
  static const String bottomMessageBarScreen =
      'cart_bottom'; // → `cart_bottom_message_bar_message_text_field_<i>`

  // ── Page-level states ──
  /// Initial-load skeleton (`CartShimmerLoading`).
  static const String shimmerLoading = 'cart_shimmer_loading';

  /// Full-screen scrim + spinner shown while a cart mutation is in flight.
  static const String updatingOverlay = 'cart_updating_overlay';

  /// Pull-to-refresh wrapper around the loaded cart.
  static const String refreshIndicator = 'cart_refresh_indicator';

  /// Toasts. They render on the app's `ScaffoldMessenger` (outside the page
  /// tree), so the key is the only handle a test has on them.
  static const String toastSnackBar = 'cart_toast_snackbar';
  static const String loginRequiredSnackBar = 'cart_login_required_snackbar';

  // ── App bar ──
  static const String appBarBackButton = 'cart_appbar_back_button';
  static const String appBarTitle = 'cart_app_bar_title';
  static const String appBarWishlistButton = 'cart_appbar_wishlist_button';
  static const String appBarPincodeButton = 'cart_app_bar_pincode_button';
  static const String appBarPincodeText = 'cart_app_bar_pincode_text_field';

  // ── Empty bag state ──
  static const String emptyStateTitle = 'cart_empty_state_title';
  static const String emptyStateSubtitle = 'cart_empty_state_subtitle';
  static const String emptyStateButton = 'cart_empty_state_button';

  // ── Load-failure state ──
  static const String errorStateTitle = 'cart_error_state_title';
  static const String errorStateSubtitle = 'cart_error_state_subtitle';
  static const String errorStateButton = 'cart_error_state_button';

  // ── Free-gift banner ──
  static const String giftCardBanner = 'cart_gift_card_banner';
  static const String giftCardImage = 'cart_gift_card_image';
  static const String giftCardTitle = 'cart_gift_card_title';
  static const String giftCardDescription = 'cart_gift_card_description';

  // ── Line items ──
  /// One card per cart line, flat-indexed → `cart_item_<i>`.
  static const String item = 'cart_item'; // + `_<i>`
  static const String itemImageSuffix = 'image'; // → `cart_item_<i>_image`
  static const String itemNameSuffix = 'name_text_field'; // → `cart_item_<i>_name_text_field`
  static const String itemVisualCueSuffix = 'visual_cue'; // → `cart_item_<i>_visual_cue`
  static const String itemPriceSuffix = 'price_text_field'; // → `cart_item_<i>_price_text_field`
  static const String itemRemoveSuffix = 'remove_button'; // → `cart_item_<i>_remove_button`
  static const String itemQuantitySuffix = 'qty_text_field'; // → `cart_item_<i>_qty_text_field`
  static const String itemQuantityIncreaseSuffix =
      'qty_increase_button'; // → `cart_item_<i>_qty_increase_button`
  static const String itemQuantityDecreaseSuffix =
      'qty_decrease_button'; // → `cart_item_<i>_qty_decrease_button`
  static const String itemSizeSuffix = 'size_text_field'; // → `cart_item_<i>_size_text_field`
  static const String itemEddSuffix = 'edd_text_field'; // → `cart_item_<i>_edd_text_field`
  static const String itemMoveToWishlistSuffix =
      'move_to_wishlist_button'; // → `cart_item_<i>_move_to_wishlist_button`
  /// Price-drop / coupon-savings note rows inside a line item, indexed within
  /// the item.
  static const String itemDetailSuffix = 'detail'; // → `cart_item_<i>_detail_<j>`

  /// Screen prefix for the shared `ServiceGuaranteeRow` (Genuine Products /
  /// Easy Returns / Secure Payments) → `cart_slg_item_<i>_icon` / `_label`.
  static const String slgScreen =
      'cart_slg'; // → `cart_slg_item_<i>` / `cart_slg_item_<i>_icon` / `cart_slg_item_<i>_label`
  static const String slgIconSuffix = 'icon';
  static const String slgLabelSuffix = 'label';

  // ── Price summary ──
  /// Prefix handed to the shared `PriceSummaryWidget`, which composes its own
  /// suffixes from it (the widget is screen-agnostic, so it never imports this
  /// class).
  static const String priceSummary =
      'cart_price_summary'; // + `_title` / `_subtitle` / `_row_<i>` / `_row_<i>_label` / `_row_<i>_value`

  // ── Promo section ──
  /// Section root — the card holding either the code input or the applied
  /// summary, plus the "See All Offers" row.
  static const String promoSection = 'cart_promo_section';

  /// Offer tag icon. The input and the applied summary render it in the same
  /// place and never together, so they share one key.
  static const String promoOfferIcon = 'cart_promo_offer_icon';
  static const String promoCodeInput = 'cart_promo_code_input';
  static const String promoCodeInputHint = 'cart_promo_code_input_hint';
  static const String promoApplyButton = 'cart_promo_apply_button';
  static const String promoRemoveButton = 'cart_promo_remove_button';

  /// Applied-promo summary labels (backend copy: "SAVE10 applied" /
  /// "Your savings ₹120").
  static const String promoAppliedCodeText = 'cart_promo_applied_code_text_field';
  static const String promoAppliedSavingsText = 'cart_promo_applied_savings_text_field';

  static const String promoSeeAllOffersButton = 'cart_promo_see_all_offers_button';
  static const String promoSeeAllOffersText = 'cart_promo_see_all_offers_text_field';

  // ── Checkout bar ──
  static const String checkoutBar = 'cart_checkout_bar';
  static const String checkoutBarSavingsBanner = 'cart_checkout_bar_savings_banner';
  static const String checkoutBarItemCountText = 'cart_checkout_bar_item_count_text';
  static const String checkoutBarTotalAmountText = 'cart_checkout_bar_total_amount_text';
  static const String checkoutBarDetailsButton = 'cart_checkout_bar_details_button';
  static const String checkoutBarProceedButton = 'cart_checkout_bar_proceed_button';

  // ── Remove item confirmation bottom sheet ──
  static const String removeItemBottomSheetTitle = 'cart_remove_item_bottomsheet_title';
  static const String removeItemBottomSheetDescription =
      'cart_remove_item_bottomsheet_description';
  static const String removeItemBottomSheetRemoveButton =
      'cart_remove_item_bottomsheet_remove_button';
  static const String removeItemBottomSheetNoButton = 'cart_remove_item_bottomsheet_no_button';
}

/// Product detail page (PDP). Keys are `pdp_<element>[_<index>]`. Dynamic lists
/// (size chips, color variants, offer cards, detail tabs) carry an index; offer
/// sub-CTAs nest under the card. The recommendations grid and recently-viewed
/// carousel reuse the shared components via `keyPrefix`, producing
/// `pdp_recommended_row_<r>_tiles_<i>` and `pdp_recently_viewed_tiles_<i>`.
class PdpTestStrings {
  PdpTestStrings();

  /// Screen prefix for shared-component keys.
  static const String screen = 'pdp';

  // App bar (shared by content + error view)
  static const String appBarBackButton = 'pdp_appbar_back_button';
  static const String appBarWishlistButton = 'pdp_appbar_wishlist_button';
  static const String appBarCartButton = 'pdp_appbar_cart_button';

  // Brand / price header
  static const String productNameText = 'pdp_product_name_text_field';
  static const String shareButton = 'pdp_share_button';
  static const String wishlistButton = 'pdp_wishlist_button';

  // Color variants (dynamic)
  static const String colorVariant = 'pdp_color_variant'; // + `_<i>`

  // Size selector
  static const String sizeChartButton = 'pdp_size_chart_button';
  static const String sizeChip = 'pdp_size_chip'; // + `_<i>`

  // Delivery & availability
  static const String deliveryTitle = 'pdp_delivery_title';
  static const String enterPincodeButton = 'pdp_enter_pincode_button';
  static const String changePincodeButton = 'pdp_change_pincode_button';

  // Offers (dynamic; copy CTA nests under the card)
  static const String offersSection = 'pdp_offers_section';
  static const String offersTitle = 'pdp_offers_title';
  static const String offerCard = 'pdp_offer_card'; // + `_<i>`
  static const String offerCopySuffix = 'copy'; // → `pdp_offer_card_<i>_copy`

  // Product details (dynamic tabs)
  static const String productDetailsTitle = 'pdp_product_details_title';
  static const String detailTab = 'pdp_detail_tab'; // header → + `_<i>`

  // Add-to-bag bar (floating primary + docked copy — both mounted, keyed apart)
  /// PDP snackbars (`PdpSnackbar`). They render on the app's
  /// `ScaffoldMessenger`, above the floating CTA bar — the add-to-bag /
  /// buy-now outcome toast, and the coupon-copied confirmation.
  static const String snackBar = 'pdp_snackbar';
  static const String couponCopiedSnackBar = 'pdp_coupon_copied_snackbar';

  static const String addToBagButton = 'pdp_add_to_bag_button';
  static const String buyNowButton = 'pdp_buy_now_button';
  static const String dockedAddToBagButton = 'pdp_docked_add_to_bag_button';
  static const String dockedBuyNowButton = 'pdp_docked_buy_now_button';

  // Scroll-to-top pill
  static const String scrollToTopButton = 'pdp_scroll_to_top_button';

  // Recommendations & recently-viewed rails (keyPrefix on shared components)
  static const String recommendedTitle = 'pdp_recommended_title';
  static const String recommendedPrefix = 'pdp_recommended'; // + `_row_<r>_tiles_<i>`
  static const String recentlyViewedPrefix = 'pdp_recently_viewed'; // + `_tiles_<i>`

  // Size selection bottom sheet
  static const String sizeSheetTitle = 'pdp_size_sheet_title';
  static const String sizeSheetSizeChartButton = 'pdp_size_sheet_size_chart_button';
  static const String sizeSheetChip = 'pdp_size_sheet_chip'; // + `_<i>`
  static const String sizeSheetConfirmButton = 'pdp_size_sheet_confirm_button';

  // Size chart bottom sheet
  static const String sizeChartSheetTitle = 'pdp_size_chart_sheet_title';
  static const String sizeChartSheetCloseButton = 'pdp_size_chart_sheet_close_button';

  // Fullscreen image gallery
  static const String galleryBackButton = 'pdp_gallery_back_button';

  // Error view
  static const String errorView = 'pdp_error_view';
  static const String errorExploreButton = 'pdp_error_explore_button';

  // Position indicators (carry no assertion value on their own)
  static const String carouselDotIndicator = 'pdp_carousel_dot_indicator';
  static const String galleryDotIndicator = 'pdp_gallery_dot_indicator';
  static const String offersIndicator = 'pdp_offers_indicator';
  static const String sizeChartTableIndicator = 'pdp_size_chart_table_indicator'; // + `_<chart>`

  // Decoration / structure
  static const String sheetLip = 'pdp_sheet_lip';
  static const String deliveryDivider = 'pdp_delivery_divider';
  static const String detailTabDividerSuffix = 'divider'; // → `pdp_detail_tab_<i>_divider`

  // Carousel & gallery images (dynamic) + visual-cue badge
  static const String carouselImage = 'pdp_carousel_image'; // + `_<i>`
  static const String galleryImage = 'pdp_gallery_image'; // + `_<i>`
  static const String visualCueBadge = 'pdp_visual_cue_badge';

  // Price text — brand/price header
  static const String sellingPriceText = 'pdp_selling_price_text';
  static const String mrpText = 'pdp_mrp_text';
  static const String discountText = 'pdp_discount_text';
  static const String priceCalloutText = 'pdp_price_callout_text';

  // Price text — size selection sheet strip
  static const String sizeSheetSellingPriceText = 'pdp_size_sheet_selling_price_text';
  static const String sizeSheetMrpText = 'pdp_size_sheet_mrp_text';
  static const String sizeSheetDiscountText = 'pdp_size_sheet_discount_text';

  // Size-chart table (dynamic; chart-scoped so multiple tables stay unique)
  static const String sizeChartUnitButton = 'pdp_size_chart_unit_button'; // + `_<chart>_<unit>`
  static const String sizeChartHeader = 'pdp_size_chart_header'; // + `_<chart>_<col>`
  static const String sizeChartCell = 'pdp_size_chart_cell'; // + `_<chart>_<row>_<col>`

  // Recommendations pagination
  static const String recommendedLoading = 'pdp_recommended_loading';
}

class KidsTestStrings {
  KidsTestStrings();

  // ── List ──
  static const String listScreen = 'kids_list';
  static const String listAppBarTitle = 'kids_list_app_bar_title';
  static const String listBackButton = 'kids_list_back_button';
  static const String listItem = 'kids_list_item'; // card → + `_<i>`
  static const String listItemNameSuffix = 'name'; // → `kids_list_item_<i>_name`
  static const String listItemEditSuffix = 'edit'; // → `kids_list_item_<i>_edit`
  static const String listItemRemoveSuffix = 'remove'; // → `kids_list_item_<i>_remove`
  static const String listAddButton = 'kids_list_add_button';
  static const String listFooterAvatarImage = 'kids_list_footer_avatar_image'; // + `_<i>`
  static const String listEmptyTitle = 'kids_list_empty_title';
  static const String listEmptySubtitle = 'kids_list_empty_subtitle';

  // Delete-confirm bottom sheet
  static const String deleteBottomSheetTitle = 'kids_list_delete_bottomsheet_title';
  static const String deleteBottomSheetDescription = 'kids_list_delete_bottomsheet_description';
  static const String deleteBottomSheetCancelButton = 'kids_list_delete_bottomsheet_cancel_button';
  static const String deleteBottomSheetConfirmButton = 'kids_list_delete_bottomsheet_confirm_button';

  // ── Add / edit form ──
  static const String formScreen = 'kids_form';
  static const String formAppBarTitle = 'kids_form_app_bar_title';
  static const String formBackButton = 'kids_form_back_button';
  static const String formNameInput = 'kids_form_name_input';
  static const String formNameInputHint = 'kids_form_name_input_hint';
  static const String formDobInput = 'kids_form_dob_input';
  static const String formDobInputHint = 'kids_form_dob_input_hint';
  static const String formGenderBoyRadio = 'kids_form_gender_boy_radio';
  static const String formGenderGirlRadio = 'kids_form_gender_girl_radio';
  static const String formConsentRow = 'kids_form_consent_row';
  static const String formConsentCheckbox = 'kids_form_consent_checkbox';
  static const String formConsentPrivacyLink = 'kids_form_consent_privacy_link';
  static const String formConsentErrorText = 'kids_form_consent_error_text';
  static const String formApiErrorBannerText = 'kids_form_api_error_banner_text';
  static const String formSaveButton = 'kids_form_save_button';

  // Discard-changes bottom sheet
  static const String discardBottomSheetTitle = 'kids_form_discard_bottomsheet_title';
  static const String discardBottomSheetDescription = 'kids_form_discard_bottomsheet_description';
  static const String discardBottomSheetConfirmButton = 'kids_form_discard_bottomsheet_confirm_button';
  static const String discardBottomSheetCancelButton = 'kids_form_discard_bottomsheet_cancel_button';
}
