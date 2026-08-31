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

  static const String sheetTitle = 'promo_offers_sheet_title';
  static const String emptyStateButton = 'promo_offers_empty_state_button';

  /// One card per offer, flat-indexed across both (applicable /
  /// non-applicable) sections.
  static const String card = 'promo_offers_card'; // + `_<i>`
  static const String codeSuffix = 'code'; // → `promo_offers_card_<i>_code`
  // Apply and Remove are mutually exclusive, but keyed separately on purpose:
  // which one renders *is* the applied-state assertion.
  static const String applyButtonSuffix = 'apply_button'; // → `promo_offers_card_<i>_apply_button`
  static const String removeButtonSuffix =
      'remove_button'; // → `promo_offers_card_<i>_remove_button`
  static const String termsButtonSuffix = 'terms_button'; // → `promo_offers_card_<i>_terms_button`
  /// Backend-driven deeplink CTA.
  static const String ctaButtonSuffix = 'cta_button'; // → `promo_offers_card_<i>_cta_button`
}

class PromoDetailsTestStrings {
  PromoDetailsTestStrings();

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

  // ── App bar ──
  static const String appBarBackButton = 'cart_appbar_back_button';

  /// Screen prefix for the shared `ServiceGuaranteeRow` (Genuine Products /
  /// Easy Returns / Secure Payments) → `cart_slg_item_<i>_icon` / `_label`.
  static const String slgScreen = 'cart_slg';

  // ── Promo section ──
  static const String promoCodeInput = 'cart_promo_code_input';
  static const String promoCodeInputHint = 'cart_promo_code_input_hint';
  static const String promoApplyButton = 'cart_promo_apply_button';
  static const String promoRemoveButton = 'cart_promo_remove_button';
  static const String promoSeeAllOffersButton = 'cart_promo_see_all_offers_button';

  // ── Checkout bar ──
  static const String checkoutBarSavingsBanner = 'cart_checkout_bar_savings_banner';
  static const String checkoutBarItemCountText = 'cart_checkout_bar_item_count_text';
  static const String checkoutBarTotalAmountText = 'cart_checkout_bar_total_amount_text';
  static const String checkoutBarDetailsButton = 'cart_checkout_bar_details_button';
  static const String checkoutBarProceedButton = 'cart_checkout_bar_proceed_button';

  // ── Remove item confirmation bottom sheet ──
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
