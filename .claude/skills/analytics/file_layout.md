# Analytics — File Layout

All analytics code lives under `lib/core/analytics/`. Never sprinkle event constants or `track()` calls inside feature folders.

```
lib/core/analytics/
├── analytics_service.dart                ← transport wrapper (Segment + integrations)
├── constants/
│   ├── analytics_events.dart             ← event-name strings (mirrors AnalyticsEvents.java)
│   ├── analytics_properties.dart         ← property-key strings (mirrors AnalyticsProperties.java)
│   └── analytics_defaults.dart           ← magic values + FromScreens / FromLocations / ClickType
├── interceptors/
│   └── cookie_analytics_interceptor.dart ← Dio interceptor that drives identify + session_started from server cookies
├── attribution/
│   ├── utm_header_util.dart              ← in-memory + SharedPreferences UTM cache, parsed by AppLinkUtil
│   ├── lp_attribution_helper.dart        ← bounded deque (max 5) of landing-page visits, persisted
│   ├── order_attribution_helper.dart     ← funnel/section/plp etc., persisted, cascade-aware setter
│   └── tab_page_attribution_helper.dart  ← in-memory stack of tab pages
├── state/
│   ├── analytics_common_properties.dart  ← one-shot "universal" buffer (First screen flag)
│   ├── launch_timer.dart                 ← ttl / tti / install_type / from_source (runtime only)
│   ├── checkout_timer.dart               ← step_duration / total_duration / background_time (runtime only)
│   └── experiments_util.dart             ← parses EXPERIMENTS cookie, exposes list for identify trait
└── events/
    ├── analytics_helper.dart             ← THE aggregator. Re-exports all module extensions.
    ├── common_events.dart                ← cross-module loggers (identify*, search, deeplink, share)
    └── modules/
        ├── auth_events.dart              ← login, join, otp, forgot, registered
        ├── home_events.dart              ← home_page_viewed, tile_impression, banner_impression, carousel_scrolled
        ├── pdp_events.dart               ← product_viewed, pdp_reco_loaded, size_chart_viewed
        ├── plp_events.dart               ← product_listing_viewed, filter_*, sorting_applied, pincode_checked
        ├── cart_events.dart              ← cart_viewed, product_added_to_cart, promo_code_*, wishlist
        ├── checkout_events.dart          ← checkout_*, order_placed, product_ordered, Order Completed, gokwik
        ├── moments_events.dart           ← moments_viewed, photo_liked, photo_upload_clicked
        ├── account_events.dart           ← name/email/mobile/password/address updates, profile photo
        ├── orders_events.dart            ← order_listing_viewed, order_viewed, exchange, return
        ├── categories_events.dart        ← category_tree_viewed
        ├── ratings_events.dart           ← product_rated, nps_*, app_rating_*, shopping_experience_*
        ├── reco_events.dart              ← reco_clicked, reco_products_viewed
        ├── lifecycle_events.dart         ← application_opened, app_launched, session_started, in_app_update_*
        ├── attribution_events.dart       ← lp_tile_*, tab_*, continue_browsing_*
        └── child_profile_events.dart     ← child_profile_added/_deleted + identifyForChildCohorts trait flow
```

Note: `state/app_record.dart` from the earlier draft is **gone** — the analytics state it held (user_type, visitor_type, last_visit_date, etc.) collapses into `PrefManager` (see `storage_backbone.md`). Don't introduce a parallel wrapper.

The `experiments_events.dart` placeholder from the earlier draft is also gone — `clear_segment_user_type` is a dead Android constant that never fires. Experiment exposure is tracked **only** via the `experiments` identify trait, fired by the cookie interceptor.

## File responsibilities

### `analytics_service.dart`
Thin wrapper over the Segment SDK. **Only two methods**: `track` and `identify`. Owns AppsFlyer id and CleverTap id getters. Reads write-key from `.env`. Disk-queues events on poor connectivity.

### `constants/analytics_events.dart`
```dart
class AnalyticsEvents {
  AnalyticsEvents._();
  static const String customerLoggedIn = 'customer_logged_in';
  static const String homePageViewed = 'homepage_viewed';
  static const String cartViewed = 'cart_viewed';
  // ... mirror every entry from Android AnalyticsEvents.java
}
```

### `constants/analytics_properties.dart`
```dart
class AnalyticsProperties {
  AnalyticsProperties._();
  static const String fromScreen = 'from_screen';
  static const String fromLocation = 'from_location';
  static const String productId = 'product_id';
  // ... mirror every entry from Android AnalyticsProperties.java
}
```

### `constants/analytics_defaults.dart`
Magic values plus nested static classes for `FromScreens`, `FromLocations`, `ClickType`, `QueryCorrection`, `Universal`. Names must match Android.

### `events/analytics_helper.dart`
The single aggregator. Holds the two low-level methods:

- `Future<void> logEvent(String event, Map<String, Object?> properties, {bool attribution = false, bool universal = false, bool useSavedAttribution = false})`
- `Future<void> logScrollEvent(String event, Map<String, Object?> properties, {bool attribution = false, bool universal = false, bool useSavedAttribution = false})`

Re-exports all the module extension files so callers `import 'package:hs_app_flutter/core/analytics/events/analytics_helper.dart';` and get every typed method in scope.

### `events/common_events.dart`
Shared loggers used by multiple modules:
- `identify*` family (anonymous, with userId, gender, gokwik, child cohorts, background resume).
- `logCustomerLoggedIn`, `logCustomerRegistered`, `logCustomerLoggedOut`, `loggedOutEvent`.
- `logOtpSent`, `logOtpVerified`.
- `logSearchClicked`, `logSearchNudgeShown`.
- `logAppShareClicked`.
- Deeplink open helpers.

### `events/modules/<feature>_events.dart`
Each file is an `extension` on `AnalyticsHelper` that adds module-specific typed methods. Each method translates its parameters to a `Map<String, Object?>` using the constant keys, then delegates to `logEvent(...)`.

```dart
extension CartEvents on AnalyticsHelper {
  Future<void> logCartViewed({
    required String fromScreen,
    required double totalItemPrice,
    required double totalAmount,
    // ... full parity with Android logCartViewedEvent
  }) {
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen: fromScreen,
      AnalyticsProperties.totalItemPrice: totalItemPrice,
      AnalyticsProperties.totalAmount: totalAmount,
      // ...
    };
    return logEvent(
      AnalyticsEvents.cartViewed,
      props,
      attribution: true,
      universal: true,
    );
  }
}
```

## Naming

- Method names: `log<EventName>` (camelCase), matching Android `log<EventName>Event()` minus the `Event` suffix when redundant. Example: `logCartViewed`, `logProductAddedToCart`, `logFilterApplied`.
- File names: `<feature>_events.dart` (lowercase, snake_case).
- Constants: camelCase Dart fields, snake_case string values matching Android verbatim.

## DI

`AnalyticsService` and `AnalyticsHelper` are both `@lazySingleton`. They are constructor-injected wherever needed (Bloc, Repository, Service) — never accessed via `sl<>()` from inside a widget tree.

```dart
@injectable
class CartBloc extends BaseBloc<CartEvent, CartState> {
  CartBloc(this._repo, this._analytics) : super(...);
  final CartRepository _repo;
  final AnalyticsHelper _analytics;
}
```