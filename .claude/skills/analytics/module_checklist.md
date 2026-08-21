# Analytics — Per-Module Checklist

When you touch a module, work through this checklist. Every Bloc event that represents user intent or a meaningful state transition must fire an analytics call. If you cannot find the Android equivalent, **stop and search** — invented event names break dashboards.

## Cart

Trigger | Helper method | Notes
---|---|---
Cart page opened | `logCartViewed` | `from_screen`, full price block, `tti`, `cart_view_state`, `first_load`, `quantity_status`, `price_status`, `image_url` list. Also calls `logAppLaunched(SHOPPING_CART)`.
Item quantity changed | `logProductUpdated` | `new_quantity`, `new_sku`, `new_price`, `sku`, `product_id`.
Item removed | `logProductRemovedFromCart` | with `from_location = 'Cart icon'` or `'Remove button'`.
Item moved to wishlist | `logProductAddedToWishlist` | from cart, `from_location = 'Move to wishlist'`.
Promo applied OK | `logPromoCodeApplied(applied: true)` | merges `promo_code`, `promotion_discount`, `merch_promo`.
Promo apply failed | `logPromoCodeApplied(applied: false)` | adds `failed_promo_code`, `promo_error`.
Promo removed | `logPromoCodeRemoved` | with `removed_promo_code`.
Pincode checked from cart | `logPincodeChecked` | use cart variant of from_screen.
Checkout tapped | `logCheckoutClicked(isFromBuyNow)` | starts `CheckoutTimer.updateFirstEventTime()`.
Buy Now tapped | `logBuyNowClicked` | use `source = Buy now`.

## PDP

Trigger | Helper method | Notes
---|---|---
PDP opened | `logProductViewed` | full product blob, `image_count`, `from_screen`, `from_location`, attribution merged.
Size selector opened | `logSelectSizeClicked` | `size_selection = upfront / bottom_sheet`.
Size selected | `logSizeSelected` (internal state).
Size chart opened | `logSizeChartViewed` |
Image carousel scrolled | `logXlProductCardScrolled` | only when PDP eligible.
Add to bag tapped | `logProductAddedToCart` | full product blob + funnel, plus FB `logFacebookAddedToCartEvent`.
Wishlist toggled | `logProductAddedToWishlist` / `logProductRemovedFromWishlist`.
Share tapped | `logProductShareClicked` | with `from_screen = Product details`.
PDP reco rail loaded | `logPdpRecoLoaded`, `logPdpAttributesLoaded`.
PDP reco item tapped | `logRecoClicked`.
A+ content scrolled | `logAPlusContentViewed`.
Shop-the-look tapped | sets `OrderAttributionHelper.redirectedFromShopTheLook`.

## PLP

Trigger | Helper method | Notes
---|---|---
PLP opened | `logProductListingViewed` | `plp_name`, `plp_type`, `feed_size`, `boutique_name`, attribution.
PLP scrolled | `logPlpScrolled` | `scrolled_row`, `from_feed_size`, `scrolled_sections`, `scrolled_funnel_tiles`, `trigger`. Uses `logScrollEvent`.
Filter icon tapped | `logFilterClicked`.
Filter applied | `logFilterApplied` | merges `filter_segment` (key/value map of selections).
Filter cleared | `logFilterApplied(isFilterCleared: true)`.
Sort applied | `logSortingApplied` | `from_sort`, `new_sort`.
Sortbar changed | `logSortbarChanged`.
Pincode checked | `logPincodeChecked` | `from_screen = Filter`.
Brand follow/unfollow | `logBrandFollowed(followed)`.
Tile tapped | `OrderAttributionHelper.add(funnel: null, funnelTile: 'Product$productId', funnelRow: rowPos+1, funnelSection: state.funnelSection, section: state.section)`, then nav. **No track event** (attribution flows through to the next page-viewed/ATC event). Caller's `add(...)` already persists to SharedPreferences — no separate save step needed.
Genie icon tapped | `logPlpGenieIconClicked`.
PLP collection tapped | `logPlpCollectionClicked`.
Smart filter applied | `logSmartFilterApplied`.

## Home / Discover

Trigger | Helper method | Notes
---|---|---
Home opened | `logHomePageViewed` | `from_screen`, `from_location`, `skin`, attribution + universal.
Home scrolled | `logHomepageScrolled` | uses `logScrollEvent` with `useSavedAttribution=true` for backgrounded scrolls.
Hero carousel scrolled | `logCarouselScrolled` | `carousel_id`, `card_index`, `swipe_direction`.
Banner / tile impression | `logBannerImpression`, `logTileImpression` | dedup per `tile_grid_id` per session.
Tile tapped | `logTileClicked` | sets `OrderAttributionHelper` first.
Continue browsing rail | `logContinueBrowsingLoaded/Viewed/Clicked`.
Tab clicked | `logTabClicked`, sets `TabPageAttributionHelper`.
Doorway loaded/viewed/scrolled/clicked | `logDoorways*`.
Shop the look carousel | `logShopTheLook*`.

Pattern: use `HomeTrackAnalyticManager` equivalent (`HomeAnalyticsTracker`) to keep impression/scroll state separate from the Bloc.

## Checkout

Trigger | Helper method | Notes
---|---|---
Checkout started | `logCheckoutEvent(isCheckoutStarted: true)` | merges cart blob via `checkoutProperties`.
Checkout failed | `logCheckoutEvent(isCheckoutStarted: false, error: ...)`.
Mobile entered | `logCheckoutMobile` / `logCheckoutMobileFailed`.
Review screen | `logCheckoutReview` / `logCheckoutReviewFailed`.
Delivery selected | `logCheckoutDelivery` / `logCheckoutDeliveryFailed`.
Payment opened | `logCheckoutPaymentViewed`.
Payment | `logCheckoutPayment` / `logCheckoutPaymentFailed`, with `payment_method`, `payment_mode`, `payment_retry`.
Order placed | `logOrderPlaced` | drives `Order Completed` (Segment standard event name with space + capitals — preserve).
Order failed | `logOrderFailed`.
Order placed (order-level) | `logOrderPlaced` | **Once per order.** order_id, total_amount, discount, shipping, payment_mode, delivery_city, state, pincode, has_gift, atc_user, checkout_user, step_duration, total_duration.
Per-product line item | `logProductOrdered` | **Once per cart item** in a loop. Enriched via `productOrderedProperties(sku)` which reads from the **cached cart response's** `trackingData.itemLevelTrackingData[sku]` (server-echoed, populated at ATC time). Cart repository must cache the most recent `ShoppingBagResponse` for this lookup. `OrderAttributionHelper` is NOT read at order time — that ship sailed at ATC.
Order completed (Segment standard) | `logOrderCompleted` | **Once per order**, with `products: [...]` array per Segment ecommerce spec. Event name is literally `"Order Completed"` (caps + space). Drives CleverTap "Charged" event via the Segment integration. Required for retargeting/abandoned-cart segments.
Facebook purchase | `_facebook.logPurchase` | Fires alongside via `facebook_app_events` plugin. Maps to native `AppEventsLogger.logPurchase`.
Post-order state | (in CartRepository / CheckoutBloc) | Set `isOrderPaid = true`, `segmentUserType = null`, `cartItemQty = 0`. **Do NOT clear** `OrderAttributionHelper`, `FirstCartLoad`, `atcUserType`, `checkoutFlowUserType`. **Do NOT fire** `clear_segment_user_type` — dead Android constant.
Gokwik risk returned | `identifyGokwikRisk`.

`CheckoutTimer` is the lifecycle hook: `step_duration` resets between events, `total_duration` accumulates, `background_time` adds when the app was backgrounded mid-funnel.

## Moments

Trigger | Helper method | Notes
---|---|---
Moments tab opened | `logMomentViewed` | calls `logAppLaunched(MOMENTS)`.
Photo liked | `logMomentPhotoLiked(status: true)`.
Photo unliked | `logMomentPhotoLiked(status: false)` → fires `photo_undid_like`.
Add moment tapped | `logMomentUploadClicked` | `user_status`, `upload_eligibility`.
Upload success | `logPhotoUploaded`.
Photo deleted | `logPhotoDeleted`.
Photo reported | `logPhotoReported`.

## Account

Trigger | Helper method | Notes
---|---|---
Name updated | `logNameUpdated` | `from_name`, new `name`.
Email updated | `logEmailUpdated` | `from_email`, new `email`.
Mobile updated | `logMobileUpdated` | `from_mobile`, new `mobile`.
Password updated | `logPasswordUpdated`.
Address added/edited | `AnalyticsHelperKt.logAddressUpdated` parity → `logAddressUpdated` | with `address = New` / `Updated`, `pincode`, `delivery_available`, `cod_available`, `delivery_city`, `default_address`.
Profile photo uploaded | `logProfilePhotoUploaded` | **preserve trailing space** in `'profile_photo_uploaded '` event name (Android bug carried over).
Sign out tapped | `logCustomerLoggedOut` then `resetIdentity()`.

## Orders

Trigger | Helper method | Notes
---|---|---
Orders list opened | `logOrderListingViewed`.
Order detail opened | `logOrderViewed` | `parent_order_id`, `order_status`, `days_since_order`.
Exchange flow | `logExchangeClicked`, `logProductExchangeClicked`, `logProductExchanged`, `logExchangeAborted`, `logReasonSelected`.
Ratings prompt | see Ratings module.

## Auth

Trigger | Helper method | Notes
---|---|---
Login screen opened | `logLoginViewed` | calls `logAppLaunched(LOGIN)`.
Join screen opened | `logJoinViewed` | calls `logAppLaunched(JOIN)`.
Forgot screen opened | `logForgotViewed`.
OTP sent | `logOtpSent` | `verification_reason`, mobile/email.
OTP verified | `logOtpVerified`.
Login success | `logCustomerLoggedIn` + identify.
Registration success | `logCustomerRegistered` + identify (with `createdAt`).
Logout | `logCustomerLoggedOut`, then `resetIdentity()` when not logged in.

## Categories / Search

Trigger | Helper method | Notes
---|---|---
Categories tab | `logCategoryTreeViewed` | `department_name`.
Search icon tapped | `logSearchClicked`.
Search executed | `logProductsSearched` | `keyword`, `length`, `search_result_pids`, `query_correction`.
Search tooltip nudge shown | `logSearchNudgeShown` → fires `tooltip_viewed`.

## Ratings / NPS

Trigger | Helper method | Notes
---|---|---
Product rating screen | `logRatingReviewViewed`.
Rating submitted | `logProductRated`.
NPS shown | `logNpsFeedback` (or relevant impl).
Shopping experience rating shown | `logRateShoppingExperienceShownAt`.
Play Store prompt response | `logRateInPlaystoreUserResponse`.
Dismissed | `logRateShoppingExperienceDismissedAt`.

## In-app update / notifications

Trigger | Helper method
---|---
Download CTA | `logInAppUpdateDownloadClicked`
Later CTA | `logInAppUpdateLaterClicked`
Install shown | `logInAppUpdateInstallShown`
Install success | `logInAppUpdateInstalledSuccess`
Install failed | `logInAppUpdateInstalledFailed`
User cancelled | `logInAppUpdateUserCancelled`
Install clicked | `logInAppUpdateInstallClicked`
Push permission intent | `logNotificationPermissionIntentShown`
Push accepted | `logNotificationPermissionAccepted`
Push rejected | `logNotificationPermissionRejected`
Push dismissed | `logNotificationPermissionDismissed`

## How to know you missed something

After your PR is staged, in Android Studio run a search for every `AnalyticsHelper.getInstance().` call inside the module's Activity / Fragment / ViewModel. Each one must have a Flutter counterpart in the equivalent Bloc/page. Missing calls = silently broken funnel.
