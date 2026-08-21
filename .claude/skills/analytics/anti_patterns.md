# Analytics — Anti-Patterns

These are mistakes that look reasonable in code review but silently break the dashboards. Refuse to ship them.

## 1. Hardcoded event or property strings at the call site
```dart
// ❌
_analytics.track('cart_viewed', {'from_screen': 'Home'});

// ✅
_analytics.logCartViewed(fromScreen: AnalyticsDefaults.fromScreens.discover, ...);
```
Reason: dashboards key on exact strings. A typo at the call site is invisible until a PM notices a funnel hole weeks later.

## 2. Inventing new event names
If the Android codebase does not have an equivalent, **escalate to the analytics owner before adding it**. Do not name your own. The data team has Amplitude / CleverTap dashboards already wired off these strings; adding new ones requires a schema review.

## 3. Calling `AnalyticsService.track()` from a widget or page
Analytics emit from Blocs (or Repositories / Usecases that own the side effect). Widgets call `context.read<Bloc>().add(SomeEvent(...))`; the Bloc fires the event. Reason: testability, deduplication (same event from two screens), and consistency with the rest of the architecture.

## 4. Updating user traits via `track`
Traits go to `identify`. Events go to `track`. `cleverTapId`, `userType`, `gender`, `email`, `mobile` are traits — never include them in a `track` payload unless Android explicitly does (cross-check the Android `logXEvent` body).

## 5. Treating `attribution=true` / `universal=true` as decorative
They map to behaviour: which attribution helpers merge, whether the universal buffer flushes. **Always copy the Android `logEvent(... , bool, bool)` flags verbatim.** Defaulting to `false, false` will drop UTM/funnel context from funnel-critical events.

## 6. Resetting identity on logout without checking login state
```dart
// ❌
await _logoutUseCase();
_analytics.resetIdentity();

// ✅
await _logoutUseCase();
if (!prefManager.isLoggedIn) {
  _analytics.resetIdentity();
}
```
Matches Android `resetIdentity()` guard. Calling reset while still logged in nukes the userId from Segment cache and de-anonymises later events incorrectly.

## 7. Firing `app_launched` from arbitrary screens
`logAppLaunched()` must be called from the FIRST viewable screen of the session — never sprinkle it on every screen-viewed handler. Mirror Android: it self-guards via `LaunchTimer.isStopped`, but the call site must still be the entry screen.

## 8. Fire-and-forget identify on every resume
The aggregated `identify(sessionChange, utmChange, userTypeChange, experimentChange)` only fires when traits actually changed. **Do not remove the size-check guard.** Otherwise every backgrounded → foregrounded transition spams Segment with no-op identifies, inflating costs and skewing metrics.

## 9. Calling `track` inside a tight loop without batching
Each impression event has cost. For impression lists (homepage tiles, PLP), batch via a tracker (e.g. `HomeAnalyticsTracker`) that deduplicates by id and flushes once at scroll-stop or on viewport exit. Mirror `HomeTrackAnalyticManager.kt` patterns: store visible-set in a `Set<Tile>`, send `tile_impression` only for previously unseen items.

## 10. Logging PII in non-Crashlytics streams
Do not `print()` payloads. Use the existing `talker` logger gated on `kDebugMode`. Email, phone, name leaving the device must only land in Segment.

## 11. Casing or punctuation drift
Android constants have quirks — **preserve them all**:
- Trailing space: `'profile_photo_uploaded '`
- `[time] ` prefix: `'[time] hour_of_day'`, `'[time] day_of_week'`
- Mixed casing: `'Order Completed'` (Segment standard), `'Product viewed'` (CleverTap special)
- Boolean-as-string: `'Yes'` / `'No'` capitalised
- Sentinel: `'none'` (lowercase) for empty values

If you fix one of these, you break the dashboard. Confirm with the analytics owner before "tidying up".

## 12. Position 0 reindex
Android contains this pattern repeatedly:
```java
if (position == 0) { position = 1; }
properties.put(AnalyticsProperties.POSITION, position);
```
The data layer treats position as 1-indexed. Mirror it. **Do not** send `position: 0` to Segment.

## 13. Async-fire then await
Analytics calls do not need to block the user experience. Fire-and-forget from the Bloc:
```dart
unawaited(_analytics.logCartViewed(...)); // optional
```
But do not await them in the user-facing critical path (loading a page, navigating). The Segment transport already queues to disk.

## 14. Skipping the wire-format diff
Before shipping a port, capture the Android payload from Segment debug for the same scenario and diff against the Flutter one. Use `jq` or `diff` on the raw JSON. Any missing key, type mismatch (`"true"` vs `true`, `"123"` vs `123`), or extra field is a regression.

## 15. Hooking Bloc-state-emit to track instead of Bloc-event
Emit-driven tracking double-fires on optimistic update + revert. Wire `track()` calls to the **action** (Bloc event handler entry / exit), not to the **state** (`BlocListener` on a status field). The exception is impression events that genuinely require the view to be visible — those go through a viewport tracker, not a `BlocListener`.

## 16. Editing the `lib/core/analytics/events/<feature>_events.dart` stubs that still use `class XEvent extends AnalyticsEvent`
These are stubs from before the Segment port. **Do not extend them**. Add to `modules/<feature>_events.dart` as `extension` methods on `AnalyticsHelper`. The typed event class approach will be removed once migration is complete.

## 17. Driving identify from lifecycle observers
The instinct on a lifecycle resume is to fire identify. **Do not.** Identify on this codebase is driven by the HTTP cookie interceptor — server cookies tell us when session/user-type/experiments changed. Wiring `WidgetsBindingObserver.didChangeAppLifecycleState` to call `identifyFromBackground()` will double-fire identify (once on resume, again on first API response) and de-anonymise traits incorrectly. Let the cookie interceptor own this.

## 18. Firing `Order Completed` per item or `product_ordered` once per order
Three terminal events fire on order placement:
- `order_placed` — once per order
- `product_ordered` — once per **line item** (loop)
- `Order Completed` — once per order, with `products: [...]` array

Looping `Order Completed` per item inflates Segment revenue N×. Firing `product_ordered` once per order silently drops N-1 line-item attribution records. See `checkout_chain.md`.

## 19. Clearing `OrderAttributionHelper` after `order_placed`
The instinct is to clear funnel state once an order is placed. **Don't.** The funnel is cleared only on cold start (Splash). The server has already snapshotted the funnel into `trackingData.itemLevelTrackingData[sku]` at ATC time — that's what enriches `product_ordered`. Clearing after order would break repeat-purchase attribution funnels.

## 20. Mocking the CleverTap or AppsFlyer ID into events
`cleverTapId` and `afUserId` are stamped onto every track payload from real SDKs. Both arrive asynchronously at app start — `cleverTapId` via `CleverTapAPI.getCleverTapID { ... }`, `afUserId` from `AppsFlyerLib.getAppsFlyerUID()`. The first few events of a cold start may carry empty strings — **mirror this**. Do not stub `''` to `'pending'` or hold events to wait for the IDs; that breaks the Android-equivalent timing.

## 21. Calling `setCustomerUserId` on AppsFlyer
Android does NOT bind AF to app user id. Do not add this call without analytics owner sign-off — AppsFlyer attribution dashboards assume the current behaviour.

## 22. Using `wzrk_dl` for push deeplinks
The Hopscotch app uses `acme-deeplink` field in FCM payloads, not `wzrk_dl`. `wzrk_dl` is the internal CleverTap key inside their notification handler. Read `data['acme-deeplink']` from the FCM payload.

## 23. Treating Branch as integrated
Branch is **not integrated** on Android. The `AnalyticsDefaults.BRANCH = "Branch"` constant exists but is never set as `from_source`. Do not port Branch without explicit analytics-owner sign-off.

## 24. Using `Segment.track` from inside the cookie interceptor
The cookie interceptor calls `AnalyticsHelper.identifyOnCookieChange(...)` and `AnalyticsHelper.fireSessionStartedEvent()`. Both are the only allowed analytics paths from interceptor code. Don't add ad-hoc `track()` calls there — it gates a service-level concern, not user intent.
