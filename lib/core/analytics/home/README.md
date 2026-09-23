# Home / LP impression tracking

Tracks `banner_impression`, `tile_impression`, `carousel_scrolled`,
`tile_clicked` (and their `lp_*` variants) for the Discover home page
and every Landing Page. Mirrors Android's `HomeTrackAnalyticManager`.

## Why this exists

Home and LP screens render dozens of components; each component has
nested tiles. If every tile emitted an impression on every visibility
change, we'd fire hundreds of events during a scroll and jank the frame
walking the tile tree + calling the plugin channel that many times.

The design is: **collect a journey during scroll (cheap), fire a batch
on screen leave (bounded).**

## Data flow (thread-annotated)

Dart is single-threaded per isolate. Every arrow below lives on the
main isolate's event loop unless explicitly marked otherwise.

```
─────────────────────  MAIN ISOLATE EVENT LOOP  ─────────────────────

  ┌─ Scroll frame ────────────────────────────────────────────────┐
  │  VisibilityDetector fires (throttled 500ms in main.dart)      │
  │        │                                                      │
  │        ▼                                                      │
  │  PageComponentRenderer._onVisibilityChanged                   │
  │        │                                                      │
  │        ▼                                                      │
  │  tracker.notifyVisible(index)                                 │
  │        │                                                      │
  │        └─▶ _journey.add(index)   ← Set<int>.add, ~µs          │
  │            [no walk, no logEvent, no I/O]                     │
  │  Frame paints. Choreographer stays happy.                     │
  └───────────────────────────────────────────────────────────────┘

  ┌─ Nav / tab / lifecycle event ─────────────────────────────────┐
  │  AppNavigationObserver.didPush  OR                            │
  │  HomeBloc.close                 OR                            │
  │  Dashboard tab switch           OR                            │
  │  WidgetsBindingObserver → paused / hidden                     │
  │        │                                                      │
  │        ▼                                                      │
  │  unawaited(_homeTrack.flushCarouselScrolls())                 │
  │        │  (alias for flushJourney)                            │
  │        ▼                                                      │
  │  HomeTrackAnalyticManager.flushJourney                        │
  │        │                                                      │
  │        ├─▶ await _fireCarouselScrolls()                       │
  │        │       └─▶ analytics.logEvent(carousel_scrolled, ..)  │
  │        │           per buffered scroll                        │
  │        │                                                      │
  │        └─▶ await _worker.flushImpressions(indices, seed)      │
  │                │                                              │
  │                └─▶ JourneyWorker:                             │
  │                     • buildImpressions() walks tile tree      │
  │                       → List<(event, props)>                  │
  │                     • Future.wait(events.map(logEvent))       │
  │                                                               │
  │  Each logEvent → AnalyticsHelper.logEvent → _service.track    │
  └───────────────────────────────────────────────────────────────┘

  ┌─ AnalyticsHelper.logEvent (per event) ────────────────────────┐
  │  1. build _commonEventProperties (attribution + nav + time)   │
  │  2. merge caller props + timestamp                            │
  │  3. await _service.track(event, enriched)                     │
  │           │                                                   │
  │           └─▶ AnalyticsService.track                          │
  │                    ├─ stamp afUserId + cleverTapId            │
  │                    ├─ AnalyticsDebugLog.record (debug only)   │
  │                    └─ _segment.track(event, properties: ...)  │
  │                            │                                  │
  │                            ▼ plugin channel serialize         │
  └───────────────────────────────────────────────────────────────┘
                                │
                                ▼
─────────  NATIVE OS THREADS (invisible to Dart)  ─────────
    Segment SDK enqueues to in-memory batch.
    storageJson=true → serialises batch to disk.
    Flush policies (count 20 / timer 30s / startup) trigger
    HTTP POST to segment.hopscotch.in/batch via the
    requestFactory (Basic auth + `channel:"mobile"` stamp).
    Retries + persistence live here.
```

## Threading — what actually runs where

Common misconception: "`await` runs in the background." **False.** In
Dart, `async` is not multi-threaded. Every async function runs its
sync-until-first-`await` portion on the caller's stack. `await` only
yields between microtasks on the same isolate.

So inside `analytics.logEvent`:

- **Blocks main:** enrichment (attribution + nav + time bucket maps),
  the timestamp string, `_service.track`'s Dart entry, the plugin
  channel argument encoding, `AnalyticsDebugLog.record` in debug.
- **Genuinely off-main:** the Segment SDK's native code — Kotlin /
  Swift disk queue writes, batch upload HTTP calls. Dart doesn't wait
  on those; the plugin channel returns after the native side accepts
  the event.

A single `logEvent` is ~200–500µs of main-isolate Dart work — invisible
inside a 16.67ms frame. A flush of hundreds of impressions stacks up.
That's why the burst is what we defend against, and single events
aren't.

## Files

| File | Role |
|------|------|
| `home_track_analytic_manager.dart` | The tracker. Scroll bookkeeping (`_currentlyVisible`, direction snapshot, `_journey`), click handling, carousel-scroll buffering, `WidgetsBindingObserver` for background flush. |
| `journey_worker.dart` | `JourneyWorker` — owns the impression build + dispatch. Also holds the pure functions (`snapshotComponents`, `buildImpressions`, `_walkTileChains`, `buildBaseSeed`, `stripLpPrefixed`) and the record typedefs (`ComponentSnapshot`, `JourneySeed`, `EmitEntry`). |
| `home_component_click_handlers.dart` | Extension on `HomeTrackAnalyticManager` — per-component tap helpers that assemble the trackingMeta chain and delegate to `logTileClick`. |

## Public API — what to call, when

| Method | Called from | Why |
|--------|-------------|-----|
| `pageComponents = ...` | `HomeBloc._emit`, `LandingPageBloc._emit` | Every time the API returns new components. Also ships the compact snapshot to the worker. |
| `attachScrollPosition(pos)` | `PageComponentRenderer.didChangeDependencies` | Idempotent. Lets the tracker detect direction change and pivot the snapshot. |
| `notifyVisible(i)` / `notifyInvisible(i)` | `PageComponentRenderer._onVisibilityChanged` | Sub-µs. Adds/removes from `_journey`. |
| `logCarouselScrolled(key, meta)` | `PageCarouselWidget` on horizontal scroll | Last-write-wins per key; fires on next `flushJourney`. |
| `logTileClick(...)` | `HomeComponentClickHandlers.on*Tapped` | Awaits `flushJourney()` first (see "Ordering" below), then writes attribution to `OrderAttributionHelper` (HP) or `LpAttributionHelper` (LP) and fires `tile_clicked` / `lp_tile_clicked`. |
| `flushJourney()` / `flushCarouselScrolls()` | `AppNavigationObserver.didPush/didPop`, `HomeBloc.close`, `LandingPageBloc.close`, `Dashboard` tab switch, app paused / hidden | Batched dispatch. `flushCarouselScrolls` is a legacy-name alias — keep it, all existing call sites use it. |
| `clearLpAttribution()` | `AppNavigationObserver` on back-to-shell | Wipes the LP deque; HP attribution untouched. |
| `resetVisibilityState()` | `AppNavigationObserver` on funnel switch | Clears scroll bookkeeping only. Doesn't touch pageComponents / sortbar / attribution. Callers must `flushJourney` first if the journey should ship. |
| `destroyFromHomeBloc()` | **`HomeBloc.close` only** | Clears everything per-screen including pageComponents + sortbar. LP blocs share the singleton and must never call this. |

## State — who owns what

| State | Owner | Lifetime |
|-------|-------|----------|
| `_currentlyVisible`, `_snapshotAtDirectionChange`, `_journey`, `_carouselScrollDepth`, scroll-position listener | `HomeTrackAnalyticManager` | Per-screen, wiped by `resetVisibilityState` |
| Cached component snapshots | `JourneyWorker` (`_components`) | Sole owner. Replaced whenever the tracker's `pageComponents` setter fires; the tracker doesn't retain its own copy. |
| `extraData`, `sortBarName` | `HomeTrackAnalyticManager` | Set by `AppNavigationObserver` / `DiscoverPage` / LP flows |
| Attribution stores | `OrderAttributionHelper`, `LpAttributionHelper` | Disk-backed, outlive individual screens |
| Nav trail | `AppNavigationObserver` | Rebuilt from route stack on push/pop |

## Testing model

- `AnalyticsTestHarness` (`test/analytics/support/analytics_test_harness.dart`) initialises `TestWidgetsFlutterBinding` and mocks `AnalyticsService.track` — captured events go into a `List<CapturedEvent>` for assertions.
- Component tests construct the tracker locally:
  ```dart
  tracker = HomeTrackAnalyticManager(
    analytics: h.analytics,
    orderAttribution: h.orderAttribution,
    lpAttribution: h.lpAttribution,
    journeyWorker: JourneyWorker(h.analytics),
  );
  ```
  The same `JourneyWorker` class runs in production and in tests — no separate test/prod path, no fakes to keep in sync.
- Impressions are two-phase in tests:
  ```dart
  tracker.notifyVisible(idx);
  await tracker.flushJourney();
  ```
  because that's exactly what production does — the widget layer calls `notifyVisible` on visibility, and the nav / bloc / lifecycle layer calls `flushJourney` on screen leave.

## Ordering — impressions before clicks

Wire order on a tile tap must read "user saw X, saw Y, then clicked Z",
not the other way round. `logTileClick` enforces this by `await`ing
`flushJourney()` before it merges attribution + fires the click event.
Two consequences:

- **Impressions carry pre-click attribution.** They reflect what the
  user saw with attribution as it stood at that moment. The click's
  attribution merge happens *after* the flush, so the click event
  and every downstream event (PLP, PDP, ATC, ...) get the new state.
- **The nav observer's `didPush → flushCarouselScrolls` becomes a
  no-op** for the click path, because `logTileClick` has already
  drained the journey. Nothing to fire again, no double emission.

If you add a new tap handler that navigates without going through
`logTileClick`, you own the ordering — call `await flushJourney()`
before firing the click event, or accept whatever order the nav
observer's flush produces.

## Constraints and trade-offs (known)

- **Journey doesn't persist across process death.** If the OS kills the app before a flush lands the journey in Segment's on-disk queue, those impressions are gone. `didChangeAppLifecycleState.paused / hidden` triggers a flush, which handles the ordinary background-then-kill path. Force-swipe kill from cold state has no window.
- **Nav-time burst.** A 200-impression flush runs 200 `logEvent` Dart bodies back-to-back on main during the nav transition. Bounded by the screen size; acceptable for now. If a specific page hitches noticeably, add local pacing at the flush site (`SchedulerBinding.scheduleTask(fn, Priority.idle)` per event or a chunked yield loop), not a global mechanism.
- **Direction-change snapshot is per-scroll-position.** `attachScrollPosition` resets it. If a screen changes its `ScrollController` mid-session, direction tracking restarts.
- **`AnalyticsDebugLog.record` is O(N) per call** where N is the log size (500). Only fires in `kDebugMode`. During a large flush in debug, this compounds; not a production concern but worth knowing while profiling debug builds.

## History — things NOT to reintroduce without a plan

- **`SchedulerBinding.scheduleTask(fn, Priority.idle)` inside `logEvent`** — deferred every event to idle time. Reliable on interactive nav, unreliable on `paused` (scheduler may not tick when the app is backgrounded, events queued but never drained to Segment's on-disk queue → lost on OS kill).
- **`BackgroundIsolateBinaryMessenger`-enabled worker isolate with its own Segment client** — genuine off-main dispatch, but produced silent event drops on isolate spawn / handshake edges. Restore only when the spawn / handshake failure modes are enumerated + tested.
- **Firing impressions inline in `notifyVisible`** — the original design. Cheap per event but produces Choreographer-visible jank on scroll-heavy screens because the tile-tree walk + N `logEvent`s happen on the visibility callback.

## When to change what

- Adding a new component type that should fire impressions → add its walk descriptor to `tilePaths` in `journey_worker.dart` and update `PageComponentType`.
- Changing what a click event carries → touch `logTileClick` in `home_track_analytic_manager.dart` (that's the click path; impressions go through `buildImpressions`).
- Adding a new flush trigger → call `unawaited(sl<HomeTrackAnalyticManager>().flushCarouselScrolls())` from the new site. Don't reach past the tracker into the worker.
- Adding a new attribution key → touch `OrderAttributionHelper` / `LpAttributionHelper`; the tracker just reads `segmentParams`.
