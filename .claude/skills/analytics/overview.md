# Analytics — Overview

Hopscotch ships analytics to Segment (with downstream destinations Amplitude, CleverTap, AppsFlyer, Facebook). This Flutter app must produce **wire-identical payloads** to the native Android app — event names and property keys are dashboard-keyed strings; renaming or casing changes will silently break funnels and journeys.

## Source of truth

The canonical reference is the Android implementation at:
`/Users/prudhvi.kumar/Documents/Hopscotch/hs-app-android/hsapp/src/main/java/in/hopscotch/android/analytics/`

When in doubt about an event name, property key, or default magic-string value, **read the Android file first**. Do not invent new strings.

Key Android files to mirror:

- `AnalyticsHelper.java` — the god-helper. Every per-module logger comes from here.
- `AnalyticsEvents.java` — 180+ event name constants.
- `AnalyticsProperties.java` — 400+ property key constants.
- `AnalyticsDefaults.java` — magic values + `FromScreens`, `FromLocations`, `ClickType`, `QueryCorrection`.
- `AnalyticsCommonPropertiesHelper.java` — one-shot "universal" buffer (used for `First screen` flag).
- `HomeTrackAnalyticManager.kt` — homepage page-component impression / scroll tracker.
- `impl/*` — module specialised helpers (orders, ratings, exchange, tabpage, webapp, child profile).

## Non-negotiables

1. **Event/property strings live in constants files only.** No literal `"product_added_to_cart"` or `"from_screen"` at the call site. Always `AnalyticsEvents.productAddedToCart` and `AnalyticsProperties.fromScreen`.
2. **Every Bloc that performs a user-meaningful action emits an analytics event.** No silent flows.
3. **Use the strongly-typed `AnalyticsHelper` methods.** Do not call `AnalyticsService.track()` directly from a Bloc, page, or widget unless the method does not yet exist — in which case add it to the right module file under `lib/core/analytics/events/modules/`.
4. **Identify writes traits; track writes events.** Never use `track` to update a user trait.
5. **Attribution must flow.** Tile clicks set the funnel; PDP, ATC, cart, and checkout events merge it. **Funnel attribution is NOT cleared on `order_placed`** — only on cold-start (Splash). See `attribution.md`.
6. **Identify is driven by the HTTP cookie interceptor, not by lifecycle.** The server tells us when session/user-type/experiments change. See `identify_and_lifecycle.md` — Cookie-driven identify.
7. **Lifecycle events** — `application_opened` is decided by `fireLifeCycleEvents()` based on cached version vs current; `app_launched` fires once per cold start when `LaunchTimer` hasn't yet stopped; `session_started` fires from the cookie interceptor when `sessionId` rotates. Do not fire any of them manually from arbitrary screens.
8. **Checkout order chain has three terminal events** — `order_placed` (once per order), `product_ordered` (once per line item, in a loop), `Order Completed` (once per order, with `products: [...]`). All three are required. See `checkout_chain.md`.

## Transport

`AnalyticsService` wraps Segment. Two methods only:

- `track(String event, Map<String, Object?> properties)` — fires a Segment track call with Amplitude session options + AppsFlyer/CleverTap id injection.
- `identify({String? userId, required Map<String, Object?> traits})` — fires a Segment identify call.

All event enrichment (time buckets, `afUserId`, `cleverTapId`, `timestamp`, `universal`, attribution merge) happens in `AnalyticsHelper.logEvent()`, not in the transport. Keep the transport dumb.

## How this differs from the existing `lib/core/analytics/` stub

The current `AnalyticsService` is a TODO stub and the typed `AnalyticsEvent` classes under `events/` are a parallel attempt that does not match Android wire format. They are being replaced by:

- A real `AnalyticsService` wrapping Segment.
- `AnalyticsHelper` (the aggregator) with per-module method extensions.
- Constant files mirroring Android verbatim.

Until the migration is complete, do not add new typed `AnalyticsEvent` subclasses — add methods to the right `modules/<feature>_events.dart` file.