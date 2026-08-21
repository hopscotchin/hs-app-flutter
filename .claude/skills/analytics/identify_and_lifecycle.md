# Analytics — Identify, Traits, and Lifecycle

## Identify rules

Segment `identify` writes **traits** to the user, not events. Treat the two operations as separate.

Trigger an identify call in these scenarios — each maps to an Android `identify*()` method:

| Trigger | Method | Notes |
|---|---|---|
| Anonymous app start | `identifyAnonymous()` | Sends `hs_site`, `hs_device_id`, `user_type` (if cached), `cleverTapId`. No `userId`. |
| Customer registers | `identifyRegistered(email, phone, userId, name, mobileStatus)` | Sets `createdAt = now (UTC ISO)`, mobile, email, name, mobile_status. |
| Customer logs in | `identifyLoggedIn(email, phone, userId, name, mobileStatus, eligibleForContinueBrowsing)` | Same traits as register, minus `createdAt`. |
| Gender captured | `identifyGender(gender)` | Single trait. |
| Continue-browsing eligibility computed | `identifyContinueBrowsingEligibleVisitor(bool)` | Single trait. |
| Child cohorts loaded | `identifyForChildCohorts(Map<String,int>?)` | Always writes the 6 cohort keys (boy_infant/toddler/child + girl_*) suffixed with `_child_profile`, plus `total_child_profiles`. Zero values when null. |
| Gokwik risk score returned | `identifyGokwikRisk(score, factor)` | Two traits. |
| **HTTP response cookie change** (the big one) | `identifyOnCookieChange(sessionChange, utmChange, userTypeChange, experimentChange)` | Fired by the cookie interceptor after every HTTP response. See "Cookie-driven identify" below. |

### Cookie-driven identify — the most important wire-up

**Identify is NOT lifecycle-driven on Android.** It is fired from the HTTP cookie response interceptor. After every successful response, `CookiesReceiverInterceptor` hands off to `CookiesBasedEventsUtil.handleCookiesAndSessionStartEvent()`, which:

1. Parses four server-set cookies: `OtherSessionInfo` (sessionId, lastVisitdate, daysSinceLastVisit), `WEBSITE_customersegment` (userType), `segment_user_type`, `EXPERIMENTS`.
2. Persists each to `AppRecordData` / `PrefUtils`.
3. Diffs new vs cached:
   - `isSessionChange = cookie.sessionId != AppRecordData.startSessionId`
   - `isUserTypeChange = cookie.userType != AppRecordData.currentUserType`
   - `isUtmChange = UTMHeaderUtil.isUtmChanged`
   - `isExperimentChange = parsedExperiments != AppRecordData.previousExperiments`
4. Calls `AnalyticsHelper.identify(sessionChange, utmChange, userTypeChange, experimentChange)` — which only actually fires if at least one flag is true (the size > 2 guard on the traits map).
5. If `isSessionChange`, additionally fires `fireSessionStartedEvent()` and rotates `startSessionId` to the new cookie value, increments `sessionCount`.

### Flutter port

Add a `CookieAnalyticsInterceptor` to `NetworkClient`'s Dio interceptor chain. Order: **after** the existing cookie-store interceptor, **before** any business-logic interceptor.

```dart
@injectable
class CookieAnalyticsInterceptor extends Interceptor {
  CookieAnalyticsInterceptor(this._prefs, this._helper, this._utm);
  final PrefManager _prefs;
  final AnalyticsHelper _helper;
  final UtmHeaderUtil _utm;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _processCookies(response);
    handler.next(response);
  }

  void _processCookies(Response response) {
    final cookies = _extractCookies(response);

    final newSessionInfo = _parseOtherSessionInfo(cookies['OtherSessionInfo']);
    final newUserType = cookies['WEBSITE_customersegment'];
    final newSegmentUserType = cookies['segment_user_type'];
    final newExperiments = cookies['EXPERIMENTS'];

    final isSessionChange = newSessionInfo?.sessionId != null &&
        newSessionInfo!.sessionId != _prefs.startSessionId;
    final isUserTypeChange = newUserType != null &&
        newUserType != _prefs.currentUserType;
    final isUtmChange = _utm.isUtmChanged;
    final isExperimentChange = newExperiments != null &&
        newExperiments != _prefs.previousExperiments;

    if (newSessionInfo != null) {
      _prefs.setLastVisitDate(newSessionInfo.lastVisitDate);
      _prefs.setDaysSinceLastVisit(newSessionInfo.daysSinceLastVisit);
    }
    if (newUserType != null) _prefs.setUserType(newUserType);
    if (newSegmentUserType != null) _prefs.setSegmentUserType(newSegmentUserType);

    _helper.identifyOnCookieChange(
      sessionChange: isSessionChange,
      utmChange: isUtmChange,
      userTypeChange: isUserTypeChange,
      experimentChange: isExperimentChange,
    );

    if (isSessionChange) {
      _helper.fireSessionStartedEvent();
      _prefs.setStartSessionId(newSessionInfo!.sessionId);
      _prefs.setCurrentUserType(newUserType ?? _prefs.userType);
      _prefs.setSessionCount(_prefs.sessionCount + 1);
    }
  }
}
```

**Without this wire-up, identify never updates `user_type`/`experiments`/`utm_*` traits after the first login.** Every segmentation dashboard breaks silently.

### Identify size-check guard

The aggregated `identify(sessionChange, utmChange, userTypeChange, experimentChange)` only fires when the resulting traits map has more than the 2 baseline keys (`hs_site`, `hs_device_id`). Mirror this guard — do not flood Segment with no-op identifies after every HTTP response when nothing changed.

### User id sticky rule

Once a `userId` is set, every subsequent identify uses it (`AnalyticsService.identify(userId: prefManager.userId, traits: ...)`). Never reset `userId` except via `resetIdentity()`. `resetIdentity()` fires only when the user is **logged out** — guard with `!prefManager.isLoggedIn`.

## Lifecycle events

These three events define how Hopscotch measures retention. Get them wrong and DAU/MAU dashboards lie.

### `application_opened`

Decision logic in Android `fireLifeCycleEvents()`:

```
if (cachedVersionCode == 0):
   if (isFirstInstall):
      install_type = "New"
      send application_opened
      isFirstInstall = false
   else:
      isUpdated = true
      install_type = "Update"  (with default previous version v1.10.2)
      send application_opened
else if (cachedVersionName != currentVersionName):
   isUpdated = true
   install_type = "Update", previous_version = cachedVersionName, previous_build = cachedVersionCode
   send application_opened
else:
   isUpdated = false
   (no event)

Then: cache currentVersionName/Code
```

Always sends: `version`, `build`, `push_enabled`, `fmessenger`, `wa`, `fc`, `my`, `rooted`, `cpu_arch`, `device_profile` (if cached). `attribution = false`, `universal = false`.

Also fired by `logAppLaunched()` as a follow-up when `AppRecordData.applicationStatus == true` — covers the case where the app was already running but hadn't yet emitted `application_opened`.

### `app_launched`

Fires once per cold start, **only after** the first viewable screen has rendered (so `tti` is meaningful). Properties:
- `from_screen` — name of the first screen (e.g. `Discover`, `Login`, `Cart`).
- `tti` — milliseconds from `LaunchTimer.launchTime` to `logTti()`.
- `ttl` — milliseconds from `LaunchTimer.launchTime` to `logTtl()`.
- `install_type` — set by `fireLifeCycleEvents` indirectly via `LaunchTimer.installType`.
- `from_source` — `AppsFlyer`, `Push`, `Deeplink`, or absent for organic. Set by the entry-point handler (AppsFlyer callback, push tap, deeplink open) **before** the first screen renders.

Implementation calls `LaunchTimer.logTtl()` / `logTti()` once, then `LaunchTimer.stop()` so subsequent screens skip. `attribution = false`, `universal = false`. After firing, call `fireLifeCycleEvents()` which decides whether `application_opened` needs to follow.

`logAppLaunched(fromScreen)` is safe to call from any screen-viewed handler — `LaunchTimer.isStopped` self-guards.

### `session_started`

Fires from `CookiesBasedEventsUtil` when the session cookie changes. Properties (all optional, included only when `UtmHeaderUtil` has the value):
- `session_utm_source`
- `session_utm_medium`
- `session_utm_campaign`
- `session_utm_gender`
- `session_deeplink`

`attribution = false`, `universal = false`.

**Do NOT wire `session_started` to background-resume on Flutter.** That's not how Android does it. Sessions rotate when the server tells us they do, via cookies.

### Background-resume — what *does* happen?

On Android, the `Foreground` library times background duration. If > 30 min, it triggers a full restart to `SplashActivity` (so the next cold-start runs identify + session-change naturally via cookies). If < 30 min, **no analytics event fires on resume** — the app continues with its existing session/identity. Cookies on the next API call will refresh state if anything has changed.

Flutter port: do not call `identifyFromBackground()` from `WidgetsBindingObserver.didChangeAppLifecycleState`. Leave the cookie interceptor to drive identify naturally. If background > 30 min, restart-to-splash via the existing splash flow.

The one thing the lifecycle observer *should* do:
- `CheckoutTimer.markBackgroundStart()` on `paused`
- `CheckoutTimer.markBackgroundEnd()` on `resumed`

## Wiring lifecycle in `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(...);
  await configureDependencies();
  await sl<AnalyticsService>().init();
  await sl<AppsFlyerHelper>().init();
  await sl<CleverTapHelper>().init();          // sets cleverTapId callback

  sl<LaunchTimer>().recordProcessStart();
  sl<AnalyticsHelper>().identifyAnonymous();

  runApp(const HsApp());
}
```

The first screen's Bloc calls `logAppLaunched(fromScreen: AnalyticsDefaults.fromScreens.discover)`. `logAppLaunched` is no-op when `LaunchTimer.isStopped`, so it is safe to call from any screen-viewed handler — only the first one wins.

## Common event-enrichment fields

Every `track` payload is enriched by `AnalyticsHelper.logEvent` with:

| Field | Source | Notes |
|---|---|---|
| `[time] hour_of_day` | `DateTime.now()` converted to `Asia/Kolkata` | Always `int`. Calendar is 0-based on JVM for some fields — see below. |
| `[time] day_of_week` | Same | **Calendar.DAY_OF_WEEK is 1-based with Sunday=1** on Android. `DateTime.weekday` in Dart is 1-based with Monday=1. **Adjust** to match Android. |
| `[time] day_of_month` | Same | int, 1-based. Same in Dart. |
| `[time] month_of_year` | Same | **Android `Calendar.MONTH` is 0-based** (Jan=0). Code adds 1, so wire format is 1-based (Jan=1). Same in Dart `DateTime.month`. |
| `[time] week_of_year` | Same | String. `"$year$ww"` where `ww` is 2-digit padded. Build with `'${year}${weekOfYear.toString().padLeft(2, '0')}'`. |
| `afUserId` | `AppsFlyerSdk.appsFlyerUID` | Always include. |
| `cleverTapId` | `PrefManager.cleverTapId` | Always include. Set via CleverTap SDK callback at app init. |
| `timestamp` | `DateTime.now().toUtc().toIso8601String()` | Only added by `logEvent`, not by `logScrollEvent`. |
| `universal` | `AnalyticsCommonProperties.flush()` when `universal=true` | If list empty, send `none`. Buffer is one-shot — cleared after flush. |
| Attribution map | Order + LP + TabPage helpers | When `attribution=true`. See `attribution.md`. |

Amplitude integration option carries `session_id` — pass via `AnalyticsService.track`:

```dart
analyticsService.track(
  event,
  properties,
  integrationOptions: {
    AnalyticsDefaults.integrationAmplitude: {
      AnalyticsProperties.sessionId: prefManager.startSessionId,
    },
  },
);
```

`AnalyticsDefaults.integrationAmplitude = 'Amplitude'`.

## What `resetIdentity` does

`AnalyticsService.reset()` (which maps to Segment's `analytics.reset()`). Wipes the Segment-cached `anonymousId` and `userId`, clears traits. On Android `AnalyticsHelper.resetIdentity()` guards with `if (!UserStatus.getInstance().getLoginStatus())` — only resets if the user is actually logged out.

Flutter:
```dart
Future<void> resetIdentity() async {
  if (_prefs.isLoggedIn) return;
  await _service.reset();
}
```

Call from the logout repository after `_prefs.clearCustomerInfo()` and any associated state clear.
