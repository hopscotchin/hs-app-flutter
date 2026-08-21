# Analytics — Storage Backbone

Maps every piece of analytics state to its persistence location. Required reading before touching `PrefManager` or building a new identify/lifecycle event.

> **Android references:**
> - `hsapp/.../db/AppRecordData.java` — most analytics keys.
> - `common/.../util/PrefUtils.kt` — `cleverTapId`, `userId`, `lpAttributionData`.
> - `hsapp/.../util/CookiesBasedEventsUtil.java` — the single writer for session/user-type/experiment state, fired from the HTTP response interceptor.
> - `hsapp/.../util/UTMHeaderUtil.java` — UTM in-memory + disk cache.

## State catalog

| Concept | Android storage | Flutter target | Writer (Android) | Reader |
|---|---|---|---|---|
| `userType` | `AppRecordData.userType` (SharedPreferences) | `PrefManager.userType` | `CookiesBasedEventsUtil.handleCookies` from cookie `WEBSITE_customersegment` | `AnalyticsHelper.identifyWithUserType()` — sent as identify trait `user_type` |
| `segmentUserType` | `AppRecordData.segmentUserType` | `PrefManager.segmentUserType` | `CookiesBasedEventsUtil.handleCookies` from cookie `segment_user_type` | `identifyWithUserType()` as fallback when `userType` empty. **Cleared post-`order_placed`** (set null in `CheckoutObserver`). |
| `atcUserType` | `AppRecordData.atcUserType` | `PrefManager.atcUserType` | Checkout flow / cart repository at ATC time | `AnalyticsHelper.addUserType()`, `addUserTypeAndDuration()`, cart/PDP loggers as `atc_user`. **Not cleared post-order.** |
| `checkoutFlowUserType` | `AppRecordData.checkoutFlowUserType` | `PrefManager.checkoutFlowUserType` | Checkout flow | `addUserType()`, `addUserTypeAndDuration()` as `checkout_user`. **Not cleared post-order.** |
| `startSessionId` | `AppRecordData.startSessionId` | `PrefManager.startSessionId` | `CookiesBasedEventsUtil.handleCookies` (sets to cookie-supplied `sessionId`) | `AnalyticsService.track` integration options `{Amplitude: {session_id}}` |
| `sessionCount` | `AppRecordData.sessionCount` | `PrefManager.sessionCount` (already exists) | `CookiesBasedEventsUtil` increments on session change | telemetry-only |
| `previousExperiments` | `AppRecordData.previousExperiments` | `PrefManager.previousExperiments` (already exists) | `CookiesBasedEventsUtil` from cookie `EXPERIMENTS` | `identifyOnExperimentChange()` |
| `currentAttributionData` | `AppRecordData.currentAttributionData` (JSON blob) | `PrefManager.currentAttributionData` | `OrderAttributionHelper` via every `AttributionData` setter | `getOrderAttributionRequestParams()`, `getOrderAttributionSegmentParams()` |
| `attributionDataForScrollEvent` | `AppRecordData.orderAttributionDataForScrollEvent` (Map JSON) | `PrefManager.attributionSnapshotForScroll` | Shell route mount + tab change snapshots `getOrderAttributionSegmentParams()` | `logScrollEvent(useSavedAttribution=true)` |
| `lpAttributionData` | `PrefUtils.lpAttributionData` (ArrayDeque JSON) | `PrefManager.lpAttributionData` | `LPAttributionHelper.addLPAttributionData` on landing-page open | `getLPAttributionSegmentData()`, `LPAttributionHelper.fillWithTrackingData(...)` for order-time enrichment |
| `isFirstInstall` | `AppRecordData.isFirstInstall` (default true) | `PrefManager.isFirstInstall` | First-launch detection in `HsApplication.onCreate` | `AnalyticsHelper.fireLifeCycleEvents()` decides `install_type = "new"` |
| `applicationStatus` | `AppRecordData.applicationStatus` | `PrefManager.applicationStatusFlag` | `AnalyticsHelper.fireApplicationOpenedEvent` resets to false; lifecycle observer sets true on app start | `logAppLaunched()` → fires `application_opened` if true |
| `versionName`, `versionCode` | `AppRecordData.versionName`, `versionCode` | `PrefManager.cachedVersionName`, `cachedVersionCode` | `AnalyticsHelper.fireLifeCycleEvents` after deciding `install_type` | `fireApplicationOpenedEvent` uses to compute `previous_version` / `previous_build` |
| `isUpdated` | `AppRecordData.isUpdated` | `PrefManager.isUpdated` | `fireLifeCycleEvents` when version changed | Misc UI gating |
| `deviceProfile`, `isDeviceProfileSet` | `AppRecordData.deviceProfile`, `isDeviceProfileSet` | `PrefManager.deviceProfile`, `isDeviceProfileSet` | `Util.setDeviceProfile()` in `HsApplication.onCreate` | `fireApplicationOpenedEvent` |
| `lastVisitDate`, `daysSinceLastVisit` | `AppRecordData.lastVisitDate`, `daysSinceLastVisit` | `PrefManager.lastVisitDate`, `daysSinceLastVisit` | `CookiesBasedEventsUtil` from `OtherSessionInfo` cookie | `identifyOnSessionChange()` |
| `isNewVisitor` | `AppRecordData.isNewVisitor` (defaults true) | `PrefManager.isNewVisitor` | `identifyOnSessionChange()` flips to false after first session-change identify | Same method reads it before flipping |
| `homePageSkin` | `AppRecordData.homePageSkin` | `PrefManager.homePageSkin` | Server response on home page load | `homePageViewedEvent` |
| `cleverTapId` | `PrefUtils.cleverTapId` | `PrefManager.cleverTapId` | `CleverTapHelper.addCleverTapId()` callback | `addCleverTapId()` (stamped on every track + identify) |
| `pushEnabled`, `isFBAvailable`, `isWaAvailable`, `isFcAvailable`, `isMyAvailable`, `isDeviceRooted` | `AppRecordData.*` | `PrefManager.*` | Device probes in `HsApplication.onCreate` (manifest queries + root detection) | `fireApplicationOpenedEvent` |
| `userId` | `PrefUtils.userId` | `PrefManager.userId` (already lives on `customerInfo` blob) | Login/registration repos on success | `AnalyticsService.identify(userId: ...)` |
| `isOrderPaid` | `AppRecordData.isOrderPaid` | `PrefManager.isOrderPaid` | `CheckoutObserver.handleOrderPlaced` | Used by repurchase suppression — not analytics directly. |

## Cookie → state writeback flow

Critical, **and I previously missed this**: most of the user-type / session / experiment state is set not by the app but by the **server response interceptor**.

```
HTTP response
    │
    ▼
CookiesReceiverInterceptor.intercept()
    │
    └─► CookiesBasedEventsUtil.handleCookiesAndSessionStartEvent(response)
            │
            ├─ Parse OtherSessionInfo cookie ──► sessionId, lastVisitdate, daysSinceLastVisit
            ├─ Parse WEBSITE_customersegment ──► userType
            ├─ Parse segment_user_type ──────────► segmentUserType
            ├─ Parse EXPERIMENTS ────────────────► ExperimentParser → ExperimentsUtil
            ├─ Persist to AppRecordData/PrefUtils
            ├─ Compute change flags:
            │     isSessionChange = (cookie.sessionId != AppRecordData.startSessionId)
            │     isUserTypeChange = (cookie.userType != AppRecordData.currentUserType)
            │     isUtmChange = UTMHeaderUtil.isUtmChanged()
            │     isExperimentChange = (parsed != previousExperiments)
            ├─ AnalyticsHelper.identify(
            │     isSessionChange, isUtmChange, isUserTypeChange, isExperimentChange
            │   )
            └─ if isSessionChange:
                  AnalyticsHelper.fireSessionStartedEvent()
                  AppRecordData.sessionCount++
                  AppRecordData.startSessionId = cookie.sessionId
                  AppRecordData.currentUserType = cookie.userType
```

### Implication for Flutter

We need a **`CookieAnalyticsInterceptor`** (Dio interceptor) installed in `NetworkClient`'s interceptor chain. Order matters — it must run **after** the existing cookie-store interceptor (so cookies are persisted first), but **before** any business logic interceptor. The interceptor:

1. Reads the response cookies.
2. Looks up the four cookie names (`OtherSessionInfo`, `WEBSITE_customersegment`, `segment_user_type`, `EXPERIMENTS`).
3. Persists each to `PrefManager`.
4. Computes the four `isXChange` flags.
5. Calls `AnalyticsHelper.identifyOnCookieChange(...)` (which internally delegates to the lower-level `identify(...)`).
6. Calls `AnalyticsHelper.fireSessionStartedEvent()` when session changed.

**This is the single most important port-correctness item beyond attribution.** Without it, identify will only ever fire on login/registration — every dashboard funnel that depends on session-rotated user-type segmentation will silently degrade.

## Visitor type lifecycle

- `isNewVisitor = true` on install (default in `AppRecordData`).
- First time `identifyOnSessionChange()` runs, it sends `visitor_type = "new visitor"` (lowercase, with space) and **immediately flips** `isNewVisitor = false`.
- All subsequent session changes send `visitor_type = "repeat visitor"`.
- Visitor type only resets on app reinstall (uninstall clears SharedPreferences).

## Constants to mirror verbatim

| Constant | Value |
|---|---|
| `AnalyticsDefaults.NEW_VISITOR` | `"new visitor"` (lowercase, single space) |
| `AnalyticsDefaults.REPEAT_VISITOR` | `"repeat visitor"` |
| `AnalyticsDefaults.NEW` | `"New"` |
| `AnalyticsDefaults.UPDATE` | `"Update"` |
| `AnalyticsDefaults.APPS_FLYER` | `"AppsFlyer"` |
| `AnalyticsDefaults.PUSH` | `"Push"` |
| `AnalyticsDefaults.BRANCH` | `"Branch"` (never set on Android — present for future use) |
| `AnalyticsDefaults.NONE` | `"none"` (lowercase) |
| `AnalyticsDefaults.YES` / `NO` | `"Yes"` / `"No"` (capitalised) |
| `AnalyticsDefaults.PLATFORM_ANDROID` | `"android"` — on iOS send `"ios"` |
| `AnalyticsDefaults.FIRST_SCREEN` | `"First screen"` |
| `AnalyticsDefaults.INTEGRATION_AMPLITUDE` | `"Amplitude"` |

## Things explicitly NOT in PrefManager

- The `applicationStatusFlag` "did we already fire application_opened this lifecycle" toggle is held in `AppRecordData` on Android. We can mirror with `PrefManager` or hold it as a runtime-only `LaunchTimer` field — Android does the former.
- `LaunchTimer.launchTime` / `tti` / `ttl` / `launchSource` are **runtime only**, never persisted.
- `CheckoutTimerHelper.firstEventTime` / `lastEventTime` / `backgroundStart` / `backgroundEnd` are **runtime only**.
- `TabPageAttributionHelper` stack is **runtime only**.
- `UtmHeaderUtil` has both runtime-cached fields and a SharedPreferences mirror. Mirror both — the in-memory copy is the source of truth during a session.
