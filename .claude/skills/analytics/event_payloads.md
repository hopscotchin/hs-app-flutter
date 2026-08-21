# Analytics — Event Payload Reference

Module-wise reference of every analytics event the Android Hopscotch app fires, with its exact wire payload. **This is the source-of-truth for Flutter port parity** — strings here MUST match verbatim (including trailing spaces, mixed casing, and `"none"` fallbacks). Renaming silently breaks dashboards.

Source files:
- `hsapp/.../analytics/AnalyticsHelper.java` — the god-helper, ~1584 lines, fires most events
- `hsapp/.../analytics/AnalyticsEvents.java` — event-name constants
- `hsapp/.../analytics/AnalyticsProperties.java` — property-key constants
- `hsapp/.../analytics/AnalyticsDefaults.java` — magic values + `FromScreens` / `FromLocations` / `ClickType`
- `hsapp/.../analytics/HomeTrackAnalyticManager.kt` — homepage impression / scroll tracker
- `hsapp/.../analytics/impl/*` — module-specific helpers (orders, ratings, exchange, tabpage)
- `components/.../util/AnalyticsEvents.kt` + `.../AnalyticsProperties.kt` — shared components-module surface

## Reading the tables

Every section is shaped:

```
### `<event_name_verbatim>`

**Android method:** logXxxEvent(...) — file:LINE
**Event constant:** AnalyticsEvents.XXX
**logEvent flags:** attribution=true|false, universal=true|false, useSavedAttribution=true|false (only stated if true)
**Side effects:** logAppLaunched(...) / state mutations / parallel SDK calls (FB / CleverTap) the method does before/after firing

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
```

The "Default" column states what is written when the input is empty/null. For most string fields the convention is `"none"` (Android `AnalyticsDefaults.NONE`); for numeric fields it's usually omission.

## Modules (jump table)

| Module | Events covered |
|---|---|
| [Auth, Lifecycle, Search](#module-auth-lifecycle-search) | customer_logged_in, customer_registered, customer_logged_out, login_viewed, join_viewed, forgot_viewed, otp_sent, otp_verified, application_opened, app_launched, session_started, install_referrer (dead), products_searched, search_clicked, search_carousel_viewed, search_carousel_tile_clicked, tooltip_viewed |
| [Home / Discover / Doorway / LP / Tab](#module-home--discover--doorway--lp--tab) | homepage_viewed, homepage_scrolled, carousel_scrolled, tile_impression, banner_impression, tile_clicked, cta_button_clicked, feature_card_viewed, lp_tile_impression, lp_banner_impression, lp_tile_clicked, lp_carousel_scrolled, tab_clicked, tab_clicked_nav_carousel, tabbed_page_container_viewed, continue_browsing_loaded/_viewed/_clicked, doorway_loaded/_viewed/_scrolled/_clicked |
| [PDP / Categories](#module-pdp--categories) | product_viewed, Product viewed, product_expanded, product_view_more_clicked, product_share_clicked, select_size_clicked, size_selected, size_chart_viewed, size_chart_clicked, shipping_info_viewed, PDP_reco_loaded, pdp_attributes_loaded, pdp_images_scrolled, xl_product_card_scrolled, aplus_content_viewed, product_content_expanded/_collapsed, product_details_expanded/_collapsed, product_details_tab_clicked, product_attribute_tab_clicked, shop_the_look_clicked, color_widget_expanded, new_color_selected, parent_collection_viewed/_clicked, pincode_form_opened, pincode_change, coupon_code_clicked/_scrolled, recently_viewed_products_*, reco_viewed, reco_product_clicked, reco_see_more_clicked, reco_clicked, product_reco_viewed, reco_products_viewed, recent_products_viewed, reco_products_carousel_scrolled, reco_collaborative_products_carousel_scrolled, product_added_to_notifylist, category_tree_viewed |
| [PLP / Filters / Sorting / Brand](#module-plp--filters--sorting--brand) | product_listing_viewed, boutique_viewed, plp_scrolled, collections_loaded/_viewed, special_page_viewed, recent_collections_viewed (dead), promo_products_viewed, offers_viewed, bestsellers_viewed, upcoming_collections_viewed, plp_genie_icon_clicked, plp_collection_clicked/_expanded/_zero_products/_more_products_loaded, smart_filter_applied, filter_applied/_clicked/_cleared, sorting_applied, sortbar_changed, pincode_check_clicked, pincode_checked, brand_followed/_unfollowed, product_listing_share_clicked (dead), special_page_share_clicked, app_share_clicked |
| [Cart / Checkout / Order placement](#module-cart--checkout--order-placement) | cart_viewed, product_added_to_cart, product_added_to_notifylist, product_added_to_wishlist, product_removed_from_wishlist, product_updated, product_update_clicked, promo_code_applied/_failed/_removed, promo_removed_failed, buynow_clicked, buy_now_clicked, checkout_clicked/_failed/_started/_mobile/_review/_delivery/_payment/_*_failed/_payment_viewed, order_place_clicked, order_placed, product_ordered, Order Completed, order_failed, order_pending |
| [Moments / Account / Orders / Ratings / Misc](#module-moments--account--orders--ratings--in-app-update--notifications--video) | moments_viewed, photo_liked/_undid_like/_reported/_uploaded/_upload_clicked/_deleted/_shared_clicked/_viewed, name_updated, email_updated, mobile_updated, password_updated, address_updated, profile_photo_uploaded (trailing space), account_card_viewed, child_profile_added/_selected, child_details_deleted/_edited, order_listing_viewed, order_viewed, exchange_clicked, product_exchanged/_exchange_clicked, exchange_aborted, reason_selected, dialog_action_clicked, order_return_clicked, exchange_size_selection_cta_clicked, exchange_address_selected, exchange_order_placed, return_address_selected, return_order_placed, exchange_nudge_widget_viewed, swap_with_correct_size_clicked, proceed_with_return_clicked, product_rated, nps_feedback, rating_review_viewed, rate_shopping_experience_shown_at/_dismissed_at, rate_in_playstore_user_response, shopping_experience_ratings_given, app_rating_ignored/_shown_interest/_dialog_shown, in_app_update_download_clicked/_later_clicked/_install_shown/_installed_success/_installed_failed/_user_cancel/_install_clicked, notification_permission_intent_shown/_accepted/_rejected/_dismissed, video_action/_appeared/_link_clicked |

## Common enrichment (applies to every track)

`AnalyticsHelper.logEvent` and `logScrollEvent` always append these fields onto every payload before dispatching to Segment:

| Property key (wire) | Source | Notes |
|---|---|---|
| `[time] hour_of_day` | `Calendar.HOUR_OF_DAY` in `Asia/Kolkata` | int 0–23 |
| `[time] day_of_week` | `Calendar.DAY_OF_WEEK` in `Asia/Kolkata` | int 1–7 (Sunday=1, Saturday=7) — Android shape, NOT Dart's Mon=1 |
| `[time] day_of_month` | `Calendar.DAY_OF_MONTH` | int 1–31 |
| `[time] month_of_year` | `Calendar.MONTH + 1` | int 1–12 (Jan=1) |
| `[time] week_of_year` | `Calendar.WEEK_OF_YEAR` joined with year | String `"YYYYww"` — 2-digit week left-padded |
| `timestamp` | `toISO8601String(new Date())` | ISO-8601 UTC. **Only added by `logEvent`, NOT by `logScrollEvent`.** |
| `afUserId` | `AppsFlyerLib.getAppsFlyerUID()` | String, may be empty on first event of cold start |
| `cleverTapId` | `PrefUtils.getCleverTapId()` | String, may be empty until the CleverTap SDK callback fires |

When `attribution=true`:
- `OrderAttributionHelper.getOrderAttributionSegmentParams()` — funnel/funnel_tile/funnel_section/section/subsection (joined by `~`)/plp/sort_by/sortbar/sortbar_group/slice_id/cta/property_type/banner_name + `redirected_from_continue_browsing_widget`/`redirected_from_cluster_eligible_plp`
- `LPAttributionHelper.getLPAttributionSegmentData()` — `lp1_*…lp5_*` (slice_id, property_type, banner_name, funnel_row, funnel_tile, name, id) for up to 5 most recent landing pages
- `TabPageAttributionHelper.getTabPageSegmentParams()` — `tabbed_page_container_name`, `tabbed_page_container_id`, `tab_name`, `tab_position` + `redirected_from_tab_page` = `"Yes"`/`"No"`

When `universal=true`:
- `universal` key with `AnalyticsCommonPropertiesHelper`'s queued strings (e.g. `["First screen"]`) — or the string `"none"` when the buffer is empty. **Buffer is one-shot — cleared after read.**

The Amplitude `session_id` is added as an integration option (not a top-level property) — sourced from `AppRecordData.getStartSessionId()`.

---

## Module: Auth, Lifecycle, Search

### `customer_logged_in`

**Android method:** `logCustomerLoggedInEvent(...)` — `AnalyticsHelper.java:303`
**Event constant:** `AnalyticsEvents.CUSTOMER_LOGGED_IN`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `authentication_type` | `AnalyticsProperties.AUTHENTICATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `validation_type` | `AnalyticsProperties.VALIDATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_validation_type` | `AnalyticsProperties.FROM_VALIDATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_redirect` | `AnalyticsProperties.FROM_REDIRECT` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |

**Quirks:** All six properties are always present in the payload — the method writes `AnalyticsDefaults.NONE` ("none") rather than omitting keys when inputs are empty.

### `customer_registered`

**Android method:** `logCustomerRegisteredEvent(...)` — `AnalyticsHelper.java:314`
**Event constant:** `AnalyticsEvents.CUSTOMER_REGISTERED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_redirect` | `AnalyticsProperties.FROM_REDIRECT` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `authentication_type` | `AnalyticsProperties.AUTHENTICATION_TYPE` | String | required | `"Mobile"` | Hard-coded to `AnalyticsDefaults.MOBILE` |
| `validation_type` | `AnalyticsProperties.VALIDATION_TYPE` | String | required | `"OTP"` | Hard-coded to `AnalyticsDefaults.OTP` |

**Quirks:** `authentication_type` and `validation_type` are not parameters — they are hard-coded to `"Mobile"` and `"OTP"` respectively (Android only supports OTP-based mobile registration).

### `customer_logged_out`

**Android method:** `loggedOutEvent()` — `AnalyticsHelper.java:324`
**Event constant:** `AnalyticsEvents.CUSTOMER_LOGGED_OUT`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — passes a brand-new empty `HashMap<>()` as properties

**Payload:** No event-specific properties beyond common enrichment.

### `login_viewed`

**Android method:** `logLoginViewedEvent(...)` — `AnalyticsHelper.java:821`
**Event constant:** `AnalyticsEvents.LOGIN_VIEWED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.LOGIN)` (`"Login"`) BEFORE firing — may trigger `app_launched` + lifecycle events if `LaunchTimer` isn't yet stopped.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `validation_type` | `AnalyticsProperties.VALIDATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_validation_type` | `AnalyticsProperties.FROM_VALIDATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `authentication_type` | `AnalyticsProperties.AUTHENTICATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_redirect` | `AnalyticsProperties.FROM_REDIRECT` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |

### `join_viewed`

**Android method:** `logJoinViewedEvent(...)` — `AnalyticsHelper.java:833`
**Event constant:** `AnalyticsEvents.JOIN_VIEWED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.JOIN)` (`"Join"`) BEFORE firing.

**Payload:** Identical shape to `login_viewed`.

### `forgot_viewed`

**Android method:** `logForgotViewedEvent(...)` — `AnalyticsHelper.java:845`
**Event constant:** `AnalyticsEvents.FORGOT_VIEWED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None (unlike login/join, this does NOT call `logAppLaunchedEvent`)

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_authentication_type` | `AnalyticsProperties.FROM_AUTHENTICATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_redirect` | `AnalyticsProperties.FROM_REDIRECT` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `mobile` | `AnalyticsProperties.MOBILE` | long OR String | required | `"none"` | If `mobileNo != 0`, sent as `long` (numeric); otherwise the String `"none"` is written — **mixed-type quirk** |
| `email` | `AnalyticsProperties.EMAIL` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |

**Quirks:** The `mobile` value is a `long` primitive (not String) when present — `properties.put(MOBILE, mobileNo != 0 ? mobileNo : AnalyticsDefaults.NONE)` puts either a `Long` or the `"none"` String, so the JSON column type is heterogeneous. The auth parameter is named `from_authentication_type` (not `authentication_type`).

### `otp_sent`

**Android method:** `logOtpSentEvent(...)` — `AnalyticsHelper.java:1142`
**Event constant:** `AnalyticsEvents.OTP_SENT`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `authentication_type` | `AnalyticsProperties.AUTHENTICATION_TYPE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `verification_reason` | `AnalyticsProperties.VERIFICATION_REASON` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `mobile` | `AnalyticsProperties.MOBILE` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` — sent as **String** here (unlike `forgot_viewed`) |
| `email` | `AnalyticsProperties.EMAIL` | String | required | `"none"` | Empty → `AnalyticsDefaults.NONE` |

**Quirks:** `mobile` is typed `String` here, unlike `forgot_viewed` which takes a `long`.

### `otp_verified`

**Android method:** `logOtpVerifiedEvent(...)` — `AnalyticsHelper.java:1153`
**Event constant:** `AnalyticsEvents.OTP_VERIFIED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:** Identical shape to `otp_sent`.

### `application_opened`

**Android method:** `fireApplicationOpenedEvent(installType, prevVersionName, prevVersionCode, sendExtraParam)` — `AnalyticsHelper.java:477`
**Event constant:** `AnalyticsEvents.APPLICATION_OPENED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:**
- Sets `AppRecordData.setApplicationStatus(false)` BEFORE firing.
- Called from `fireLifeCycleEvents()` (line 447) which decides the `installType`:
  - First-install: `installType="New"`, empty `prevVersionName`, `prevVersionCode=0`, then `setIsFirstInstall(false)`.
  - Upgrade with no prior version: `installType="Update"`, hard-coded `prevVersionName="v1.10.2"`, `prevVersionCode=2016102904`.
  - Versioned-upgrade: `installType="Update"`, real previous values.
- Also re-fired from `logAppLaunchedEvent` with `installType=""`, real previous values, `sendExtraParam=false` if `getApplicationStatus()` is true (background-to-foreground resume).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `version` | `AnalyticsProperties.VERSION_NAME` | String | always | — | `BuildConfig.VERSION_NAME` |
| `build` | `AnalyticsProperties.VERSION_CODE` | int | always | — | `BuildConfig.VERSION_CODE` |
| `device_profile` | `AnalyticsProperties.DEVICE_PROFILE` | String | optional | omitted | Only if `AppRecordData.isDeviceProfileSet() && !TextUtils.isEmpty(...)` |
| `install_type` | `AnalyticsProperties.INSTALL_TYPE` | String | conditional | omitted | Only if `sendExtraParam=true` AND non-empty — values: `"New"` or `"Update"` |
| `previous_version` | `AnalyticsProperties.PREVIOUS_VERSION_NAME` | String | conditional | omitted | Only if `sendExtraParam=true` AND non-empty |
| `previous_build` | `AnalyticsProperties.PREVIOUS_VERSION_CODE` | int | conditional | omitted | Only if `sendExtraParam=true` AND `prevVersionCode != 0` |
| `push_enabled` | `AnalyticsProperties.PUSH_ENABLED` | String | always | — | `"Yes"`/`"No"` |
| `fmessenger` | `AnalyticsProperties.FMESSENGER` | String | always | — | `"Yes"`/`"No"` — FB Messenger installed |
| `wa` | `AnalyticsProperties.WA_INSTALLED` | String | always | — | `"Yes"`/`"No"` — WhatsApp installed |
| `fc` | `AnalyticsProperties.FC_INSTALLED` | String | always | — | `"Yes"`/`"No"` — FreeCharge installed |
| `my` | `AnalyticsProperties.MY_INSTALLED` | String | always | — | `"Yes"`/`"No"` — MyApp installed |
| `rooted` | `AnalyticsProperties.ROOTED` | String | always | — | `"Yes"`/`"No"` |
| `cpu_arch` | `AnalyticsProperties.DEVICE_CPU_ARCH` | String | always | — | `DeviceUtil.INSTANCE.getCpuArch()` |

**Quirks:** When `sendExtraParam=false` (resume path), the three install/upgrade fields are dropped. Hard-coded fallback `prevVersionName="v1.10.2"` / `prevVersionCode=2016102904` is the historical first-install baseline.

### `app_launched`

**Android method:** `logAppLaunchedEvent(String fromScreen)` — `AnalyticsHelper.java:1314`
**Event constant:** `AnalyticsEvents.APP_LAUNCHED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:**
- Guarded by `LaunchTimer.getInstance().isStopped()` — fires only when timer running. Calls `LaunchTimer.stopLaunchTimer()` after.
- Calls `LaunchTimer.logTTI()` to compute TTI right before reading.
- After the event, invokes `fireLifeCycleEvents()` (which may fire `application_opened`).
- If `AppRecordData.getApplicationStatus()` is true, additionally fires `fireApplicationOpenedEvent("", versionName, versionCode, false)` for foreground-resume.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | Callers pass screen names like `"Discover"`, `"Login"`, `"Join"`, `"Cart"`, `"Moments"` |
| `ttl` | `AnalyticsProperties.TTL` | long | always | — | `LaunchTimer.getTtl()` (ms) |
| `tti` | `AnalyticsProperties.TTI` | long | always | — | `LaunchTimer.getTti()` (ms) |
| `install_type` | `AnalyticsProperties.INSTALL_TYPE` | String | always | `"none"` | `LaunchTimer.getInstallType()` — populated to `"New"`/`"Update"` by `fireLifeCycleEvents` |
| `from_source` | `AnalyticsProperties.FROM_SOURCE` | String | always | `"none"` | `LaunchTimer.getLaunchSource()` — values: `BRANCH`/`APPS_FLYER`/`PUSH`/`DEEPLINK`/`BACKGROUND`/`SCREEN` |

**Quirks:** The method is `synchronized`. Order: `app_launched` fires FIRST, then lifecycle events (`application_opened`, resume re-fire) — so on Segment: app_launched, then application_opened.

### `session_started`

**Android method:** `fireSessionStartedEvent()` — `AnalyticsHelper.java:408`
**Event constant:** `AnalyticsEvents.SESSION_STARTED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `session_utm_source` | `AnalyticsProperties.SESSION_UTM_SOURCE` | String | optional | omitted | Only if `UTMHeaderUtil.getUtmSource()` non-empty |
| `session_utm_campaign` | `AnalyticsProperties.SESSION_UTM_CAMPAIGN` | String | optional | omitted | Only if `UTMHeaderUtil.getUtmCampaign()` non-empty |
| `session_utm_medium` | `AnalyticsProperties.SESSION_UTM_MEDIUM` | String | optional | omitted | Only if `UTMHeaderUtil.getUtmMedium()` non-empty |
| `session_deeplink` | `AnalyticsProperties.SESSION_DEEPLINK` | String | optional | omitted | Only if `UTMHeaderUtil.getDeeplink()` non-empty |
| `session_utm_gender` | `AnalyticsProperties.SESSION_UTM_GENDER` | String | optional | omitted | Only if `UTMHeaderUtil.getUtmGender()` non-empty |

**Quirks:** Every property is conditional. With no UTM data, the payload carries only common enrichment. The `session_*` prefix differs from the top-level `utm_*` traits sent via `identify()`.

### `install_referrer`

**Android method:** None — the event constant `AnalyticsEvents.INSTALL_REFERRER = "install_referrer"` (`AnalyticsEvents.java:14`) is **declared but never fired** anywhere. UTM/referrer data flows through `identify(isUtmChange=true, ...)` traits instead. Dead constant; do not implement.

### `products_searched`

**Android method:** `logSearchViewedEvent(ProductListResponse, int, boolean)` — `ProductListPageActivity.java:2876` (primary) and `logSearchViewedEventAfterQueryCorrection(ProductListResponse)` — `ProductListPageActivity.java:2827` (re-fire). Both invoke `AnalyticsHelper.logEvent(AnalyticsEvents.PRODUCTS_SEARCHED, properties, true, true)`.
**Event constant:** `AnalyticsEvents.PRODUCTS_SEARCHED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Primary adds `AnalyticsDefaults.FIRST_SCREEN` if `Util.addFirstScreenProperty()` is true.
- Sets `firedViewedEvent = true` after firing (per-activity dedup).
- Fires Facebook SDK `logFacebookSearchEvent(searchQuery)` after.
- `logSearchViewedEventAfterQueryCorrection` resets `queryCorrectionClicked = false`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (search-suggestion tracking-data spread) | from `searchSuggestionItem.getTrackingData()` | mixed | optional | omitted | Merged first |
| `keyword` | `KEYWORD` | String | conditional | omitted | When section is `recent_search`/`keyword`/`segment_search_section`; ALSO from `IntentHelper.SEARCH_QUERY` extra |
| `category` | `CATEGORY` | String | conditional | omitted | When `segmentSectionValue == segment_category_section` |
| `brand` | `BRAND` | String | conditional | omitted | When `segmentSectionValue == segment_brand_section` |
| `profile` | `PROFILE` | String | conditional | omitted | When `segmentSectionValue == segment_profile_section` |
| `subcategory` | `SUB_CATEGORY` | String | conditional | omitted | When `segmentSectionValue == segment_subcategory_section` |
| `browsecategory` | `BROWSECATEGORIES` | String | conditional | omitted | When `segmentSectionValue == segment_browse_category_section` |
| `product` | `PRODUCT` | String | conditional | omitted | When `segmentSectionValue == segment_product_section` |
| `sort_order` | `SORT_ORDER` | String | optional | omitted | First sorting option's `sortName` |
| `add_from_details` | `ADD_FROM_DETAILS` | String | always | — | `mLocalAddFromDetails` |
| `feed_size` | `FEED_SIZE` | int | always | `0` | `totalCount` or `0` |
| `promo_code` | `PROMO_CODE` | String | optional | omitted | From `response.promoPLPSegmentEvents.promotionCode` |
| `merch_promo` | `MERCH_PROMO` | String | optional | omitted | `"Yes"`/`"No"`; only when `promoPLPSegmentEvents` non-null |
| `from_screen` | `FROM_SCREEN` | String | conditional | omitted | `"Search"` when `IS_FROM_SEARCH` extra true |
| `from_section` | `FROM_SECTION` | String | always | — | `"Recent searches"` when `isFromRecentSearch`, else `segmentSectionValue`; overridable via `IntentHelper.FROM_SECTION` extra |
| `plp_name` | `PLP_NAME` | String | always | — | `"No results"` when feed empty, else `"Search results"` |
| `plp_type` | `PLP_TYPE` | String | always | — | `"Search"` |
| `suggestion_index` | `SUGGESTION_INDEX` | int | optional | omitted | From `IntentHelper.SUGGESTION_INDEX` (only if `> 0`) |
| `length` | `LENGTH` | int | optional | omitted | `searchQuery.length()` when non-empty |
| `search_result_pids` | `SEARCH_RESULT_PIDS` | List<String> | optional | omitted | Up to first 5 product IDs; only when `hasResults` |
| `query_correction` | `QUERY_CORRECTION` | String | always | `"none"` | `"Suggested correction"` / `"Autocorrected"` / `"Auto trimmed"` / `"Suggestion used"` / `"Autocorrect reverted"` / `"none"` |

**Quirks:**
- Early-return guard `if (firedViewedEvent) return;`.
- Query-correction re-fire path is slimmer (no FIRST_SCREEN, no tracking-data spread, no `length` or `suggestion_index`).
- The same method also fires `reco_products_viewed` (not `products_searched`) when intent has `SIMILAR_PRODUCTS_VIEWED=true` or `IS_FROM_RECO=true`.

### `search_clicked`

**Android method:** `logSearchClickedEvent(String fromScreen, String fromLocation)` — `AnalyticsHelper.java:1562`
**Event constant:** `AnalyticsEvents.SEARCH_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | always | — | Raw arg — **no empty-check, no `"none"` fallback** |
| `from_location` | `FROM_LOCATION` | String | always | — | Raw arg — same no-fallback behavior |

**Quirks:** Unlike most other auth-adjacent events, this method does NOT apply the `!TextUtils.isEmpty(...) ? x : NONE` guard.

### `search_carousel_viewed`

**Android method:** `logSearchCarouselViewedEvent(Integer carouselId)` — `SearchAutocompleteActivity.kt:555`
**Event constant:** `components.AnalyticsEvents.SEARCH_CAROUSEL_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None. Routed through `GlobalObservers.analyticsHelper.send(AnalyticsEvent.SendEvent(...))`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `carousel_id` | `CAROUSEL_ID` (common module) | Int | optional | omitted | Added via `putAnalyticsKey` which **skips null** values |
| `from_screen` | `FROM_SCREEN` (common module) | String | optional | omitted | From activity's `fromScreen` field; null-safe |

**Quirks:** Uses common-module `AnalyticsProperties`. `putAnalyticsKey` drops null silently — no `"none"` fallbacks.

### `search_carousel_tile_clicked`

**Android method:** `logSearchCarouselTileClickedEvent(Integer carouselId, Integer tileId)` — `SearchAutocompleteActivity.kt:569`
**Event constant:** `components.AnalyticsEvents.SEARCH_CAROUSEL_TILE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `carousel_id` | `CAROUSEL_ID` | Int | optional | omitted | Null-safe |
| `tile_id` | `TILE_ID` | Int | optional | omitted | Null-safe |
| `from_screen` | `FROM_SCREEN` | String | optional | omitted | Null-safe |

### `tooltip_viewed`

**Android method:** `logSearchNudgeShownEvent()` — `AnalyticsHelper.java:1569`
**Event constant:** `AnalyticsEvents.TOOLTIP_VIEWED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None. Only call site is `CollectionsFragment.kt:1417`.

**Payload:** No event-specific properties — empty `HashMap<>()`.

**Quirks:** Despite the generic name, this event is fired ONLY for the search nudge tooltip — no `from_screen` / `tooltip_type` is included.

---

## Module: Home / Discover / Doorway / LP / Tab

### `homepage_viewed`

**Android method:** `homePageViewedEvent(String fromScreen, String fromLocation)` — `AnalyticsHelper.java:428`
**Event constant:** `AnalyticsEvents.HOME_PAGE_VIEWED` = `"homepage_viewed"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.DISCOVER)` BEFORE building properties (line 429). This in turn fires `app_launched` (if launch timer active), then `fireLifeCycleEvents()`.
- If `Util.addFirstScreenProperty()` true, pushes `AnalyticsDefaults.FIRST_SCREEN` into `AnalyticsCommonPropertiesHelper`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_location` | `FROM_LOCATION` | String | conditional | — | Only if `fromLocation` non-empty |
| `from_screen` | `FROM_SCREEN` | String | conditional | — | Only if `fromScreen` non-empty |
| `skin` | `SKIN` | String | always | `"none"` | From `AppRecordData.getHomePageSkin()` else `AnalyticsDefaults.NONE` |

**Quirks:**
- `logAppLaunchedEvent` runs first — Segment receives `app_launched` BEFORE `homepage_viewed`.
- `skin` defaults to literal `"none"` — never omitted.

### `homepage_scrolled`

**Android method:** Plumbed via `CollectionsFragment.initScrollTracking()` (line 516) and `sendScrollData()` (`CollectionsFragment.kt:1577`); core path `AnalyticsHelper.logScrollEvent(...)` — `AnalyticsHelper.java:361`.
**Event constant:** `AnalyticsEvents.HOMEPAGE_SCROLLED` = `"homepage_scrolled"`
**logEvent flags:** `attribution=true`, `universal=true`, `useSavedAttribution=true` (uses `AppRecordData.getOrderAttributionDataForScrollEvent()`)
**Side effects:**
- Pops stack frame from `StackForMultiScrollEvents`.
- Does NOT add `timestamp` (uses `logScrollEvent`).
- Reuses attribution snapshot saved at last screen entry.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `total_rows` | `TOTAL_ROWS` | int | always | — | `max(totalCollections + totalSections + extraRows - excludedRows + dynamicUI, scrolledRowCount)` |
| `screen_height` | `SCREEN_HEIGHT` | String | always | — | `DefaultDisplay.displayHeight.toString()` — **sent as String** |
| `scrolled_sections` | `SCROLLED_SCROLLED_SECTION` | List<String>\|"none" | always | `"none"` | Section IDs (e.g. `["B<id>"]`); `"none"` when empty |
| `scrolled_funnel_tiles` | `SCROLLED_FUNNEL_TILES` | List<String>\|"none" | always | `"none"` | Funnel tile IDs (e.g. `"CT<id>"`); `"none"` when empty |
| `sortbar` | `SCROLLED_SORT_BAR` | String | conditional | — | Only when sortbar changed |
| `trigger` | `SCROLLED_TRIGGER` | String | always | — | `"Sortbar changed"` or `"App moved background"` |
| `from_row` | `FROM_ROW` | int | conditional | — | `1` if start ≤ 0 else `startScrollIndex` |
| `scrolled_row` | `SCROLLED_ROW` | int | conditional | — | `scrolledRowCount` |
| `scrolled_height` | `SCROLLED_HEIGHT` | int | conditional | — | `maxScrolledHeight + extraRowHeight`; only if non-zero or first emit |

**Quirks:**
- `screen_height` is sent as a String.
- Uses `logScrollEvent` (no timestamp).
- `useSavedAttribution=true` — saved snapshot is merged in, not live.

### `carousel_scrolled`

**Android method:** `HomeTrackAnalyticManager.pushScrollData(...)` — `HomeTrackAnalyticManager.kt:436`. Staged via `logCarouselScrolled(carouselId, attributionData)` at line 619 (called from `PageCarouselView.kt:238`).
**Event constant:** `AnalyticsEvents.CAROUSEL_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:**
- One event per scrolled carousel; clears `carouselScrollDepth` map after flush.
- Snapshots `OrderAttributionHelper.getOrderAttributionSegmentParams()` once at start and passes via `fillHPAttributionData`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `carousel_id` | `CAROUSEL_ID` | Int | conditional | — | Map key; null-skipped |
| `scrolled_tiles` | `SCROLLED_TILES` | String | conditional | — | `HPAttributionData.sliceId` |
| `funnel_row` | `FUNNEL_ROW` | String | conditional | — | from `HPAttributionData.funnelRow` |
| `funnel_tile` | `FUNNEL_TILE` | String | conditional | — | from `HPAttributionData.funnelTile`, **prefixed with `"CT"` if not already** |
| `banner_name` | `BANNER_NAME` | String | conditional | — | |
| `property_type` | `PROPERTY_TYPE` | String | conditional | — | |
| `funnel` | `FUNNEL` | String | always (fromHomePage) | `"Discover"` | `AttributionConstants.FUNNEL_DISCOVER` |
| `selected_sortbar` | `SELECTED_SCROLLED_SORT_BAR` | String | always | `""` | from `sortBarName` |
| `sortbar` | `SORTBAR` | String | always | `""` | from `sortBarName` |

**Quirks:**
- `funnel_tile` auto-prefixed with `"CT"`.
- Same dispatcher emits `LP_CAROUSEL_SCROLLED` when `fromHomePage=false`.

### `tile_impression`

**Android method:** `HomeTrackAnalyticManager.pushScrollData(...)` — `HomeTrackAnalyticManager.kt:461`. Per-page-component built via `identifyPageComponents(index, event, fromHomePage)` (line 453).
**Event constant:** `AnalyticsEvents.TILE_IMPRESSION`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:**
- Gated by `isHomepageAnalyticsEnabled` (combined `ExperimentUtil.RemoteConfigFlags.isHomepageAnalyticsEnabled` AND `ABTestHelper.isHomePageTrackingEnabled`).
- One event per child tile (per component, per item index) within scroll range.
- Clears `heroTiles`, `carouselTiles`, `shopTheLookTiles` after flush.
- Each invocation also fires `banner_impression` for the parent component.

**Base payload (all variants):**

| Property key (wire) | Constant | Type | Notes |
|---|---|---|---|
| `type` | `TYPE` | String | Component type (`hero`, `pageCarousel`, `customTile`, etc.) |
| `position` | `POSITION` | Int | `PageComponent.position` |
| `selected_sortbar` | `SELECTED_SCROLLED_SORT_BAR` | String | `sortBarName` |
| `sortbar` | `SORTBAR` | String | `sortBarName` |

Plus per-variant fields and `fillHPAttributionData` merge.

**Custom-tile (TYPE_CUSTOM_TILE):** `name`, `start_date`, `end_date`, `cbt_id`, `page_name`, `tile_detail_id`, `tile_grid_position`, `image_url`, `width`, `height`, `action`, `action_uri`, `tile_grid_id`.

**Continue browsing (TYPE_CONTINUE_BROWSING):** `name` (trackingMeta.title), `cbt_id`, `position` (String — overwrites parent Int), `action_uri`, `tile_name` (item.heading).

**Page carousel (TYPE_PAGE_CAROUSEL):** `name`, `width`, `height`, `cbt_id`, `carousel_id` (queryParams), `carousel_type`, `tile_detail_id`, `banner_name` (pageCarousel.title), `image_url`, `action_uri`.

**Hero (TYPE_HERO):** `carousel_id`, `carousel_type`, `transition_type`, `scroll_duration`, `cbt_id`, `tile_name`, `start_date`, `end_date`, `tile_detail_id`, `tile_grid_position`, `image_url`, `width`, `height`, `action`, `action_uri`, `tile_grid_id`.

**Collection (TYPE_COLLECTION):** `name`, `cbt_id`, `tile_name`, `banner_name`, `tile_grid_position`, `image_url`, `width`, `height`, `action`, `action_uri`, `tile_grid_id`.

**Testimonial (TYPE_TESTIMONIAL):** Only `cbt_id` + `fillHPAttributionData`.

**Product grid (TYPE_PRODUCT_GRID_ROW):** `type`, `position`, `name`, `cbt_id`, `tile_detail_id`, `slice_id`, `image_url`, `action`, `action_uri`, `tile_grid_id`.

**Tabbed decor / Tabbed custom tiles:** `name`, `tab_id`, `tab_name`, then per-tile fields.

**Shop the look:** `name` (trackingMeta name), `banner_name` (the int loop index!), `tile_detail_id`.

**Plus `fillHPAttributionData` (when `fromHomePage=true`):**

| Property key (wire) | Constant | Notes |
|---|---|---|
| `funnel_row` | `FUNNEL_ROW` | position string |
| `funnel_tile` | `FUNNEL_TILE` | `"CT" + tile` (prefix if missing) |
| `banner_name` | `BANNER_NAME` | component/tile name |
| `property_type` | `PROPERTY_TYPE` | useCase / type |
| `slice_id` | `SLICE_ID` | `Util.getSliceId(row+1, col+1)` → `"R{row}_C{col}"` |
| `funnel` | `FUNNEL` | `"Discover"` — only when fromHomePage |

**Quirks:**
- Continue-browsing position is a String (overwrites parent Int).
- `funnel_tile` always gets `"CT"` prefix.
- Shop-the-look uses int loop index as `banner_name` — mirror this.

### `banner_impression`

**Android method:** `HomeTrackAnalyticManager.logBannerImpression(...)` — `HomeTrackAnalyticManager.kt:610`; hero variant `logBannerImpressionForHero(...)` line 603.
**Event constant:** `AnalyticsEvents.BANNER_IMPRESSION`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:**
- Gated by `isHomepageAnalyticsEnabled`.
- One emission per page-component, one extra per hero tile.
- `addSortProperties` always merges `selected_sortbar` and `sortbar`.
- `logBannerImpression` also merges `fillHPAttributionData(...)` (so the impression carries funnel data even with `attribution=false`).

**Payload:** Per-component fields (same as `tile_impression` parent fields), plus `selected_sortbar`, `sortbar`, plus `fillHPAttributionData` (`funnel_row`, `funnel_tile` (CT-prefixed), `banner_name`, `property_type`, `slice_id` (often null), `funnel="Discover"`).

**Quirks:**
- Hero variant fires one banner impression per hero TILE GRID (nested loop) — N tile grids → N events.
- Tabbed components fire only for currently selected tab.
- Shop-the-look: `banner_name` overwritten to numeric loop index per tile.

### `tile_clicked`

**Android method:** `HomeTrackAnalyticManager.logTileClickAnalyticEvent(...)` — `HomeTrackAnalyticManager.kt:478`, dispatch line 521.
**Event constant:** `AnalyticsEvents.TILE_CLICKED` (or `LP_TILE_CLICKED` for non-homepage)
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- If `sortBar` provided: sets `sortBarName` and calls `OrderAttributionHelper.addSortData(sortBar)`.
- Variant via `extraData?.fromHomePage`: `true` → `TILE_CLICKED`, `false` → `LP_TILE_CLICKED`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `action` | `ACTION` | String | conditional | — | `actionType` |
| `action_uri` | `ACTION_URI` | String | conditional | — | actionUri |
| `tile_grid_id` | `TILE_GRID_ID` | String | conditional | — | actionValue |
| `name` | `NAME` | String | conditional | — | tile name |
| `type` | `TYPE` | String | conditional | — | tile type |
| `carousel_id` | `CAROUSEL_ID` | Int | conditional | — | id |
| `cbt_id` | `CBT_ID` | Int | conditional | — | tileId |
| `width` / `height` / `image_url` | various | various | conditional | — | |
| `position` | `POSITION` | Int | conditional | — | |
| `start_date` / `end_date` | various | Date | conditional | — | |
| `sortbar` | `SORTBAR` | String | conditional | — | |
| `cta` | `CTA` | String | when type non-null | `"No"` | `"Yes"` if `type.equalsIgnoreCase("cta")` else `"No"` |
| `selected_sortbar` | `SELECTED_SCROLLED_SORT_BAR` | String | always | `sortBarName` | from `addSortProperties` |
| `sortbar` | `SORTBAR` | String | always | `sortBarName` | from `addSortProperties` (may overwrite) |

**Quirks:**
- `cta` value uses `AnalyticsProperties.YES`/`NO` constants which are `"Yes"`/`"No"` strings.
- All properties via `putAnalyticsKey` (null-skip).
- `sortbar` may appear twice; last write wins.

### `cta_button_clicked`

**Android method:** `TabbedCustomTilesHolder.sendCTAClickedEvent(...)` — `TabbedCustomTilesHolder.kt:75`, dispatch line 118.
**Event constant:** `AnalyticsEvents.CTA_BUTTON_CLICKED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- Builds `section = ctaButton.tracking + "-" + position`.
- For homepage: `OrderAttributionHelper.addAttributionData(null, ctaButton.tracking, position, section, null, section, null, null, null, null, CTA)`.
- For LP: equivalent flow + `LPAttributionHelper.addLPAttributionData(...)`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `action` | `ACTION` | String | conditional | — | `ctaButton.actionType` |
| `action_uri` | `ACTION_URI` | String | conditional | — | `ctaButton.actionUri` |
| `tile_grid_id` | `TILE_GRID_ID` | String | conditional | — | `ctaButton.actionValue` |
| `cta_button_name` | `CTA_BUTTON_NAME` | String | conditional | — | `ctaButton.title` |
| `position` | `POSITION` | Int | conditional | — | only if `position >= 0` |
| `selected_sortbar` | `SELECTED_SCROLLED_SORT_BAR` | String | conditional | — | only if `extraData.sortBar` non-empty |
| `selected_sortbar_group` | `SELECTED_SCROLLED_SORTBAR_GROUP` | String | conditional | — | only if `extraData.sortBarGroup` non-empty |
| `selected_sort_by` | `SELECTED_SCROLLED_SORT_BY` | String | always | — | `extraData.isSystemSelectedSort` |

**Quirks:** `position >= 0` guard (not `> 0`). LP slice_id uses `(position + 1)` while attribution position is raw.

### `feature_card_viewed`

**Android method:** `logFeatureCardViewedEvent(featureType, title)` — `AnalyticsHelper.java:1164`
**Event constant:** `AnalyticsEvents.FEATURE_CARD_VIEWED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `feature_type` | `FEATURE_TYPE` | String | always | `"none"` | Empty → `AnalyticsDefaults.NONE` |
| `title` | `TITLE` | String | always | `"none"` | Empty → `AnalyticsDefaults.NONE` |

### `lp_tile_impression`

**Android method:** Same dispatcher as `tile_impression`; variant chosen by `fromHomePage` param.
**Event constant:** `AnalyticsEvents.LP_TILE_IMPRESSION`
**logEvent flags:** `attribution=false`, `universal=false`

**Payload:** Identical structure to `tile_impression`. `fillHPAttributionData` switches keys to LP-prefixed:

| Property key (wire) | Notes |
|---|---|
| `lp_funnel_row` | position string |
| `lp_funnel_tile` | CT-prefixed |
| `lp_banner_name` | |
| `lp_property_type` | |
| `lp_slice_id` | |
| `lp_id` | `extraData.landingPageId` |
| `lp_name` | `extraData.landingPageName` |

Plus a snapshot of `OrderAttributionHelper.getOrderAttributionSegmentParams()` from `attributeSnapshot` (LP-only). **No `funnel="Discover"` key.**

### `lp_banner_impression`

**Android method:** Same as `banner_impression`; routes to `LP_BANNER_IMPRESSION` when `extraData?.fromHomePage != true`.
**Event constant:** `AnalyticsEvents.LP_BANNER_IMPRESSION`
**logEvent flags:** `attribution=false`, `universal=false`

**Payload:** Identical to `banner_impression` but LP-prefixed funnel keys + `lp_id` + `lp_name`. No `funnel="Discover"`.

### `lp_tile_clicked`

**Android method:** Same as `tile_clicked`. Routes to `LP_TILE_CLICKED` when `fromHomePage != true`.
**Event constant:** `AnalyticsEvents.LP_TILE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=false`

**Payload:** Identical fields to `tile_clicked`. LP attribution params merged via `LPAttributionHelper.getLPAttributionSegmentData()`.

### `lp_carousel_scrolled`

**Android method:** Same dispatcher as `carousel_scrolled`.
**Event constant:** `AnalyticsEvents.LP_CAROUSEL_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=false`

**Payload:** Same as `carousel_scrolled` but LP-prefixed funnel keys + `lp_id` + `lp_name`. No `funnel="Discover"`.

### `tab_clicked`

**Android method:** `HomeTrackAnalyticManager.sendTabClickedEvent(...)` — `HomeTrackAnalyticManager.kt:529`, dispatch line 565.
**Event constant:** `AnalyticsEvents.TAB_CLICKED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- `section = "${tabItem.tracking}-${position + 1}"`.
- Homepage: `OrderAttributionHelper.addAttributionData(...)`.
- LP: equivalent + `LPAttributionHelper.addLPAttributionData(Util.getSliceId(1, position + 1), ...)`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `tab_id` | `TAB_ID` | Int | conditional | — | `tabItem.id` |
| `tab_name` | `TAB_NAME` | String | conditional | — | `tabItem.title` |
| `type` | `TYPE` | String | conditional | — | `tabItem.type` |
| `position` | `POSITION` | Int | conditional | — | raw position (0-indexed) |
| `selected_sortbar` | `SELECTED_SCROLLED_SORT_BAR` | String | always | `""` | |
| `sortbar` | `SORTBAR` | String | always | `""` | |

**Quirks:** `position` sent raw (0-indexed) but attribution `section` uses `position + 1`.

### `tab_clicked_nav_carousel`

**Android method:** `TabbedPageAnalyticsHelper.logTabClickedEvent(directedTo: TabbedPageTabType)` — `TabbedPageAnalyticsHelper.kt:25`.
**Event constant:** `components.AnalyticsEvents.TAB_CLICKED_NAV_CAROUSEL`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `directed_to` | `TabbedPageProperties.DIRECTED_TO` | enum→String | always | — | `LP` / `BLOG` / `OTHER` (toString) |

### `tabbed_page_container_viewed`

**Android method:** `TabbedPageAnalyticsHelper.logTabbedPageContainerViewedEvent(source: TabbedPageSource)` — `TabbedPageAnalyticsHelper.kt:10`.
**Event constant:** `components.AnalyticsEvents.TAB_PAGE_CONTAINER_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `source` | `TabbedPageProperties.SOURCE` | enum→String | always | — | `HS` / `OTHERS` (toString) |

### `continue_browsing_loaded`

**Android method:** `ComponentLoadedEventUseCase.invoke(homePageResponse)` — `ComponentLoadedEventUseCase.kt:14`.
**Event constant:** `AnalyticsEvents.CONTINUE_BROWSING_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Runs on `Dispatchers.IO`. Fires ONLY for first `TYPE_CONTINUE_BROWSING` component found.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `total_slices_in_continue_browsing_widget` | `TOTAL_SLICES_IN_CONTINUE_BROWSING_WIDGET` | Int | always | — | items count |

### `continue_browsing_viewed`

**Android method:** `ComponentViewedScrollListener.checkAndSendEvent(component)` — `ComponentViewedScrollListener.kt:41`.
**Event constant:** `AnalyticsEvents.CONTINUE_BROWSING_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Listener returns `true` after firing — breaks iteration; fires once per scroll-idle pass.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `total_slices_in_continue_browsing_widget` | `TOTAL_SLICES_IN_CONTINUE_BROWSING_WIDGET` | Int | always | `0` | `items?.size.zeroIfNull()` |

### `continue_browsing_clicked`

**Android method:** `CollectionsAdapter.onItemClick(...)` — `CollectionsAdapter.kt:495`.
**Event constant:** `AnalyticsEvents.CONTINUE_BROWSING_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- `OrderAttributionHelper.addRedirectedFromContinueBrowsingWidget(true)` BEFORE firing (propagates to downstream events).
- Continues to `TileAction.parseAction(...)` after firing.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `total_slices_in_continue_browsing_widget` | `TOTAL_SLICES_IN_CONTINUE_BROWSING_WIDGET` | Int | conditional | — | from extras `TOTAL_TILES` |
| `tile_position` | `TILE_POSITION` | Int | always | — | `itemPosition + 1` (1-indexed) |
| `tile_name` | `TILE_NAME` | String | conditional | — | from extras |

### `doorway_loaded`

**Android method:** `DoorwayAttributionHelper.logDoorwaysEvent(doorWaysCarousel, isViewedEvent=false, plpId, productId, name)` — `DoorwayAttributionHelper.kt:78`.
**Event constant:** `AnalyticsEvents.DOORWAYS_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | Int | conditional | — | only if `productId != 0` |
| `doorway_id` | `DOORWAYS_ID` | Int | conditional | — | productId when present, else plpId |
| `product_listing_id` | `PRODUCT_LISTING_ID` | Int | conditional | — | only if `plpId != 0` |
| `doorway_name` | `DOORWAYS_NAME` | String | always | — | |
| `doorway_slice_count` | `DOORWAYS_SLICES_COUNT` | Int | always | `0` | tiles count |

### `doorway_viewed`

**Android method:** Same as `doorway_loaded` with `isViewedEvent=true`.
**Event constant:** `AnalyticsEvents.DOORWAYS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Payload:** Identical to `doorway_loaded`.

### `doorway_scrolled`

**Android method:** `DoorwayAttributionHelper.logDoorwaysScrollEvent(...)` — `DoorwayAttributionHelper.kt:96`.
**Event constant:** `AnalyticsEvents.DOORWAYS_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | Int | conditional | — | only if `productId != 0` |
| `doorway_id` | `DOORWAYS_ID` | Int | conditional | — | productId else plpId |
| `product_listing_id` | `PRODUCT_LISTING_ID` | Int | conditional | — | only if `plpId != 0` |
| `doorway_name` | `DOORWAYS_NAME` | String | always | — | |
| `doorway_slice_count` | `DOORWAYS_SLICES_COUNT` | Int | always | `0` | |
| `doorway_scroll_count` | `DOORWAYS_SCROLL_COUNT` | Int | always | — | `position + 1` (1-indexed) |
| `collection_name` | `COLLECTION_NAME` | String | conditional | — | |
| `collection_id` | `COLLECTION_ID` | Int | conditional | — | |
| `dominant_pt` | `DOMINANT_PT` | String | conditional | — | `TextUtils.join(",", dominantId)` — comma-joined |

### `doorway_clicked`

**Android method:** `DoorwayAttributionHelper.logDoorwaysClickedEvent(doorwayData, id, title, fromPdp)` — `DoorwayAttributionHelper.kt:59`.
**Event constant:** `AnalyticsEvents.DOORWAYS_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | Int | conditional | — | only when `fromPdp=true` |
| `product_listing_id` | `PRODUCT_LISTING_ID` | Int | conditional | — | only when `fromPdp=false` |
| `doorway_id` | `DOORWAYS_ID` | Int | always | — | the `id` arg |
| `doorway_name` | `DOORWAYS_NAME` | String | always | — | `title` arg |
| `doorway_slice_count` | `DOORWAYS_SLICES_COUNT` | Int | always | — | `doorWaySlices` |
| `doorway_slice_id` | `DOORWAYS_SLICE_ID` | Int | always | — | 0-indexed position |
| `collection_name` | `COLLECTION_NAME` | String | always | — | |
| `collection_id` | `COLLECTION_ID` | Int | always | — | |
| `dominant_pt` | `DOMINANT_PT` | String | always | — | comma-joined |

**Quirks:** `doorway_slice_id` is 0-indexed (NOT incremented). Mutually exclusive: `product_id` vs `product_listing_id` based on `fromPdp`.

---


## Module: PDP / Categories

### `product_viewed`

**Android method:** `logProductViewAnalyticsEvent(...)` — `hsapp/src/main/java/in/hopscotch/android/activity/ProductDetailPageActivityNew.java:3275` (legacy) AND `sendProductViewedEvent()` — `hspdp/src/main/java/in/hopscotch/android/hspdp/analytics/PDPAnalytics.kt:113` (modern rewrite)
**Event constant:** `AnalyticsEvents.PRODUCT_VIEWED` (hsapp) / `AnalyticsEvents.PRODUCT_VIEWED` (components module — both resolve to `"product_viewed"`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.PRODUCT)` BEFORE building properties (legacy). Adds `FIRST_SCREEN` to common properties via `AnalyticsCommonPropertiesHelper` when `Util.addFirstScreenProperty()` is true. Parallel: `logFacebookContentViewedEvent()` is called from `setUpProductContent` (line 2302) — separate FB ContentView event (not via Segment). `setupTransitionImage` and `triggerProductViewEvent` are the entry points.

**Payload (legacy ProductDetailPageActivityNew — union of all branches):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_section` | `FROM_SECTION` | String | No | — | From intent `IntentHelper.FROM_SECTION` |
| `from_screen` | `FROM_SCREEN` | String | No | — | From intent `IntentHelper.FROM_SCREEN` |
| `photo_id` | `PHOTO_ID` | int | No | — | If intent contains non-zero `IntentHelper.PHOTO_ID` |
| `from_collection` | `FROM_COLLECTION` | bool | No | — | From intent `IntentHelper.FROM_COLLECTION` if true |
| `collection_name` | `COLLECTION_NAME` | String | No | — | From intent extras |
| `product_id` | `PRODUCT_ID` | String | Yes | — | `productDetailResponse.id` |
| `sku` | `SKU` | List<String> | Yes | — | `getCompleteSku()` — list of skuIds from simpleSkus |
| `name` | `NAME` | String | No | — | `mSku.productName` |
| `brand` | `BRAND` | String | No | — | `productDetailResponse.brandName` |
| `price` | `PRICE` | float | Yes | — | `mSku.retailPrice` |
| `mrp` | `MRP` | float | Yes | — | `mSku.regularPrice` |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `mSku.discount + "%"` (string with %) |
| `category` | `CATEGORY` | String | No | — | |
| `subcategory` | `SUB_CATEGORY` | String | No | — | |
| `product_type` | `PRODUCT_TYPE` | String | No | — | |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | No | — | NOTE: wire key from constant `SUBPRODUCT_TYPE = "subproduct_type"` (Android hsapp) — also exists as `SUB_PRODUCT_TYPE` in common module |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` if `mSku.isPresale == 1` |
| `sale` | `SALE` | String | No | — | `"Yes"` if `mSku.onSale == 1` |
| `gender` | `GENDER` | String | No | — | `mSku.gender` |
| `colour` | `COLOUR` | String | No | — | `getColourOrSize("colour")` |
| `low_inventory` | `LOW_INVENTORY` | String | No | — | `"Yes"` if `qtyCounter <= 3 && > 0`; `"Sold out"` if `soldOut` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | Format `yyyy-MM-dd hh:mm:ss` from `mSku.deliveryDate` |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | `mSku.maxDeliveryDays` |
| `from_age` | `FROM_AGE` | int | Yes | — | `mSku.fromAge` |
| `to_age` | `TO_AGE` | int | Yes | — | `mSku.toAge` |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | `localAddFromDetails` |
| `preorder_info` | `PRE_ORDER_INFO` | String | No | — | `"Yes"` if `preorderInfo` true |
| `sizes` | `SIZES` | int | No | — | `simpleSkus.size()` (count) |
| `from_feed_size` | `FROM_FEED_SIZE` | int | No | — | If intent contains non-zero `IntentHelper.FROM_FEED_SIZE` |
| `position` | `POSITION` | int | No | — | If intent contains non-zero `IntentHelper.POSITION` |
| `hbt` | `HBT` | String | No | — | From SKU `hbt` attr (via `addAttrsFromSelectedSku`) |
| `taste` | `TASTE` | String | No | — | From SKU `taste` attr |
| `style` | `STYLE` | String | No | — | |
| `season` | `SEASON` | String | No | — | |
| `pattern` | `PATTERN` | String | No | — | |
| `character` | `CHARACTER` | String | No | — | |
| `weave` | `WEAVE` | String | No | — | |
| `merch_type` | `MERCH_TYPE` | String | No | — | `mSku.merchType` |
| `v_country` | `COUNTRY` | String | No | — | `productDetailResponse.country` (key is `v_country`) |
| `is_notifiable` | `IS_NOTIFIABLE` | String | Yes | `"No"` | `"Yes"` if sold out and `canWishList == 1` |
| `image_count` | `IMAGE_COUNT` | int | No | — | If `imageCount > 0` |
| `default_edd` | `DEFAULT_EDD` | int | Yes | — | `productDetailResponse.maxDeliveryDays` |
| `edd` | `EDD` | String | No | — | `"Different for sizes"` localized string if `isEddDifferentForSKUs` |
| `return` | `RETURN` | String | No | — | Either `diff_for_sizes` string or `simpleSkus[0].deliveryMessage.msg` |
| `best_price` | `BEST_PRICE` | String | No | — | `mPromoDetailResponse.bestPrice` when `addPromoProperties` and cardCount > 0 |
| `promo_code` | `PROMO_CODE` | String | No | — | `mPromoDetailResponse.bestPricePromoCode` |
| `merch_promo` | `MERCH_PROMO` | String | No | — | `"Yes"`/`"No"` from `mPromoDetailResponse.isMerchRule` |
| `offer_card_count` | `OFFER_CARD_COUNT` | int | No | — | `mPromoDetailResponse.cardCount` |
| `click_type` | `CLICK_TYPE` | String | Yes | `"none"` | From `getClickType()` — `ClickType.*` strings (Search CTR, Reco CTR, etc.) or `"none"` |
| `source_tile_type` | `SOURCE_TILE_TYPE` | String | Yes | `"Other"` | `sourceTileType` — `"XL"`, `"Normal"`, or `"Other"` |
| `from_pincode` | `FROM_PINCODE` | String | Yes | `"standard"` | `mProductDetailResponse.pinCode` or `"standard"` |
| `is_pid_aplus` | `IS_PID_APLUS` | String | Yes | `"No"` | `"Yes"` if A+ content present |
| `aplus_virtual_group_name` | `APLUS_VIRTUAL_GROUP_NAME` | String | No | — | `content.getName()` |
| `aplus_usp_list` | `APLUS_USP_LIST` | List<String> | No | — | List of `name` from each content item (NOT comma-flattened in product_viewed — `toFlatten=false`) |
| `aplus_content_type` | `APLUS_CONTENT_TYPE` | String | No | — | Underscore-joined mime types: `image_gif_video` |
| `redirected_from_colour_widget` | `REDIRECTED_FROM_SHOP_THE_LOOK` (in `common`) | String | Yes | — | From intent `REDIRECTED_FROM_SHOP_THE_LOOK` boolean → `"Yes"`/`"No"` via `toYesNoString()` — wire key here is `redirected_from_shop_the_look` |
| `tabbed_page_container_name` | `TABBED_PAGE_CONTAINER_NAME` | String | No | — | Tab page metadata via `addTabPageProperties()` |
| `tabbed_page_container_id` | `TABBED_PAGE_CONTAINER_ID` | String | No | — | |
| `tab_name` | `TAB_NAME` | String | No | — | |
| `tab_position` | `TAB_POSITION` | String | No | — | |
| `image_url` | `IMAGE_URL` | String | No | — | `imgurls[0].imgUrlFull` |
| `doorway_id` | `DOORWAYS_ID` | String | No | — | Via `DoorwayAttributionHelper.addDoorwayProperties(intent)` |
| `doorway_name` | `DOORWAYS_NAME` | String | No | — | |
| `doorway_slice_count` | `DOORWAYS_SLICES_COUNT` | int | No | — | |
| `doorway_slice_id` | `DOORWAYS_SLICE_ID` | String | No | — | |
| `collection_name` | `COLLECTION_NAME` | String | No | — | Doorway-sourced |
| `collection_id` | `COLLECTION_ID` | String | No | — | |
| `dominant_pt` | `DOMINANT_PT` | String | No | — | |
| `redirected_from_doorway` | `REDIRECTED_FROM_DOORWAY` | bool | No | — | `true` when doorway data present |

**Modern PDPAnalytics.kt (`hspdp/.../PDPAnalytics.kt:113`) emits a tighter subset:**
- `from_screen`, `from_page`, `from_feed_size`, `position`, `source_tile_type`, `sizes`, `name`, `sale` (boolean not "Yes"/"No"!), `image_count`, `sku` (List), `delivery_days`, `from_pincode` (default `"standard"`), `add_from_details`, `redirected_from_shop_the_look` ("Yes"/"No"), `coupon_applicable` (Int — `promos.trackingMeta.applicableCount`), product attributes (extras + brand-meta from `pdpPageProperties()` — `product_id`, `image_url`, `category`, `subcategory`, `product_type`, `subproduct_type`, `country_of_origin`, `brand`, `gender`, `from_age`, `to_age`, `mrp`, `price`, `discount_percentage`), A+ properties (`is_pid_aplus` "Yes"/"No", `aplus_virtual_group_name`, `aplus_usp_list` as `toString()` of List, `aplus_content_type` underscore-joined), doorway properties, tab-page properties, color tracking meta (`style_code`, `count_of_pids_in_style_code`, `redirected_from_colour_widget`).

**Quirks:**
- `discount_percentage` in legacy is a STRING like `"60%"`, but in modern PDPAnalytics.kt it is a numeric double via `toNumericDouble()`.
- `sale`/`preorder` in legacy are `"Yes"` strings; in modern they are raw booleans (`onSale ?: false`).
- `aplus_usp_list` in `product_viewed` is a `List<String>` (legacy: `toFlatten=false`), but is comma-joined string in `aplus_content_viewed` / `product_added_to_cart` callsites.
- Legacy wire-key `subproduct_type` (no underscore between sub and product) — see hsapp `AnalyticsProperties.SUBPRODUCT_TYPE = "subproduct_type"`.
- Modern PDP uses `country_of_origin` key (common module constant); legacy uses `v_country` (hsapp).
- The Universal Property bag is auto-added when `addUniversalProperties=true` — common props from `AnalyticsCommonPropertiesHelper`.
- `timestamp` (ISO8601), `afUserId`, `cleverTapId`, `session_id` (Amplitude integration) and the `universal` map are appended automatically by `AnalyticsHelper.logEvent` AFTER the per-event payload.

---

### `Product viewed`

**Android constant:** `AnalyticsEvents.CLEVER_TAP_PRODUCT_VIEWED = "Product viewed"` — defined at `hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsEvents.java:130` but **NOT currently fired** in either the legacy `ProductDetailPageActivityNew.java` or the modern `hspdp/PDPAnalytics.kt`. No `logEvent(AnalyticsEvents.CLEVER_TAP_PRODUCT_VIEWED, ...)` call exists anywhere in the Android codebase (verified via grep). Historically this was a CleverTap-friendly mirror of `product_viewed`; the legacy custom dispatch appears to have been removed.

**Payload:** N/A — event constant retained but unwired. If Flutter parity is required, mirror the `product_viewed` payload verbatim, but treat this as a no-op on Android until CleverTap routing is restored.

---

### `product_expanded`

**Android method:** `logProductExpandedAnalyticsEvent()` — `ProductDetailPageActivityNew.java:1656`
**Event constant:** `AnalyticsEvents.PRODUCT_EXPANDED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Built by `getEventPropertiesForBottomButton()` (line 1804).

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `sku` | `SKU` | String | Yes | — | Single SKU (not List) |
| `price` | `PRICE` | float | Yes | — | `mSku.retailPrice` |
| `mrp` | `MRP` | float | Yes | — | `mSku.regularPrice` |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `mSku.discount + "%"` |
| `quantity` | `QUANTITY` | int | Yes | — | `mQty` |
| `subtotal` | `SUBTOTAL` | float | Yes | — | `mSku.retailPrice * mQty` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `name` | `NAME` | String | No | — | |
| `category`, `subcategory`, `product_type`, `subproduct_type`, `brand` | — | String | No | — | |
| `gender` | `GENDER` | String | No | — | |
| `size_selection` | `SIZE_SELECTION` | String | No | — | `fromSelection` |
| `from_age`, `to_age` | — | int | Yes | — | |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` |
| `sale` | `SALE` | String | No | — | `"Yes"` |
| `size` | `SIZE` | String | Yes | — | From `getColourOrSize(SIZE)` |
| `colour` | `COLOUR` | String | Yes | — | From `getColourOrSize(COLOUR)` |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |
| `hbt`, `taste`, `style`, `season`, `pattern`, `character`, `weave` | — | String | No | — | From `addAttrsFromSelectedSku` |
| `merch_type` | `MERCH_TYPE` | String | No | — | |
| `v_country` | `COUNTRY` | String | No | — | |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | Hardcoded |
| `atc_user` | `ATC_USER` | String | No | — | `AppRecordData.getATCUserType()` |
| `image_count` | `IMAGE_COUNT` | int | No | — | If > 0 |
| `image_url` | `IMAGE_URL` | String | No | — | First imgurl |

---

### `product_view_more_clicked`

**Android method:** `logViewMoreAnalyticsEvent()` — `ProductDetailPageActivityNew.java:3565`
**Event constant:** `AnalyticsEvents.PRODUCT_VIEW_MORE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Identical to `product_expanded` — same `getEventPropertiesForBottomButton()` payload.

---

### `product_share_clicked`

**Android method:** `logProductShareClickedEvent(String shareLocation)` — `ProductDetailPageActivityNew.java:2119` (legacy) / `sendProductShareEvent()` — `PDPAnalytics.kt:180` (modern)
**Event constant:** `AnalyticsEvents.PRODUCT_SHARE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload (legacy):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | |
| `from_location` | `FROM_LOCATION` | String | Yes | — | `shareLocation` param |
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `category` | `CATEGORY` | String | No | — | |
| `subcategory` | `SUB_CATEGORY` | String | No | — | |
| `product_type` | `PRODUCT_TYPE` | String | No | — | |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | No | — | |

**Modern PDPAnalytics:** payload is `pdpPageProperties()` (product/category/brand/A+/pricing meta).

---

### `select_size_clicked`

**Android method:** `sendSizeFilterSelectedData(boolean isFromAddToCart, boolean isFromSizeChips)` — `ProductDetailPageActivityNew.java:1407`
**Event constant:** `AnalyticsEvents.SELECT_SIZE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `price` | `PRICE` | float | Yes | — | |
| `mrp` | `MRP` | float | Yes | — | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `mSku.discount + "%"` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `name` | `NAME` | String | No | — | |
| `category`, `subcategory`, `product_type`, `subproduct_type`, `brand` | — | String | No | — | |
| `gender` | `GENDER` | String | No | — | |
| `colour` | `COLOUR` | String | Yes | — | |
| `hbt`, `taste`, `style`, `season`, `pattern`, `character`, `weave` | — | String | No | — | |
| `merch_type` | `MERCH_TYPE` | String | No | — | |
| `is_notifiable` | `IS_NOTIFIABLE` | String | Yes | `"No"` | |
| `default_edd` | `DEFAULT_EDD` | int | Yes | — | |
| `v_country` | `COUNTRY` | String | No | — | |
| `from_pincode` | `FROM_PINCODE` | String | Yes | `"standard"` | |
| `from_location` | `FROM_LOCATION` | String | No | — | `"Add to cart button"` / `"Size chips selection"` / diff-EDD/diff-return nudge strings |

---

### `size_selected`

**Android method:** `sendSizeSelected(fromLocation: String, selectedSku: Sku?)` — `hspdp/.../PDPAnalytics.kt:192` (components-module event — no legacy hsapp emitter)
**Event constant:** `AnalyticsEvents.SIZE_SELECTED` (components)
**logEvent flags:** `attribution=true`, `universal=true` (via `send()` defaults)
**Side effects:** Dedupes — only fires when `selectedSku.skuId != currentSku.skuId`. Updates `currentSku` regardless.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_location` | `FROM_LOCATION` | String | Yes | — | Passed param |
| `sku` | `SKU` | String | Yes | — | `selectedSku.skuId` (single, not List) |
| `sku_size` | `SKU_SIZE` | String | Yes | — | `selectedSku.size` |
| (all `pdpPageProperties()` keys) | — | — | — | — | `product_id`, `image_url`, `category`, `subcategory`, `product_type`, `subproduct_type`, `country_of_origin`, `brand`, `gender`, `from_age`, `to_age`, `mrp`, `price`, `discount_percentage` + extras + A+ props |

---

### `size_chart_viewed`

**Android method:** `logSizeChartViewedEvent()` — `hsapp/src/main/java/in/hopscotch/android/activity/SizeChartActivity.java:85` AND `hsapp/.../components/stylecarousel/SizeChartFragment.kt:169`
**Event constant:** `AnalyticsEvents.SIZE_CHART_VIEWED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Adds `FIRST_SCREEN` to common properties via `AnalyticsCommonPropertiesHelper` when `Util.addFirstScreenProperty()` is true.

**Payload (SizeChartActivity):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | int | Yes | — | `mProductId` |
| `from_screen` | `FROM_SCREEN` | String | No | — | Intent `FROM_SCREEN` |
| `from_location` | `FROM_LOCATION` | String | No | — | Intent `FROM_LOCATION` |
| `name` | `NAME` | String | No | — | Intent `NAME` (product name) |
| `brand` | `BRAND` | String | No | — | |
| `category`, `subcategory`, `product_type`, `subproduct_type` | — | String | No | — | |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` if presale |
| `gender` | `GENDER` | String | No | — | From first SKU |
| `size` | `SIZE` | List<String> | No | — | All sizes from all SKUs (uses key `size`, not `sizes`) |
| `age` | `AGE` | List<String> | No | — | Single-element list `[fromAge - toAge]` |

---

### `size_chart_clicked`

**Android method:** `sendEventSizeChartCLicked()` — `hspdp/.../PDPAnalytics.kt:217`
**Event constant:** `AnalyticsEvents.SIZE_CHART_CLICKED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only (product/category/brand/pricing/A+ meta — no `from_location` set; callers in legacy launch SizeChartActivity directly without firing this).

---

### `shipping_info_viewed`

**Android method:** `logShippingInfoViewedEvent(scope, fromLocation)` — `hscart/src/main/java/in/hopscotch/android/hscart/ui/helper/CartAnalytics.kt:54`
**Event constant:** `AnalyticsEvents.SHIPPING_INFO_VIEWED` (components)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_location` | `FROM_LOCATION` | String | No | — | Param |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Cart"` | `FromScreens.SHOPPING_CART` hardcoded |

**Quirks:** Currently emitted only from cart (shipping info icon/bar). Despite being in the spec PDP list, there is **no PDP emitter on Android** — neither legacy nor `hspdp/PDPAnalytics.kt` fires this. If Flutter PDP fires it, that is a new addition.

---

### `PDP_reco_loaded`

**Android method:** `logPDPRecoLoadedEvent(String fromScreen, String fromLocation, String recoType, String productId, String recoFilter, int size)` — `hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsHelper.java:1106`
**Event constant:** `AnalyticsEvents.PDP_RECO_LOADED` (uppercase `PDP_` preserved on the wire)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"none"` | |
| `from_location` | `FROM_LOCATION` | String | Yes | `"none"` | |
| `reco_type` | `RECO_TYPE` | String | Yes | `"none"` | |
| `product_id` | `PRODUCT_ID` | String | Yes | `"none"` | |
| `attribute_count` | `ATTRIBUTE_COUNT` | int | Yes | — | `size` param (NB: key is `attribute_count`, not `feed_size`) |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |

---

### `pdp_attributes_loaded`

**Android method:** `logPDPAttributeLoadedEvent(String fromScreen, String fromLocation, String recoType, String productId, String recoFilter, int size)` — `AnalyticsHelper.java:1117`
**Event constant:** `AnalyticsEvents.PDP_ATTRIBUTES_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same shape as `PDP_reco_loaded` — `from_screen`, `from_location`, `reco_type`, `attribute_count`, `product_id`, `reco_filter` (all defaulted to `"none"` when empty).

---

### `pdp_images_scrolled`

**Android method:** `sendPdpImagesScrolledEvent(uniqueScrollCount: Int)` — `hspdp/.../PDPAnalytics.kt:169` (private; called from `onStop()`)
**Event constant:** `AnalyticsEvents.PDP_IMAGES_SCROLLED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupe — only fires if `uniqueScrollCount > 1 AND > pdpImagesMaxViewCount`. Updates `pdpImagesMaxViewCount`. Fired on activity `onStop`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all `pdpPageProperties()` keys) | — | — | — | — | |
| `unique_images_scrolled` | `UNIQUE_IMAGES_SCROLLED` | int | Yes | — | Max distinct image positions viewed during session |

---

### `xl_product_card_scrolled`

**Android method:** `logXLProductCardScrolled(position: Int?, direction: String?)` — `hsplp/src/main/java/in/hopscotch/android/hsplp/analytics/PLPAnalytics.kt:514` AND `onXLTileScrolled(...)` — `hsapp/.../activity/ProductListPageActivity.java:4102`
**Event constant:** `AnalyticsEvents.XL_PRODUCT_CARD_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all `addCommonProductListProperties()` keys / `getCommonPLPProperties()`) | — | — | — | — | PLP context (plp_name, plp_type, boutique meta, sort, filters) |
| `card_index` | `CARD_INDEX` | int | Yes | — | Position of the XL card scrolled |
| `swipe_direction` | `SWIPE_DIRECTION` | String | Yes | — | `"left"` / `"right"` |

**Quirks:** Emitted on PLP, NOT on PDP. The spec lists it under PDP — verify caller intent; on Android this is fired from the PLP when an XL tile inside a feed is scrolled.

---

### `aplus_content_viewed`

**Android method:** `logAPlusContentViewed()` — `ProductDetailPageActivityNew.java:2040` (legacy) / `sendEventAPlusContentViewed()` — `PDPAnalytics.kt:326` (modern)
**Event constant:** `AnalyticsEvents.APLUS_CONTENT_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload (legacy):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `is_pid_aplus` | `IS_PID_APLUS` | String | Yes | `"No"` | `"Yes"` if A+ content present |
| `aplus_virtual_group_name` | `APLUS_VIRTUAL_GROUP_NAME` | String | No | — | `content.getName()` |
| `aplus_usp_list` | `APLUS_USP_LIST` | List<String> | No | — | List of USP names — passed with `toFlatten=false` in this event (so list, NOT comma-string) |
| `aplus_content_type` | `APLUS_CONTENT_TYPE` | String | No | — | Underscore-joined mime types (`image`, `gif`, `video`) |
| `sku` | `SKU` | List<String> | Yes | — | `getCompleteSku()` |
| `name` | `NAME` | String | No | — | |
| `brand` | `BRAND` | String | No | — | |
| `price`, `mrp`, `discount_percentage` | — | float/String | Yes | — | `discount_percentage` is `"xx%"` string |
| `category`, `subcategory`, `product_type`, `subproduct_type` | — | String | No | — | |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` |
| `sale` | `SALE` | String | No | — | `"Yes"` |
| `gender` | `GENDER` | String | No | — | |
| `colour` | `COLOUR` | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `from_age`, `to_age` | — | int | Yes | — | |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |

**Quirks:**
- **`aplus_usp_list`**: In `logProductViewAnalyticsEvent` and `logAPlusContentViewed`, `toFlatten=false` → emitted as `List<String>`. In `logAddToCartAnalyticsEvent`, the modern PDP passes `uspNames?.joinToString(",")` → emitted as comma-string. **The spec calls out that on Flutter `aplus_usp_list` should be split by `,` into a `List<String>` — this matches the cart/ATC path, not the view/PDP path. Confirm before mirroring.**
- Modern PDPAnalytics emits `aplus_usp_list` as `uspNames.toString()` (Kotlin List `toString()` → `"[a, b, c]"`) when fired via `pdpPageProperties()` — this is **divergent from legacy** and likely a bug. Verify in Segment debugger before mirroring.

---

### `product_content_expanded`

**Android method:** `sendProductContentExpanded()` — `PDPAnalytics.kt:361` (private; called from `handlePDPContentSheetState` when `BottomSheetBehavior.STATE_EXPANDED`)
**Event constant:** `AnalyticsEvents.PRODUCT_CONTENT_EXPANDED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_content_collapsed`

**Android method:** `sendProductContentCollapsed()` — `PDPAnalytics.kt:365` (private; called from `handlePDPContentSheetState` when `STATE_COLLAPSED` AND `initialTop != null`)
**Event constant:** `AnalyticsEvents.PRODUCT_CONTENT_COLLAPSED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None — guards against firing on the initial collapsed state by requiring non-null `initialTop`.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_expanded`

**Android method:** `sendProductDetailsExpanded()` — `PDPAnalytics.kt:221`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_EXPANDED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_collapsed`

**Android method:** `sendProductDetailsCollapsed()` — `PDPAnalytics.kt:225`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_COLLAPSED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_tab_clicked`

**Android method:** `sendEventProductDetailsTabClicked(tabPosition: Int?)` — `PDPAnalytics.kt:229`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_TAB_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Returns early if `tabPosition == null` or no product.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `tab_name` | `TAB_NAME` | String | Yes | — | `product.details[tabPosition].tabName` |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `product_attribute_tab_clicked`

**Android method:** `logProductAttributeTabClickedEvent(ProductAttributes attribute)` — `ProductDetailPageActivityNew.java:2101`
**Event constant:** `AnalyticsEvents.PRODUCT_ATTRIBUTE_TAB_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | `mProductId` |
| `from_location` | `FROM_LOCATION` | String | Yes | `"Product Attribute"` | Hardcoded |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | Hardcoded |
| `product_type` | `PRODUCT_TYPE` | String | No | — | |
| `gender` | `GENDER` | String | No | — | |
| `product_attribute_name` | `PRODUCT_ATTRIBUTE_NAME` | String | No | — | `attribute.getAttributeName()` |
| `product_attribute_value` | `PRODUCT_ATTRIBUTE_VALUE` | String | No | — | `attribute.getAttributeValue()` |

---

### `shop_the_look_clicked`

**Android method:** `logStyleCarouselClickedEvent(ExtraData extraData, int position)` — `hsapp/src/main/java/in/hopscotch/android/viewholders/homepage/StyleCarouselViewHolder.kt:66`
**Event constant:** `AnalyticsEvents.SHOP_THE_LOOK_CLICKED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `banner_name` | `BANNER_NAME` (or `LPAttributionParams.BANNER_NAME`) | int | Yes | — | `position + 1` — wire key is `banner_name` but the value is a numeric position, not a string name |

**Quirks:** The constant `BANNER_NAME` resolves to `"banner_name"` for both homepage and landing-page variants; the value is just an index. This is fired by the homepage StyleCarousel, NOT the PDP shop-the-look entry — verify with iOS source-of-truth if mirroring on PDP.

---

### `color_widget_expanded`

**Android method:** `sendEventColorWidgetExpanded()` — `PDPAnalytics.kt:142`
**Event constant:** `AnalyticsEvents.COLOR_WIDGET_EXPANDED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupe via `sentColorEventExpandedEvent` flag — only fires once per PDP session (until `refreshPID()` resets it on a new PID load).

**Payload:** `pdpPageProperties()` + `getProductAttributes()` (product attrs) + `addDoorwayProperties()` + `addColorTrackingMeta()` (style_code, count_of_pids_in_style_code, redirected_from_colour_widget).

---

### `new_color_selected`

**Android method:** `sendEventNewColorSelected(newPid: String?)` — `PDPAnalytics.kt:157`
**Event constant:** `AnalyticsEvents.NEW_COLOR_SELECTED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all `pdpPageProperties()` + product-attrs + doorway + color tracking keys) | — | — | — | — | |
| `new_product_id_selected` | `NEW_PRODUCT_ID_SELECTED` | String | Yes | — | The PID being switched to |

---

### `parent_collection_viewed`

**Android method:** `sendEventParentCollectionViewed(collectionId: String?, collectionName: String?)` — `PDPAnalytics.kt:267`
**Event constant:** `AnalyticsEvents.PARENT_COLLECTION_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `collection_id` | `COLLECTION_ID` | String | No | — | |
| `collection_name` | `COLLECTION_NAME` | String | No | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `parent_collection_clicked`

**Android method:** `sendEventParentCollectionClicked(collectionId: String?, collectionName: String?)` — `PDPAnalytics.kt:276`
**Event constant:** `AnalyticsEvents.PARENT_COLLECTION_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same as `parent_collection_viewed` (`collection_id`, `collection_name`, `pdpPageProperties()`).

---

### `pincode_form_opened`

**Android method:** `sendEventPinCodeFormOpened()` — `PDPAnalytics.kt:242`
**Event constant:** `AnalyticsEvents.PINCODE_FORM_OPENED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `pincode_change`

**Android method:** `sendEventPinCodeChanged(status: Boolean)` — `PDPAnalytics.kt:246`
**Event constant:** `AnalyticsEvents.PINCODE_CHANGE`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `pincode_check_status` | `PINCODE_CHECK_STATUS` | String | Yes | — | `AnalyticsDefaults.SUCCESS` (`"Success"`) or `AnalyticsDefaults.FAILURE` (`"Failure"`) — string literals |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `coupon_code_clicked`

**Android method:** `sendEventCouponCodeClicked(cta: String?, couponCode: String?)` — `PDPAnalytics.kt:254`
**Event constant:** `AnalyticsEvents.COUPON_CODE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `call_to_action` | `CALL_TO_ACTION` | String | No | — | CTA label tapped |
| `coupon_code` | `COUPON_CODE` | String | No | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `coupon_code_scrolled`

**Android method:** `sendEventCouponCodeScrolled()` — `PDPAnalytics.kt:263`
**Event constant:** `AnalyticsEvents.COUPON_CODE_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `recently_viewed_products_loaded`

**Android method:** `sendEventRecentlyViewedProductsLoaded(feedSize: Int?)` — `PDPAnalytics.kt:285`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `feed_size` | `FEED_SIZE` | int | No | — | Number of recently-viewed items |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `recently_viewed_products_scrolled`

**Android method:** `sendEventRecentlyViewedProductsScrolled(scrollDepth: Int?)` — `PDPAnalytics.kt:369`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupe — only fires when `feedSize > 0`, `scrollDepth > 0`, and `scrollDepth > recentlyViewedMaxScrollCount`. Updates `recentlyViewedMaxScrollCount`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `feed_size` | `FEED_SIZE` | int | Yes | — | Total items in carousel |
| `scroll_depth` | `SCROLL_DEPTH` | int | Yes | — | Max scroll position reached |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `recently_viewed_products_clicked`

**Android method:** `sendEventRecentlyViewedProductsClicked(clickedProduct: ProductItem?)` — `PDPAnalytics.kt:293`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Returns early if `clickedProduct == null`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `clicked_product_pid` | `CLICKED_PRODUCT_PID` | String | Yes | — | `clickedProduct.id` |
| `clicked_product_type` | `CLICKED_PRODUCT_TYPE` | String | No | — | `clickedProduct.trackingMeta.productTypeName` |
| `clicked_product_category` | `CLICKED_CATEGORY` | String | No | — | NOTE: wire key is `clicked_product_category` |
| `clicked_product_subcategory` | `CLICKED_SUBCATEGORY` | String | No | — | NOTE: wire key is `clicked_product_subcategory` |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `reco_viewed`

**Android method:** `sendEventRECOViewed()` — `PDPAnalytics.kt:306`
**Event constant:** `AnalyticsEvents.RECO_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `reco_product_clicked`

**Android method:** `sendEventRECOProductClicked(clickedProduct: ProductItem)` — `PDPAnalytics.kt:310`
**Event constant:** `AnalyticsEvents.RECO_PRODUCT_CLICKED` (components — PDP rail item tap)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same shape as `recently_viewed_products_clicked` — `clicked_product_pid`, `clicked_product_type`, `clicked_product_category`, `clicked_product_subcategory` + `pdpPageProperties()`.

**Quirks:** Distinct from `reco_clicked` (PLP reco tile tap; legacy `AnalyticsHelper.logRecoClickedEvent`).

---

### `reco_see_more_clicked`

**Android method:** `sendEventRECOSeeMoreClicked()` — `PDPAnalytics.kt:322`
**Event constant:** `AnalyticsEvents.RECO_SEE_MORE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `reco_clicked`

**Android method:** `logRecoClickedEvent(String fromScreen, String fromLocation, String recoType, String productId, int imageCount, String recoFilter)` — `AnalyticsHelper.java:1093` (legacy PLP reco tap)
**Event constant:** `AnalyticsEvents.RECO_CLICKED` (also aliased as `AnalyticsEvents.RECO_FILTER = "reco_clicked"` at line 99 — same wire string)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"none"` | |
| `from_location` | `FROM_LOCATION` | String | Yes | `"none"` | |
| `reco_type` | `RECO_TYPE` | String | Yes | `"none"` | |
| `product_id` | `PRODUCT_ID` | String | Yes | `"none"` | |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |
| `image_count` | `IMAGE_COUNT` | int | No | — | Only added when > 0 |

**Quirks:** Distinct from `reco_product_clicked` (PDP-rail tap). `reco_clicked` is the legacy PLP-side tap event.

---

### `product_reco_viewed`

**Android method:** `logProductRecoViewedEvent()` — `ProductDetailPageActivityNew.java:2087`
**Event constant:** `AnalyticsEvents.PRODUCT_RECO_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | int | Yes | — | `mProductId` |
| `product_attribute_available` | `PRODUCT_ATTRIBUTE_AVAILABLE` | bool | Yes | — | true if attributes list non-empty |
| `total_product_attributes` | `TOTAL_PRODUCT_ATTRIBUTES` | int | Yes | `0` | Count of attributes |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |

---

### `reco_products_viewed`

**Android method:** Inline at `ProductListPageActivity.java:2936` and `:2955` (no dedicated helper). Built within the PLP feed-viewed handler.
**Event constant:** `AnalyticsEvents.RECO_PRODUCTS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload (similar PLP-viewed bag plus reco overlays):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (PLP common props built earlier in the method — keyword, browsecategory, product, sort_order, feed_size, promo_code, merch_promo, etc.) | — | — | — | — | |
| `from_screen` | `FROM_SCREEN` | String | No | — | Intent `FROM_SCREEN` |
| `product_id` | `PRODUCT_ID` | int | No | — | Intent `PRODUCT_ID` (for similar-products variant) |
| `from_location` | `FROM_LOCATION` | String | No | — | Reco variant |
| `from_section` | `FROM_SECTION` | String | No | — | |
| `reco_type` | `RECO_TYPE` | String | No | — | |
| `plp_name` | `PLP_NAME` | String | No | — | |
| `plp_type` | `PLP_TYPE` | String | No | — | `"Reco"` for the reco-variant branch |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |

---

### `recent_products_viewed`

**Android constant:** `AnalyticsEvents.RECENT_PRODUCTS_VIEWED = "recent_products_viewed"` — defined at `AnalyticsEvents.java:39` but **never invoked** anywhere in the Android codebase (only the constant declaration exists). Treat as deprecated/unwired on Android.

**Payload:** N/A.

---

### `reco_products_carousel_scrolled`

**Android method:** `logHorizontalScrollEvent(...)` via `ScrollEventDataModel(AnalyticsEvents.RECO_PRODUCTS_CAROUSEL_SCROLLED, mScrollHelper)` registered in `initScrollTracking()` — `ProductDetailPageActivityNew.java:1313`. Event fires through `AnalyticsHelper.logScrollEvent(...)` at line 3214 (`logScrollEvent` flags: `attribution=false`, `universal=true`, `useSavedAttribution=false`).
**Event constant:** `AnalyticsEvents.RECO_PRODUCTS_CAROUSEL_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=true`, `useSavedAttribution=false`
**Side effects:** Resets `scrollTrackingHelper.resetStartScrollIndex()` after firing. Trigger is `SCROLLED_TRIGGER = "trigger"` set to either `"Sortbar changed"` or `"App moved background"` or back-press string.

**Payload (built from ScrollTrackingHelper + saveScrollMetaData):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (scroll-depth params from `ScrollTrackingHelper.getScrollDepthParams()`) | — | — | — | — | |
| `trigger` | `SCROLLED_TRIGGER` | String | Yes | — | `"User back pressed"` (R.string), `"Sortbar changed"`, or `"App moved background"` |
| `from_screen` | `FROM_SCREEN` | String | Yes | — | R.string `reco_products_from_screen` |
| `from_section` | `FROM_SECTION` | String | Yes | — | R.string `rfy_products` |
| `reco_type` | `RECO_TYPE` | String | Yes | — | R.string `reco_products_reco_type` |
| `plp_name` | `PLP_NAME` | String | No | — | `plpNameForScrollEvent` |
| `total_tiles` | `TOTAL_TILES` | int | No | — | Adapter list size |
| `scrolled_tiles` | `SCROLLED_TILES` | int | No | — | `scrollTrackingHelper.getEndScrollIndex()` |
| (local attribution data) | — | — | No | — | `localAttributionDataForScroll` |

---

### `reco_collaborative_products_carousel_scrolled`

**Android method:** Same dispatcher as `reco_products_carousel_scrolled` — `ScrollEventDataModel(AnalyticsEvents.RECO_COLLABORATIVE_PRODUCTS_CAROUSEL_SCROLLED, peopleAlsoLikeScrollHelper)` registered in `initPeopleAlsoLikeScrollTracking()` — `ProductDetailPageActivityNew.java:1322`.
**Event constant:** `AnalyticsEvents.RECO_COLLABORATIVE_PRODUCTS_CAROUSEL_SCROLLED`
**logEvent flags:** Same — `attribution=false`, `universal=true`, `useSavedAttribution=false`
**Side effects:** Same as `reco_products_carousel_scrolled`.

**Payload:** Same shape as `reco_products_carousel_scrolled`, sourced from the "People also like" carousel adapter (`peopleAlsoLikeRecommendedProductsAdapter`).

---

### `product_added_to_notifylist`

**Android method:** `logAddToNotifyMeList()` — `ProductDetailPageActivityNew.java:1791`
**Event constant:** `AnalyticsEvents.PRODUCT_ADDED_TO_NOTIFY_LIST` (wire: `"product_added_to_notifylist"` — note no underscore between `notify` and `list`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same `getEventPropertiesForBottomButton()` payload as `product_expanded` / `product_view_more_clicked` (see `product_expanded` table).

---

### `category_tree_viewed`

**Android method:** `logCategoryTreeViewedEvent(String fromScreen, String fromLocation, String departmentName)` — `AnalyticsHelper.java:1544`
**Event constant:** `AnalyticsEvents.CATEGORY_TREE_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None (wrapped in try/catch; logs to Crashlytics on exception).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | No | — | Only added if non-empty |
| `from_location` | `FROM_LOCATION` | String | No | — | Only added if non-empty |
| `department_name` | `DEPARTMENT_NAME` | String | No | — | Only added if non-empty |

Now let me share this back as the final response.

### `product_viewed`

**Android method:** `logProductViewAnalyticsEvent(boolean preorderInfo, boolean isEddDifferentForSKUs, boolean isReturnInfoDifferentForSKUs, boolean addPromoProperties)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/activity/ProductDetailPageActivityNew.java:3275` (legacy, .java NOT .kt). Modern rewrite: `sendProductViewedEvent()` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hspdp/src/main/java/in/hopscotch/android/hspdp/analytics/PDPAnalytics.kt:113`
**Event constant:** `AnalyticsEvents.PRODUCT_VIEWED` (both hsapp + components — same wire `"product_viewed"`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Legacy entry calls `AnalyticsHelper.getInstance().logAppLaunchedEvent(AnalyticsDefaults.FromScreens.PRODUCT)` BEFORE building props. Adds `FIRST_SCREEN` to common properties via `AnalyticsCommonPropertiesHelper` when `Util.addFirstScreenProperty()`. Sibling FB event: `logFacebookContentViewedEvent()` is fired earlier from `setUpProductContent` (line 2302) via `facebookAppEventsHelper.logFacebookContentViewedEvent(skuId, retailPrice, brandName, gender, productName)`. Entry point: `triggerProductViewEvent(...)` at line 2862.

**Payload (legacy union):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_section` | `FROM_SECTION` | String | No | — | Intent `IntentHelper.FROM_SECTION` |
| `from_screen` | `FROM_SCREEN` | String | No | — | Intent `IntentHelper.FROM_SCREEN` |
| `photo_id` | `PHOTO_ID` | int | No | — | Intent, if non-zero |
| `from_collection` | `FROM_COLLECTION` | bool | No | — | Intent, if true |
| `collection_name` | `COLLECTION_NAME` | String | No | — | Intent extras |
| `product_id` | `PRODUCT_ID` | String | Yes | — | `productDetailResponse.id` |
| `sku` | `SKU` | List<String> | Yes | — | `getCompleteSku()` — list of all simpleSkus' skuIds |
| `name` | `NAME` | String | No | — | `mSku.productName` |
| `brand` | `BRAND` | String | No | — | |
| `price` | `PRICE` | float | Yes | — | `mSku.retailPrice` |
| `mrp` | `MRP` | float | Yes | — | `mSku.regularPrice` |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | **String** | Yes | — | `mSku.discount + "%"` — string with `%` suffix |
| `category` | `CATEGORY` | String | No | — | |
| `subcategory` | `SUB_CATEGORY` | String | No | — | |
| `product_type` | `PRODUCT_TYPE` | String | No | — | |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | No | — | Wire is `subproduct_type` (no underscore between `sub` and `product`) |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` if `isPresale == 1` |
| `sale` | `SALE` | String | No | — | `"Yes"` if `onSale == 1` |
| `gender` | `GENDER` | String | No | — | |
| `colour` | `COLOUR` | String | No | — | British spelling preserved |
| `low_inventory` | `LOW_INVENTORY` | String | No | — | `"Yes"` if `qtyCounter <=3 && >0`; `"Sold out"` if `soldOut` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | `yyyy-MM-dd hh:mm:ss` |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | `mSku.maxDeliveryDays` |
| `from_age` | `FROM_AGE` | int | Yes | — | |
| `to_age` | `TO_AGE` | int | Yes | — | |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | `localAddFromDetails` |
| `preorder_info` | `PRE_ORDER_INFO` | String | No | — | `"Yes"` if param `preorderInfo` |
| `sizes` | `SIZES` | int | No | — | `simpleSkus.size()` |
| `from_feed_size` | `FROM_FEED_SIZE` | int | No | — | Intent, if non-zero |
| `position` | `POSITION` | int | No | — | Intent, if non-zero |
| `hbt`/`taste`/`style`/`season`/`pattern`/`character`/`weave` | — | String | No | — | Via `addAttrsFromSelectedSku` from `mSku.attrs` |
| `merch_type` | `MERCH_TYPE` | String | No | — | |
| `v_country` | `COUNTRY` | String | No | — | Wire key is `v_country` (legacy hsapp) — modern PDP uses `country_of_origin` |
| `is_notifiable` | `IS_NOTIFIABLE` | String | Yes | `"No"` | `"Yes"` if sold-out & `canWishList==1` |
| `image_count` | `IMAGE_COUNT` | int | No | — | If `>0` |
| `default_edd` | `DEFAULT_EDD` | int | Yes | — | `maxDeliveryDays` |
| `edd` | `EDD` | String | No | — | `diff_for_sizes` string when EDD differs across SKUs |
| `return` | `RETURN` | String | No | — | `diff_for_sizes` or `simpleSkus[0].deliveryMessage.msg` |
| `best_price` | `BEST_PRICE` | String | No | — | When `addPromoProperties && cardCount>0` |
| `promo_code` | `PROMO_CODE` | String | No | — | `mPromoDetailResponse.bestPricePromoCode` |
| `merch_promo` | `MERCH_PROMO` | String | No | — | `"Yes"`/`"No"` from `isMerchRule` |
| `offer_card_count` | `OFFER_CARD_COUNT` | int | No | — | `mPromoDetailResponse.cardCount` |
| `click_type` | `CLICK_TYPE` | String | Yes | `"none"` | From `getClickType()`: `"Search CTR"`, `"Reco CTR"`, `"RFYP CTR"`, `"Recent CTR"`, `"Direct PDP"`, `"Wishlist CTR"`, `"Homepage Recent Carousel CTR"`, `"Product Attribute CTR"`, `"Similar Reco CTR"`, `"Product list CTR"`, `"Boutique CTR"` — dedupes via `CTRHelper` |
| `source_tile_type` | `SOURCE_TILE_TYPE` | String | Yes | `"Other"` | `"XL"` / `"Normal"` / `"Other"` |
| `from_pincode` | `FROM_PINCODE` | String | Yes | `"standard"` | |
| `is_pid_aplus` | `IS_PID_APLUS` | String | Yes | `"No"` | |
| `aplus_virtual_group_name` | `APLUS_VIRTUAL_GROUP_NAME` | String | No | — | |
| `aplus_usp_list` | `APLUS_USP_LIST` | **List<String>** | No | — | `toFlatten=false` here → emitted as List, NOT comma-string |
| `aplus_content_type` | `APLUS_CONTENT_TYPE` | String | No | — | Underscore-joined (`image_gif_video`) |
| `redirected_from_shop_the_look` | (common) `REDIRECTED_FROM_SHOP_THE_LOOK` | String | Yes | — | `"Yes"`/`"No"` via `toYesNoString()` of intent boolean |
| `tabbed_page_container_name`, `tabbed_page_container_id`, `tab_name`, `tab_position` | (common nested) | String | No | — | Via `addTabPageProperties` |
| `image_url` | `IMAGE_URL` | String | No | — | `imgurls[0].imgUrlFull` |
| `doorway_id`, `doorway_name`, `doorway_slice_count`, `doorway_slice_id`, `collection_name`, `collection_id`, `dominant_pt`, `redirected_from_doorway` | doorway keys | mixed | No | — | Via `DoorwayAttributionHelper.addDoorwayProperties(intent)` |

**Modern PDPAnalytics.kt subset (line 113):** Tighter — emits `from_screen`, `from_page`, `from_feed_size`, `position`, `source_tile_type`, `sizes`, `name`, `sale` (raw bool, not "Yes"/"No"), `image_count`, `sku` (List), `delivery_days`, `from_pincode`, `add_from_details`, `redirected_from_shop_the_look` ("Yes"/"No"), `coupon_applicable` (Int — `promos.trackingMeta.applicableCount` defaulted to `0`), plus product attributes from extras (`putAll(trackingMeta.extras)`), plus `pdpPageProperties()` which adds `product_id`, `image_url`, `category`, `subcategory`, `product_type`, `subproduct_type`, `country_of_origin` (NOT `v_country`), `brand`, `gender`, `from_age`, `to_age`, `mrp`/`price`/`discount_percentage` (numeric doubles via `toNumericDouble()` — NOT `"%"`-suffixed string; if `price.type == "range"` uses min-priced SKU's pricing), A+ props, doorway, tab-page, color tracking meta (`style_code`, `count_of_pids_in_style_code`, `redirected_from_colour_widget`).

**Quirks:**
- `discount_percentage` legacy is string `"60%"`, modern is numeric double — Flutter must pick one. Source-of-truth is legacy hsapp for current Segment dashboards.
- `sale`/`preorder` legacy emits `"Yes"` string only when true (no `"No"` branch); modern emits raw boolean (defaults to `false`).
- `aplus_usp_list` here is a `List<String>`; in `product_added_to_cart` it is a comma-string — divergent shape across events.
- `country` wire-key disagreement: legacy `v_country`, modern `country_of_origin`.
- `timestamp` (ISO8601), `afUserId`, `cleverTapId`, `session_id` (Amplitude integration only), and `universal` bag are auto-appended by `AnalyticsHelper.logEvent` AFTER per-event props.

---

### `Product viewed`

**Status:** **Unwired on Android.** Constant `AnalyticsEvents.CLEVER_TAP_PRODUCT_VIEWED = "Product viewed"` is declared at `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsEvents.java:130` but no `logEvent(CLEVER_TAP_PRODUCT_VIEWED, ...)` call exists anywhere in the codebase (verified via grep across hsapp, hspdp, components, common, hscart, hsplp). Historically a CleverTap-friendly mirror of `product_viewed`; the dispatch site has been removed. **Do not mirror in Flutter unless reintroducing CleverTap-special routing.**

---

### `product_expanded`

**Android method:** `logProductExpandedAnalyticsEvent()` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/activity/ProductDetailPageActivityNew.java:1656`
**Event constant:** `AnalyticsEvents.PRODUCT_EXPANDED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload** (from `getEventPropertiesForBottomButton()` at line 1804):

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `sku` | `SKU` | String | Yes | — | Single skuId (NOT List, unlike `product_viewed`) |
| `price` | `PRICE` | float | Yes | — | |
| `mrp` | `MRP` | float | Yes | — | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `discount + "%"` |
| `quantity` | `QUANTITY` | int | Yes | — | `mQty` |
| `subtotal` | `SUBTOTAL` | float | Yes | — | `retailPrice * mQty` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `name`, `category`, `subcategory`, `product_type`, `subproduct_type`, `brand`, `gender` | — | String | No | — | |
| `size_selection` | `SIZE_SELECTION` | String | No | — | `fromSelection` |
| `from_age`, `to_age` | — | int | Yes | — | |
| `preorder`, `sale` | — | String | No | — | `"Yes"` when applicable |
| `size` | `SIZE` | String | Yes | — | `getColourOrSize(SIZE)` |
| `colour` | `COLOUR` | String | Yes | — | |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |
| `hbt`/`taste`/`style`/`season`/`pattern`/`character`/`weave` | — | String | No | — | |
| `merch_type` | `MERCH_TYPE` | String | No | — | |
| `v_country` | `COUNTRY` | String | No | — | |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | Hardcoded `AnalyticsDefaults.PRODUCT_DETAILS` |
| `atc_user` | `ATC_USER` | String | No | — | `AppRecordData.getATCUserType()` |
| `image_count` | `IMAGE_COUNT` | int | No | — | If `>0` |
| `image_url` | `IMAGE_URL` | String | No | — | First imgurl |

---

### `product_view_more_clicked`

**Android method:** `logViewMoreAnalyticsEvent()` — `ProductDetailPageActivityNew.java:3565`
**Event constant:** `AnalyticsEvents.PRODUCT_VIEW_MORE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** **Identical** to `product_expanded` — same `getEventPropertiesForBottomButton()` payload.

---

### `product_share_clicked`

**Android method:** Legacy: `logProductShareClickedEvent(String shareLocation)` — `ProductDetailPageActivityNew.java:2119`. Modern: `sendProductShareEvent()` — `PDPAnalytics.kt:180`
**Event constant:** `AnalyticsEvents.PRODUCT_SHARE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload (legacy):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | Hardcoded |
| `from_location` | `FROM_LOCATION` | String | Yes | — | Param (`shareLocation`) |
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `category`, `subcategory`, `product_type`, `subproduct_type` | — | String | No | — | |

**Modern PDPAnalytics:** payload is full `pdpPageProperties()` (much richer than legacy — includes brand/pricing/A+ etc.).

---

### `select_size_clicked`

**Android method:** `sendSizeFilterSelectedData(boolean isFromAddToCart, boolean isFromSizeChips)` — `ProductDetailPageActivityNew.java:1407`
**Event constant:** `AnalyticsEvents.SELECT_SIZE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Guarded by `hasSelectedSizeFilter` flag (dedupes within picker animation cycle).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `price`, `mrp` | — | float | Yes | — | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `"xx%"` |
| `delivery_date` | `DELIVERY_DATE` | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `name`, `category`, `subcategory`, `product_type`, `subproduct_type`, `brand`, `gender` | — | String | No | — | |
| `colour` | `COLOUR` | String | Yes | — | |
| `hbt`/`taste`/`style`/`season`/`pattern`/`character`/`weave` | — | String | No | — | |
| `merch_type` | `MERCH_TYPE` | String | No | — | |
| `is_notifiable` | `IS_NOTIFIABLE` | String | Yes | `"No"` | |
| `default_edd` | `DEFAULT_EDD` | int | Yes | — | |
| `v_country` | `COUNTRY` | String | No | — | |
| `from_pincode` | `FROM_PINCODE` | String | Yes | `"standard"` | |
| `from_location` | `FROM_LOCATION` | String | No | — | One of: `R.string.add_to_cart_button`, `R.string.size_chips_selection`, `R.string.diff_edd_return_nudge`, `R.string.diff_return_nudge`, `R.string.diff_edd_nudge` |

---

### `size_selected`

**Android method:** `sendSizeSelected(fromLocation: String, selectedSku: Sku?)` — `PDPAnalytics.kt:192`. **Components-module event** — no legacy `hsapp` emitter.
**Event constant:** `AnalyticsEvents.SIZE_SELECTED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupes — fires only when `selectedSku.skuId != currentSku?.skuId`. Updates `currentSku` after firing.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_location` | `FROM_LOCATION` | String | Yes | — | Param |
| `sku` | `SKU` | String | Yes | — | `selectedSku.skuId` (single) |
| `sku_size` | `SKU_SIZE` | String | Yes | — | `selectedSku.size` |
| (all `pdpPageProperties()` keys) | — | — | — | — | product/category/brand/pricing/A+ meta |

---

### `size_chart_viewed`

**Android method:** `logSizeChartViewedEvent()` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/activity/SizeChartActivity.java:85` AND `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/components/stylecarousel/SizeChartFragment.kt:169`
**Event constant:** `AnalyticsEvents.SIZE_CHART_VIEWED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Adds `FIRST_SCREEN` to common properties via `AnalyticsCommonPropertiesHelper` when `Util.addFirstScreenProperty()`.

**Payload (SizeChartActivity):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | int | Yes | — | If `mProductId > 0` |
| `from_screen` | `FROM_SCREEN` | String | No | — | Intent |
| `from_location` | `FROM_LOCATION` | String | No | — | Intent — typically `"Size picker"` (`SELECT_SIZE_LOCATION`) or `R.string.pdp` |
| `name` | `NAME` | String | No | — | Intent (product name) |
| `brand` | `BRAND` | String | No | — | |
| `category`, `subcategory`, `product_type`, `subproduct_type` | — | String | No | — | |
| `preorder` | `PRE_ORDER` | String | No | — | `"Yes"` if presale |
| `gender` | `GENDER` | String | No | — | From first SKU |
| `size` | `SIZE` | List<String> | No | — | All sizes — wire key is `size` (singular), value is List |
| `age` | `AGE` | List<String> | No | — | Single-element list `["fromAge - toAge"]` |

---

### `size_chart_clicked`

**Android method:** `sendEventSizeChartCLicked()` — `PDPAnalytics.kt:217`. Components-module event — no legacy `hsapp` emitter.
**Event constant:** `AnalyticsEvents.SIZE_CHART_CLICKED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only (no `from_location` set — legacy code launches `SizeChartActivity` directly with `fromLocation` intent extra; that powers `size_chart_viewed`, not `size_chart_clicked`).

---

### `shipping_info_viewed`

**Android method:** `logShippingInfoViewedEvent(scope, fromLocation)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hscart/src/main/java/in/hopscotch/android/hscart/ui/helper/CartAnalytics.kt:54`
**Event constant:** `AnalyticsEvents.SHIPPING_INFO_VIEWED` (components)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_location` | `FROM_LOCATION` | String | No | — | Param |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Cart"` | `FromScreens.SHOPPING_CART` hardcoded |

**Quirks:** Currently fired ONLY from cart on Android. No PDP emitter exists in `hsapp` (`ProductDetailPageActivityNew.java`) or `hspdp/PDPAnalytics.kt` — verified via grep. If Flutter PDP fires this, it's a net-new behavior.

---

### `PDP_reco_loaded`

**Android method:** `logPDPRecoLoadedEvent(String fromScreen, String fromLocation, String recoType, String productId, String recoFilter, int size)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsHelper.java:1106`
**Event constant:** `AnalyticsEvents.PDP_RECO_LOADED` — wire string is `PDP_reco_loaded` (uppercase `PDP_` prefix, lower elsewhere)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"none"` | |
| `from_location` | `FROM_LOCATION` | String | Yes | `"none"` | |
| `reco_type` | `RECO_TYPE` | String | Yes | `"none"` | |
| `product_id` | `PRODUCT_ID` | String | Yes | `"none"` | |
| `attribute_count` | `ATTRIBUTE_COUNT` | int | Yes | — | `size` param. Note: key is `attribute_count`, NOT `feed_size` |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |

---

### `pdp_attributes_loaded`

**Android method:** `logPDPAttributeLoadedEvent(...)` — `AnalyticsHelper.java:1117`
**Event constant:** `AnalyticsEvents.PDP_ATTRIBUTES_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Identical shape to `PDP_reco_loaded`: `from_screen`, `from_location`, `reco_type`, `attribute_count`, `product_id`, `reco_filter` (all defaulted to `"none"` when empty).

---

### `pdp_images_scrolled`

**Android method:** `sendPdpImagesScrolledEvent(uniqueScrollCount: Int)` — `PDPAnalytics.kt:169` (private; invoked from `onStop(uniqueImagesScrolled: Int)` at line 355 — `uniqueScrollCount = uniqueImagesScrolled + 1`)
**Event constant:** `AnalyticsEvents.PDP_IMAGES_SCROLLED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupe — fires only when `uniqueScrollCount > 1 && uniqueScrollCount > pdpImagesMaxViewCount`. Updates `pdpImagesMaxViewCount`. Fired on activity `onStop` (not per-swipe).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all `pdpPageProperties()` keys) | — | — | — | — | |
| `unique_images_scrolled` | `UNIQUE_IMAGES_SCROLLED` | int | Yes | — | Max distinct image positions viewed during session (+1) |

---

### `xl_product_card_scrolled`

**Android method:** `logXLProductCardScrolled(position: Int?, direction: String?)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsplp/src/main/java/in/hopscotch/android/hsplp/analytics/PLPAnalytics.kt:514` AND legacy `onXLTileScrolled(int position, String direction)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/activity/ProductListPageActivity.java:4102`. Also fired in `ProductsListingActivity.java:2376`.
**Event constant:** `AnalyticsEvents.XL_PRODUCT_CARD_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all PLP common props via `addCommonProductListProperties()` / `getCommonPLPProperties()`) | — | — | — | — | plp_name, plp_type, boutique meta, sort/filter, feed_size etc. |
| `card_index` | `CARD_INDEX` | int | Yes | — | Index of XL card scrolled |
| `swipe_direction` | `SWIPE_DIRECTION` | String | Yes | — | |

**Quirks:** This is a **PLP event**, not a PDP event despite being in the spec's PDP list. On Android no PDP-side emitter exists.

---

### `aplus_content_viewed`

**Android method:** Legacy: `logAPlusContentViewed()` — `ProductDetailPageActivityNew.java:2040`. Modern: `sendEventAPlusContentViewed()` — `PDPAnalytics.kt:326`
**Event constant:** `AnalyticsEvents.APLUS_CONTENT_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload (legacy):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String | Yes | — | |
| `is_pid_aplus` | `IS_PID_APLUS` | String | Yes | `"No"` | `"Yes"` if A+ |
| `aplus_virtual_group_name` | `APLUS_VIRTUAL_GROUP_NAME` | String | No | — | `content.getName()` |
| `aplus_usp_list` | `APLUS_USP_LIST` | **List<String>** | No | — | `toFlatten=false` in legacy here — List, NOT comma-string |
| `aplus_content_type` | `APLUS_CONTENT_TYPE` | String | No | — | Underscore-joined (`image_gif_video`) |
| `sku` | `SKU` | List<String> | Yes | — | `getCompleteSku()` |
| `name` | `NAME` | String | No | — | |
| `brand` | `BRAND` | String | No | — | |
| `price`, `mrp` | — | float | Yes | — | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | Yes | — | `"xx%"` |
| `category`, `subcategory`, `product_type`, `subproduct_type` | — | String | No | — | |
| `preorder`, `sale` | — | String | No | — | `"Yes"` |
| `gender`, `colour` | — | String | No | — | |
| `delivery_days` | `DELIVERY_DAYS` | int | Yes | — | |
| `from_age`, `to_age` | — | int | Yes | — | |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |

**Quirks:** Spec instruction says "`aplus_usp_list` is split by `,` into a `List<String>`". On Android `product_viewed` and `aplus_content_viewed` ALREADY emit `aplus_usp_list` as a `List<String>` (no splitting needed) — the comma-string form is used only in `product_added_to_cart` (`logAddToCartAnalyticsEvent` legacy via `toFlatten=true` and in `sendEventProductAddedToCart` modern via `uspNames?.joinToString(",")`). The Flutter "split by comma" treatment likely refers to the cart/ATC ingestion side, not these PDP-view events. Modern PDPAnalytics emits the List via Kotlin `List.toString()` (i.e. literal `"[usp1, usp2]"` string) — this is **divergent from legacy** and likely a bug; verify before mirroring.

---

### `product_content_expanded`

**Android method:** `sendProductContentExpanded()` — `PDPAnalytics.kt:361` (private; invoked from `handlePDPContentSheetState(newState, initialTop)` when `newState == BottomSheetBehavior.STATE_EXPANDED`)
**Event constant:** `AnalyticsEvents.PRODUCT_CONTENT_EXPANDED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_content_collapsed`

**Android method:** `sendProductContentCollapsed()` — `PDPAnalytics.kt:365` (private; from `handlePDPContentSheetState` when `STATE_COLLAPSED && initialTop != null`)
**Event constant:** `AnalyticsEvents.PRODUCT_CONTENT_COLLAPSED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Guards against initial-state-collapsed by requiring non-null `initialTop`.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_expanded`

**Android method:** `sendProductDetailsExpanded()` — `PDPAnalytics.kt:221`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_EXPANDED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_collapsed`

**Android method:** `sendProductDetailsCollapsed()` — `PDPAnalytics.kt:225`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_COLLAPSED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `product_details_tab_clicked`

**Android method:** `sendEventProductDetailsTabClicked(tabPosition: Int?)` — `PDPAnalytics.kt:229`
**Event constant:** `AnalyticsEvents.PRODUCT_DETAILS_TAB_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Returns early if `tabPosition == null` or product is null.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `tab_name` | `TAB_NAME` | String | Yes | — | `product.details[tabPosition].tabName` |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `product_attribute_tab_clicked`

**Android method:** `logProductAttributeTabClickedEvent(ProductAttributes attribute)` — `ProductDetailPageActivityNew.java:2101`
**Event constant:** `AnalyticsEvents.PRODUCT_ATTRIBUTE_TAB_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | int | Yes | — | |
| `from_location` | `FROM_LOCATION` | String | Yes | `"Product Attribute"` | Hardcoded |
| `from_screen` | `FROM_SCREEN` | String | Yes | `"Product details"` | Hardcoded |
| `product_type` | `PRODUCT_TYPE` | String | No | — | |
| `gender` | `GENDER` | String | No | — | |
| `product_attribute_name` | `PRODUCT_ATTRIBUTE_NAME` | String | No | — | |
| `product_attribute_value` | `PRODUCT_ATTRIBUTE_VALUE` | String | No | — | |

---

### `shop_the_look_clicked`

**Android method:** `logStyleCarouselClickedEvent(ExtraData extraData, int position)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/viewholders/homepage/StyleCarouselViewHolder.kt:66`
**Event constant:** `AnalyticsEvents.SHOP_THE_LOOK_CLICKED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `banner_name` | `BANNER_NAME` (or `LPAttributionParams.BANNER_NAME` — both resolve to wire `banner_name`) | int | Yes | — | `position + 1` — the wire key is `banner_name` but the **value is a numeric position**, not a string name |

**Quirks:** Fired from the **homepage** StyleCarousel (Add-to-cart inside the carousel, or product tile tap inside it). Not a PDP-side event on Android. The "redirected_from_shop_the_look" boolean travels on subsequent PDP `product_viewed` / `product_added_to_cart` events instead.

---

### `color_widget_expanded`

**Android method:** `sendEventColorWidgetExpanded()` — `PDPAnalytics.kt:142`
**Event constant:** `AnalyticsEvents.COLOR_WIDGET_EXPANDED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupes via `sentColorEventExpandedEvent` flag — fires once per PDP load (cleared by `refreshPID()`).

**Payload:** `pdpPageProperties()` + `getProductAttributes()` (extras from `trackingMeta.productAttrs`) + `addDoorwayProperties()` + color tracking meta (`style_code`, `count_of_pids_in_style_code`, `redirected_from_colour_widget`).

---

### `new_color_selected`

**Android method:** `sendEventNewColorSelected(newPid: String?)` — `PDPAnalytics.kt:157`
**Event constant:** `AnalyticsEvents.NEW_COLOR_SELECTED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None directly, but `refreshPID()` is typically called downstream to reset PDP-session counters.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (all `pdpPageProperties()` + product-attrs + doorway + color tracking meta keys) | — | — | — | — | |
| `new_product_id_selected` | `NEW_PRODUCT_ID_SELECTED` | String | Yes | — | PID being switched to |

---

### `parent_collection_viewed`

**Android method:** `sendEventParentCollectionViewed(collectionId: String?, collectionName: String?)` — `PDPAnalytics.kt:267`
**Event constant:** `AnalyticsEvents.PARENT_COLLECTION_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `collection_id` | `COLLECTION_ID` | String | No | — | |
| `collection_name` | `COLLECTION_NAME` | String | No | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `parent_collection_clicked`

**Android method:** `sendEventParentCollectionClicked(collectionId: String?, collectionName: String?)` — `PDPAnalytics.kt:276`
**Event constant:** `AnalyticsEvents.PARENT_COLLECTION_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same as `parent_collection_viewed`.

---

### `pincode_form_opened`

**Android method:** `sendEventPinCodeFormOpened()` — `PDPAnalytics.kt:242`
**Event constant:** `AnalyticsEvents.PINCODE_FORM_OPENED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `pincode_change`

**Android method:** `sendEventPinCodeChanged(status: Boolean)` — `PDPAnalytics.kt:246`
**Event constant:** `AnalyticsEvents.PINCODE_CHANGE`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `pincode_check_status` | `PINCODE_CHECK_STATUS` | String | Yes | — | `AnalyticsDefaults.SUCCESS` or `AnalyticsDefaults.FAILURE` (string literals — typically `"Success"`/`"Failure"`) |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `coupon_code_clicked`

**Android method:** `sendEventCouponCodeClicked(cta: String?, couponCode: String?)` — `PDPAnalytics.kt:254`
**Event constant:** `AnalyticsEvents.COUPON_CODE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `call_to_action` | `CALL_TO_ACTION` | String | No | — | CTA label tapped (e.g. `"Copy"`, `"Apply"`) |
| `coupon_code` | `COUPON_CODE` | String | No | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `coupon_code_scrolled`

**Android method:** `sendEventCouponCodeScrolled()` — `PDPAnalytics.kt:263`
**Event constant:** `AnalyticsEvents.COUPON_CODE_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `recently_viewed_products_loaded`

**Android method:** `sendEventRecentlyViewedProductsLoaded(feedSize: Int?)` — `PDPAnalytics.kt:285`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `feed_size` | `FEED_SIZE` | int | No | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `recently_viewed_products_scrolled`

**Android method:** `sendEventRecentlyViewedProductsScrolled(scrollDepth: Int?)` — `PDPAnalytics.kt:369`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_SCROLLED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Dedupe — fires only when `feedSize > 0`, `scrollDepth > 0`, and `scrollDepth > recentlyViewedMaxScrollCount`. Updates `recentlyViewedMaxScrollCount`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `feed_size` | `FEED_SIZE` | int | Yes | — | |
| `scroll_depth` | `SCROLL_DEPTH` | int | Yes | — | |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `recently_viewed_products_clicked`

**Android method:** `sendEventRecentlyViewedProductsClicked(clickedProduct: ProductItem?)` — `PDPAnalytics.kt:293`
**Event constant:** `AnalyticsEvents.RECENTLY_VIEWED_PRODUCTS_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Returns early if `clickedProduct == null`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `clicked_product_pid` | `CLICKED_PRODUCT_PID` | String | Yes | — | |
| `clicked_product_type` | `CLICKED_PRODUCT_TYPE` | String | No | — | |
| `clicked_product_category` | `CLICKED_CATEGORY` | String | No | — | Wire key is `clicked_product_category` |
| `clicked_product_subcategory` | `CLICKED_SUBCATEGORY` | String | No | — | Wire key is `clicked_product_subcategory` |
| (all `pdpPageProperties()` keys) | — | — | — | — | |

---

### `reco_viewed`

**Android method:** `sendEventRECOViewed()` — `PDPAnalytics.kt:306`
**Event constant:** `AnalyticsEvents.RECO_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `reco_product_clicked`

**Android method:** `sendEventRECOProductClicked(clickedProduct: ProductItem)` — `PDPAnalytics.kt:310`. **Components-module event — PDP reco rail item tap**, distinct from `reco_clicked` (PLP).
**Event constant:** `AnalyticsEvents.RECO_PRODUCT_CLICKED` (components)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Same shape as `recently_viewed_products_clicked` — `clicked_product_pid`, `clicked_product_type`, `clicked_product_category`, `clicked_product_subcategory` + `pdpPageProperties()`.

---

### `reco_see_more_clicked`

**Android method:** `sendEventRECOSeeMoreClicked()` — `PDPAnalytics.kt:322`
**Event constant:** `AnalyticsEvents.RECO_SEE_MORE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** `pdpPageProperties()` only.

---

### `reco_clicked`

**Android method:** `logRecoClickedEvent(String fromScreen, String fromLocation, String recoType, String productId, int imageCount, String recoFilter)` — `AnalyticsHelper.java:1093`. **Legacy PLP-side reco tap** — distinct from `reco_product_clicked` (PDP rail).
**Event constant:** `AnalyticsEvents.RECO_CLICKED`. **Aliased** at line 99 as `AnalyticsEvents.RECO_FILTER = "reco_clicked"` (same wire string).
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Yes | `"none"` | |
| `from_location` | `FROM_LOCATION` | String | Yes | `"none"` | |
| `reco_type` | `RECO_TYPE` | String | Yes | `"none"` | |
| `product_id` | `PRODUCT_ID` | String | Yes | `"none"` | |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |
| `image_count` | `IMAGE_COUNT` | int | No | — | Only added when `>0` |

---

### `product_reco_viewed`

**Android method:** `logProductRecoViewedEvent()` — `ProductDetailPageActivityNew.java:2087`
**Event constant:** `AnalyticsEvents.PRODUCT_RECO_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | int | Yes | — | |
| `product_attribute_available` | `PRODUCT_ATTRIBUTE_AVAILABLE` | bool | Yes | — | `true` iff attributes list non-empty |
| `total_product_attributes` | `TOTAL_PRODUCT_ATTRIBUTES` | int | Yes | `0` | |
| `reco_filter` | `RECO_FILTER` | String | Yes | `"none"` | |

---

### `reco_products_viewed`

**Android method:** Inline emit at `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/activity/ProductListPageActivity.java:2936` (similar-products branch) and `:2955` (reco-PLP branch). No dedicated helper.
**Event constant:** `AnalyticsEvents.RECO_PRODUCTS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** PLP common props (keyword/browsecategory/product, sort_order, feed_size, promo_code, merch_promo, add_from_details) plus reco overlays:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | No | — | Intent |
| `product_id` | `PRODUCT_ID` | int | No | — | Intent (similar-products variant) |
| `from_location` | `FROM_LOCATION` | String | No | — | |
| `from_section` | `FROM_SECTION` | String | No | — | |
| `reco_type` | `RECO_TYPE` | String | No | — | Intent |
| `plp_name` | `PLP_NAME` | String | No | — | |
| `plp_type` | `PLP_TYPE` | String | No | — | `"Reco"` for reco branch |
| `feed_size` | `FEED_SIZE` | int | Yes | `0` | |
| `sort_order` | `SORT_ORDER` | String | No | — | |
| `promo_code`, `merch_promo` | — | mixed | No | — | When `promoPLPSegmentEvents` present |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Yes | — | |

---

### `recent_products_viewed`

**Status:** **Unwired.** Constant `AnalyticsEvents.RECENT_PRODUCTS_VIEWED = "recent_products_viewed"` exists at `AnalyticsEvents.java:39` but no `logEvent(RECENT_PRODUCTS_VIEWED, ...)` invocation exists anywhere in the codebase (verified via grep). Likely deprecated; do not implement on Flutter without explicit product confirmation.

---

### `reco_products_carousel_scrolled`

**Android method:** Registered as `ScrollEventDataModel(AnalyticsEvents.RECO_PRODUCTS_CAROUSEL_SCROLLED, mScrollHelper)` in `initScrollTracking()` — `ProductDetailPageActivityNew.java:1313`. Fires through `AnalyticsHelper.getInstance().logScrollEvent(eventName, mData, false, true, false)` at the back-press/sortbar/background trigger site (line 3214).
**Event constant:** `AnalyticsEvents.RECO_PRODUCTS_CAROUSEL_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=true`, `useSavedAttribution=false`
**Side effects:** Calls `scrollTrackingHelper.resetStartScrollIndex()` after firing. Fires only on lifecycle trigger (back-press, sortbar change, background) — not per-swipe.

**Payload (via `ScrollTrackingHelper.getScrollDepthParams()` + `saveScrollMetaData`):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (scroll depth params: row, from_row, scrolled_row, total_rows, scrolled_height, screen_height, soldout_count, scrolled_rfyc_row, sort_by, sortbar, sortbar_group) | — | — | — | — | All from `ScrollTrackingHelper` |
| `trigger` | `SCROLLED_TRIGGER` | String | Yes | — | `R.string.user_back_pressed` / `"Sortbar changed"` / `"App moved background"` |
| `from_screen` | `FROM_SCREEN` | String | Yes | — | `R.string.reco_products_from_screen` |
| `from_section` | `FROM_SECTION` | String | Yes | — | `R.string.rfy_products` |
| `reco_type` | `RECO_TYPE` | String | Yes | — | `R.string.reco_products_reco_type` |
| `plp_name` | `PLP_NAME` | String | No | — | `plpNameForScrollEvent` |
| `total_tiles` | `TOTAL_TILES` | int | No | — | Adapter list size |
| `scrolled_tiles` | `SCROLLED_TILES` | int | No | — | `getEndScrollIndex()` |
| (local attribution data) | — | — | No | — | `localAttributionDataForScroll` if present |

---

### `reco_collaborative_products_carousel_scrolled`

**Android method:** Same dispatcher pattern — `ScrollEventDataModel(AnalyticsEvents.RECO_COLLABORATIVE_PRODUCTS_CAROUSEL_SCROLLED, peopleAlsoLikeScrollHelper)` registered in `initPeopleAlsoLikeScrollTracking()` — `ProductDetailPageActivityNew.java:1322`. Same `logScrollEvent` flags and trigger lifecycle.
**Event constant:** `AnalyticsEvents.RECO_COLLABORATIVE_PRODUCTS_CAROUSEL_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=true`, `useSavedAttribution=false`
**Side effects:** Same as `reco_products_carousel_scrolled`.

**Payload:** Same shape, sourced from the "People also like" carousel (`peopleAlsoLikeRecommendedProductsAdapter`).

---

### `product_added_to_notifylist`

**Android method:** `logAddToNotifyMeList()` — `ProductDetailPageActivityNew.java:1791`. Fired only after a successful `addToWishList` API response when `mSku.availableQuantity < 1 && canWishList == 1` (sold-out notify flow).
**Event constant:** `AnalyticsEvents.PRODUCT_ADDED_TO_NOTIFY_LIST` — wire string is `"product_added_to_notifylist"` (note: `notifylist` is one word, not `notify_list`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:** Identical to `product_expanded` / `product_view_more_clicked` — `getEventPropertiesForBottomButton()` payload (see `product_expanded` table).

---

### `category_tree_viewed`

**Android method:** `logCategoryTreeViewedEvent(String fromScreen, String fromLocation, String departmentName)` — `/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/analytics/AnalyticsHelper.java:1544`
**Event constant:** `AnalyticsEvents.CATEGORY_TREE_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Wrapped in try/catch; logs to Crashlytics on exception.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | No | — | Only added if `StringUtils.exists(fromScreen)` |
| `from_location` | `FROM_LOCATION` | String | No | — | Only added if non-empty |
| `department_name` | `DEPARTMENT_NAME` | String | No | — | Only added if non-empty |

---

## Module: PLP / Filters / Sorting / Brand

### `product_listing_viewed`

**Android method:** `logProductsListingEvent()` (uses `getCommonPLPProperties()`) - `hsapp/src/main/java/in/hopscotch/android/activity/ProductListPageActivity.java:3008` (event fires at line 3014). Common properties helper at line 4432.
**Event constant:** `AnalyticsEvents.PRODUCT_LISTING_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(plpTypeText)` (where `plpTypeText` is the `R.string.product_listing` constant, e.g. `"Product list page"`). Adds `first_screen` to `universal` if `Util.addFirstScreenProperty()` is true. Guards itself with `firedViewedEvent` flag (fires only once per session of the screen).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Optional | — | From intent extras; for search PLP overrides to `R.string.searchTitle` |
| `from_location` | `FROM_LOCATION` | String | Optional | — | From intent extras |
| `from_section` | `FROM_SECTION` | String | Optional | — | From `searchPageCatSubCat` then intent extras (intent wins) |
| `feed_size` | `FEED_SIZE` | int | Always | `0` | `totalCount` if `> -1`, else `0` |
| `is_page_xl_tile_eligible` | `IS_PAGE_XL_TILE_ELIGIBLE` | String | Always | — | `"Yes"`/`"No"` from `mProductListResponse.hasXLTiles` |
| `collection_count` | `COLLECTION_COUNT` | int | Optional | — | `availablePLPCollections` if non-null |
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Optional | — | `productsDeeplinkId` if non-zero |
| `page_eligible_for_clustered_plp` | `PAGE_ELIGIBLE_FOR_CLUSTERED_PLP` | String | Always | — | `"Yes"`/`"No"` from `clusteringExistsForListingPage` |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Always | — | `mProductListResponse.screenName` |
| `sort_order` | `SORT_ORDER` | String | Optional | — | `sortingOptions[0].sortName` if present |
| `position` | `POSITION` | int | Optional | — | From intent extra if non-zero |
| `product_id` | `PRODUCT_ID` | List<String> | Optional | — | First 4 product IDs as `ArrayList<String>` |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Always | — | `mLocalAddFromDetails` |
| `plp_type` | `PLP_TYPE` | String | Always | — | Hard-set to `R.string.product_listing` ("Product list page") |
| `promo_code` | `PROMO_CODE` | String | Optional | — | From `promoPLPSegmentEvents.promotionCode` |
| `merch_promo` | `MERCH_PROMO` | String | Optional | — | `"Yes"`/`"No"` from `isMerchRule` |
| Doorway attribution keys | (varies) | mixed | Optional | — | Via `DoorwayAttributionHelper.addDoorwayProperties(intent)` |

**Quirks:** Common PLP properties helper is reused by other PLP events. `from_screen`/`from_location`/`from_section` are intent-driven.

---

### `boutique_viewed`

**Android method:** `logBoutiqueViewAnalyticsEvent()` (uses `getCommonBoutiqueProperties()`) - `hsapp/src/main/java/in/hopscotch/android/activity/ProductsListingActivity.java:984` (event fires at line 993).
**Event constant:** `AnalyticsEvents.BOUTIQUE_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(salePlanDetail.name)`. Adds `first_screen` to `universal` if `Util.addFirstScreenProperty()` is true. Returns early if `salePlanDetail == null` or `salePlanDetail.isUpcoming`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Optional | — | From intent extras |
| `from_location` | `FROM_LOCATION` | String | Optional | — | From intent extras |
| `from_section` | `FROM_SECTION` | String | Optional | — | From intent extras |
| `reco_type` | `RECO_TYPE` | String | Optional | — | From intent extras (when arriving from recommendations) |
| `boutique_id` | `BOUTIQUE_ID` | int | Always | — | `salePlanDetail.id` |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | `salePlanDetail.name` |
| `boutique_start_date` | `BOUTIQUE_START_DATE` | String | Optional | — | Formatted `"yyyy-MM-dd hh:mm:ss"` |
| `boutique_end_date` | `BOUTIQUE_END_DATE` | String | Optional | — | Formatted `"yyyy-MM-dd hh:mm:ss"` |
| `page_eligible_for_clustered_plp` | `PAGE_ELIGIBLE_FOR_CLUSTERED_PLP` | String | Always | — | `"Yes"`/`"No"` |
| `days_since_boutique_start` | `DAYS_SINCE_BOUTIQUE_START` | int | Always | — | `salePlanDetail.daysSinceBoutiqueStart` |
| `sort_order` | `SORT_ORDER` | String | Optional | — | `selectedSortText` if non-empty |
| `add_from_details` | `ADD_FROM_DETAILS` | String | Optional | — | If non-null |
| `boutique_type` | `BOUTIQUE_TYPE` | String | Optional | — | `salePlanDetail.saleType` |
| `position` | `POSITION` | int | Optional | — | From intent extra if non-zero |
| `row` | `ROW` | int | Optional | — | From intent extra if non-zero |
| `feed_size` | `FEED_SIZE` | int | Optional | — | `totalProducts` if `> 0` |
| `is_page_xl_tile_eligible` | `IS_PAGE_XL_TILE_ELIGIBLE` | String | Always | — | `"Yes"`/`"No"` from `productListResponses.hasXLTiles` |
| `product_id` | `PRODUCT_ID` | List<String> | Optional | — | First 4 product IDs |
| `from_feed_size` | `FROM_FEED_SIZE` | int | Optional | — | From intent extra if non-zero |
| `soldout_count` | `SOLDOUT_COUNT` | int | Optional | — | If `> 0` |
| `plp_type` | `PLP_TYPE` | String | Always | — | Hard-set to `R.string.addToCartSourceBoutique` ("Boutique") |
| Doorway attribution keys | (varies) | mixed | Optional | — | Via `DoorwayAttributionHelper.addDoorwayProperties(intent)` |

**Quirks:** Properties use the boutique-specific keys from `common/util/AnalyticsProperties.kt`. The constants `BOUTIQUE_ID`/`BOUTIQUE_NAME` come from `in.hopscotch.android.common.util.AnalyticsProperties`.

---

### `plp_scrolled`

**Android method:** Emitted via `logScrollEvent(...)` from `ProductListPageActivity.java:3693` (PLP), `ProductsListingActivity.java:1283` (Boutique), and `Foreground.sendSavedScrollData()` for background trigger (`Foreground.java:210`, lines 228 and 255). Event name set by `ScrollEventDataModel` at `ProductsListingActivity.java:496` and `ProductListPageActivity.java:1135`.
**Event constant:** `AnalyticsEvents.PLP_SCROLLED`
**logEvent flags:** `attribution=false`, `universal=true`, `useSavedAttribution=false` for in-screen calls. The `true, true, true` form (saved attribution) is only used by `CollectionsFragment.kt` for homepage scroll — not for `plp_scrolled`.
**Side effects:** Sends accumulated scroll metadata only when `getScrollDepthParams()` returns non-null. Resets start-scroll index after firing. No `logAppLaunchedEvent`.

**Payload (PLP listing case):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_row` | `FROM_ROW` | int | Always | `1` | Start scroll index (1 if `mStartScrolledItemIndex <= 0`) |
| `scrolled_row` | `SCROLLED_ROW` | int | Always | — | Capped to `(totalProductCount + 1) / 2 + extraRowCount` |
| `scrolled_height` | `SCROLLED_HEIGHT` | int | Optional | — | Max scrolled height in px (omitted if zero unless `isUnScrolled && isUnSent`) |
| `screen_height` | `SCREEN_HEIGHT` | String | Always | — | `String.valueOf(DefaultDisplay.displayHeight)` |
| `plp_type` | `PLP_TYPE` | String | Optional | — | `plpTypeText` if non-empty |
| `plp_name` | `PLP_NAME` | String | Optional | — | Only when search PLP — `plpName`, or `"No results"` / `"Search results"` |
| `feed_size` | `FEED_SIZE` | int | Always | — | `totalProductCount` |
| `total_rows` | `TOTAL_ROWS` | int | Always | — | `(totalProductCount + 1) / 2 + extraRowCount` |
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Optional | — | `productsDeeplinkId` if non-zero |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | `plpName` if non-empty |
| `from_screen` | `FROM_SCREEN` | String | Optional | — | Resolved per branch |
| `brand` | `BRAND` | List<String> | Optional | — | Unique brand names of scrolled rows |
| `product_id` | `PRODUCT_ID` | List<String> | Optional | — | Unique product IDs of scrolled rows |
| `xl_product_id` | `XL_PRODUCT_ID` | List<String> | Optional | — | IDs of XL tile products in scroll range |
| `product_category` | `CATEGORY` | List<String> | Optional | — | Unique category names |
| `subcategory` | `SUB_CATEGORY` | List<String> | Optional | — | Unique sub-category names |
| `product_type` | `PRODUCT_TYPE` | List<String> | Optional | — | Unique product type names |
| `merch_type` | `MERCH_TYPE` | List<String> | Optional | — | Unique merch types |
| (saved attribution) | — | mixed | Optional | — | Local order/scroll attribution map from `OrderAttributionHelper.getOrderAttributionDataForScrollEvent` |

**Payload (Boutique case):** Same scroll-depth fields, plus `boutique_id`, `boutique_name`, `from_screen`, `scrolled_rfyc_row` (String), `total_rows` (computed via `getTotalScrollableRows`), and hard-set `plp_type="Boutique"`.

**Quirks:**
- The trigger sentinel `Sortbar changed` is only used by Discover (homepage), NOT for `plp_scrolled`.
- `Foreground.sendSavedScrollData()` writes a slightly different literal `"App moved to background"` (with `to`) into the `SCROLLED_TRIGGER` key for any background-triggered scroll event — Android inconsistency between the constant value and the literal.
- `scrolled_height` is omitted when 0 unless unscrolled-and-unsent.
- The event is suppressed entirely if `mLastScrolledRowIndex <= mStartScrolledItemIndex` (no real scroll).

---

### `collections_loaded`

**Android method:** `getPLPCollections()` API success callback - `ProductListPageActivity.java:1636` (event fires at line 1664).
**Event constant:** `AnalyticsEvents.COLLECTIONS_LOADED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `collection_count` | `COLLECTION_COUNT` | int | Optional | — | `plpCollections.size() - 1` if `> 0`, else `0` (the "All" tab is excluded) |

**Quirks:** Fires immediately when PLP collections list is loaded — only one property.

---

### `collections_viewed`

**Android method:** `logViewedEvent(specialPageName, pageType, pageId)` — branch when `pageType` matches `R.string.from_collections` - `SearchResultsShowingBoutiquesActivity.java:765` (event fires at line 835).
**Event constant:** `AnalyticsEvents.COLLECTIONS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(intent.getStringExtra(IntentHelper.NAME))` immediately before. Adds `first_screen` to `universal` if applicable.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (search suggestion tracking data) | — | mixed | Optional | — | `SearchSuggestionItem.getTrackingData()` map spread in |
| `from_screen` | `FROM_SCREEN` | String | Optional | — | From intent extra |
| `from_location` | `FROM_LOCATION` | String | Optional | — | From intent extra |
| `name` | `NAME` | String | Optional | — | `specialPageName`, then overwritten with intent's `IntentHelper.NAME` if non-empty in collections branch |
| `id` | `ID` | int | Optional | — | Intent extra `ID` if `> 0`, else `pageId` if `> 0` |
| `from_section` | `FROM_SECTION` | String | Optional | — | From intent extra |
| `position` | `POSITION` | int | Optional | — | From intent extra if non-zero |
| `from_feed_size` | `FROM_FEED_SIZE` | int | Optional | — | From intent extra if non-zero |
| `edd` | `EDD` | String | Optional | — | From intent extra |
| `from_pincode` | `FROM_PINCODE` | String | Optional | — | From intent extra |
| `product_id` | `PRODUCT_ID` | int | Optional | — | From intent extra if `> 0` (single int) |
| `row` | `ROW` | int | Optional | — | From intent extra if non-zero |
| `custom_tile_type` | `CUSTOM_TILE_TYPE` | String | Optional | — | From intent extra |

---

### `special_page_viewed`

**Android method:** Two emitters:
- `logViewedEvent(...)` — branch when `pageType` matches `R.string.from_special_page` - `SearchResultsShowingBoutiquesActivity.java:765` (fires line 841).
- `TabbedPageAnalyticsHelper.logSpecialPageViewed(source)` - `impl/tabpage/TabbedPageAnalyticsHelper.kt:40` (fires line 47).

**Event constant:** `AnalyticsEvents.SPECIAL_PAGE_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** SearchResultsShowingBoutiques path: `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.SPECIAL_PAGE)`. Tabbed-page path has no `logAppLaunched`.

**Payload (SearchResults branch):** Same set as `collections_viewed`, plus `name` set to `specialPageName`.

**Payload (TabbedPage branch):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `source` | `TabbedPageProperties.SOURCE` | String | Always | — | Enum `HS` or `OTHERS` |

**Quirks:** Two disjoint call paths.

---

### `recent_collections_viewed`

**Android method:** None — declared at `AnalyticsEvents.java:63` but no call sites.
**Event constant:** `AnalyticsEvents.RECENT_COLLECTIONS_VIEWED`
**Payload:** N/A (dead event).
**Quirks:** Defined but never emitted — do not implement.

---

### `promo_products_viewed`

**Android method:** `logPromoProductsViewedEvent(promoPLPSegmentEvents)` - `ProductListPageActivity.java:2628` (fires line 2652).
**Event constant:** `AnalyticsEvents.PROMO_PRODUCTS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Guards itself with `firedViewedEvent` (fires once).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Optional | — | From intent extra |
| `promo_code` | `PROMO_CODE` | String | Optional | — | `promoPLPSegmentEvents.promotionCode` if non-empty |
| `merch_promo` | `MERCH_PROMO` | String | Optional | — | `"Yes"`/`"No"` from `isMerchRule` |
| `plp` | `PLP` | String | Optional | — | `"Promo" + promotionId` if non-empty |
| `plp_name` | `PLP_NAME` | String | Optional | — | `promoPLPSegmentEvents.promotionName` if non-empty |
| `plp_type` | `PLP_TYPE` | String | Always | `"Promotion products"` | Hard-coded literal |

---

### `offers_viewed`

**Android method:** `logOffersViewedEvent(items)` - `ui/promos/ui/PromosActivity.kt:424` (fires line 436, via `logAnalyticsEvent`).
**Event constant:** `AnalyticsEvents.OFFERS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true` (via `logAnalyticsEvent` — identical to `logEvent` minus `timestamp`).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `offer_card_count` | `OFFER_CARD_COUNT` | int? | Always (key) | — | `items?.size` |
| `promo_code` | `PROMO_CODE` | String? | Always (key) | — | First item's `promoCode` |
| `merch_promo` | `MERCH_PROMO` | String | Always | — | `"Yes"` if first item's `merchRule == true`, else `"No"` |
| `promotion_discount` | `PROMOTION_DISCOUNT` | int? | Always (key) | — | First item's `saving` |
| `total_amount` | `TOTAL_AMOUNT` | int | Always | — | `cartTotalAmount` |
| `promo_codes` | `PROMO_CODES` | List<String?>? | Always (key) | — | All items' `promoCode` values |
| `from_screen` | `FROM_SCREEN` | String | Always | — | `"Cart"` if `cartTotalAmount != 0`, else `"Product details"` |
| `product_id` | `PRODUCT_ID` | int | Optional | — | Only if `productId != 0` |

**Quirks:** Uses `logAnalyticsEvent` (not `logEvent`) — no `timestamp` is added.

---

### `bestsellers_viewed`

**Android method:** `logViewedEvent(...)` — branch when `PAGE_NAME == Constants.PAGE_BESTSELLERS` - `SearchResultsShowingBoutiquesActivity.java:822` (fires line 824).
**Event constant:** `AnalyticsEvents.BESTSELLERS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.BESTSELLERS)`.

**Payload:** Same set as `collections_viewed` (intent-driven keys, with `name = specialPageName`).

---

### `upcoming_collections_viewed`

**Android method:** `logViewedEvent(...)` — branch when `isUpcomingBoutiques == true` - `SearchResultsShowingBoutiquesActivity.java:825` (fires line 827).
**Event constant:** `AnalyticsEvents.UPCOMING_COLLECTIONS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.UPCOMING)`.

**Payload:** Same set as `collections_viewed`.

---

### `plp_genie_icon_clicked`

**Android method:** Inline click listener on genie icon - `ProductListPageActivity.java:978` (fires line 980).
**Event constant:** `AnalyticsEvents.PLP_GENIE_ICON_CLICKED`
**logEvent flags:** `attribution=true`, `universal=false`

**Payload:** Empty — only common time/attribution properties.

**Quirks:** Only PLP event using `universal=false`. No event-specific properties.

---

### `plp_collection_clicked`

**Android method:** Fired from product-list response callback after collection chip tapped - `ProductListPageActivity.java:1996` (fires line 2009).
**Event constant:** `AnalyticsEvents.PLP_COLLECTION_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Optional | — | `productsDeeplinkId` if non-zero |
| `collection_name` | `COLLECTION_NAME` | String | Optional | `""` | Name of selected collection |
| `collection_count` | `COLLECTION_COUNT` | int | Optional | — | `plpCollections.size() - 1` (excludes "All") |
| `product_count` | `PRODUCT_COUNT` | int | Always | — | `productListResponse.totalRecords` |

**Quirks:** Fires AFTER new collection products load (success callback), gated by `currentCollectionPosition > 0 && collectionClicked`.

---

### `plp_collections_expanded`

**Android method:** Inline click listener on collections bar - `ProductListPageActivity.java:999` (fires line 1007).
**Event constant:** `AnalyticsEvents.PLP_COLLECTIONS_EXPANDED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Optional | — | `productsDeeplinkId` if non-zero |
| `collection_count` | `COLLECTION_COUNT` | int | Optional | — | `plpCollections.size() - 1` if `> 0`, else `0` |

---

### `plp_collection_zero_products`

**Android method:** Fired when search PLP returns no records but collections exist - `ProductListPageActivity.java:2462` (fires line 2473).
**Event constant:** `AnalyticsEvents.PLP_COLLECTION_ZERO_PRODUCTS`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `collection_name` | `COLLECTION_NAME` | String | Always | `""` | Current collection's name |
| `filters` | `FILTERS` | Collection<Object> | Always | — | `filterParam.values()` — Collection (not List) |
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Always | — | `productsDeeplinkId` (no zero-check) |

**Quirks:** `filters` is `LinkedHashMap.values()` — `Collection<Object>` on the wire (JSON array).

---

### `plp_collection_more_products_loaded`

**Android method:** Fired when "view more" wrapper item is added during pagination - `ProductListPageActivity.java:3429` (fires line 3442).
**Event constant:** `AnalyticsEvents.PLP_COLLECTIONS_VIEW_MORE_VIEWED` (wire: `"plp_collection_more_products_loaded"`)
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_listing_id` | `PRODUCT_LISTING_ID` | int | Optional | — | `productsDeeplinkId` if non-zero |
| `collection_name` | `COLLECTION_NAME` | String | Optional | `""` | Current collection's name |
| `collection_count` | `COLLECTION_COUNT` | int | Optional | — | `plpCollections.size()` (raw size — NOT minus 1 unlike other plp_collection events) |
| `product_count` | `PRODUCT_COUNT` | int | Always | — | `response.totalRecords` |

**Quirks:** `collection_count` uses raw `.size()` here while `plp_collection_clicked` and `plp_collections_expanded` use `size() - 1`.

---

### `smart_filter_applied`

**Android method:** `logSmartFilterAppliedEvent(name, productListingName, subProperties, sfRule, feedSize)` - `ProductListPageActivity.java:3018` (fires line 3072).
**Event constant:** `AnalyticsEvents.SMART_FILTER_APPLIED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `plp_type` | `PLP_TYPE` | String | Optional | — | `plpTypeText` if non-empty |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | Only when `plpType == "Product list page"` |
| `plp_name` | `PLP_NAME` | String | Optional | — | `name` or `getPlpName()`, only when `plpType != "Product list page"` |
| `from_feed_size` | `FROM_FEED_SIZE` | int | Always | `0` | `totalCount` (or 0 if `-1`) |
| `feed_size` | `FEED_SIZE` | int | Always | — | `feedSize` arg (or 0 if `totalCount == -1`) |
| `sf_name` | `SF_NAME` | String | Optional | — | From `subProperties` map |
| `sf_segment` | `SF_SEGMENT` | String | Optional | — | From `subProperties` map |
| `sf_count` | `SF_COUNT` | String | Optional | — | From `subProperties` map (typed as String) |
| `sf_position` | `SF_POSITION` | String | Optional | — | From `subProperties` map |
| `sf_segment_order` | `SF_SEGMENT_ORDER` | String | Optional | — | From `subProperties` map |
| `sf_segment_position` | `SF_SEGMENT_POSITION` | String | Optional | — | From `subProperties` map |
| `sf_applied` | `SF_APPLIED` | List | Optional | — | `appliedSF` if non-empty |
| `sf_applied_count` | `SF_APPLIED_COUNT` | int | Always (if subProperties) | `1` | `1 + appliedSF.size()` |
| `sf_rule` | `SF_RULE` | String | Optional | — | If non-empty |

**Quirks:** `sf_count` / `sf_position` etc. arrive as Strings because `subProperties` map is `Map<String, String>`.

---

### `filter_clicked`

**Android method:** `logFilterClickedEvent(plpName, feedSize, boutiqueName, productListingName, plpType, clickSource)` - `AnalyticsHelper.java:612`.
**Event constant:** `AnalyticsEvents.FILTER_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `plp_type` | `PLP_TYPE` | String | Optional | — | If non-empty |
| `plp_name` | `PLP_NAME` | String | Optional | — | Only when `plpType != "Product list page"` |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | Only when `plpType == "Product list page"` |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | If non-empty |
| `click_source` | `CLICK_SOURCE` | String | Optional | — | E.g. `"standard_filters"`, `"floating_filter"`, `"sticky_filter"`, `"genie_filter"` |
| `feed_size` | `FEED_SIZE` | int | Optional | — | If `> 0` |

---

### `filter_applied`

**Android method:** `logFilterAppliedEvent(plpName, feedSize, boutiqueName, productListingName, plpType, fromScreen, clickSource, filterSegment, isFilterCleared)` - `AnalyticsHelper.java:637` (fires `FILTER_APPLIED` at line 666 when `isFilterCleared=false`).
**Event constant:** `AnalyticsEvents.FILTER_APPLIED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Optional | — | If non-empty |
| `plp_type` | `PLP_TYPE` | String | Optional | — | If non-empty |
| `click_source` | `CLICK_SOURCE` | String | Optional | — | If non-empty |
| `plp_name` | `PLP_NAME` | String | Optional | — | Only when `plpType != "Product list page"` |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | Only when `plpType == "Product list page"` |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | If non-empty |
| `feed_size` | `FEED_SIZE` | int | Optional | — | If `> 0` |
| `filter_section` | `FILTER_SECTION` | List<String> | Optional | — | Names of sections with selected attributes |
| `filter_section_count` | `FILTER_SECTION_COUNT` | int | Optional | — | Count; only if `> 0` |
| `filter_attribute` | `FILTER_ATTRIBUTE` | List<String> | Optional | — | Selected attribute values |
| `filter_attribute_count` | `FILTER_ATTRIBUTE_COUNT` | int | Optional | — | Total selected; only if `> 0` |
| `non_preorder_filter` | `NON_PREORDER_FILTER` | String | Always | — | `"Yes"`/`"No"` |
| (filter segment map entries) | (varies) | List<String> | Optional | — | **Spread directly into top-level properties** — keys are filter section names verbatim (e.g. `"Brand": ["Nike"]`) |

**Quirks:**
- `filterSegment` is `HashMap<String, Object>` whose entries get **spread into the top-level event properties** via `properties.putAll(filterSegment)` — NOT nested under a single key.
- Per-rule keys on the wire are the filter section names verbatim (whatever the API returns).

---

### `filter_cleared`

**Android method:** Same `logFilterAppliedEvent(...)` — branch when `isFilterCleared==true` - `AnalyticsHelper.java:664`.
**Event constant:** `AnalyticsEvents.FILTER_CLEARED`
**logEvent flags:** `attribution=false`, `universal=true` (note: different from `filter_applied`)

**Payload:** Identical structure to `filter_applied` (same property set, reduced filter segment map).

**Quirks:** Only differences from `filter_applied` are the event name and `attribution=false`.

---

### `sorting_applied`

**Android method:** `logSortingAppliedEvent(plpName, boutiqueName, name, plpType, fromSort, newSort)` - `AnalyticsHelper.java:670`.
**Event constant:** `AnalyticsEvents.SORTING_APPLIED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `plp_type` | `PLP_TYPE` | String | Always | — | Always set |
| `plp_name` | `PLP_NAME` | String | Optional | — | Only when `plpType != "Product list page"` |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | Only when `plpType == "Product list page"` |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | If non-empty |
| `from_sort` | `FROM_SORT` | String | Optional | — | Previous sort selection |
| `new_sort` | `NEW_SORT` | String | Optional | — | Newly selected sort |

---

### `sortbar_changed`

**Android method:** `logSortBarChangedEvent()` - `fragment/homepage/CollectionsFragment.kt:1921` (fires line 1932).
**Event constant:** `AnalyticsEvents.SORTBAR_CHANGED`
**logEvent flags:** `attribution=true`, `universal=false`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Always | — | Hard-set to `R.string.discover` ("Discover") |
| `from_location` | `FROM_LOCATION` | String | Always | — | `fromSortLocation` — `recently_selected_sort` or sort tile/group context |
| `from_sortbar` | `FROM_SORTBAR` | String | Optional | — | Previous sortbar name; only if non-empty |

**Quirks:** This is a **Discover/homepage** event (not PLP), despite living in `AnalyticsEvents`. Only call site is the homepage `CollectionsFragment`.

---

### `pincode_check_clicked`

**Android method:** `logPincodeClickedEvent()` - `activity/ProductDetailPageActivityNew.java:4099` (fires line 4107).
**Event constant:** `AnalyticsEvents.PINCODE_CHECK_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Always | — | `AnalyticsDefaults.PRODUCT_DETAILS` (`"Product details"`) |
| `from_pincode` | `FROM_PINCODE` | String | Always | — | `"standard"` if no current pincode, else `mProductDetailResponse.pinCode` |

**Quirks:** This is a **PDP** event (tap on PDP pincode UI). Matching `pincode_checked` is the API response handler.

---

### `pincode_checked`

**Android method:** `logPincodeCheckedEvent(plpName, boutiqueName, productListingName, plpType, fromPincode, pincode)` - `AnalyticsHelper.java:795`. Single caller: `features/plpfilters/ui/activity/FiltersActivity.java:204` inside `onServicablePincodeEntered(...)`.
**Event constant:** `AnalyticsEvents.PINCODE_CHECKED`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Always | — | Hard-coded literal `"Filter"` |
| `plp_type` | `PLP_TYPE` | String | Optional | — | If non-empty |
| `plp_name` | `PLP_NAME` | String | Optional | — | Only when `plpType != "Product list page"` |
| `product_listing_name` | `PRODUCT_LISTING_NAME` | String | Optional | — | If non-empty (no plpType gate here) |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | If non-empty |
| `from_pincode` | `FROM_PINCODE` | String | Optional | — | Previous pincode |
| `pincode` | `PINCODE` | String | Optional | — | Newly entered pincode |

**Quirks:** Distinguishing from `pincode_check_clicked`:
- `pincode_check_clicked` = user tapped PDP pincode UI (intent).
- `pincode_checked` = filter screen received successful serviceability response (result).
- `from_screen` hard-set to `"Filter"`.

---

### `brand_followed`

**Android method:** `logBrandFollowed(followed, fromScreen, boutiqueId, boutiqueBrandName, boutiqueName)` — branch when `followed==true` - `AnalyticsHelper.java:693` (fires line 710).
**Event constant:** `AnalyticsEvents.BRAND_FOLLOWED`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Optional | — | If non-empty |
| `boutique_id` | `BOUTIQUE_ID` | int | Optional | — | If `> 0` |
| `brand` | `BRAND` | String | Optional | — | `boutiqueBrandName` if non-empty |
| `boutique_name` | `BOUTIQUE_NAME` | String | Optional | — | Added under the same `!TextUtils.isEmpty(boutiqueBrandName)` guard as `brand` — **Android bug** |

**Quirks:** The `boutique_name` field is gated on `boutiqueBrandName` non-empty (not `boutiqueName`) — Android-side bug. Mirror for parity.

---

### `brand_unfollowed`

**Android method:** Same `logBrandFollowed(...)` — branch when `followed==false` - `AnalyticsHelper.java:712`.
**Event constant:** `AnalyticsEvents.BRAND_UNFOLLOWED`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:** Identical to `brand_followed`.

**Quirks:** Same `boutique_name`-gated-on-`boutiqueBrandName` bug applies.

---

### `product_listing_share_clicked`

**Android method:** None — declared at `AnalyticsEvents.java:74` but no call sites.
**Event constant:** `AnalyticsEvents.PRODUCT_LISTING_SHARE_CLICKED`
**Payload:** N/A (dead event on Android).
**Quirks:** Defined but never emitted — do not implement.

---

### `special_page_share_clicked`

**Android method:** `logSpecialPageShareClickedEvent()` - `SearchResultsShowingBoutiquesActivity.java:671` (fires line 676).
**Event constant:** `AnalyticsEvents.SPECIAL_PAGE_SHARE_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Always | — | Activity's `fromScreen` member |
| `name` | `NAME` | String | Always | — | `specialPageName` |
| `id` | `ID` | int | Always | — | `specialPageId` |

---

### `app_share_clicked`

**Android method:** `logAppShareClickedEvent(fromScreen)` - `AnalyticsHelper.java:789` (fires line 792). Single caller: `fragment/AccountFragment.kt:439` with `fromScreen = "Account"`.
**Event constant:** `AnalyticsEvents.APP_SHARE_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | Always | — | Caller-provided (always `"Account"` currently) |

**Quirks:** This is the Account-page "Share the app" event, not a PLP-area event despite being listed under "Sharing".

---

## Module: Cart / Checkout / Order placement

### `cart_viewed`

**Android method:** `logCartViewedEvent(...)` — `AnalyticsHelper.java:716-787` (hsapp legacy) and `CartAnalytics.fireCartViewedEvent(...)` — `CartAnalytics.kt:125-181` (hscart module via `CartEvents.SendCartViewedEvent`)
**Event constant:** `AnalyticsEvents.CART_VIEWED` = `"cart_viewed"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.SHOPPING_CART)` before firing (only fires `app_launched` if `LaunchTimer` not stopped). Sets `FirstCartLoad.firstCartLoad = false` after firing. May add `first_screen` common property if `Util.addFirstScreenProperty()` returns true.
**Fire frequency:** Once per cart screen entry.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | conditional | omitted if empty | e.g. `"Cart"` from `CartFragment.fromScreen` |
| `from_location` | `FROM_LOCATION` | String | conditional | omitted if empty | source of cart entry |
| `total_item_price` | `TOTAL_ITEM_PRICE` | Double | conditional | only included if `> 0` (hsapp); always set via `productAmount.zeroIfNull()` in hscart | `orderDetails.productAmount` |
| `total_amount` | `TOTAL_AMOUNT` | Double | conditional | hsapp gated on `totalQuantity > 0`; hscart always | `orderDetails.totalAmount` |
| `credit` | `CREDIT` | Double | conditional | hsapp gated on `credit > 0`; hscart always sets (zeroIfNull) | `orderDetails.totalCredit` |
| `shipping` | `SHIPPING` | Double | conditional | hsapp gated on `shipping > 0`; hscart always | `orderDetails.shipping` |
| `net_amount` | `NET_AMOUNT` | Double | conditional | hsapp gated on `totalQuantity > 0`; hscart always | `orderDetails.payAmount` |
| `sku_count` | `SKU_COUNT` | Int | conditional | hsapp gated on `skuCount > 0`; hscart always | `cart.cartItems.size` |
| `total_quantity` | `TOTAL_QUANTITY` | Int | conditional | hsapp gated on `> 0`; hscart always | `orderDetails.itemCount` |
| `message_bar` | `MESSAGE_BAR` | String | conditional | omitted if empty (hsapp); always set in hscart with `AnalyticsDefaults.NONE` fallback | message bar type (e.g. "Info", "Warning") |
| `cart_filler_reco` | `CART_FILLER_RECO` | String | conditional | hscart sends `"Yes"` if `totalAmount < shippingMinimum` else `"No"` | |
| `shipping_minimum` | `SHIPPING_MINIMUM` | Double | yes | always set | `shippingFeeInfo.shippingMinimum` |
| `quantity_status` | `QUANTITY_STATUS` | List<String> | conditional | hsapp only if non-empty; hscart always sends list | one per item: `"0"` (sold out), `"Lower"` (quantity > available), `"Available"` |
| `price_status` | `PRICE_STATUS` | List<String> | conditional | hsapp only if non-empty; hscart always | one per item: `"Same"`, `"Lower"` (Info messageType), `"Higher"` (Warning messageType) |
| `tti` | `TTI` | Long | yes | always set | time-to-interactive in ms since `Util.getCartClickedTime()` |
| `cart_view_state` | `CART_VIEW_STATE` | String | yes | `AnalyticsDefaults.NONE` if empty | `viewModel.cartViewState` |
| `first_load` | `FIRST_LOAD` | String | yes (hsapp only) | `"Yes"`/`"No"` from `FirstCartLoad.getFirstCartLoad()` | hsapp legacy only |
| `atc_user` | `ATC_USER` | String | conditional | hsapp adds via `AppRecordData.getATCUserType()` if non-empty | not set by hscart explicitly here |
| `image_url` | `IMAGE_URL` | List<String> | conditional | included only when non-empty | list of cart item image URLs |

**Quirks:** hscart variant always emits the numeric fields with zero defaults via `zeroIfNull()`, whereas hsapp version omits zero numeric fields. Empty-cart variant in hscart only sends `from_screen`, `from_location`, `cart_view_state`. `first_load` and `atc_user` only present in hsapp legacy flow.

---

### `product_added_to_cart`

**Android method:** `logAddToCartAnalyticsEvent(boolean isFromBuyNow)` — `ProductDetailPageActivityNew.java:3534-3563` (hsapp legacy PDP); `PDPAnalytics.sendEventProductAddedToCart()` — `PDPAnalytics.kt:330-341` (new components-module PDP)
**Event constant:** `AnalyticsEvents.PRODUCT_ADDED_TO_CART` = `"product_added_to_cart"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `facebookAppEventsHelper.logFacebookAddToCartEvent(sku, retailPrice, brandName, gender, productName)` separately on Facebook SDK (`ProductDetailPageActivityNew.java:1629` → `:3516-3532`). FB event uses `EVENT_NAME_ADDED_TO_CART` with `content_type=product`, `content_id=sku`, `currency=INR`, `_valueToSum=retailPrice`, `_value=retailPrice`, `description=productName`, `fb_brand`, `fb_gender`.
**Fire frequency:** Once per add-to-cart action.

**Payload (from `getEventPropertiesForBottomButton()` + ATC extras):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String/Int | yes | omitted if empty | `productDetailResponse.id` |
| `sku` | `SKU` | String | yes | omitted if empty | selected SKU id |
| `price` | `PRICE` | Float | yes | always | `mSku.retailPrice` |
| `mrp` | `MRP` | Double | yes | always | `mSku.regularPrice` |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | yes | always | `mSku.discount + "%"` (with literal `%` suffix) |
| `quantity` | `QUANTITY` | Int | yes | always | `mQty` |
| `subtotal` | `SUBTOTAL` | Double | yes | always | `mSku.retailPrice * mQty` |
| `delivery_date` | `DELIVERY_DATE` | String | conditional | only if non-null | formatted `yyyy-MM-dd hh:mm:ss` |
| `delivery_days` | `DELIVERY_DAYS` | Int | yes | always | `mSku.maxDeliveryDays` |
| `name` | `NAME` | String | conditional | omitted if empty | `mSku.productName` |
| `category` | `CATEGORY` | String | conditional | omitted if empty | |
| `subcategory` | `SUB_CATEGORY` | String | conditional | omitted if empty | |
| `product_type` | `PRODUCT_TYPE` | String | conditional | omitted if empty | |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | conditional | omitted if empty | |
| `brand` | `BRAND` | String | conditional | omitted if empty | `productDetailResponse.brandName` |
| `gender` | `GENDER` | String | conditional | omitted if empty | |
| `size_selection` | `SIZE_SELECTION` | String | conditional | omitted if `fromSelection` empty | how user picked size |
| `from_age` | `FROM_AGE` | Int | yes | always | `mSku.fromAge` |
| `to_age` | `TO_AGE` | Int | yes | always | `mSku.toAge` |
| `preorder` | `PRE_ORDER` | String | conditional | only set if `mSku.isPresale == 1` (value `"Yes"`) | not set otherwise |
| `sale` | `SALE` | String | conditional | only set if `mSku.onSale == 1` (value `"Yes"`) | not set otherwise |
| `size` | `SIZE` | String | yes | always | from `getColourOrSize("size")` |
| `colour` | `COLOUR` | String | yes | always | from `getColourOrSize("colour")` |
| `add_from_details` | `ADD_FROM_DETAILS` | String | yes | always | `localAddFromDetails` |
| `merch_type` | `MERCH_TYPE` | String | conditional | omitted if empty | `mSku.merchType` |
| `v_country` | `COUNTRY` | String | conditional | omitted if empty | `productDetailResponse.country` |
| `from_screen` | `FROM_SCREEN` | String | yes | `AnalyticsDefaults.PRODUCT_DETAILS` = `"Product details"` | |
| `atc_user` | `ATC_USER` | String | conditional | only if `AppRecordData.getATCUserType()` non-empty | |
| `image_count` | `IMAGE_COUNT` | Int | conditional | only if `> 0` | |
| `image_url` | `IMAGE_URL` | String | conditional | first image URL from `productDetailResponse.imgurls[0].imgUrlFull` | |
| `default_edd` | `DEFAULT_EDD` | Int | yes | always | `productDetailResponse.maxDeliveryDays` |
| `pincode` | `PINCODE` | String | yes | `AnalyticsDefaults.STANDARD` if `pinCode` empty | |
| `source` | `SOURCE` | String | yes | `"Buy now"` if `isFromBuyNow`, else `"Add to cart"` | `AnalyticsDefaults.BUYNOW`/`ADD_TO_CART` |
| `product_size` | `PRODUCT_SIZE` | String | conditional | only if `mSku.size` non-empty | |
| `redirected_from_shop_the_look` | (literal) | String | yes | `"Yes"`/`"No"` from intent extra | |
| `source_tile_type` | `SOURCE_TILE_TYPE` | String | yes | always | `sourceTileType` from intent |
| A+ properties | (added via `addAPlusProperties(false)`) | Map | conditional | aplus_* keys | |
| Tab page properties | (added via `addTabPageProperties(properties)`) | Map | conditional | tab_name, tab_position, tabbed_page_container_* | |
| Selected SKU attrs | (added via `addAttrsFromSelectedSku`) | various | conditional | `hbt`, `taste`, `style`, `season`, `pattern`, `character`, `weave` from attr map | |

**Quirks:** `discount_percentage` is a **String** with literal `"%"` suffix (e.g. `"50%"`). `preorder` and `sale` are only emitted when truthy — absence means false. New components PDP variant adds `aplus_usp_list` joined to comma-separated string (instead of list).

---

### `product_added_to_notifylist`

**Android method:** `logAddToNotifyMeList()` — `ProductDetailPageActivityNew.java:1791-1802`
**Event constant:** `AnalyticsEvents.PRODUCT_ADDED_TO_NOTIFY_LIST` = `"product_added_to_notifylist"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None (no FB / no app launched).
**Fire frequency:** Once when a not-yet-released product is reminded (upcoming boutique reminder set).

**Payload:** Uses the same `getEventPropertiesForBottomButton()` payload as `product_added_to_cart` above (lines `1804-1876`) — i.e. `product_id`, `sku`, `price`, `mrp`, `discount_percentage` (with `"%"`), `quantity`, `subtotal`, `delivery_date`, `delivery_days`, `name`, `category`, `subcategory`, `product_type`, `subproduct_type`, `brand`, `gender`, `size_selection`, `from_age`, `to_age`, `preorder` (only if 1), `sale` (only if 1), `size`, `colour`, `add_from_details`, `merch_type`, `v_country`, `from_screen` (`"Product details"`), `atc_user`, `image_count`, `image_url`, plus attribute map. **Does NOT** include the ATC-only extras: `default_edd`, `pincode`, `source`, `product_size`, `redirected_from_shop_the_look`, A+ properties, tab page properties, `source_tile_type`.

**Quirks:** Same `discount_percentage` `"%"` quirk. Payload is a true subset of ATC.

---

### `product_added_to_wishlist`

**Android method:** `logProductAddedToWishList(...)` — `AnalyticsHelper.java:1361-1500` (hsapp wide-signature variant); `CartAnalytics.logProductAddedToWishList(...)` — `CartAnalytics.kt:227-278` (cart move-to-wishlist)
**Event constant:** `AnalyticsEvents.PRODUCT_ADDED_TO_WISHLIST` = `"product_added_to_wishlist"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** Calls `facebookAppEventsHelper.logFacebookAddedToWishlistEvent(sku, retailPrice, brandName, gender)` after firing. FB `EVENT_NAME_ADDED_TO_WISHLIST` payload: `content_type=product`, `content_id=sku`, `currency=INR`, `_value=retailPrice`, `fb_brand`, `fb_gender`.
**Fire frequency:** Once per wishlist add.

**Payload (hsapp variant — gated by `hasSelectedSku`):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| (otherProperties spread first) | — | Map | conditional | only if non-null/non-empty | caller-supplied extras merged in first |
| `from_screen` | `FROM_SCREEN` | String | conditional | omitted if empty | |
| `from_location` | `FROM_LOCATION` | String | conditional | omitted if empty | e.g. `"Move to wishlist"` from cart |
| `product_id` | `PRODUCT_ID` | Int | conditional | only if `> 0` | |
| `sku` | `SKU` | String | conditional (sku branch) | only if `hasSelectedSku && exists` | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | conditional (sku branch) | `discountPercentage + "%"` | with `"%"` suffix |
| `quantity` | `QUANTITY` | Int | conditional (sku branch) | | |
| `subtotal` | `SUBTOTAL` | Double | conditional (sku branch) | | |
| `gender` | `GENDER` | String | conditional (sku branch) | omitted if empty | |
| `from_age` | `FROM_AGE` | Int | conditional (sku branch) | | |
| `to_age` | `TO_AGE` | Int | conditional (sku branch) | | |
| `colour` | `COLOUR` | String | conditional (sku branch) | omitted if empty | |
| `size` | `SIZE` | String | conditional (sku branch) | omitted if empty | |
| `taste` | `TASTE` | String | conditional (sku branch) | omitted if empty | |
| `hbt` | `HBT` | String | conditional (sku branch) | omitted if empty | |
| `price` | `PRICE` | Float | yes | always | `retailPrice` |
| `mrp` | `MRP` | Double | yes | always | `regularPrice` |
| `delivery_date` | `DELIVERY_DATE` | String | conditional | only if `deliveryDate != null` | formatted `yyyy-MM-dd hh:mm:ss` |
| `delivery_days` | `DELIVERY_DAYS` | Int | yes | always | |
| `name` | `NAME` | String | conditional | omitted if empty | |
| `category` | `CATEGORY` | String | conditional | omitted if empty | |
| `subcategory` | `SUB_CATEGORY` | String | conditional | omitted if empty | |
| `product_type` | `PRODUCT_TYPE` | String | conditional | omitted if empty | |
| `brand` | `BRAND` | String | conditional | omitted if empty | |
| `promo_applied_count` | `PROMO_APPLIED_COUNT` | Int | yes | always | |
| `preorder` | `PRE_ORDER` | String | yes | `"Yes"` if `isPresale` else `"No"` | always emitted |
| `sale` | `SALE` | String | yes | `"Yes"` if `onSale` else `"No"` | always emitted |
| `image_count` | `IMAGE_COUNT` | Int | yes | always | |
| `collection_name` | `COLLECTION_NAME` | String | conditional | omitted if empty | |
| `from_collection` | `FROM_COLLECTION` | String | yes | `"Yes"`/`"No"` | always emitted |
| `merch_type` | `MERCH_TYPE` | String | conditional | omitted if empty | |
| `add_from_details` | `ADD_FROM_DETAILS` | String | conditional | omitted if empty | |
| `v_country` | `COUNTRY` | String | conditional | omitted if empty | |
| `promo_codes` | `PROMO_CODES` | List<String> | conditional | only if non-null | |
| `atc_user` | `ATC_USER` | String | conditional | omitted if empty | |
| `image_url` | `IMAGE_URL` | String | conditional | only if non-null | |
| `style` | `STYLE` | String | conditional | omitted if empty | |
| `season` | `SEASON` | String | conditional | omitted if empty | |
| `pattern` | `PATTERN` | String | conditional | omitted if empty | |
| `character` | `CHARACTER` | String | conditional | omitted if empty | |
| `weave` | `WEAVE` | String | conditional | omitted if empty | |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | conditional | omitted if empty | |
| `source_tile_type` | `SOURCE_TILE_TYPE` | String | conditional | omitted if empty | |

**Quirks:** SKU-gated branch (`hasSelectedSku`) — without a selected SKU, many fields are dropped. `discount_percentage` has `"%"` suffix. Cart's move-to-wishlist variant always emits `from_location = "Move to wishlist"` and a different reduced set (no taste/hbt/style/season/pattern/character/weave).

---

### `product_removed_from_wishlist`

**Android method:** `logProductRemovedFromWishList(...)` — `AnalyticsHelper.java:1502-1542`
**Event constant:** `AnalyticsEvents.PRODUCT_REMOVED_FROM_WISHLIST` = `"product_removed_from_wishlist"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | conditional | omitted if empty | |
| `from_location` | `FROM_LOCATION` | String | conditional | omitted if empty | |
| `product_id` | `PRODUCT_ID` | Int | conditional | only if `> 0` | |
| `sku` | `SKU` | String | conditional | omitted if empty | |
| `category` | `CATEGORY` | String | conditional | omitted if empty | |
| `subcategory` | `SUB_CATEGORY` | String | conditional | omitted if empty | |
| `brand` | `BRAND` | String | conditional | omitted if empty | |
| `price_status` | `PRICE_STATUS` | List<String> or String | yes | `AnalyticsDefaults.NONE` if empty | list when populated, else `"none"` |
| `low_inventory` | `LOW_INVENTORY` | String | yes | `AnalyticsDefaults.NO` if empty | always emitted |

---

### `product_updated`

**Android method:** `CartAnalytics.logProductUpdatedEvent(...)` — `CartAnalytics.kt:92-123`
**Event constant:** `AnalyticsEvents.PRODUCT_UPDATED` = `"product_updated"` (components module)
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `CartFragment.fromScreen` | |
| `sku` | `SKU` | String | yes | `product.sku` | |
| `product_id` | `PRODUCT_ID` | Int | yes | `product.productId` | |
| `brand` | `BRAND` | String | yes | `product.brandName` | |
| `price` | `PRICE` | Double | yes | `product.price * oldQty` | total at old qty |
| `new_price` | `NEW_PRICE` | Double | yes | `product.price * product.quantity` | total at new qty |
| `quantity_status` | `QUANTITY_STATUS` | List<String> | yes | from `getQuantityStatus(product)` — `"0"`/`"Lower"`/`"Available"` | |
| `price_status` | `PRICE_STATUS` | List<String> | yes | from `getPriceStatus(product)` — `"Same"`/`"Lower"`/`"Higher"` | |
| `image_url` | `IMAGE_URL` | String | conditional | image of any other item in cart from `getAnyItemImageFromCartApartFrom` (excluding current) | |
| `quantity` | `QUANTITY` | Int | yes | `oldQty` | |
| `new_quantity` | `NEW_QUANTITY` | Int | conditional | only if `product.quantity != oldQty` | |

---

### `product_update_clicked`

**Android method:** `CartAnalytics.fireProductUpdateClicked(...)` — `CartAnalytics.kt:27-52`
**Event constant:** `AnalyticsEvents.PRODUCT_UPDATE_CLICKED` = `"product_update_clicked"`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `AnalyticsDefaults.FromScreens.SHOPPING_CART` = `"Cart"` | |
| `from_location` | `FROM_LOCATION` | String | yes | provided by caller (e.g. quantity-stepper location) | |
| `sku` | `SKU` | String | yes | | |
| `quantity` | `QUANTITY` | Int | yes | `product.quantity` | |
| `product_id` | `PRODUCT_ID` | Int | yes | | |
| `brand` | `BRAND` | String | yes | | |
| `price` | `PRICE` | Double | yes | `product.price` | |
| `quantity_status` | `QUANTITY_STATUS` | List<String> | yes | | |
| `price_status` | `PRICE_STATUS` | List<String> | yes | | |

---

### `promo_code_applied`

**Android method:** `logPromoCodeApplied(applied=true, ...)` — `AnalyticsHelper.java:1008-1036`; `CartAnalytics.logPromoCodeApplied(...)` — `CartAnalytics.kt:334-360`
**Event constant:** `AnalyticsEvents.PROMO_CODE_APPLIED` = `"promo_code_applied"`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload (hsapp variant):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Cart"` | |
| `total_item_price` | `TOTAL_ITEM_PRICE` | Double | yes | always | |
| `total_amount` | `TOTAL_AMOUNT` | Float | yes | always | |
| `from_shipping` | `FROM_SHIPPING` | Double | yes | always | `shipping` |
| `promo_applied_count` | `PROMO_APPLIED_COUNT` | Int | yes | always | |
| `item_discount` | `ITEM_DISCOUNT` | Double | yes | always | |
| `from_net_amount` | `FROM_NET_AMOUNT` | Double | yes | always | `netAmount` |
| `merch_promo` | `MERCH_PROMO` | String | yes | `"Yes"`/`"No"` | from `getPromoListData()` — true if matched promo is merch rule |
| `promo_code` | `PROMO_CODE` | List<String> | yes | list of all applied promo codes | from `getPromoListData()` |
| `promotion_discount` | `PROMOTION_DISCOUNT` | Double | conditional | only if `> 0` | from matched promo |
| `from_promo_code` | `FROM_PROMO_CODE` | String | conditional | only if non-null | |

---

### `promo_code_failed`

**Android method:** `logPromoCodeApplied(applied=false, ...)` — `AnalyticsHelper.java:1008-1036`
**Event constant:** `AnalyticsEvents.PROMO_CODE_FAILED` = `"promo_code_failed"`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:** Same as `promo_code_applied` minus `promotion_discount`, plus:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `failed_promo_code` | `FAILED_PROMO_CODE` | String | yes | the entered (rejected) code | |
| `promo_error` | `PROMO_ERROR` | String | conditional | only if non-empty | failure reason |

---

### `promo_code_removed`

**Android method:** `logPromoCodeRemoved(..., isSuccess=true, ...)` — `AnalyticsHelper.java:1038-1067`; `CartAnalytics.logPromoCodeRemoved(...)` — `CartAnalytics.kt:199-225`
**Event constant:** `AnalyticsEvents.PROMO_CODE_REMOVED` = `"promo_code_removed"`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Cart"` | |
| `promo_applied_count` | `PROMO_APPLIED_COUNT` | Int | yes | always | |
| `removed_promo_code` | `REMOVED_PROMO_CODE` | String | yes | the removed code | |
| `total_item_price` | `TOTAL_ITEM_PRICE` | Double | yes | always | |
| `total_amount` | `TOTAL_AMOUNT` | Float | yes | always | |
| `from_shipping` | `FROM_SHIPPING` | Double | yes | always | |
| `item_discount` | `ITEM_DISCOUNT` | Double | yes | always | |
| `from_net_amount` | `FROM_NET_AMOUNT` | Double | yes | always | |
| `merch_promo` | `MERCH_PROMO` | String | yes | `"Yes"`/`"No"` | |
| `promo_code` | `PROMO_CODE` | List<String> | yes | remaining applied codes | |
| `promotion_discount` | `PROMOTION_DISCOUNT` | Double | conditional | only if `> 0` | |

---

### `promo_removed_failed`

**Android method:** `logPromoCodeRemoved(..., isSuccess=false, ...)` — `AnalyticsHelper.java:1038-1067`
**Event constant:** `AnalyticsEvents.PROMO_REMOVED_FAILED` = `"promo_removed_failed"`
**logEvent flags:** `attribution=true`, `universal=true`

**Payload:** Same as `promo_code_removed` except `removed_promo_code` becomes `failed_promo_code` (`FAILED_PROMO_CODE`), plus `promo_error` (`PROMO_ERROR`, only if non-empty `error`).

---

### `buynow_clicked` (hsapp legacy)

**Android method:** `pdpBottomButtonClicked(view, isFromBuyNow=true)` — `ProductDetailPageActivityNew.java:768-797` (inline at lines 773-778)
**Event constant:** `AnalyticsEvents.BUYNOW_CLICKED` = `"buynow_clicked"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None for this event itself (it's the first event in the flow; the subsequent ATC follows via `addCartOrWishList(true)`).
**Fire frequency:** Once per Buy Now tap (before size validation).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `AnalyticsDefaults.PRODUCT_DETAILS` = `"Product details"` | hard-coded |
| `product_id` | `PRODUCT_ID` | Int | yes | `mProductId` | |

**Quirks:** Minimal payload — only screen + pid. The full product context arrives in the subsequent `product_added_to_cart` (source=`"Buy now"`).

---

### `buy_now_clicked` (components module — distinct event)

**Android method:** `PDPAnalytics.sendEventBuyNowClicked()` — `PDPAnalytics.kt:343-349`
**Event constant:** `AnalyticsEvents.BUY_NOW_CLICKED` (components-module) = `"buy_now_clicked"` — note underscore between `buy` and `now`, **different** from hsapp `buynow_clicked`

**logEvent flags:** routed through `GlobalObservers.analyticsHelper.send(...)`; flags depend on `AnalyticsEvent.SendEvent` configuration (no explicit `attribution`/`universal` set at call site).

**Payload:** all keys from `pdpPageProperties()` map plus color tracking meta via `addColorTrackingMeta(properties)`:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `product_id` | `PRODUCT_ID` | String/Int | yes | `product.id` | |
| `image_url` | `IMAGE_URL` | String | conditional | first media URL | |
| `category` | `CATEGORY` | String | conditional | `trackingMeta.categoryName` | |
| `subcategory` | `SUB_CATEGORY` | String | conditional | `trackingMeta.subcategoryName` | |
| `product_type` | `PRODUCT_TYPE` | String | conditional | `trackingMeta.productTypeName` | |
| `subproduct_type` | `SUB_PRODUCT_TYPE` | String | conditional | `trackingMeta.subProductTypeName` | |
| `country_of_origin` | `COUNTRY_OF_ORIGIN` | String | conditional | `trackingMeta.countryOfOrigin` | |
| `brand` | `BRAND` | String | conditional | | |
| `gender` | `GENDER` | String | conditional | | |
| `from_age` | `FROM_AGE` | Int | conditional | | |
| `to_age` | `TO_AGE` | Int | conditional | | |
| `mrp` | `MRP` | Double | conditional | | |
| `price` | `PRICE` | Double | conditional | | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | Number | conditional | from `price.discount?.toNumericDouble()` — **no `"%"` suffix here** (numeric) | |
| `aplus_*` | (A+ keys) | various | conditional | added via `addAPlusProperties` | |
| color tracking meta | various | various | conditional | merged via `addColorTrackingMeta(properties)` | |
| `trackingMeta.extras` | various | various | conditional | spread if non-empty | |

**Quirks:** `buy_now_clicked` (with underscore) is from the **new components-module PDP** — distinct from `buynow_clicked` (no underscore) in the **legacy hsapp PDP**. Both can fire from different code paths; downstream pipelines must treat as different events. Components-module emits richer payload (full PDP page properties); legacy emits only `from_screen` + `product_id`.

---

### `checkout_clicked`

**Android method:** `logCheckoutClickedEvent(boolean isFromBuyNow)` — `AnalyticsHelper.java:871-889`
**Event constant:** `AnalyticsEvents.CHECKOUT_CLICKED` = `"checkout_clicked"`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Calls `CheckoutTimerHelper.updateFirstEventTime()` **before** firing — this resets `firstEventTime = lastEventTime = now()`, starting the per-checkout step clock. Subsequent checkout-funnel events use `step_duration` (time since last event) and `total_duration` (time since `checkout_clicked`).
**Fire frequency:** Once per checkout button tap.

**Payload:** All keys from `getCheckoutEventProperties()` (see below) plus:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Cart"` (hard-coded) | |
| `checkout_user` | `CHECKOUT_USER` | String | conditional | only if `AppRecordData.getCheckoutFlowUserType()` non-empty | |
| `atc_user` | `ATC_USER` | String | conditional | only if `AppRecordData.getUserType()` non-empty | |
| `source` | `SOURCE` | String | yes | `"Buy now"` if `isFromBuyNow` else `"Cart"` | |
| `step_duration` | `STEP_DURATION` | Long | yes | hard-coded `0` (first event in funnel) | |
| `total_duration` | `TOTAL_DURATION` | Long | yes | hard-coded `0` | |

**`getCheckoutEventProperties()` (`AnalyticsHelper.java:921-985`) adds — from cached `Util.getShoppingBagResponse()`:**

| Property key (wire) | Constant | Type | Notes |
|---|---|---|---|
| `total_item_price` | `TOTAL_ITEM_PRICE` | Double | `orderDetails.productAmount` |
| `total_amount` | `TOTAL_AMOUNT` | Double | `orderDetails.totalAmount` |
| `discount` | `DISCOUNT` | Long | `Math.round(orderDetails.discount)` — rounded int |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | String | `orderDetails.discountPercentage + "%"` (with `"%"` suffix) |
| `shipping` | `SHIPPING` | Double | `orderDetails.shipping` |
| `net_amount` | `NET_AMOUNT` | Double | `orderDetails.payAmount` |
| `total_quantity` | `TOTAL_QUANTITY` | Int | `orderDetails.itemCount` |
| `flow` | `FLOW` | String | `AnalyticsDefaults.REGULAR` = `"regular"` |
| `sku_count` | `SKU_COUNT` | Int | `cartItems.size` |
| `promo_code` | `PROMO_CODE` | String | from applied `PromoItem.code` (first matching applied) |
| `promotion_discount` | `PROMOTION_DISCOUNT` | String | from applied `PromoItem.discount` as string |
| `product_id` | `PRODUCT_ID` | List<Int> | list of `cartItems[i].productId` |
| `product_category` | `PRODUCT_CATEGORY` | List<String> | list of `cartItems[i].categoryName` |
| `price_status` | `PRICE_STATUS` | List<String> | per-item: `"Same"` / `"Lower"` (Info messageType) / `"Higher"` (Warning messageType) |
| `checkout_user` | `CHECKOUT_USER` | String | conditional, redundant with above |
| `timestamp` | `TIMESTAMP` | String | ISO8601 |

**Quirks:** `discount_percentage` always has `"%"` suffix here too. `discount` is rounded to integer via `Math.round`. `step_duration` and `total_duration` are hard-coded `0` for this event since `updateFirstEventTime()` runs **after** them being set in the properties map.

---

### `checkout_failed`

**Android method:** `logCheckoutEvent(isFromBuyNow, isCheckoutStarted=false, error)` — `AnalyticsHelper.java:891-906`
**Event constant:** `AnalyticsEvents.CHECKOUT_FAILED` = `"checkout_failed"`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:** All keys from `getCheckoutEventProperties()` (above) plus:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `flow` | `FLOW` | String | yes | `"regular"` | (already set by getCheckoutEventProperties, overwritten) |
| `error` | `ERROR` | String | conditional | only if non-empty | |
| `source` | `SOURCE` | String | yes | `"Buy now"` / `"Cart"` | |
| `from_screen` | `FROM_SCREEN` | String | yes | `"Cart"` | |
| `atc_user` | `ATC_USER` | String | conditional | from `addUserType()` merge | |
| `checkout_user` | `CHECKOUT_USER` | String | conditional | from `addUserType()` merge | |
| `step_duration` | `STEP_DURATION` | Long | yes | from `addUserType()` → `CheckoutTimerHelper.getTimeSinceLastEvent(true)` — time since last event in ms, resets last-event marker | |
| `total_duration` | `TOTAL_DURATION` | Long | yes | from `addUserType()` → `CheckoutTimerHelper.getTimeSinceFirstEvent()` — time since `checkout_clicked` in ms | |

**`addUserType()` quirk:** `AnalyticsHelper.java:908-919` — merges `atc_user`, `checkout_user`, `step_duration` (with `updateWithCurrentTime=true` side effect: also advances `lastEventTime`), `total_duration`.

---

### `checkout_started`

**Android method:** `logCheckoutEvent(isFromBuyNow, isCheckoutStarted=true, error)` — `AnalyticsHelper.java:891-906`. Also routed via `CheckoutObserver.LogCheckoutStarted` — `CheckoutObserver.kt:134-136`.
**Event constant:** `AnalyticsEvents.CHECKOUT_STARTED` = `"checkout_started"`
**logEvent flags:** `attribution=false`, `universal=true`

**Payload:** Identical to `checkout_failed` minus `error` (error only included when `!isCheckoutStarted`).

---

### `checkout_mobile`

**Android method:** RN-bridge `checkoutMobileEvent(response, fromScreen, validationError, eventName, screenRef)` — `index.android.bundle:104632-104667` with `analyticsEventName = SegmentEvents.CHECKOUT_MOBILE`.

**Note:** The RN bridge forwards via `HSEventBridge.triggerEventWithInfo` → `ReactToNativeEvents.SEGMENT_EVENT` → native side calls `AnalyticsHelper.logEvent(...)`. Native CheckoutObserver also catches `LogCheckoutEvents` → adds `getCartProperty()` + `addCommonCartProperties()` + `addUserTypeAndDuration(reset)` before firing (`CheckoutObserver.kt:137-146`).

**Event constant:** `SegmentEvents.CHECKOUT_MOBILE` = `"checkout_mobile"`

**logEvent flags (from CheckoutObserver path):** `attribution=false`, `universal=false`. Note: the SegmentEvent path in CheckoutObserver:91-93 uses `attribution=true, universal=true` if the event arrives via `SegmentEvent`. Two paths exist.

**Side effects:** `addUserTypeAndDuration(reset)` merge — adds `atc_user`, `checkout_user`, `step_duration`, `total_duration`, `background_time`. If `backgroundDuration > 0`, resets background timer after read.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Checkout Mobile"` or `"Checkout Review"` | passed by caller |
| `message_count` | `MESSAGE_COUNT` | Int | conditional | only if `response.messageBars` non-null and `length > 0` | |
| `error` | `ERROR` | String | yes | from `response.message`; overridden by `response.messageBar.message` if present | |
| `message_bar` | `MESSAGE_BAR` | List<String> | conditional | only if non-empty | from `addMessageBar(response)` |
| `mobile` | `MOBILE` | String | conditional | from `response.mobile.number` (or raw `response.mobile`) | |
| `validation_error` | `VALIDATION_ERROR` | String | yes | passed by caller | |
| **+ cart enrichment** | — | — | — | from `CheckoutObserver.getCartProperty()` — discount, discount_percentage, shipping, promo_code, promotion_discount | |
| **+ common cart properties** | — | — | — | total_item_price, total_amount, net_amount, total_quantity, sku_count, promo_code | |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(reset)` | |

---

### `checkout_mobile_failed`

**Android method:** Same RN bridge `checkoutMobileEvent(...)` with `analyticsEventName = SegmentEvents.CHECKOUT_MOBILE_FAILED`.
**Event constant:** `"checkout_mobile_failed"`
**Payload:** Identical to `checkout_mobile`. `validation_error` and `error` are typically populated on the failure path.

---

### `checkout_review`

**Android method:** `CheckoutAnalytics.logCheckoutReview(isReviewStarted=true, ...)` — `CheckoutAnalytics.kt:112-145`
**Event constant:** `CheckoutAnalytics.Events.CHECKOUT_REVIEW` = `"checkout_review"`
**logEvent flags (CheckoutObserver pathway):** `attribution=false`, `universal=false`
**Side effects:** `addUserTypeAndDuration(reset=isReviewStarted)` merge in CheckoutObserver (`atc_user`, `checkout_user`, `step_duration`, `total_duration`, `background_time`); also merges cart enrichment from `getCartProperty()` and `addCommonCartProperties()`.

**Payload (from CheckoutAnalytics):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Checkout Review"` | |
| `message` | `MESSAGE` | String | yes (null allowed) | passed by caller | |
| `delivery_city` | `DELIVERY_CITY` | String | conditional | from `response.address.city` | |
| `state` | `STATE` | String | conditional | from `response.address.state` | |
| `pincode` | `PINCODE` | String | conditional | first set to `address.zipCode`, then **overwritten** to `"Yes"`/`"No"` based on `canCod` (bug in source — see Quirks) | |
| `delivery_available` | `DELIVERY_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `address.isServicable` | |
| `cod_available` | `COD_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `address.canCod` | |
| `payment_mode` | `PAYMENT_MODE` | String | conditional | from `paymentDetails.paymentMode`; **not set** if mode is `"POL"` | |
| `source` | `SOURCE` | String | conditional | `"buynow"` only if `isFromBuyNow == true` | |
| `message_count` | `MESSAGE_COUNT` | Int/String | yes | `checkMessageBars()` → `"1"` (single), `size` (multi), or `"0"` | |
| `message_bar` | `MESSAGE_BAR` | Array/String | yes | array of messages or `"none"` | |
| **+ cart enrichment** | — | — | — | from `getCartProperty()` + `addCommonCartProperties()` | discount, shipping, promo_code, total_item_price, total_amount, net_amount, total_quantity, sku_count |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(reset)` | reset=`true` for success, `false` for failed |

**Quirks:** Source line `CheckoutAnalytics.kt:128` overwrites `pincode` with `canCod`-based Yes/No string — appears to be a latent bug; pincode value lost when canCod is set.

---

### `checkout_review_failed`

**Android method:** `CheckoutAnalytics.logCheckoutReview(isReviewStarted=false, ...)` — `CheckoutAnalytics.kt:112-145`
**Event constant:** `CheckoutAnalytics.Events.CHECKOUT_REVIEW_FAILED` = `"checkout_review_failed"`
**Payload:** Same shape as `checkout_review`. `addUserTypeAndDuration(reset=false)` — does not advance `lastEventTime`.

---

### `checkout_delivery`

**Android method:** RN-bridge `checkoutDeliveryEvent(result, fromScreen, defaultAddress, addressType, fromPinCode, fromAddress, eventName, screenRef)` — `index.android.bundle:104668-104717` with `analyticsEventName = SegmentEvents.CHECKOUT_DELIVERY`. Goes through `SegmentEvent` → `CheckoutObserver.kt:91-93` → `attribution=true, universal=true`.

**Event constant:** `SegmentEvents.CHECKOUT_DELIVERY` = `"checkout_delivery"`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | passed by caller (e.g. `"Checkout Ship"`, `"Checkout Review"`) | |
| `default_address` | `DEFAULT_ADDRESS` | String | yes | `"Available"`/`"Not available"` | `.toString()` of arg |
| `pincode` | `PINCODE` | String | yes | from `result.zipCode` | |
| `address` | `ADDRESS` | String | yes | `"Default"`, `"New"` etc. | `.toString()` of `addressType` arg |
| `delivery_city` | `DELIVERY_CITY` | String | yes | `result.city` | |
| `from_pincode` | `FROM_PINCODE` | String | yes | passed by caller | |
| `from_address` | `FROM_ADDRESS` | String | yes | passed by caller | |
| `delivery_available` | `DELIVERY_AVAILABLE` | String | yes | `"Yes"`/`"No"` from `result.isServicable` | |
| `cod_available` | `COD_AVAILABLE` | String | yes | `"Yes"`/`"No"` from `result.canCod` | |
| `pol_available` | `POL_AVAILABLE` | String | yes | `"Yes"`/`"No"` from `result.canPol` | |
| `message_count` | `MESSAGE_COUNT` | Int | conditional | only if `messageBars` non-empty | |
| `message_bar` | `MESSAGE_BAR` | List | conditional | only if non-empty | |
| `error` | `ERROR` | String | conditional | only if non-null | from `getErrorMessage(result)` |
| `validation_error` | `VALIDATION_ERROR` | String | conditional | only if non-null | |

**Quirks:** Note `SegmentEvent` path on CheckoutObserver uses `attribution=true, universal=true` (different from other checkout events).

---

### `checkout_delivery_failed`

**Android method:** Same RN bridge with `analyticsEventName = SegmentEvents.CHECKOUT_DELIVERY_FAILED`.
**Event constant:** `"checkout_delivery_failed"`
**Payload:** Identical to `checkout_delivery`. Error/validation_error typically populated on failure.

---

### `checkout_payment`

**Android method:** `CheckoutAnalytics.logCheckoutPayment(isPaymentStarted=true, ...)` — `CheckoutAnalytics.kt:180-203`. RN bridge variant: `firePaymentEvent(segmentData, screenRef)` — `index.android.bundle:104959-104989`.
**Event constant:** `CheckoutAnalytics.Events.CHECKOUT_PAYMENT` = `"checkout_payment"`
**logEvent flags (CheckoutObserver pathway):** `attribution=false`, `universal=false`
**Side effects:** `addUserTypeAndDuration(reset=true)` merge — `atc_user`, `checkout_user`, `step_duration`, `total_duration`, `background_time`.

**Payload (from CheckoutAnalytics):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Checkout Juspay"` | |
| `message` | `MESSAGE` | String | yes (nullable) | passed by caller | |
| `delivery_city` | `DELIVERY_CITY` | String | conditional | `address.city` | |
| `state` | `STATE` | String | conditional | `address.state` | |
| `pincode` | `PINCODE` | String | conditional | `address.zipCode` | |
| `delivery_available` | `DELIVERY_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `isServicable` | |
| `cod_available` | `COD_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `canCod` (set twice in source, no consequence) | |
| `message_count` | `MESSAGE_COUNT` | Int/String | yes | via `checkMessageBars()` | |
| `message_bar` | `MESSAGE_BAR` | Array/String | yes | via `checkMessageBars()` | |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(true)` | |
| **+ cart enrichment** | — | — | — | from `getCartProperty()` + `addCommonCartProperties()` | |

**RN bundle variant `firePaymentEvent` adds:** `from_screen`, `from_location`, `phone_verified_for_cod`, `can_cod`, `pincode`, `delivery_city`, `cod_available`, `payment_mode`, `card_pay_type`, `card_type`, `card`, `netbanking_bank`, `from_payment_mode`, `from_card`, `from_netbanking_bank`, `credit`, `loyalty_credit`, `message_count`, `message_bar` — depending on entry point (PayU/Juspay/UPI).

---

### `checkout_payment_failed`

**Android method:** `CheckoutAnalytics.logCheckoutPayment(isPaymentStarted=false, ...)`; RN: `firePaymentFailedEvent(segmentData, screenRef)` — `index.android.bundle:104990-105029`.
**Event constant:** `"checkout_payment_failed"`

**Payload (RN bundle variant — most complete):** `from_screen = "Checkout Pay"`, `from_location`, `pincode`, `delivery_city`, `cod_available`, `payment_mode`, `card_pay_type`, `card_type`, `card`, `netbanking_bank`, `from_payment_mode`, `from_netbanking_bank`, `from_card`, `credit`, `loyalty_credit`, `message_count`, `message_bar`, `validation_error` (array if non-empty else `"none"`), `error`. CheckoutAnalytics variant uses the same payload shape as `checkout_payment` plus `message` carrying the error string.

---

### `checkout_payment_viewed`

**Android method:** RN-bridge `firePaymentViewedEvent(segmentData, screenRef)` — `index.android.bundle:104839-104865`.
**Event constant:** `SegmentEvents.PAYMENT_VIEWED` = `"checkout_payment_viewed"`

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | passed by caller | |
| `from_location` | `FROM_LOCATION` | String | yes | passed by caller | |
| `phone_verified_for_cod` | `PHONE_VERIFIED_FOR_COD` | Bool | yes | | |
| `can_cod` | `CAN_COD` | Bool | yes | | |
| `pincode` | `PINCODE` | String | yes | | |
| `delivery_city` | `DELIVERY_CITY` | String | yes | | |
| `cod_available` | `COD_AVAILABLE` | Bool | yes | | |
| `isCodGokwikDisabled` | `IS_COD_GOKWIK_DISABLED` | Bool | yes | | |
| `from_payment_mode` | `FROM_PAYMENT_MODE` | String | yes | | |
| `from_card` | `FROM_CARD` | String | yes | | |
| `from_netbanking_bank` | `FROM_NETBANKING_BANK` | String | yes | | |
| `credit` | `CREDIT` | Int | yes | | |
| `loyalty_credit` | `LOYALTY_CREDIT` | Int | yes | | |
| `message_count` | `MESSAGE_COUNT` | Int/String | yes | | |
| `message_bar` | `MESSAGE_BAR` | Array/String | yes | | |

---

### `order_place_clicked`

**Android method:** `CheckoutAnalytics.logOrderPlaceClickedEvent(...)` — `CheckoutAnalytics.kt:72-99`. RN variant: `fireOrderPlaceClickEvent(segmentData, screenRef)` — `index.android.bundle:104748-104776`.
**Event constant:** `CheckoutAnalytics.Events.ORDER_PLACE_CLICKED` = `"order_place_clicked"`
**logEvent flags (CheckoutObserver pathway):** `attribution=false`, `universal=false`
**Side effects:** `addUserTypeAndDuration(reset=true)` merge.

**Payload (from CheckoutAnalytics):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `"Checkout Review"` | |
| `delivery_city` | `DELIVERY_CITY` | String | conditional | from `response.address.city` | |
| `state` | `STATE` | String | conditional | from `response.address.state` | |
| `pincode` | `PINCODE` | String | conditional | from `response.address.zipCode` | |
| `delivery_available` | `DELIVERY_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `isServicable` | |
| `cod_available` | `COD_AVAILABLE` | String | conditional | `"Yes"`/`"No"` from `canCod` | |
| `payment_mode_selected` | `PAYMENT_MODE_SELECTED` | String | yes | selected mode | |
| `cod_fee` | `COD_FEE` | Number | yes | from COD `chargeAdjustment` or `0` | |
| `quick_checkout_default_payment_suggested` | `QUICK_CHECKOUT_PAYMENT` | String | yes | `preSelectedPaymentMode` | |
| `payment_mode` | `PAYMENT_MODE` | String | conditional | only if `paymentMode != "POL"` | |
| `message_count` | `MESSAGE_COUNT` | Int/String | yes | from `checkMessageBars()` | |
| `message_bar` | `MESSAGE_BAR` | Array/String | yes | from `checkMessageBars()` | |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(true)` | |
| **+ cart enrichment** | — | — | — | from `getCartProperty()` + `addCommonCartProperties()` | |

**RN bundle `fireOrderPlaceClickEvent` adds:** `card`, `netbanking_bank`, `credit`, `loyalty_credit`, `cvvRequired` — entry point dependent.

---

### `order_placed`

**Android method:** `CheckoutObserver.logOrderPlacedEvent(response: OrderConfirmationResponse, fromRetry: Boolean)` — `CheckoutObserver.kt:174-240`
**Event constant:** `AnalyticsEvents.ORDER_PLACED` = `"order_placed"`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** Fires before `logProductOrderedEvent`, `logFacebookPurchaseEvent`, `logOrderCompletedEvent`. After: `AppRecordData.setIsOrderPaid(true)`, `AppRecordData.setSegmentUserType(null)`, `CartData.setCartQuantity(context, 0)`. Merges `addUserTypeAndDuration(reset=true)` — adds `atc_user`, `checkout_user`, `step_duration`, `total_duration`, `background_time` (with background timer reset if > 0).
**Fire frequency:** Once per successful order placement.

**Payload (from `OrderConfirmationResponse`):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `order_id` | `ORDER_ID` | Long/Int | conditional | from `response.orderDetails.orderId` | |
| `first_order` | `FIRST_ORDER` | String | conditional | only if `orderDetails.firstOrder == true`; value `"Yes"` | not set otherwise |
| `discount` | `DISCOUNT` | Double | conditional | from `orderDetails.discount` | |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | Number | conditional | from `orderDetails.discountPercentage` — **no `"%"` suffix here** (raw numeric, unlike cart events) | |
| `promotion_discount` | `PROMOTION_DISCOUNT` | Number | conditional | from `orderDetails.promoDiscount` | |
| `promo_code` | `PROMO_CODE` | String | conditional | from `orderDetails.promoCode` | |
| `total_amount` | `TOTAL_AMOUNT` | Double | conditional | from `orderDetails.totalAmount` | |
| `shipping` | `SHIPPING` | Double | conditional | from `orderDetails.shipping` | |
| `total_quantity` | `TOTAL_QUANTITY` | Int | conditional | from `orderDetails.totalQuantity` | |
| `total_item_price` | `TOTAL_ITEM_PRICE` | Double | conditional | from `orderDetails.productAmount` | |
| `net_amount` | `NET_AMOUNT` | Double | conditional | from `orderDetails.payAmount` | |
| `sku_count` | `SKU_COUNT` | Int | conditional | from `orderDetails.itemCount` | |
| `credit` | `CREDIT` | Double | conditional | from `orderDetails.totalCredit` | |
| `has_gift_pid` | `HAS_GIFT` | String | conditional | `"Yes"`/`"No"` from `orderSummary.hasGift` | only if `orderSummary` non-null |
| `payment_mode` | `PAYMENT_MODE` | String | conditional | `response.paymentDetails.paymentMethod`; **rewritten** from `"CARD"` to `"Card"` | |
| `delivery_city` | `DELIVERY_CITY` | String | conditional | `response.address.city` | |
| `state` | `STATE` | String | conditional | `response.address.state` | |
| `pincode` | `PINCODE` | String | conditional | `response.address.zipCode` | |
| `message_count` | `MESSAGE_COUNT` | String/Int | yes | `"1"` if single `messageBar`, `size` of `messageBars` array, or `"0"` | |
| `message_bar` | `MESSAGE_BAR` | Array<String?> or String | yes | populated array (size 1 or N) of `.message`, else `"none"` | |
| `banner` | `BANNER` | String | conditional | only if `header.items.size >= 1 && header.items[1] != null` → `items[1].action` | |
| `paymentOffersActive` | `PAYMENT_OFFERS_ACTIVE` | Bool | yes | always | |
| `ordered_from_reattempt_screen` | `ORDERED_FROM_REATTEMPT_SCREEN` | String | yes | `"Yes"`/`"No"` from `fromRetry` | |
| `promoApplied` | `PROMO_APPLIED` | Map | conditional | only if `orderDetails.promoApplied` non-empty — JSON-stringified and converted to map | |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(true)` | |

**Quirks:** `discount_percentage` here is **raw numeric**, unlike `cart_viewed`/`checkout_clicked` which append `"%"`. `payment_mode` value `"CARD"` is special-cased and rewritten to `"Card"` (case-fold). `message_bar` is an `arrayOfNulls<String>` — entries may be null. `header.items[1]` indexing assumes a fixed structure (could throw if items < 2 — but guarded by `>= 1` which is incorrect since accessing `[1]`).

---

### `product_ordered`

**Android method:** `CheckoutObserver.logProductOrderedEvent(response, fromRetry)` — `CheckoutObserver.kt:242-292`
**Event constant:** `AnalyticsEvents.PRODUCT_ORDERED` = `"product_ordered"`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None per-event; called once per cart line-item in a loop. **Important:** the `properties` map is reused across iterations (mutated in-place) — accumulating data, but per-item fields (sku/product_id/etc.) overwrite each iteration.
**Fire frequency:** Once per cart line item. Loops `response.orderDetails.items.indices`, each iteration:
1. Merges per-item properties via `addOrderConfirmedCartProperties(i, response)` — see table below.
2. Reads `sku` from properties → calls `AnalyticsHelper.setProductOrderedData(sku)` for per-item enrichment from cached `ShoppingBagResponse.trackingData.itemLevelTrackingData[sku]`.
3. Fires event.

**Base payload (set once before loop):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `payment_mode` | `PAYMENT_MODE` | String | conditional | from `response.paymentDetails.paymentMethod`; `"CARD"` → `"Card"` | |
| `delivery_city` | `DELIVERY_CITY` | String | conditional | `response.address.city` | |
| `state` | `STATE` | String | conditional | `response.address.state` | |
| `pincode` | `PINCODE` | String | conditional | `response.address.zipCode` | |
| `checkout_user` | `CHECKOUT_USER` | String | conditional | from `AppRecordData.getCheckoutFlowUserType()` if non-empty | |
| `has_gift_pid` | `HAS_GIFT` | String | conditional | `"Yes"`/`"No"` from `orderSummary.hasGift` | |
| `step_duration` | `STEP_DURATION` | Long | yes | `CheckoutTimerHelper.getTimeSinceLastEvent(true)` — sets last-event marker (only first iteration sees meaningful value) | |
| `total_duration` | `TOTAL_DURATION` | Long | yes | `CheckoutTimerHelper.getTimeSinceFirstEvent()` | |
| `ordered_from_reattempt_screen` | `ORDERED_FROM_REATTEMPT_SCREEN` | String | yes | `"Yes"`/`"No"` from `fromRetry` | |
| `order_id` | `ORDER_ID` | Long | conditional | `orderDetails.orderId` | |
| `first_order` | `FIRST_ORDER` | String | conditional | `"Yes"` only if `orderDetails.firstOrder == true` | |

**Per-item from `addOrderConfirmedCartProperties(index, response)` — `CheckoutObserver.kt:294-328`:**

| Property key (wire) | Constant | Type | Notes |
|---|---|---|---|
| `product_id` | `PRODUCT_ID` | Int | `items[i].productId` |
| `sku` | `SKU` | String | `items[i].sku` |
| `price` | `PRICE` | Double | `items[i].retailPrice` |
| `mrp` | `MRP` | Double | `items[i].regularPrice` |
| `discount_percentage` | `DISCOUNT_PERCENTAGE` | Number | `items[i].discountPercentage` (raw numeric, no `"%"`) |
| `quantity` | `QUANTITY` | Int | `items[i].quantity` |
| `revenue` | `REVENUE` | Double | `items[i].priceAfterAllDiscount` |
| `delivery_days` | `DELIVERY_DAYS` | Int | `items[i].deliveryDays` |
| `name` | `NAME` | String | `items[i].productName` |
| `category` | `CATEGORY` | String | `items[i].category` |
| `subcategory` | `SUB_CATEGORY` | String | `items[i].subcategory` |
| `product_type` | `PRODUCT_TYPE` | String | `items[i].productType` |
| `subproduct_type` | `SUBPRODUCT_TYPE` | String | `items[i].subProductType` |
| `brand` | `BRAND` | String | `items[i].brandName` |
| `gender` | `GENDER` | String | `items[i].gender` |
| `from_age` | `FROM_AGE` | Int | `items[i].fromAge` |
| `to_age` | `TO_AGE` | Int | `items[i].toAge` |
| `preorder` | `PRE_ORDER` | Bool/Int | `items[i].isPresale` (raw value, not `"Yes"`/`"No"`) |
| `sale` | `SALE` | Bool/Int | `items[i].onSale` (raw value) |
| `colour` | `COLOUR` | String | `items[i].color` |
| `size` | `SIZE` | String | `items[i].size` |
| `image_url` | `IMAGE_URL` | String | `items[i].imgSrc` |

**Per-item enrichment via `AnalyticsHelper.setProductOrderedData(sku)` — `AnalyticsHelper.java:1171-1311` — reads `ShoppingBagResponse.trackingData.itemLevelTrackingData[sku]` as `ProductTrackingData`:**

| Property key (wire) | Constant | Type | Source field | Gating |
|---|---|---|---|---|
| `atc_user` | `ATC_USER` | String | `productTrackingData.atcUser` | only if non-empty |
| `funnel` | `FUNNEL` | String | `funnel` | only if non-empty |
| `section` | `SECTION` | String | `section` | only if non-empty |
| `subsection` | `SUB_SECTION` | String | `subSection` | only if non-empty |
| `plp` | `PLP` | String | `plp` | only if non-empty |
| `atc_site` | `ATC_FROM` | String | `site` | only if non-empty; key resolves to `"atc_site"` |
| `atc_date` | `ATC_DATE` | String | `atcDate` | only if non-empty |
| `funnel_section` | `FUNNEL_SECTION` | String | `funnelSection` | only if non-empty |
| `funnel_tile` | `FUNNEL_TILE` | String | `funnelTile` | only if non-empty |
| `funnel_row` | `FUNNEL_ROW` | Int/String | `funnelRow` | always emitted: `none` if `0`, else `Int` |
| `sortbar` | `SORTBAR` | String | `sortBar` | only if non-empty |
| `sortbar_group` | `SORTBAR_GROUP` | String | `sortBarGroup` | only if non-empty |
| `sort_by` | `SORT_BY` | String | `sortBy` | only if non-empty |
| `merch_type` | `MERCH_TYPE` | String | `merchType` | only if non-empty |
| `v_country` | `COUNTRY` | String | `country` | only if non-empty |
| `atc_site` | `ATC_SITE` | String | `atcSite` | only if non-empty (NOTE: same wire key as ATC_FROM — later value wins) |
| `hbt` | `HBT` | String | `hbt` | only if non-empty |
| `taste` | `TASTE` | String | `taste` | only if non-empty |
| `style` | `STYLE` | String | `style` | only if non-empty |
| `season` | `SEASON` | String | `season` | only if non-empty |
| `pattern` | `PATTERN` | String | `pattern` | only if non-empty |
| `character` | `CHARACTER` | String | `character` | only if non-empty |
| `weave` | `WEAVE` | String | `weave` | only if non-empty |
| `property_type` | `PROPERTY_TYPE` | String | `propertyType` | only if non-empty |
| `slice_id` | `SLICE_ID` | String | `sliceId` | only if non-empty |
| `cta` | `CTA` | String | `cta` | only if non-empty |
| `banner_name` | `BANNER_NAME` | String | `bannerName` | only if non-empty |
| `is_pid_aplus` | `IS_PID_APLUS` | String | `isPidAPlus` | only if non-empty |
| `aplus_virtual_group_name` | `APLUS_VIRTUAL_GROUP_NAME` | String | `aPlusVirtualGroupName` | only if non-empty |
| `aplus_usp_list` | `APLUS_USP_LIST` | Array<String> | `aPlusUspList.split(",")` | only if non-null/non-empty — **comma-split into String[]** |
| `aplus_content_type` | `APLUS_CONTENT_TYPE` | String | `aPlusContentType` | only if non-empty |
| `source_tile_type` | `SOURCE_TILE_TYPE` | String | `sourceTileType` | only if non-empty |
| `count_of_pids_in_style_code` | `STYLE_CODE_PID_COUNT` | String | `countOfPidsInStyleCode` | only if non-empty |
| `style_code` | `STYLE_CODE` | String | `styleCode` | only if non-empty |
| `redirected_from_colour_widget` | `REDIRECTED_FROM_COLOR_WIDGET` | String | `redirectedFromColourWidget` | only if non-empty |
| `redirected_from_continue_browsing_widget` | (ApiParam) | String | `redirectedFromContinueBrowsingWidget` | only if non-empty |
| `redirected_from_cluster_eligible_plp` | (ApiParam) | String | `redirectedFromClusterEligiblePlp` | only if non-empty |
| `redirected_from_shop_the_look` | (common util) | String | `redirectedFromShopTheLook` | only if non-empty |
| `redirected_from_tab_page` | (common util) | String | `redirectedFromTabPage` | only if non-empty |
| `tabbed_page_container_name` | (TabbedPageProperties) | String | `tabPageContainerName` | only if non-empty |
| `tabbed_page_container_id` | (TabbedPageProperties) | String | `tabPageContainerId` | only if non-empty |
| `tab_name` | (TabbedPageProperties) | String | `tabName` | only if non-empty |
| `tab_position` | (TabbedPageProperties) | String | `tabPosition` | only if non-empty |
| `lp1_*` ... `lp5_*` | — | various | from `LPAttributionHelper.fillWithTrackingData(productTrackingData)` | all LP1..LP5 attribution keys |
| `product_utm_*` | — | various | from `UTMAttributionHelper.fillWithTrackingData(productTrackingData)` | product-scoped UTM attribution |

**Quirks:** `discount_percentage` here is **raw numeric** (unlike cart events with `"%"`). `preorder`/`sale` are raw booleans/ints — not coerced to `"Yes"`/`"No"`. The `properties` map is **mutated in place across loop iterations** — fields from a previous iteration that aren't overwritten persist (e.g. enrichment keys from previous SKU may leak if the new SKU has gaps). `atc_site` key collision (ATC_FROM and ATC_SITE both resolve to `"atc_site"`). `aplus_usp_list` is a String array (from `.split(",")`), not a List<String>. `step_duration` only meaningful for first item in loop (since `getTimeSinceLastEvent(true)` resets after first call).

---

### `Order Completed`

**Android method:** `CheckoutObserver.logOrderCompletedEvent(response)` — `CheckoutObserver.kt:330-361`
**Event constant:** `AnalyticsEvents.ORDER_COMPLETED` = `"Order Completed"` — **note capitalized "O" and "C" and the space** (Segment ecommerce spec event name)
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** Fires after `order_placed` + `product_ordered` loop + Facebook purchase event. Last terminal event in the order flow.
**Fire frequency:** Once per successful order placement.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `order_id` | `ORDER_ID` | Long | conditional | `response.orderDetails.orderId` | only if `orderDetails != null` |
| `order_bar_code` | `ORDER_BAR_CODE` | String | conditional | `response.orderDetails.orderBarCode` | only if `orderDetails != null` |
| `revenue` | `REVENUE` | Number | conditional | `response.orderSummary.totalOrderAmount.value` | only if both non-null |
| `currency` | `CURRENCY` | String | yes | `"INR"` hard-coded | |
| `products` | `PRODUCTS` | List<Map> | conditional | only if `Util.getShoppingBagResponse() != null`; constructed from `bagResponse.cartItems` | Segment ecommerce spec format |

**`products` array** (one element per `ReviewCartItem` in cached cart):

| Sub-key | Type | Source |
|---|---|---|
| `productId` | String | `reviewCartItem.productId.toString()` (set via `Properties.Product(id, sku, value)` constructor; first arg) |
| `sku` | String | `reviewCartItem.sku` (second arg) |
| (price/value) | Double | `reviewCartItem.orderPrice * reviewCartItem.quantity` (third arg — line total) |
| `quantity` | Int | `reviewCartItem.quantity` |
| `name` | String | `reviewCartItem.productName` |
| `brand` | String | `reviewCartItem.brandName` |

**Quirks:** Event name is **NOT snake_case** — `"Order Completed"` follows Segment ecommerce v2 spec verbatim (with capitalized words and space). `productId` is set via `Properties.Product` constructor (segment SDK) which serializes as `product_id` on wire per Segment spec — but the Kotlin code uses the SDK builder, so wire mapping follows the SDK's product schema (`product_id`, `sku`, `price`, `quantity`, `name`, `brand`). The `products` list shape matches Segment's `Order Completed` ecommerce spec.

---

### `order_failed`

**Android method:** `CheckoutObserver.kt:97-108` (`LogOrderFailedEvent` case) → routes through `AnalyticsHelper.logOrderPlacedEvent(eventName, properties, reset=false)`
**Event constant:** `AnalyticsEvents.ORDER_FAILED` = `"order_failed"`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** `addUserTypeAndDuration(reset=false)` — does not advance `lastEventTime`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `FROM_SCREEN` | String | yes | `AnalyticsDefaults.FromScreens.ORDER_CHECKOUT` | |
| `error` | `ERROR` | String | yes | `events.errorData.errorMessage` | |
| `payment_mode` | `PAYMENT_MODE` | String | yes | `events.cards` | |
| **+ cart enrichment** | — | — | conditional | from `getCartProperty()` if non-empty: `discount`, `discount_percentage` (raw numeric), `shipping`, `promo_code`, `promotion_discount` | |
| `atc_user` / `checkout_user` / `step_duration` / `total_duration` / `background_time` | — | — | yes | from `addUserTypeAndDuration(false)` | |

**RN bundle variant `fireOrderFailedEvent`** (`index.android.bundle:105040-105068`): adds `delivery_city`, `state`, `pincode`, `address`, `card`, `netbanking_bank`, `message_count`, `message_bar`, `credit`, `loyalty_credit`, `payment_retry`, `payu_time`.

---

### `order_pending`

**Android method:** `CheckoutObserver.kt:109-120` (`LogOrderPendingEvent` case) → routes through `AnalyticsHelper.logOrderPlacedEvent(eventName, properties, reset=false)`
**Event constant:** `AnalyticsEvents.ORDER_PENDING` = `"order_pending"`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** Same as `order_failed`.

**Payload:** Identical structure to `order_failed` — `from_screen = "Order Checkout"`, `error`, `payment_mode = events.cards`, cart enrichment, and user-type/duration merge.

---

### Cross-event invariants

**`getCommonEventProperties(isAttributionDataRequired, addUniversalProperties, useSavedAttributionData)` — `AnalyticsHelper.java:328-359`** is merged into **every** event fired via `logEvent(...)`:
- `[time] hour_of_day`, `[time] day_of_week`, `[time] day_of_month`, `[time] month_of_year`, `[time] week_of_year` (computed in `Asia/Calcutta` timezone; `week_of_year` is year-prefixed e.g. `202615`).
- If `isAttributionDataRequired=true` (and not `useSavedAttributionData`): merges `OrderAttributionHelper.getOrderAttributionSegmentParams()`, `LPAttributionHelper.getLPAttributionSegmentData()`, `TabPageAttributionHelper.getTabPageSegmentParams()`.
- If `useSavedAttributionData=true`: merges `AppRecordData.getOrderAttributionDataForScrollEvent()` instead.
- If `addUniversalProperties=true` and `commonProperties.size > 0`: adds `universal` = list of properties; else `universal = "none"`; cleared after read.

**Additional global props always added in `logEvent` (`AnalyticsHelper.java:375-387`):** `timestamp` (ISO8601), `afUserId` (AppsFlyer UID), `cleverTapId`.

**Segment Options (`AnalyticsHelper.java:400-406`):** `session_id` is set on every event under integration key `AnalyticsDefaults.INTEGRATION_AMPLITUDE` — passes `session_id` to Amplitude integration.

**`addUserTypeAndDuration(reset)` — `AnalyticsHelper.java:1343-1359`** (merged into `order_placed`, `order_failed`, `order_pending`, and all CheckoutObserver `LogCheckoutEvents`):
- `atc_user` (only if `AppRecordData.getATCUserType()` non-empty)
- `checkout_user` (only if `AppRecordData.getCheckoutFlowUserType()` non-empty)
- `step_duration` (ms since last event; resets `lastEventTime` if `reset=true`)
- `total_duration` (ms since `checkout_clicked`)
- `background_time` (accumulated background time in ms; reset to 0 after read if `> 0`)

---

## Module: Moments / Account / Orders / Ratings / In-app update / Notifications / Video

### `moments_viewed`

**Android method:** `logMomentViewedEvent(fromScreen, fromLocation, position)` — `AnalyticsHelper.java:593`
**Event constant:** `AnalyticsEvents.MOMENTS_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- If `Util.addFirstScreenProperty()` is true, queues `"First screen"` into `AnalyticsCommonPropertiesHelper` (will be flushed as `universal` on this event).
- Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.MOMENTS)` (= `"Moments"`) **BEFORE** firing `MOMENTS_VIEWED` — this may itself emit `app_launched` if the launch-dedup state has not yet fired this session.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Written unconditionally (no null guard). |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | input | Written unconditionally. |
| `position` | `AnalyticsProperties.POSITION` | int | conditional | omitted | **Only added when `fromLocation == "from custom tile"` AND `position != -1`.** Re-indexed 0→1. |

**Quirks:** `position` is conditional on `fromLocation` matching `R.string.from_custom_tile` (= `"from custom tile"`). `position=0` is silently re-mapped to `1`.

---

### `photo_liked`

**Android method:** `logMomentPhotoLikedEvent(context, photoId, source, uploaderId, position, status=true)` — `AnalyticsHelper.java:528`
**Event constant:** `AnalyticsEvents.PHOTO_LIKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — sibling of `photo_undid_like`, chosen via the `status` boolean (true → `PHOTO_LIKED`, false → `PHOTO_UNDID_LIKE`).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | derived | `MyMomentActivity` → `R.string.my_moments_for_segment` (`"My Moments"`); `MomentDetailActivity` → `R.string.photo_page` (`"Photo Page"`); else → `R.string.moment_tab` (`"Moments"`). |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"Heart"` | Hard-coded to `R.string.heart` (`"Heart"`). |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | conditional | omitted | Omitted when `photoId == -1`. |
| `photo_source` | `AnalyticsProperties.PHOTO_SOURCE` | String | conditional | omitted | Omitted when empty. |
| `photo_from` | `AnalyticsProperties.PHOTO_FROM` | String | conditional | omitted | Uploader ID. Omitted when empty. |
| `position` | `AnalyticsProperties.POSITION` | int | conditional | omitted | Omitted when `position == -1`. `position=0` is re-mapped to `1`. |

**Quirks:** `from_screen` is determined by `context instanceof` checks against three activity types. Position 0→1 reindex.

---

### `photo_undid_like`

**Android method:** `logMomentPhotoLikedEvent(context, photoId, source, uploaderId, position, status=false)` — `AnalyticsHelper.java:528`
**Event constant:** `AnalyticsEvents.PHOTO_UNDID_LIKE`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — sibling of `photo_liked`, chosen via the same `status` boolean (false branch).

**Payload:** Identical schema to `photo_liked` — same six properties (`from_screen`, `from_location` = `"Heart"`, `photo_id`, `photo_source`, `photo_from`, `position`). See `photo_liked` for the table and resolution rules.

**Quirks:** Same as `photo_liked`. Only the event name differs (`status=false` branch at line 556).

---

### `photo_reported`

**Android method:** `logPhotoReportedEvent(momentPhotoId, source, photoStatus, selectedReason, reportedBy)` — `MomentReportActivity.java:170`
**Event constant:** `AnalyticsEvents.PHOTO_REPORTED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — fired directly via `AnalyticsHelper.getInstance().logEvent(...)` at line 179 (no helper wrapper).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Photo details"` | Hard-coded to `R.string.photo_details`. |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | required | input | Always written (no null guard). |
| `photo_source` | `AnalyticsProperties.PHOTO_SOURCE` | String | required | input | Always written. |
| `photo_status` | `AnalyticsProperties.PHOTO_STATUS` | String | required | input | Always written. |
| `reason` | `AnalyticsProperties.REASON` | String | required | input | Selected report reason. |
| `reported_by` | `AnalyticsProperties.REPORTED_BY` | String | required | input | Always written. |

**Quirks:** No null/empty guards on any property — all six keys are always emitted.

---

### `photo_uploaded`

**Android method:** `logMomentUploadEvent(newlyAddedMomentId, imageSize, noOfTaggedKids, noOfTaggedProducts)` — `MomentFragment.java:560`
**Event constant:** `AnalyticsEvents.PHOTO_UPLOADED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Moments"` | Hard-coded to `R.string.moment_tab`. |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"Add moment button"` | Hard-coded to `R.string.add_moment_button`. |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | conditional | omitted | Omitted when `newlyAddedMomentId == -1`. |
| `image_size` | `AnalyticsProperties.IMAGE_SIZE` | float | conditional | omitted | Omitted when `imageSize == 0`. |
| `kids` | `AnalyticsProperties.KIDS` | int | conditional | omitted | Tagged kids count. Omitted when `0`. |
| `product` | `AnalyticsProperties.PRODUCT` | int | conditional | omitted | Tagged products count. Omitted when `0`. |

**Quirks:** None.

---

### `photo_upload_clicked`

**Android method:** `logMomentUploadClicked(userStatus, uploadEligibility)` — `AnalyticsHelper.java:560`; also `logDeeplinkomentUploadClickEvent(fromScreen, fromLocation, position, userStatus, uploadEligibility)` — `AnalyticsHelper.java:569`
**Event constant:** `AnalyticsEvents.PHOTO_UPLOAD_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload (default path — `logMomentUploadClicked`):**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Moments"` | Hard-coded to `R.string.moment_tab`. |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"Add moment button"` | Hard-coded to `R.string.add_moment_button`. |
| `user_status` | `AnalyticsProperties.USER_STATUS` | String | required | input | Always written. |
| `upload_eligibility` | `AnalyticsProperties.UPLOAD_ELIGIBILITY` | String | required | input | Always written. |

**Deeplink variant additions (`logDeeplinkomentUploadClickEvent`):** Same shape but takes explicit `fromScreen` / `fromLocation` and optionally a `position` (omitted when `== -1`; `0→1` reindex). All four base props are conditional in this variant (omitted when empty).

**Quirks:** Two parallel methods fire the same event with overlapping shapes; deeplink path adds `position`.

---

### `photo_deleted`

**Android method:** `logPhotoDeleteEvent()` — `MomentDetailActivity.java:389`
**Event constant:** `AnalyticsEvents.PHOTO_DELETED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — fires only if `momentDetailViewModel != null`; otherwise no event is dispatched.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Photo details"` | Hard-coded to `R.string.photo_details`. |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | conditional | omitted | Omitted when `id == -1`. |
| `photo_source` | `AnalyticsProperties.PHOTO_SOURCE` | String | conditional | omitted | Omitted when empty. |
| `photo_status` | `AnalyticsProperties.PHOTO_STATUS` | String | conditional | omitted | Omitted when empty. |
| `uploaded_date` | `AnalyticsProperties.UPLOADED_DATE` | String | conditional | omitted | `dd-MM-yyyy` formatted (Locale.ENGLISH) from `createdDate`. Omitted when `createdDate == 0`. |

**Quirks:** Date format is locale-fixed `dd-MM-yyyy`. Entire event suppressed when ViewModel is null.

---

### `photo_shared_clicked`

**Android method:** `logPhotoShareClickEvent(id, source, uploader, isPopular)` — `MomentDetailViewModel.java:637`
**Event constant:** `AnalyticsEvents.PHOTO_SHARED_CLICKED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Photo details"` | Hard-coded to `R.string.photo_details`. |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | required | input | Always written. |
| `photo_source` | `AnalyticsProperties.PHOTO_SOURCE` | String | required | `"Hopscotch"` | Empty → `AnalyticsDefaults.HOPSCOTCH` (`"Hopscotch"`). |
| `photo_from` | `AnalyticsProperties.PHOTO_FROM` | String | conditional | omitted | Uploader. Omitted when empty. |
| `photo_type` | `AnalyticsProperties.PHOTO_TYPE` | String | required | `"Recent"` | `isPopular ? "Popular" : "Recent"` (AnalyticsDefaults.POPULAR / RECENT). |

**Quirks:** `photo_source` has a `"Hopscotch"` default rather than being omitted.

---

### `photo_viewed`

**Android method:** `logPhotoViewedEvent(fromScreen, fromLocation, position, customTileId, photoId, photoSource, photoFrom, isPopular)` — `MomentDetailActivity.java:357`
**Event constant:** `AnalyticsEvents.PHOTO_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- If `Util.addFirstScreenProperty()` is true, queues `"First screen"` into `AnalyticsCommonPropertiesHelper` (consumed by `universal=true`).
- Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.PHOTO_DETAILS)` (= `"Photo details"`) **BEFORE** firing.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | conditional | omitted | Omitted when empty. |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | conditional | omitted | Omitted when empty. |
| `position` | `AnalyticsProperties.POSITION` | int | conditional | omitted | Omitted when `== -1`. `0→1` reindex. |
| `photo_id` | `AnalyticsProperties.PHOTO_ID` | int | conditional | omitted | Omitted when `== -1`. |
| `photo_source` | `AnalyticsProperties.PHOTO_SOURCE` | String | conditional | omitted | Omitted when empty. |
| `photo_from` | `AnalyticsProperties.PHOTO_FROM` | String | conditional | omitted | Omitted when empty. |
| `photo_type` | `AnalyticsProperties.PHOTO_TYPE` | String | required | `"Recent"` | `isPopular ? "Popular" : "Recent"`. Always written. |

**Quirks:** `customTileId` is in the signature but never written to the payload — only the call-site interpretation (deeplink vs. listing tap) at lines 330–353 sets `fromLocation` accordingly. Position 0→1 reindex.

---

### `name_updated`

**Android method:** Inline in `ProfileSettingNameFragment.kt:117` (no helper) — also fired (apparently buggy) from `ProfileSettingMobileFragment.kt:64`.
**Event constant:** `AnalyticsEvents.NAME_UPDATED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — `activity?.finish()` happens after dispatch.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_name` | `AnalyticsProperties.FROM_NAME` | String | required | input | The PREVIOUS name (pre-edit `nameValue`). |
| `name` | `AnalyticsProperties.NAME` | String | required | input | The NEW name. |

**Quirks:** Two values per event — `from_name` carries the OLD name, `name` carries the NEW name. **Bug-for-bug parity**: Android's `ProfileSettingMobileFragment` ALSO fires `NAME_UPDATED` (not `MOBILE_UPDATED`) when a phone number is confirmed via OTP — Flutter must replicate this for now unless the team explicitly fixes the upstream bug.

---

### `email_updated`

**Android method:** Inline in `ProfileSettingMobileFragment.kt:72` (no helper).
**Event constant:** `AnalyticsEvents.EMAIL_UPDATED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_email` | `AnalyticsProperties.FROM_EMAIL` | String | required | input | The PREVIOUS email (pre-edit `emailValue`). |
| `mobile` | `AnalyticsProperties.MOBILE` | String | required | input | The new value from `INTENT_EXTRA_VALUE`. |

**Quirks:** **Bug-for-bug parity**: Android writes the NEW value under the key `mobile` (not `email`) — `event[AnalyticsProperties.MOBILE] = …` at line 70. Flutter must replicate `from_email` + `mobile` literally.

---

### `mobile_updated`

**Android method:** Defined constant only — `AnalyticsEvents.MOBILE_UPDATED = "mobile_updated"` (`AnalyticsEvents.java:91`).
**Event constant:** `AnalyticsEvents.MOBILE_UPDATED`
**logEvent flags:** N/A
**Side effects:** N/A

**Payload:** Not fired by Android. The intended mobile-update flow (in `ProfileSettingMobileFragment.kt`) instead fires `NAME_UPDATED` (with `from_mobile` + `mobile`) — see `name_updated` quirks.

**Quirks:** Dead constant. If Flutter chooses to actually fire `mobile_updated`, the closest payload pattern (from the unused branch in `ProfileSettingMobileFragment.kt:60–66`) would be `from_mobile` (old phone) + `mobile` (new phone) under wire keys `from_mobile` / `mobile`. The constant `AnalyticsProperties.FROM_MOBILE = "from_mobile"` is defined for this.

---

### `password_updated`

**Android method:** Defined constant only — `AnalyticsEvents.PASSWORD_UPDATED = "password_updated"` (`AnalyticsEvents.java:92`).
**Event constant:** `AnalyticsEvents.PASSWORD_UPDATED`
**logEvent flags:** N/A
**Side effects:** N/A

**Payload:** Not fired anywhere in the Android codebase. `AnalyticsProperties.FROM_PASSWORD = "from_password"` is also defined but unused.

**Quirks:** Dead constant. Hopscotch's mobile flows are OTP-based — there is no traditional password update path on Android. Flutter likely does not need to wire this event; if implemented, parallel the `name_updated` pattern (`from_password` + new password — though the new password should obviously NEVER be sent in plaintext).

---

### `address_updated`

**Android method:** `AnalyticsHelperKt.logAddressUpdatedEvent(address, fromScreen, isNewAddress)` — `AnalyticsHelperKt.kt:7`
**Event constant:** `AnalyticsEvents.ADDRESS_UPDATED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Returns early (no event) when `address` is null.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | conditional | omitted | Omitted when null/empty. |
| `address` | `AnalyticsProperties.ADDRESS` | String | conditional | omitted | `isNewAddress==true` → `"New"`, `isNewAddress==false` → `"Updated"` (constants `AnalyticsProperties.NEW` / `AnalyticsProperties.UPDATED`). Omitted when `isNewAddress == null`. |
| `pincode` | `AnalyticsProperties.PINCODE` | String | conditional | omitted | Omitted when `zipCode` empty. |
| `delivery_available` | `AnalyticsProperties.DELIVERY_AVAILABLE` | String | conditional | omitted | Only added when `address.isServicable == true`; in that case value is hard-coded `"Yes"` (the false branch is dead). |
| `cod_available` | `AnalyticsProperties.COD_AVAILABLE` | Boolean | required | `canCod` | Always written (raw bool from `address.canCod`). |
| `delivery_city` | `AnalyticsProperties.DELIVERY_CITY` | String | conditional | omitted | Omitted when empty. |
| `default_address` | `AnalyticsProperties.DEFAULT_ADDRESS` | Boolean | required | `isPrimary` | Always written (raw bool). |

**Quirks:** The `delivery_available` block has a dead else-branch (the condition `address.isServicable` already gates it to true). `cod_available` and `default_address` are raw `Boolean` values, not `"Yes"`/`"No"` strings.

---

### `profile_photo_uploaded `

**Android method:** `logProfilePhotoUploadedEvent(fromScreen, photoUrl)` — `AnalyticsHelper.java:1128`
**Event constant:** `AnalyticsEvents.PROFILE_PHOTO_UPLOADED` — value is `"profile_photo_uploaded "` (trailing space)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | conditional | omitted | Omitted when empty. |
| `from_photo` | `AnalyticsProperties.FROM_PHOTO` | String | required | `"None"` | `photoUrl` non-empty → `ProfileDetailsActivity.UPLOAD` (`"Upload"`); empty → `ProfileDetailsActivity.NONE` (`"None"`). Always written. |

**Quirks:** **CRITICAL — the event name has a trailing space**: the wire string is literally `"profile_photo_uploaded "` (note the space at the end). This is preserved bug-for-bug from the Android constant. Flutter must emit the same trailing-space string verbatim. The only call site is `ProfileDetailsActivity.kt:277` invoking `logProfilePhotoUploadedEvent("Profile Settings", "Upload")`.

---

### `account_card_viewed`

**Android method:** Defined constant only — `AnalyticsEvents.ACCOUNT_CARD_VIEWED = "account_card_viewed"` (`AnalyticsEvents.java:62`).
**Event constant:** `AnalyticsEvents.ACCOUNT_CARD_VIEWED`
**logEvent flags:** N/A
**Side effects:** N/A

**Payload:** Not fired anywhere in the Android codebase. The Account screen exists (`AccountFragment.kt`) but does not emit any account-card-viewed event on render.

**Quirks:** Dead constant. If Flutter wants to add tracking for the Account tab landing, this is the canonical wire name to use, but there is no Android shape to copy.

---

### `child_profile_added`

**Android method:** `ChildProfileAnalyticsHelper.logChildProfileRelatedEvents(eventName=CHILD_PROFILE_ADDED, childInfo)` — `ChildProfileAnalyticsHelper.kt:14`
**Event constant:** `AnalyticsEvents.CHILD_PROFILE_ADDED` (in `components/util/AnalyticsEvents.kt:75`) — value `"child_profile_added"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Computes `childCohort` via `Utils.getChildCohortCategory(year, month, day, isMale)`.
- Updates `PrefUtils.childCohorts` map: increments count for this cohort (creates entry if missing).
- Calls `AnalyticsHelper.identifyForChildCohorts(currentCohorts)` (Segment `identify()` with updated cohort traits) BEFORE the `track()` for `child_profile_added`.
- Returns early (no event) when `childInfo` is null.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `child_profile_name` | `AnalyticsProperties.CHILD_PROFILE_NAME` | String | conditional | omitted | Written via `putAnalyticsKey` (skips null/empty). |
| `child_profile_gender` | `AnalyticsProperties.CHILD_PROFILE_GENDER` | String | conditional | omitted | Written via `putAnalyticsKey`. |
| `child_profile_dob` | `AnalyticsProperties.CHILD_PROFILE_DOB` | String | conditional | omitted | `year-month-day` raw concat (`"2020-5-3"`). |
| `child_profile_age` | `AnalyticsProperties.CHILD_PROFILE_AGE` | String/int | conditional | omitted | Computed by `Utils.calculateAge`. |
| `child_age_gender_cohort` | `AnalyticsProperties.CHILD_PROFILE_COHORT` | String | conditional | omitted | Computed by `Utils.getChildCohortCategory`. |

**Quirks:** Triggers an `identify()` call with the updated cohort map BEFORE the track. The cohort property key is `child_age_gender_cohort` (note constant name vs. wire-string mismatch). DOB string has no zero-padding.

---

### `child_profile_selected`

**Android method:** `logChildProfileSelectedEvent(childInfo)` — `ChildrenManagerTileViewHolder.kt:273`
**Event constant:** `AnalyticsEvents.CHILD_PROFILE_SELECTED` — value `"child_profile_selected"`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None (does NOT update cohorts or fire `identify` — distinct from `child_profile_added`/`child_details_deleted`).

**Payload:** Identical schema to `child_profile_added`:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `child_profile_name` | `AnalyticsProperties.CHILD_PROFILE_NAME` | String | conditional | omitted | Via `putAnalyticsKey`. |
| `child_profile_gender` | `AnalyticsProperties.CHILD_PROFILE_GENDER` | String | conditional | omitted | Via `putAnalyticsKey`. |
| `child_profile_dob` | `AnalyticsProperties.CHILD_PROFILE_DOB` | String | conditional | omitted | `year-month-day`. |
| `child_profile_age` | `AnalyticsProperties.CHILD_PROFILE_AGE` | String/int | conditional | omitted | Via `Utils.calculateAge`. |
| `child_age_gender_cohort` | `AnalyticsProperties.CHILD_PROFILE_COHORT` | String | conditional | omitted | Via `Utils.getChildCohortCategory`. |

**Quirks:** Same shape as added/deleted/edited but does NOT touch cohorts. Fires directly via `AnalyticsHelper.getInstance().logEvent(...)`, not via the shared `ChildProfileAnalyticsHelper`.

---

### `child_details_deleted`

**Android method:** `ChildProfileAnalyticsHelper.logChildProfileRelatedEvents(eventName=CHILD_PROFILE_DELETED, childInfo)` — `ChildProfileAnalyticsHelper.kt:14`
**Event constant:** `AnalyticsEvents.CHILD_PROFILE_DELETED` (in `components/util/AnalyticsEvents.kt:77`) — **value `"child_details_deleted"`** (NOT `child_profile_deleted`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Updates `PrefUtils.childCohorts`: decrements the cohort count, removes the entry when count would drop to ≤0.
- Calls `AnalyticsHelper.identifyForChildCohorts(currentCohorts)` (Segment `identify()` with updated traits) BEFORE the track.

**Payload:** Identical schema to `child_profile_added`:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `child_profile_name` | `AnalyticsProperties.CHILD_PROFILE_NAME` | String | conditional | omitted | Via `putAnalyticsKey`. |
| `child_profile_gender` | `AnalyticsProperties.CHILD_PROFILE_GENDER` | String | conditional | omitted | Via `putAnalyticsKey`. |
| `child_profile_dob` | `AnalyticsProperties.CHILD_PROFILE_DOB` | String | conditional | omitted | `year-month-day`. |
| `child_profile_age` | `AnalyticsProperties.CHILD_PROFILE_AGE` | String/int | conditional | omitted | Via `Utils.calculateAge`. |
| `child_age_gender_cohort` | `AnalyticsProperties.CHILD_PROFILE_COHORT` | String | conditional | omitted | Via `Utils.getChildCohortCategory`. |

**Quirks:** **Asymmetric constant naming** — the Kotlin constant is `CHILD_PROFILE_DELETED` but the wire string is `"child_details_deleted"`. Triggers `identify()` cohort decrement before the track.

---

### `child_details_edited`

**Android method:** `ChildProfileAnalyticsHelper.logChildProfileRelatedEvents(eventName=CHILD_PROFILE_EDITED, childInfo)` — `ChildProfileAnalyticsHelper.kt:14`
**Event constant:** `AnalyticsEvents.CHILD_PROFILE_EDITED` (in `components/util/AnalyticsEvents.kt:78`) — **value `"child_details_edited"`** (NOT `child_profile_edited`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Reads current cohorts from `PrefUtils.childCohorts` but does NOT mutate them (the `if (CHILD_PROFILE_ADDED) { … } if (CHILD_PROFILE_DELETED) { … }` branches in `getChildCohortsMap` both miss for the EDITED event).
- Still calls `AnalyticsHelper.identifyForChildCohorts(currentCohorts)` with the unchanged map BEFORE the track — this re-asserts the existing cohort traits on every edit.

**Payload:** Identical schema to `child_profile_added` (same five `child_profile_*` / `child_age_gender_cohort` keys).

**Quirks:** **Asymmetric constant naming** — `CHILD_PROFILE_EDITED` constant → `"child_details_edited"` wire. Identify is still called with the unchanged cohort map (so the trait is re-asserted, no-op net effect unless app cold-started with stale prefs).

---

### `order_listing_viewed`

**Android method:** `OrdersListingAnalyticsImpl.fireOrdersListingViewed(fromScreen, totalOrders, activeOrders, isFirstScreen)` — `OrdersListingAnalyticsImpl.kt:11`
**Event constant:** `AnalyticsEvents.ORDER_LISTING_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- If `isFirstScreen` is true, queues `"First screen"` into `AnalyticsCommonPropertiesHelper` (consumed by `universal=true`).
- Calls `analyticsHelper.logAppLaunchedEvent(AnalyticsDefaults.FromScreens.ORDER_LISTING)` (= `"Order listing"`) **BEFORE** firing.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Always written. |
| `order_count` | `AnalyticsProperties.ORDER_COUNT` | int | required | input | `totalOrders`. |
| `active_orders` | `AnalyticsProperties.ACTIVE_ORDERS` | int | required | input | `activeOrders`. |

**Quirks:** None.

---

### `order_viewed`

**Android method:** `logOrderViewedEvent(fromScreen, parentOrderId, orderId, orderStatus)` — `OrderDetailsActivity.java:916`
**Event constant:** `AnalyticsEvents.ORDER_VIEWED`
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- If `Util.addFirstScreenProperty()` is true, queues `"First screen"` into `AnalyticsCommonPropertiesHelper`.
- Calls `logAppLaunchedEvent(AnalyticsDefaults.FromScreens.ORDER_DETAILS)` (= `"Order details"`) **BEFORE** firing.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | conditional | omitted | Omitted when empty. |
| `parent_order_id` | `AnalyticsProperties.PARENT_ORDER_ID` | String | required | input | Always written (no null guard). |
| `order_id` | `AnalyticsProperties.ORDER_ID` | List<String> | conditional | omitted | Array of sub-order ids. Omitted when list is null. |
| `order_status` | `AnalyticsProperties.ORDER_STATUS` | List<String> | conditional | omitted | Array of sub-order statuses. Omitted when null. |

**Quirks:** `order_id` and `order_status` are arrays (parallel lists), not scalars. `parent_order_id` is written unconditionally.

---

### `exchange_clicked`

**Android method:** `sendOrderExchangeClickEvent()` — `OrderDetailsActivity.java:677`
**Event constant:** `AnalyticsEvents.EXCHANGE_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Wrapped in a try/catch — failures are swallowed via `AppLogger.logCrashlyticsException`.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | Omitted when empty. |
| `total_item_price` | `AnalyticsProperties.TOTAL_ITEM_PRICE` | double | conditional | omitted | Omitted when `<= 0`. |

**Quirks:** Source comment notes "Add Few More Properties after discussing with Victor" — Android currently emits only two keys. Try/catch suppresses any exceptions.

---

### `product_exchanged`

**Android method:** `ExchangeAnalyticsImpl.fireProductExchangedEvent(productExchangedAnalyticsResponse)` — `ExchangeAnalyticsImpl.kt:48`
**Event constant:** `AnalyticsEvents.PRODUCT_EXCHANGED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — returns `Completable.complete()`. Skips the entire dispatch when `properties.isEmpty()` (impossible in practice since several int/double props are written unconditionally).

**Payload:** (conditional strings via `.exists()` guard; ints/doubles always written)

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `exchange_reason` | `AnalyticsProperties.EXCHANGE_REASON` | String | conditional | omitted | `.exists()` guard. |
| `payment_method` | `AnalyticsProperties.PAYMENT_METHOD` | String | conditional | omitted | |
| `pincode` | `AnalyticsProperties.PINCODE` | String | conditional | omitted | |
| `city` | `AnalyticsProperties.CITY` | String | conditional | omitted | |
| `state` | `AnalyticsProperties.STATE` | String | conditional | omitted | |
| `category` | `AnalyticsProperties.CATEGORY` | String | conditional | omitted | |
| `subcategory` | `AnalyticsProperties.SUB_CATEGORY` | String | conditional | omitted | |
| `product_type` | `AnalyticsProperties.PRODUCT_TYPE` | String | conditional | omitted | |
| `gender` | `AnalyticsProperties.GENDER` | String | conditional | omitted | |
| `hbt` | `AnalyticsProperties.HBT` | String | conditional | omitted | |
| `merch_type` | `AnalyticsProperties.MERCH_TYPE` | String | conditional | omitted | |
| `shipping` | `AnalyticsProperties.SHIPPING` | String | conditional | omitted | |
| `order_number` | `AnalyticsProperties.ORDER_NUMBER` | String | conditional | omitted | |
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | |
| `sku` | `AnalyticsProperties.SKU` | String | conditional | omitted | |
| `days_since_order` | `AnalyticsProperties.DAYS_SINCE_ORDER` | int | required | `0` | Always written. |
| `days_since_shipped` | `AnalyticsProperties.DAYS_SINCE_SHIPPED` | int | required | `0` | Always written. |
| `days_since_delivery` | `AnalyticsProperties.DAYS_SINCE_DELIVERY` | int | required | `0` | Always written. |
| `quantity` | `AnalyticsProperties.QUANTITY` | int | required | `0` | Always written. |
| `price` | `AnalyticsProperties.PRICE` | double | required | `0.0` | Always written. |
| `from_age` | `AnalyticsProperties.FROM_AGE` | String/int | required | input | Always written. |
| `to_age` | `AnalyticsProperties.TO_AGE` | String/int | required | input | Always written. |
| `style` | `AnalyticsProperties.STYLE` | String | conditional | omitted | |
| `season` | `AnalyticsProperties.SEASON` | String | conditional | omitted | |
| `pattern` | `AnalyticsProperties.PATTERN` | String | conditional | omitted | |
| `character` | `AnalyticsProperties.CHARACTER` | String | conditional | omitted | |
| `weave` | `AnalyticsProperties.WEAVE` | String | conditional | omitted | |
| `subproduct_type` | `AnalyticsProperties.SUBPRODUCT_TYPE` | String | conditional | omitted | |

**Quirks:** Mix of always-written numerics (zero defaults) and conditional strings (`.exists()` guard).

---

### `product_exchange_clicked`

**Android method:** `ExchangeAnalyticsImpl.fireProductExchangeClickedEvent(productExchangedItem)` — `ExchangeAnalyticsImpl.kt:158`
**Event constant:** `AnalyticsEvents.PRODUCT_EXCHANGE_CLICKED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — returns `Completable.complete()`. Skips entire dispatch when properties map is empty.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | `.exists()` guard. |
| `sku` | `AnalyticsProperties.SKU` | String | conditional | omitted | |
| `item_price` | `AnalyticsProperties.ITEM_PRICE` | double | conditional | omitted | Omitted when `== 0.0`. |
| `category` | `AnalyticsProperties.CATEGORY` | String | conditional | omitted | |
| `subcategory` | `AnalyticsProperties.SUB_CATEGORY` | String | conditional | omitted | |
| `product_type` | `AnalyticsProperties.PRODUCT_TYPE` | String | conditional | omitted | |

**Quirks:** All properties are conditional — no event fires when input is fully empty.

---

### `exchange_aborted`

**Android method:** `ExchangeAnalyticsImpl.fireExchangeAbortedEvent(exchangeAbortedItem)` — `ExchangeAnalyticsImpl.kt:130`
**Event constant:** `AnalyticsEvents.EXCHANGE_ABORTED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — returns `Completable.complete()`. Skips dispatch when properties map is empty.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | conditional | omitted | `.exists()` guard. |
| `quantity` | `AnalyticsProperties.QUANTITY` | int | conditional | omitted | Omitted when `== 0`. |
| `reason` | `AnalyticsProperties.REASON` | String | conditional | omitted | |
| `size_availability` | `AnalyticsProperties.SIZE_AVAILABILITY` | String | conditional | omitted | |
| `error` | `AnalyticsProperties.ERROR` | String | conditional | omitted | |
| `has_address_serviceable` | `AnalyticsProperties.HAS_ADDRESS_SERVICEABLE` | String | conditional | omitted | `.exists()` (Kotlin extension treats it as String, so this is a stringified Yes/No coming in). |

**Quirks:** All fields conditional. `has_address_serviceable` wire-key uses British spelling "serviceable" — verify in payload.

---

### `reason_selected`

**Android method:** `ExchangeAnalyticsImpl.fireReasonSelectedEvent(reason)` — `ExchangeAnalyticsImpl.kt:22`
**Event constant:** `AnalyticsEvents.REASON_SELECTED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None. Skips dispatch when properties is empty (so when `reason` doesn't exist, the event isn't fired).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `reason` | `AnalyticsProperties.REASON` | String | conditional | omitted | Only key in the event; `.exists()` guard. |

**Quirks:** Single-property event.

---

### `dialog_action_clicked`

**Android method:** `ExchangeAnalyticsImpl.fireDialogActionClickedEvent(type, action)` — `ExchangeAnalyticsImpl.kt:33`
**Event constant:** `AnalyticsEvents.DIALOG_ACTION_CLICKED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — returns `Completable.complete()`. Skips dispatch when both inputs are empty.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `action` | `AnalyticsProperties.ACTION` | String | conditional | omitted | `.exists()` guard. |
| `type` | `AnalyticsProperties.TYPE` | String | conditional | omitted | `.exists()` guard. |

**Quirks:** Lives in the exchange impl (`impl/exchange/ExchangeAnalyticsImpl.kt`) despite the generic-sounding name — it's the cancel/confirm dialog inside the exchange flow.

---

### `order_return_clicked`

**Android method:** `logEventOrderReturnClicked()` — `ReturnableItemDetailsActivity.java:217`
**Event constant:** `AnalyticsEvents.ORDER_RETURN_CLICKED` (in `components/util/AnalyticsEvents.kt:91`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:** (all via `ExtentionsKt.putAnalyticsKey` — skips null/empty)

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | `mSelectedReason`. |
| `return_quantity` | `AnalyticsProperties.RETURN_QUANTITY` | int | conditional | omitted | `mSelectedQuantity`. |
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | |
| `proceed_with_return_clicked` | `AnalyticsProperties.PROCEED_WITH_RETURN_CLICKED` | String | required | `"Yes"` or `"No"` | Computed from `selectedReasonData.showCommentOnly == false`. Always added — `toYesNoString()` produces literal `"Yes"`/`"No"`. |
| `<product_attributes…>` | from `buildProductAttributesMap()` | various | conditional | varies | Merged via `properties.putAll(buildProductAttributesMap())` — includes `product_id`, `name`, `brand`, `price`, `sku`, etc. (full PDP-style product attribute bag). |

**Quirks:** Property key in source is `AnalyticsProperties.PROCEED_WITH_RETURN_CLICKED` (lives in `common/util/AnalyticsProperties.kt`) — wire string is `proceed_with_return_clicked`. The flag uses string `"Yes"`/`"No"` rather than booleans.

---

### `exchange_size_selection_cta_clicked`

**Android method:** `ExchangeScreenAnalyticsHelper.logEventExchangeSizeSelectionCTAClicked(selectedSize, isReturn, viewedSizeChart, productAttributes)` — `ExchangeScreenAnalyticsHelper.kt:12`
**Event constant:** `AnalyticsEvents.EXCHANGE_SIZE_SELECTION_CTA_CLICKED` (in `components/util/AnalyticsEvents.kt:92`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `exchange_size_selected` | `AnalyticsProperties.EXCHANGE_SIZE_SELECTED` | String | conditional | omitted | `putAnalyticsKey` guards. |
| `cant_find_size_return_pdt` | `AnalyticsProperties.CANT_FIND_SIZE_RETURN_PDT` | String | conditional | omitted | `isReturn.toYesNoString()` → `"Yes"`/`"No"`. |
| `size_chart_viewed` | `AnalyticsProperties.SIZE_CHART_VIEWED` | String | conditional | omitted | `viewedSizeChart.toYesNoString()` → `"Yes"`/`"No"`. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | Full PDP product attribute bag. |

**Quirks:** Bools are serialized as `"Yes"`/`"No"` strings via `toYesNoString()`. Product attributes come pre-shaped from the caller.

---

### `exchange_address_selected`

**Android method:** `ExchangeScreenAnalyticsHelper.logEventExchangeAddressSelected(productAttributes)` — `ExchangeScreenAnalyticsHelper.kt:33`
**Event constant:** `AnalyticsEvents.EXCHANGE_ADDRESS_SELECTED` (in `components/util/AnalyticsEvents.kt:93`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `<product_attributes…>` | passed-in map | various | varies | varies | The entire `productAttributes` map is sent as-is — no fixed keys added by the helper. |

**Quirks:** Just a passthrough of the caller's product attribute map; no extra fields added.

---

### `exchange_order_placed`

**Android method:** `ExchangeScreenAnalyticsHelper.logEventExchangeOrderPlaced(selectedReason, selectedQuantity, orderId, selectedSize, otherButtonClicked, productAttributes)` — `ExchangeScreenAnalyticsHelper.kt:42`
**Event constant:** `AnalyticsEvents.EXCHANGE_ORDER_PLACED` (in `components/util/AnalyticsEvents.kt:94`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | `putAnalyticsKey` guards. Yes — exchange flow reuses the `return_reason` key. |
| `exchange_quantity` | `AnalyticsProperties.EXCHANGE_QUANTITY` | String | conditional | omitted | |
| `exchange_size` | `AnalyticsProperties.EXCHANGE_SIZE` | String | conditional | omitted | |
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | |
| `other_button_clicked` | `AnalyticsProperties.OTHER_BUTTON_CLICKED` | String | conditional | omitted | Only added when `otherButtonClicked != null`; value `"Yes"`/`"No"` via `toYesNoString()`. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | |

**Quirks:** Exchange uses the `return_reason` key (shared with the return flow). `other_button_clicked` is gated on null.

---

### `return_address_selected`

**Android method:** `OrderReturnAnalyticsHelper.logEventReturnAddressSelected(productAttributes)` — `OrderReturnAnalyticsHelper.kt:14`
**Event constant:** `AnalyticsEvents.RETURN_ADDRESS_SELECTED` (in `components/util/AnalyticsEvents.kt:95`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `<product_attributes…>` | passed-in map | various | varies | varies | Entire `productAttributes` map sent as-is. |

**Quirks:** Passthrough — identical helper shape to `exchange_address_selected`.

---

### `return_order_placed`

**Android method:** `OrderReturnAnalyticsHelper.logEventReturnOrderPlaced(returnReason, returnQuantity, isProceedWithReturn, orderId, returnAmount, isToBank, productAttributes)` — `OrderReturnAnalyticsHelper.kt:24`
**Event constant:** `AnalyticsEvents.RETURN_ORDER_PLACED` (in `components/util/AnalyticsEvents.kt:96`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | |
| `return_quantity` | `AnalyticsProperties.RETURN_QUANTITY` | int | conditional | omitted | |
| `proceed_with_return_clicked` | `AnalyticsProperties.PROCEED_WITH_RETURN_CLICKED` | String | required | `"Yes"`/`"No"` | `isProceedWithReturn.toYesNoString()` — always added (`putAnalyticsKey` accepts non-null Yes/No strings). |
| `order_id` | `AnalyticsProperties.ORDER_ID` | String | conditional | omitted | |
| `refund_amount` | `AnalyticsProperties.REFUND_AMOUNT` | String | required | `returnAmount.toString()` | Stringified double via `.toString()`. |
| `refunded_to` | `AnalyticsProperties.REFUNDED_TO` | String | required | `"Hopscotch Merchandising Credits"` or `"Bank Account"` | `isToBank ?? false ? AnalyticsDefaults.BANK_ACCOUNT : AnalyticsDefaults.HOPSCOTCH_MERCHANDISING_CREDITS`. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | |

**Quirks:** `refund_amount` is sent as a STRING (not a double). `refunded_to` is hard-string-mapped from a boolean (note: when `isToBank` is null, falls through to `"Hopscotch Merchandising Credits"`).

---

### `exchange_nudge_widget_viewed`

**Android method:** `ExchangeNudgeAnalyticsHelper.logEventExchangeNudgeViewed(reason, productAttributes)` — `ExchangeNudgeAnalyticsHelper.kt:14` (in `features/.../exchangeNudge/.../helpers/`)
**Event constant:** `AnalyticsEvents.EXCHANGE_NUDGE_WIDGET_VIEWED` (in `components/util/AnalyticsEvents.kt:88`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None — sent via `GlobalObservers.analyticsHelper.send(AnalyticsEvent.SendEvent(...))` (the components-module global observer plumbing).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | `putAnalyticsKey` guard. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | |

**Quirks:** Uses the `GlobalObservers` async event pipe (not the synchronous `AnalyticsHelper.logEvent`) — net dispatch is the same Segment `track`, but routed via the observer.

---

### `swap_with_correct_size_clicked`

**Android method:** `ExchangeNudgeAnalyticsHelper.logEventSwapCorrectWithSizeClicked(reason, defaultSize, otherOptionClicked, productAttributes)` — `ExchangeNudgeAnalyticsHelper.kt:29`
**Event constant:** `AnalyticsEvents.SWAP_WITH_CORRECT_SIZE_CLICKED` (in `components/util/AnalyticsEvents.kt:89`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | |
| `default_exchange_size` | `AnalyticsProperties.DEFAULT_EXCHANGE_SIZE` | String | conditional | omitted | Only added when `defaultSize` is non-null and non-empty. |
| `other_button_clicked` | `AnalyticsProperties.OTHER_BUTTON_CLICKED` | String | conditional | omitted | Only when `otherOptionClicked != null`; serialized `"Yes"`/`"No"`. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | |

**Quirks:** None beyond the others-button null gate.

---

### `proceed_with_return_clicked`

**Android method:** `ExchangeNudgeAnalyticsHelper.logEventProceedWithReturnClicked(reason, productAttributes)` — `ExchangeNudgeAnalyticsHelper.kt:50`
**Event constant:** `AnalyticsEvents.PROCEED_WITH_RETURN_CLICKED` (in `components/util/AnalyticsEvents.kt:90`)
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `return_reason` | `AnalyticsProperties.RETURN_REASON` | String | conditional | omitted | `putAnalyticsKey` guard. |
| `<product_attributes…>` | merged via `putAll` | various | varies | varies | |

**Quirks:** Note this is the EVENT named `proceed_with_return_clicked` — distinct from the PROPERTY-key `proceed_with_return_clicked` used inside `order_return_clicked` / `return_order_placed`. Same wire string, two different roles.

---

### `product_rated`

**Android method:** `RatingsAnalyticsImpl.fireProductRatedEvent(fromScreen, fromLocation, productId, brand, category, subCategory, productType, gender, fromAge, toAge, sku, rating, review, orderId, npsRating, firstOrder, product, reviewObject)` — `RatingsAnalyticsImpl.java:76`
**Event constant:** `AnalyticsEvents.PRODUCT_RATED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — uses `logAnalyticsEvent` (returns boolean, no Crashlytics/AppsFlyer parallel side effects beyond the common enrichment).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | `getNoneIfEmpty(...)`. |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | |
| `product_id` | `AnalyticsProperties.PRODUCT_ID` | int | required | input | Always written. |
| `brand` | `AnalyticsProperties.BRAND` | String | required | `"none"` | |
| `category` | `AnalyticsProperties.CATEGORY` | String | required | `"none"` | |
| `subcategory` | `AnalyticsProperties.SUB_CATEGORY` | String | required | `"none"` | |
| `product_type` | `AnalyticsProperties.PRODUCT_TYPE` | String | required | `"none"` | |
| `gender` | `AnalyticsProperties.GENDER` | String | required | `"none"` | |
| `from_age` | `AnalyticsProperties.FROM_AGE` | String | required | `"none"` | |
| `to_age` | `AnalyticsProperties.TO_AGE` | String | required | `"none"` | |
| `sku` | `AnalyticsProperties.SKU` | String | required | `"none"` | |
| `rating` | `AnalyticsProperties.RATING` | int | required | input | Always written. |
| `review` | `AnalyticsProperties.REVIEW` | String | required | `"none"` | |
| `order_id` | `AnalyticsProperties.ORDER_ID` | long | required | input | Always written. |
| `<question_type_keys…>` | dynamic — `product.questions[i].type` | List<String> | conditional | omitted | For each question on the product, key = `questionType` (the question's `type` string), value = list of selected-option texts from the answer matching that qid. Skipped when `product == null` or no questions. |
| `nps` | `AnalyticsProperties.NPS` | int | conditional | omitted | Omitted when `== 0`. |
| `first_order` | `AnalyticsProperties.FIRST_ORDER` | String | conditional | omitted | Omitted when empty. |

**Quirks:** Adds **dynamic property keys** named after each question's `type` field on the product (e.g. `size_fit`, `low_rating_reason`) — these are not enumerated in `AnalyticsProperties`. The value is a list of option texts selected by the user for that question.

---

### `nps_feedback`

**Android method:** `RatingsAnalyticsImpl.fireNPSFeedbackRatedEvent(orderId, productIds, nps, npsFeedback, ratings, averageRating, firstOrder)` — `RatingsAnalyticsImpl.java:140`
**Event constant:** `AnalyticsEvents.NPS_FEEDBACK`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `order_id` | `AnalyticsProperties.ORDER_ID` | long | required | input | |
| `product_id` | `AnalyticsProperties.PRODUCT_ID` | List<long> | required | input | Array of product IDs in this order. |
| `nps` | `AnalyticsProperties.NPS` | int | required | input | NPS score 0–10. |
| `nps_feedback` | `AnalyticsProperties.NPS_FEEDBACK` | String | required | input | Free-text feedback. |
| `rating` | `AnalyticsProperties.RATING` | List<int> | required | input | Per-product star ratings array. |
| `average_rating` | `AnalyticsProperties.AVERAGE_RATING` | double | required | input | |
| `first_order` | `AnalyticsProperties.FIRST_ORDER` | String | conditional | omitted | Omitted when empty. |

**Quirks:** `product_id` and `rating` are parallel arrays. `nps_feedback` is also defined as a top-level property — distinct from the event name `nps_feedback`.

---

### `rating_review_viewed`

**Android method:** `RatingsAnalyticsImpl.fireRatingReviewViewed(fromScreen, fromLocation, productIdList, brandList, categoryList, subCategoryList, productType, orderId, firstOrder, productsToBeViewed, npsReview, skuList)` — `RatingsAnalyticsImpl.java:35`
**Event constant:** `AnalyticsEvents.RATING_REVIEW_VIEWED`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"none"` | |
| `from_location` | `AnalyticsProperties.FROM_LOCATION` | String | required | `"none"` | |
| `sku` | `AnalyticsProperties.SKU` | List<String> | conditional | omitted | Omitted when null/empty. |
| `product_id` | `AnalyticsProperties.PRODUCT_ID` | List<long> | conditional | omitted | Omitted when null/empty. |
| `brand` | `AnalyticsProperties.BRAND` | List<String> | conditional | omitted | Omitted when null/empty. |
| `category` | `AnalyticsProperties.CATEGORY` | List<String> | conditional | omitted | Omitted when null/empty. |
| `subcategory` | `AnalyticsProperties.SUB_CATEGORY` | List<String> | conditional | omitted | Omitted when null/empty. |
| `product_type` | `AnalyticsProperties.PRODUCT_TYPE` | List<String> | conditional | omitted | Omitted when null/empty. |
| `order_id` | `AnalyticsProperties.ORDER_ID` | long | conditional | omitted | Omitted when `== 0`. |
| `first_order` | `AnalyticsProperties.FIRST_ORDER` | String | conditional | omitted | Omitted when empty. |
| `products_to_review` | `AnalyticsProperties.PRODUCTS_TO_REVIEW` | int | required | input | Always written. |
| `nps_review` | `AnalyticsProperties.NPS_REVIEW` | String | conditional | omitted | Omitted when empty. |

**Quirks:** All `sku`/`brand`/`category`/etc. are arrays here (parallel lists across the products being reviewed). `products_to_review` is the only unconditional integer.

---

### `rate_shopping_experience_shown_at`

**Android method:** `logRateShoppingExperienceShowedAtEvent()` — `RateShoppingExperienceFragment.kt:143`
**Event constant:** `AnalyticsEvents.RATE_SHOPPING_EXPERIENCE_SHOWN_AT`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None — called from `onCreate`-ish flow (line 96).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `rate_shopping_experience_shown_time` | `AnalyticsProperties.RATE_SHOPPING_EXPERIENCE_SHOWN_TIME` | long | required | `Calendar.getInstance().timeInMillis` | Epoch millis at dispatch. |
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Always written. |

**Quirks:** Timestamp here is `_shown_time` (long millis) — distinct from the global `timestamp` (ISO-8601) added by `logEvent`.

---

### `rate_in_playstore_user_response`

**Android method:** Defined constant only — `AnalyticsEvents.RATE_IN_PLAYSTORE_USER_RESPONSE = "rate_in_playstore_user_response"` (`AnalyticsEvents.java:144`).
**Event constant:** `AnalyticsEvents.RATE_IN_PLAYSTORE_USER_RESPONSE`
**logEvent flags:** N/A
**Side effects:** N/A

**Payload:** Not fired anywhere in the Android codebase. The related property `AnalyticsProperties.RATE_IN_PLAYSTORE_USER_ACTION = "rate_in_playstore_user_action"` is also defined but unused.

**Quirks:** Dead constant. The current rating flow uses `app_rating_dialog_shown` / `app_rating_shown_interest` / `app_rating_ignored` instead. Likely intended for the in-app review flow (`com.google.android.play.core.review`) but never wired.

---

### `shopping_experience_ratings_given`

**Android method:** `logShoppingExperienceRatingsEvent(rating)` — `RateShoppingExperienceFragment.kt:131`
**Event constant:** `AnalyticsEvents.SHOPPING_EXPERIENCE_RATINGS_GIVEN`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `ratings_given_for_shopping_experience` | `AnalyticsProperties.RATINGS_GIVEN_FOR_SHOPPING_EXPERIENCE` | int | required | input | Star rating value (1–5). |
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Always written. |

**Quirks:** Property key is verbose — wire string `ratings_given_for_shopping_experience` (note plural "ratings", "given_for").

---

### `rate_shopping_experience_dismissed_at`

**Android method:** `logRateShoppingExperienceDismissedAtEvent()` — `RateShoppingExperienceFragment.kt:156`
**Event constant:** `AnalyticsEvents.RATE_SHOPPING_EXPERIENCE_DISMISSED_AT`
**logEvent flags:** `attribution=false`, `universal=false`
**Side effects:** None.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `rate_shopping_experience_dismissed_time` | `AnalyticsProperties.RATE_SHOPPING_EXPERIENCE_DISMISSED_TIME` | long | required | `Calendar.getInstance().timeInMillis` | Epoch millis at dispatch. |
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Always written. |

**Quirks:** Symmetric counterpart of `rate_shopping_experience_shown_at` — `_dismissed_time` long millis.

---

### `app_rating_ignored`

**Android method:** `AppRatingManager.logAndHandleEvent(event=APP_RATING_IGNORED, analyticsProperties, interestShown=false)` via `onDismissClicked` — `AppRatingManager.kt:82`
**Event constant:** `AnalyticsEvents.APP_RATING_IGNORED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- Calls `appRatingViewModel.userShownInterestToRate(false)` → records that the user did NOT show interest (server-side state mutation).
- Triggers the listener's `onRateUsClicked` callback (the parameter naming in `logAndHandleEvent` is misleading — for IGNORED, `action` is `appRatingListener?.onRateUsClicked`, NOT dismiss).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | Carries the screen where the dialog was triggered. |

**Quirks:** Sibling of `app_rating_shown_interest` / `app_rating_dialog_shown` — shares the same single-property shape. Note the listener-callback swap in source (`onDismissClicked` triggers `onRateUsClicked` action).

---

### `app_rating_shown_interest`

**Android method:** `AppRatingManager.logAndHandleEvent(event=APP_RATING_SHOWN_INTEREST, analyticsProperties, interestShown=true)` via `onRateUsClicked` — `AppRatingManager.kt:76`
**Event constant:** `AnalyticsEvents.APP_RATING_SHOWN_INTEREST`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- Calls `appRatingViewModel.userShownInterestToRate(true)` → records that the user DID show interest.
- Triggers the listener's `onDismissClicked` callback (same swap as above — for SHOWN_INTEREST, `action` is `appRatingListener?.onDismissClicked`).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | |

**Quirks:** Same shape as `app_rating_ignored`. The dialog UI's "Rate Us" button fires this event — does NOT directly fire Play Store rating (that's gated on the swap-callback `onDismissClicked` triggering the actual rating flow).

---

### `app_rating_dialog_shown`

**Android method:** `AppRatingManager.showAppRatingDialog(fromScreen)` — `AppRatingManager.kt:63`
**Event constant:** `AnalyticsEvents.APP_RATING_DIALOG_SHOWN`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- Shows the `AppRatingDialogFragment` AFTER firing the event.
- Gated by `ExperimentUtil.RemoteConfigFlags.isRatingAfterShoppingExperienceEnabled` upstream (in `checkAndShowAppRating`).
- Gated by `appRatingViewModel.isUserAllowedToRate()` server-side eligibility upstream.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | input | |

**Quirks:** Single-property event. The `analyticsProperties` map is reused across the three app-rating events.

---

### `in_app_update_download_clicked`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_DOWNLOAD_CLICKED)` — `AccountFragment.kt:602` (within `onClickOfDownload()`); `CollectionsFragment.kt:2030`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_DOWNLOAD_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Triggers `appUpdateHelper.downloadUpdate(...)` AFTER firing the event.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Account"` (`AccountFragment`) / `"Discover"` (`CollectionsFragment`) | Hard-coded per call site. |

**Quirks:** Two parallel `logInAppUpdateEvent` helpers (one per fragment); they differ only in the `from_screen` value. **The `AccountFragment` helper guards `if (properties.isNotEmpty())` before firing — since `from_screen` is unconditionally added, this is always true (defensive but vacuous).**

---

### `in_app_update_later_clicked`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_LATER_CLICKED)` — `AccountFragment.kt:598`; `CollectionsFragment.kt:2026`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_LATER_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:**
- `AccountFragment`: calls `inAppUpdatePreferences.saveLaterButtonClickCountAndTime()` and `removeAppUpdateView()` BEFORE firing the event.
- `CollectionsFragment`: similar (preference write + UI removal).

**Payload:** Same single-property shape as `in_app_update_download_clicked` — only `from_screen`.

**Quirks:** Same dual call-site structure.

---

### `in_app_update_install_shown`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_INSTALL_SHOWN)` — `AccountFragment.kt:553` (within `addInAppUpdateView` when `status.isDownloaded == true`); `CollectionsFragment.kt:752`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_INSTALL_SHOWN`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:**
- Gated by `canShowAppUpdateView()` (in `AccountFragment` this requires `inAppUpdatePreferences.getLaterButtonClickCount() >= 3`).
- Fires inside the adapter-update path before notifying the RecyclerView.

**Payload:** Same single-property shape — only `from_screen`.

**Quirks:** Fired when the in-app-update install row becomes visible (not on user action). Eligibility gate is the "later clicked 3+ times" rule.

---

### `in_app_update_installed_success`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_INSTALLED_SUCCESS)` — `AccountFragment.kt:555` (within `addInAppUpdateView` when `status.isInstalled == true`); `CollectionsFragment.kt:754`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_INSTALLED_SUCCESS`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:** Same single-property shape — only `from_screen`.

**Quirks:** **Dead branch**: line 553–555 has `if (status.isDownloaded) {…} else if (status.isInstalled) {…}` inside an outer guard `if (!status.isInstalled)` — meaning the `isInstalled == true` branch is unreachable. In practice this event is never fired from this code path. Flutter may want to fire it from a different observer if the same telemetry intent is desired.

---

### `in_app_update_installed_failed`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_INSTALLED_FAILED)` — `AccountFragment.kt:619` (within `onAppUpdateResult` when `result.resultCode == RESULT_IN_APP_UPDATE_FAILED`); `CollectionsFragment.kt:1341`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_INSTALLED_FAILED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:** Same single-property shape — only `from_screen`.

**Quirks:** Fired in the `ActivityResult` handler when Play Update flow returns `RESULT_IN_APP_UPDATE_FAILED` from `com.google.android.play.core.install.model.ActivityResult`.

---

### `in_app_update_user_cancel`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_USER_CANCELLED)` — `AccountFragment.kt:617` (within `onAppUpdateResult` when `result.resultCode == Activity.RESULT_CANCELED`); `CollectionsFragment.kt:1339`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_USER_CANCELLED` — value `"in_app_update_user_cancel"`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** None.

**Payload:** Same single-property shape — only `from_screen`.

**Quirks:** **CRITICAL — the Kotlin constant is `IN_APP_UPDATE_USER_CANCELLED` (with `-LED` suffix) but the wire string is `"in_app_update_user_cancel"` (NO trailing `led`).** Flutter MUST emit `in_app_update_user_cancel`, not `in_app_update_user_cancelled`. Asymmetric naming preserved for dashboard compatibility.

---

### `in_app_update_install_clicked`

**Android method:** `logInAppUpdateEvent(AnalyticsEvents.IN_APP_UPDATE_INSTALL_CLICKED)` — `AccountFragment.kt:611` (within `onClickOfInstall()`); `CollectionsFragment.kt:2042`
**Event constant:** `AnalyticsEvents.IN_APP_UPDATE_INSTALL_CLICKED`
**logEvent flags:** `attribution=false`, `universal=true`
**Side effects:** Triggers `appUpdateHelper.completeUpdate()` AFTER firing (which invokes the Play Store install confirmation flow, which may then route through `onAppUpdateResult` → `user_cancel` or `installed_failed`).

**Payload:** Same single-property shape — only `from_screen`.

**Quirks:** Distinct from `in_app_update_download_clicked` — this is fired on the "Install" CTA (after download has completed), the other on the "Download" CTA.

---

### `notification_permission_intent_shown`

**Android method:** `NotificationUtil.onNotificationIntentShown()` — `NotificationUtil.kt:44`; also `OrdersMainActivity.kt:97` (inline)
**Event constant:** `AnalyticsEvents.NOTIFICATION_PERMISSION_INTENT_SHOWN`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:**
- `AppRecordData.setNotificationDialogShown(true)` — stops further dialog auto-shows in this session.
- `AppRecordData.setNotificationNudgeDateTime()` — stamps the show timestamp for the dismiss-cooldown rule.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `AnalyticsDefaults.FromScreens.DISCOVER` (`"Discover"`) in `NotificationUtil`; `AnalyticsDefaults.FromScreens.ORDER_LISTING` (`"Order listing"`) in `OrdersMainActivity` | Hard-coded per call site. |

**Quirks:** Two call sites with different `from_screen` values. The Util variant runs the side-effect prefs writes; the OrdersMainActivity inline variant does not (but it does call `binding.notificationNudge.visibility = View.VISIBLE` first).

---

### `notification_permission_accepted`

**Android method:** Multiple inline call sites (no shared helper):
- `OrdersMainActivity.kt:171` — Clevertap `onPushPermissionResponse(accepted=true)` callback
- `OrderConfirmationActivityNew.kt:305` — via `logNotificationRelatedEvent`
- `WebAppActivity.kt:905` — via `fireWishListNudgeEvent`
- `ProductListPageActivity.java:4425` — inline

**Event constant:** `AnalyticsEvents.NOTIFICATION_PERMISSION_ACCEPTED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:** Varies per call site; typically hides the nudge UI.

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | varies | E.g. `"Order listing"` (OrdersMainActivity), `"Discover"` (homepage), etc. |

**Quirks:** Fired when the system push-permission dialog returns `accepted == true` (via CleverTap's `onPushPermissionResponse` callback). Multiple parallel call sites, each with their own `from_screen`.

---

### `notification_permission_rejected`

**Android method:** Multiple inline call sites:
- `OrdersMainActivity.kt:87` (negative-button click) and `:173` (push-permission denied)
- `OrderConfirmationActivityNew.kt:117` and `:307`
- `WebAppActivity.kt:732` and `:907`

**Event constant:** `AnalyticsEvents.NOTIFICATION_PERMISSION_REJECTED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:** Typically hides the nudge UI.

**Payload:** Same single-property shape as `notification_permission_accepted` — only `from_screen`.

**Quirks:** Fired in TWO scenarios per call site: (a) user clicks the in-app nudge's "Not now" button (rejected without ever opening the system dialog), and (b) user dismisses the system permission dialog.

---

### `notification_permission_dismissed`

**Android method:** `NotificationUtil.onNotificationPermissionDismissed()` — `NotificationUtil.kt:53`
**Event constant:** `AnalyticsEvents.NOTIFICATION_PERMISSION_DISMISSED`
**logEvent flags:** `attribution=true`, `universal=false`
**Side effects:** Calls `AppRecordData.setNotificationNudgeDismiss()` (sets the "dismissed" flag on the nudge, separate from the "denied"/"rejected" state — drives the dismissed-frequency-based re-show rule).

**Payload:**

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `from_screen` | `AnalyticsProperties.FROM_SCREEN` | String | required | `"Discover"` | Hard-coded to `AnalyticsDefaults.FromScreens.DISCOVER`. |

**Quirks:** **`dismissed` ≠ `rejected`**: dismissed fires when the user closes the IN-APP nudge bottom-sheet without tapping any button (touch-outside or back-press); rejected fires when they tap "No" / decline the system dialog.

---

### `video_action`

**Android method:** `VideoAnalytics.logVideoActionEvent(analyticsData, action, playButtonClicked=false)` — `VideoAnalytics.kt:53`
**Event constant:** `AnalyticsEvents.VIDEO_ACTION` (in `components/util/AnalyticsEvents.kt:14`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None. Sent via `GlobalObservers.analyticsHelper.send(AnalyticsEvent.SendEvent(...))`. Returns early when `videoDetails == null`.

**Payload:** (always includes base + attribution-data block from `addVideoParameters` + `addAttributionData`)

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `video_page` | `AnalyticsProperties.VIDEO_PAGE` | String | required | `"HP"` or `"LP"` | From bundle `IS_FROM_HOME_PAGE` → `AnalyticsDefaults.VideoPage.HP` / `.LP`. |
| `aspect_ratio` | `AnalyticsProperties.ASPECT_RATIO` | String | conditional | omitted | From `videoDetails.trackingMeta?.aspectRatio`. |
| `video_length` | `AnalyticsProperties.VIDEO_LENGTH` | int/long | conditional | omitted | From `videoDetails.trackingMeta?.videoLength`. |
| `video_identifier` | `AnalyticsProperties.VIDEO_IDENTIFIER` | String | conditional | omitted | |
| `autoplay_enabled` | `AnalyticsProperties.AUTOPLAY_ENABLED` | String | required | `"Yes"` or `"No"` | From `videoDetails.autoplay == true`. |
| `preview` | `AnalyticsProperties.PREVIEW` | String | required | `"Yes"` or `"No"` | `videoDetails.previewUrl.isNullOrEmpty() ? "No" : "Yes"`. |
| `created_date` | `AnalyticsProperties.CREATED_DATE` | String | conditional | omitted | |
| `action` | `AnalyticsProperties.ACTION` | String | required | input | e.g. `"Played"`, `"Paused"`, etc. |
| `played` | `AnalyticsProperties.PLAYED` | String | conditional | omitted | Only when `action == AnalyticsDefaults.PLAYED`: `playButtonClicked ? AnalyticsDefaults.VideoPlayType.PLAY_BUTTON : .AUTO_PLAY`. |
| `cache_percentage` | `AnalyticsProperties.CACHE_PERCENTAGE` | String | conditional | omitted | Only when `action == PLAYED`: `ExoPlayerManager.getCachePercent(videoUrl).toString()`. |
| `component_type` | `AnalyticsProperties.COMPONENT_TYPE` | String | conditional | omitted | Only when `action == PLAYED`: pulled from bundle `BundleKeys.COMPONENT_TYPE`. |
| `<attribution_block>` | from `addAttributionData(...)` | various | varies | varies | If HP: `funnel_row`, `funnel_tile`, `banner_name`, `slice_id`, `property_type`. If LP: `lp_id`, `lp_name`, `lp_funnel_row`, `lp_funnel_tile`, `lp_banner_name`, `lp_slice_id`, `lp_property_type`. |

**Quirks:** `played`/`cache_percentage`/`component_type` are conditional ONLY on `action == "Played"` — for other actions (pause, end, etc.) they're omitted. Attribution-block keys differ between HP and LP contexts (use of `Constants.OrderAttributionParam.*` vs `Constants.LPAttributionParams.*`).

---

### `video_appeared`

**Android method:** `VideoAnalytics.logVideoAppearedEvent(analyticsData)` — `VideoAnalytics.kt:19`
**Event constant:** `AnalyticsEvents.VIDEO_APPEARED` (in `components/util/AnalyticsEvents.kt:12`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:**
- Returns early when `videoDetails == null`.
- Adds `videoIdentifier` to a `helperList`.
- **Dedup**: if `videoIdentifier` is already in `onScreenList` (i.e. already seen this session-on-screen), returns WITHOUT firing the event. Otherwise adds it to `onScreenList` and fires.

**Payload:** Same base + attribution-data block as `video_action`, but without the `action`/`played`/`cache_percentage`/`component_type` keys:

| Property key (wire) | Constant | Type | Required? | Default | Notes |
|---|---|---|---|---|---|
| `video_page` | `AnalyticsProperties.VIDEO_PAGE` | String | required | `"HP"`/`"LP"` | |
| `aspect_ratio` | `AnalyticsProperties.ASPECT_RATIO` | String | conditional | omitted | |
| `video_length` | `AnalyticsProperties.VIDEO_LENGTH` | int/long | conditional | omitted | |
| `video_identifier` | `AnalyticsProperties.VIDEO_IDENTIFIER` | String | conditional | omitted | |
| `autoplay_enabled` | `AnalyticsProperties.AUTOPLAY_ENABLED` | String | required | `"Yes"`/`"No"` | |
| `preview` | `AnalyticsProperties.PREVIEW` | String | required | `"Yes"`/`"No"` | |
| `created_date` | `AnalyticsProperties.CREATED_DATE` | String | conditional | omitted | |
| `<attribution_block>` | from `addAttributionData(...)` | various | varies | varies | HP vs LP block as in `video_action`. |

**Quirks:** **Per-video dedup via `onScreenList`** — same `videoIdentifier` will not refire `video_appeared` until `removeElement` or `clearViewPortList` / `refreshViewPortList` clears it. This is an in-memory dedup, lost on app kill.

---

### `video_link_clicked`

**Android method:** `VideoAnalytics.logVideoLinkClickedEvent(analyticsData)` — `VideoAnalytics.kt:39`
**Event constant:** `AnalyticsEvents.VIDEO_LINK_CLICKED` (in `components/util/AnalyticsEvents.kt:13`)
**logEvent flags:** `attribution=true`, `universal=true`
**Side effects:** None. Returns early when `videoDetails == null`. No dedup.

**Payload:** Identical to `video_appeared` (base + attribution-data, no `action`/`played` keys).

**Quirks:** No dedup (unlike `video_appeared`). Fired on each click of the video's CTA/link overlay.
