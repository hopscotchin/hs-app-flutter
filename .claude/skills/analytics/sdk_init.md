# Analytics — SDK Initialisation

Single source of truth for how Segment, AppsFlyer, and CleverTap are wired up. Mirrors the Android `HsApplication.onCreate()` flow.

> **Android references:**
> - `hsapp/.../application/HsApplication.java` — `onCreate()` orchestrates all three SDKs.
> - `hsapp/.../analytics/AppsFlyerHelper.kt` — AppsFlyer init + deeplink subscribe.
> - `common/.../helper/CleverTapHelper.kt` — `addCleverTapId()` callback wiring.

## 1. Segment

Init in `main.dart` before `runApp`. Init in `AnalyticsService` so the singleton owns the client.

| Setting | Value | Source |
|---|---|---|
| Write key | per-env (`dev`, `prod`) | `.env` via `flutter_dotenv` — separate `SEGMENT_WRITE_KEY_DEBUG` / `SEGMENT_WRITE_KEY_RELEASE`, picked by `kReleaseMode`. Android equivalent: `KeysProvider.getAnalyticsKey(BuildConfig.DEBUG)` (native lib). |
| API host | per-env | `.env` via `SEGMENT_HOST_DEBUG` / `SEGMENT_HOST_RELEASE`. Android equivalent: `APIConstants.SEGMENT_DEBUG` vs `APIConstants.SEGMENT_RELEASE`. **Critical — debug & release point at different endpoints; don't conflate.** |
| Log level | `verbose` in debug, off in release | Gated on `kDebugMode`. Android: `Analytics.LogLevel.VERBOSE`. |
| Lifecycle auto-tracking | **disabled** | We fire custom `application_opened` / `app_launched` / `session_started`. Do not enable `trackApplicationLifecycleEvents` or `recordScreenViews` — they'll double-fire and pollute funnels. |
| CleverTap integration | **enabled as a Segment integration** | Android does `Analytics.Builder.use(CleverTapIntegration.FACTORY)`. Flutter equivalent depends on the chosen plugin — verify the plugin supports CleverTap as a destination, or wire it as a separate native bridge that consumes the same event stream. |
| Default integration options per track | `Amplitude` carries `session_id` | Set by `AnalyticsHelper.logEvent` on every track. See `identify_and_lifecycle.md`. |
| Flush interval / queue size | SDK defaults | Not customised on Android. Match. |
| Disk queue | enabled | Required — events fire reliably across network drops and app kills. |

### Flutter init shape

```dart
// lib/core/analytics/analytics_service.dart
@lazySingleton
class AnalyticsService {
  AnalyticsService(this._prefs);
  final PrefManager _prefs;
  late final SegmentClient _segment;

  Future<void> init() async {
    final isDebug = kDebugMode;
    final writeKey = isDebug
        ? dotenv.env['SEGMENT_WRITE_KEY_DEBUG']!
        : dotenv.env['SEGMENT_WRITE_KEY_RELEASE']!;
    final apiHost = isDebug
        ? dotenv.env['SEGMENT_HOST_DEBUG']
        : dotenv.env['SEGMENT_HOST_RELEASE'];

    _segment = await SegmentClient.create(
      writeKey: writeKey,
      apiHost: apiHost,
      logLevel: isDebug ? SegmentLogLevel.verbose : SegmentLogLevel.none,
      trackLifecycleEvents: false,    // do NOT enable — we fire custom events
      recordScreenViews: false,       // do NOT enable
    );
  }

  Future<void> track(String event, Map<String, Object?> properties,
      {Map<String, Map<String, Object?>>? integrationOptions}) async {
    await _segment.track(event, properties: properties, integrations: integrationOptions);
  }

  Future<void> identify({String? userId, required Map<String, Object?> traits}) async {
    await _segment.identify(userId: userId, traits: traits);
  }

  Future<void> reset() => _segment.reset();
}
```

The SDK choice matters less than these constraints. Options that are known to work:
- A maintained Flutter Segment plugin (e.g. `segment_analytics_flutter` or similar).
- A thin platform-channel wrapper that calls the existing native Segment SDK already linked on Android (`com.segment.analytics.Analytics`) and `analytics-swift` on iOS. This is the safest port — bytes-identical to Android.
- HTTP-level direct submission. Last resort — loses CleverTap-integration destination routing.

Decide in the PR. The helper API stays identical.

## 2. AppsFlyer

| Setting | Value | Notes |
|---|---|---|
| Dev key | `.env` — `APPSFLYER_DEV_KEY` | Android: native `KeysProvider.getAppsFlyerKey()`. |
| Deeplink subscribe | yes | Mirror Android `AppsFlyerHelper.kt`: store `result.deepLink.deepLinkValue` when `status == FOUND` AND `isDeferred != true` AND value not empty. |
| `setCustomerUserId` | **NOT called** | Android does not bind AF to app user id. Do not start binding it now without analytics sign-off. |
| `setMinTimeBetweenSessions` | default | Not customised on Android. |
| `onConversionDataReceived` | **NOT registered** on Android | AF only delivers a deeplink string. UTM parsing is uniform via `AppLinkUtil.processUtmContent()` — see below. |

### AF UID injection into events

`afUserId` is stamped onto every track payload by `AnalyticsHelper.logEvent` (Android line 367–368, 380–381). Read once at module init and cache; otherwise read on every track. Mirror Android exactly.

## 3. CleverTap

CleverTap on Android is split:
- **As a Segment destination** via `CleverTapIntegration.FACTORY` — all `track`/`identify` calls flow through Segment which fans out to CleverTap.
- **CleverTap ID retrieval** via the native CleverTap SDK callback `CleverTapAPI.getCleverTapID { id -> PrefUtils.cleverTapId = id }`.

The `cleverTapId` is then stamped onto **every track payload** (Android line 1580–1583) and into every identify trait map (Android line 209). Both paths read `PrefUtils.cleverTapId`.

### Flutter port

If the chosen Flutter Segment plugin supports CleverTap-via-Segment, that's enough. Otherwise:
- Add the native CleverTap SDK (Android + iOS) for ID retrieval only.
- Register a callback that stores `cleverTapId` in `PrefManager`.
- Continue stamping `cleverTapId` into every track payload from `AnalyticsHelper.logEvent`.

## 4. Deeplink + push routing

Three entry points, one common parser.

### Universal app links / custom-scheme deeplinks
- Flutter side: `uni_links` or `app_links` plugin.
- Hand the deeplink to `DeeplinkRouter.handle(uri)` which calls `AppLinkUtil.processUtmContent(uri)` (port the Android logic).
- `AppLinkUtil.processUtmContent` calls `UtmHeaderUtil.clearUtmParams()` then re-parses every `utm_*` field from the URL query.
- Sets `LaunchTimer.fromSource = AnalyticsDefaults.deeplink` (or `appsFlyer` when AF-delivered).

### AppsFlyer deeplink
- `AppsFlyerHelper.checkAndProcessDeeplink(...)` reads the stored AF deeplink and feeds it into the same `DeeplinkRouter.handle` path.
- Sets `LaunchTimer.fromSource = AnalyticsDefaults.appsFlyer` (Android: `"AppsFlyer"`).

### Push deeplink (CleverTap / FCM)
- Notification payload field is **`acme-deeplink`** — NOT `wzrk_dl`. `wzrk_dl` is an internal CleverTap-managed key inside their notification handler; the application-visible custom key is `acme-deeplink` (Android: `PushData.createPushData()`).
- Read `data['acme-deeplink']` from the FCM message → hand to `DeeplinkRouter.handle`.
- Sets `LaunchTimer.fromSource = AnalyticsDefaults.push` (Android: `"Push"`).

### Branch
**Not integrated on Android.** The `AnalyticsDefaults.BRANCH = "Branch"` constant exists but is never set. Do not port until analytics owner explicitly requests it.

## 5. Init order in `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(...);
  await configureDependencies();          // PrefManager ready
  await sl<AnalyticsService>().init();    // Segment ready
  AppsFlyerSdk(...).initSdk(...);         // AF init + deeplink subscribe
  CleverTapPlugin.setDebugLevel(...);     // CT init
  CleverTapPlugin.getCleverTapID().then(  // CT ID → PrefManager
    (id) => sl<PrefManager>().setCleverTapId(id),
  );

  sl<LaunchTimer>().recordProcessStart();
  sl<AnalyticsHelper>().identifyAnonymous();   // hs_site, hs_device_id, cleverTapId

  runApp(const HsApp());
}
```

Order matters: `PrefManager` first (everyone needs it), `AnalyticsService` second (its init pulls keys from `.env`), then SDKs that produce ids the helper stamps onto events.

## 6. What does NOT belong here

- Per-feature impression deduplication (lives in feature-level trackers).
- Per-event property assembly (lives in `AnalyticsHelper` module extensions).
- Lifecycle event firing (lives in `events/lifecycle_events.dart` — see `identify_and_lifecycle.md`).
