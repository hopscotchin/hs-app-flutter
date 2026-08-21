# Analytics — Checkout & Order Event Chain

The checkout/order chain is the highest-stakes part of the analytics surface — these events drive revenue dashboards. Get the loop wrong, count items twice or miss them, and weekly revenue numbers lie.

> **Android references:**
> - `hsapp/.../communication/CheckoutObserver.kt` — the three terminal events fire from here.
> - `hsapp/.../analytics/AnalyticsHelper.java` — checkout-stage helpers and `setProductOrderedData(sku)`.
> - `hsapp/.../helper/CheckoutTimerHelper.java` — `step_duration`, `total_duration`, `background_time`.
> - `hsapp/.../analytics/facebook/FacebookAppEventsHelper.kt` — parallel Facebook purchase event.

## The three terminal events

Three different events fire on order completion. They are NOT redundant — each serves a different dashboard.

| Event | Event name (verbatim) | Loop | Purpose |
|---|---|---|---|
| `order_placed` | `"order_placed"` | **Once per order** | Custom funnel event for Amplitude / internal dashboards. Order-level aggregates. |
| `product_ordered` | `"product_ordered"` | **Once per cart line item** (loop over `orderDetails.items`) | Per-item revenue + attribution funnel. Enriched per item via `setProductOrderedData(sku)`. |
| `Order Completed` | `"Order Completed"` (capitals + space) | **Once per order** | Segment-standard ecommerce spec. Has `products: [...]` array, `revenue`, `currency = "INR"`, `order_id`. Drives CleverTap "Charged" event automatically via Segment routing. |

All three are fired by `CheckoutObserver` after the order-place API succeeds. They use `attribution: false, universal: false` because attribution is already baked into each line item via `setProductOrderedData(sku)`.

## Loop semantics — get this exactly right

```dart
Future<void> onOrderPlaced(OrderResponse response) async {
  // 1. order_placed — once
  await _analytics.logOrderPlaced(
    orderId: response.orderId,
    totalAmount: response.totalAmount,
    discount: response.discount,
    discountPercentage: response.discountPercentage,
    shipping: response.shipping,
    paymentMode: response.paymentMode,
    deliveryCity: response.deliveryCity,
    state: response.state,
    pincode: response.pincode,
    hasGift: response.hasGift,
    messageBar: response.messageBarType,
  );

  // 2. product_ordered — once per line item
  for (final item in response.orderDetails.items) {
    final perItemProps = _buildPerItemProperties(item);
    final attributionProps = _analytics.productOrderedProperties(item.sku);
    await _analytics.logProductOrdered({
      ...perItemProps,
      ...attributionProps,
    });
  }

  // 3. Order Completed — once, with products array per Segment spec
  await _analytics.logOrderCompleted(
    orderId: response.orderId,
    revenue: response.totalAmount,
    currency: 'INR',
    products: response.orderDetails.items.map((i) => {
      AnalyticsProperties.productId: i.productId,
      AnalyticsProperties.sku: i.sku,
      AnalyticsProperties.name: i.name,
      AnalyticsProperties.price: i.price,
      AnalyticsProperties.quantity: i.quantity,
      AnalyticsProperties.category: i.categoryName,
      AnalyticsProperties.brand: i.brandName,
    }).toList(),
  );

  // 4. Parallel ecosystem
  await _facebook.logPurchase(
    productIds: response.orderDetails.items.map((i) => i.productId).join(','),
    brands: response.orderDetails.items.map((i) => i.brandName).join(','),
    itemCount: response.orderDetails.items.length,
    totalAmount: response.totalAmount,
    coupon: response.appliedPromoCode,
  );

  // 5. Post-order state
  await _prefs.setIsOrderPaid(true);
  await _prefs.setSegmentUserType(null);   // ONLY this clears
  await _prefs.setCartItemQty(0);
  // DO NOT clear: OrderAttributionHelper, FirstCartLoad, ATCUserType, CheckoutFlowUserType.
  // DO NOT fire: clear_segment_user_type (constant exists but never fires).
}
```

## What does NOT clear after `order_placed`

Easy to over-clean. Don't.

| State | Cleared? | Note |
|---|---|---|
| `OrderAttributionHelper` (`currentAttributionData`) | **NO** | Cleared only on cold start (Splash). Subsequent purchases without a new tile click retain the same funnel — by design (server-cached at ATC time anyway). |
| `FirstCartLoad` flag | **NO** | Cleared only on Splash. |
| `AppRecordData.atcUserType` | **NO** | Persists. |
| `AppRecordData.checkoutFlowUserType` | **NO** | Persists. |
| `AppRecordData.segmentUserType` | **YES** | Set to `null` by `CheckoutObserver` (this is the one explicit clear). |
| `AppRecordData.isOrderPaid` | Set to `true` | Used for repurchase suppression. |
| Cart quantity | Set to `0` | Via cart data layer. |
| `CheckoutTimerHelper.firstEventTime` / `lastEventTime` | **NO** | They naturally reset on next `checkout_clicked`. |
| `CheckoutTimerHelper.backgroundTimer` | Conditionally — reset only after a non-zero `background_time` is read |
| `clear_segment_user_type` event | **NEVER FIRED** | Dead constant on Android. Skip entirely. |

## Checkout stages (between `cart_viewed` and `order_placed`)

```
cart_viewed                (logCartViewed — sets CheckoutTimer? no, just logs)
   │
   ▼
checkout_clicked           ← CheckoutTimer.updateFirstEventTime() — initialises both firstEventTime and lastEventTime
   │
   ├─► checkout_failed     (error branch)
   │
   ▼
checkout_started           ← addUserType() → getTimeSinceLastEvent(reset=true)
   │
   ▼
checkout_mobile            ← addUserTypeAndDuration(reset=true)
   │
   ├─► checkout_mobile_failed
   │
   ▼
checkout_review            ← addUserTypeAndDuration(reset=true)
   │
   ├─► checkout_review_failed
   │
   ▼
checkout_payment_viewed    ← addUserTypeAndDuration(reset=true)
   │
   ▼
checkout_delivery          ← addUserTypeAndDuration(reset=true)
   │
   ├─► checkout_delivery_failed
   │
   ▼
checkout_payment           ← addUserTypeAndDuration(reset=true) — payment_method, payment_mode, payment_retry
   │
   ├─► checkout_payment_failed
   ▼
order_placed + product_ordered (loop) + Order Completed + Facebook purchase
```

Every step adds `atc_user`, `checkout_user`, `step_duration` (since previous step, reset on read), `total_duration` (since `checkout_clicked`), and `background_time` (accumulated; reset after read if > 0).

## `setProductOrderedData(sku)` — the enrichment lookup

This is the function (Android `AnalyticsHelper.java:1171–1311`) that builds the per-item attribution map for `product_ordered`. It reads from the **cached most-recent cart response** — `Util.getShoppingBagResponse().trackingData.itemLevelTrackingData[sku]` — and returns a `Map<String, Object?>` of every non-empty field:

```
atc_user, funnel, section, subsection, plp, atc_site, atc_date,
funnel_section, funnel_tile, funnel_row, sortbar, sortbar_group, sort_by,
merch_type, country, hbt, taste, style, season, pattern, character, weave,
property_type, slice_id, cta, banner_name,
is_pid_aplus, aplus_virtual_group_name, aplus_usp_list (csv → list), aplus_content_type,
source_tile_type, count_of_pids_in_style_code, style_code,
redirected_from_colour_widget, redirected_from_continue_browsing_widget,
redirected_from_cluster_eligible_plp, redirected_from_shop_the_look,
redirected_from_tab_page, tabbed_page_container_name, tabbed_page_container_id,
tab_name, tab_position,
+ LPAttributionHelper.fillWithTrackingData(productTrackingData)  → lp1_*…lp5_*
+ UTMAttributionHelper.fillWithTrackingData(productTrackingData) → product_utm_*
```

### Flutter contract

The cart repository must cache the most recent `ShoppingBagResponse` (entity, not the raw model). `AnalyticsHelper.productOrderedProperties(String sku)` reads from that cache.

```dart
@lazySingleton
class CartRepositoryImpl implements CartRepository {
  ShoppingBagResponse? _latestCartResponse;
  ShoppingBagResponse? get latestCartResponse => _latestCartResponse;

  @override
  Future<Either<Failure, Cart>> loadCart() async {
    final result = await _remote.loadCart();
    return result.fold(
      (f) => Left(f),
      (cart) {
        _latestCartResponse = cart;  // cache for analytics
        return Right(cart.toEntity());
      },
    );
  }
}
```

```dart
extension OrderAnalytics on AnalyticsHelper {
  Map<String, Object?> productOrderedProperties(String sku) {
    final cart = _cartRepo.latestCartResponse;
    final tracking = cart?.trackingData?.itemLevelTrackingData?[sku];
    if (tracking == null) return const {};

    return <String, Object?>{
      if (tracking.atcUser?.isNotEmpty == true) AnalyticsProperties.atcUser: tracking.atcUser,
      if (tracking.funnel?.isNotEmpty == true) AnalyticsProperties.funnel: tracking.funnel,
      // ... port every field from Android setProductOrderedData verbatim
      ..._lpHelper.fillWithTrackingData(tracking),
      ..._utmHelper.fillWithTrackingData(tracking),
    };
  }
}
```

Inject the cart repository into `AnalyticsHelper` (or a thin `OrderAnalyticsContext` that wraps it) — analytics needs read access without owning the cart.

## Facebook parallel purchase

Fires alongside `order_placed`, not via Segment:

```kotlin
HsApplication.getHsApplication().getFacebookAppEventsHelper()
    .logFacebookPurchaseEvent(
        productIdsList.toString(),
        brandsList.toString(),
        itemCount,
        totalAmount,
        coupon
    )
```

Maps to `AppEventsLogger.logPurchase(BigDecimal, Currency, params)`. Flutter equivalent: `facebook_app_events` plugin's `logPurchase`.

Same pattern for any other ecosystem SDK (AppsFlyer, CleverTap charged). On Android currently **only Facebook fires** at order time — no AppsFlyer purchase, no CleverTap charged via direct SDK call (CleverTap "Charged" arrives via the Segment integration's `Order Completed` mapping).

## What goes wrong if you miss any of this

- **Forgetting `Order Completed`** → CleverTap "Charged" never fires → all revenue-based segments (retargeting, abandoned-cart suppression) break.
- **Looping `Order Completed` per item** → revenue 5x inflated in Segment.
- **Looping `order_placed` per item** → order count 5x inflated in Amplitude.
- **Skipping `setProductOrderedData(sku)`** → product_ordered events ship without funnel attribution → can't trace which PLP/PDP path drove the revenue.
- **Caching `null` `cleverTapId` at app start** → first session's events lack CT id → CleverTap user merging fails.
- **Clearing `OrderAttributionHelper` after order** → next order without intervening tile click ships with empty funnel.
- **Firing the dead `clear_segment_user_type` event** → unknown event in Segment, ignored everywhere.
