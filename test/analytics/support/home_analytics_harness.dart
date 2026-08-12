import 'package:flutter_test/flutter_test.dart';

import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/funnel.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/analytics/home/journey_worker.dart';
import 'package:hs_app_flutter/features/discover/domain/entities/home_page_entity.dart';

import 'analytics_test_harness.dart';
import 'fixture_loader.dart';

/// Shared setUp scaffolding for HP component analytics tests.
///
/// Each of Hero / CustomTiles / PageCarousel / ProductGrid tests were
/// duplicating the same 20-line boilerplate: build the analytics harness,
/// wire a fresh `HomeTrackAnalyticManager` off it, pick a random component
/// of a given type from the fixture, seed funnel + sortbar. This wraps it
/// so component tests read as behavior, not setup.
///
/// **Fixture pick is filtered** — components whose root trackingMeta ships
/// `lp_*`-prefixed keys are skipped (they're LP-variant components leaked
/// into the home feed; the random pick would otherwise flake). The `.setUp`
/// factory returns `null` if the fixture has no clean component of the
/// requested type; the caller uses that as `skip` on their tests.
class HomeAnalyticsHarness {
  HomeAnalyticsHarness._({
    required this.h,
    required this.tracker,
    required this.fx,
    required this.component,
    required this.componentIndex,
  });

  final AnalyticsTestHarness h;
  final HomeTrackAnalyticManager tracker;
  final HomeFixture fx;
  final PageComponent component;
  final int componentIndex;

  int get position => component.position;
  Map<String, dynamic> get rootMeta => fx.rootTrackingMetaAt(componentIndex);

  /// Returns a skip reason if the fixture has no clean (non-`lp_*`-rooted)
  /// component of [type], otherwise null. Call at test-file top level so
  /// `test(..., skip: ...)` gets a stable value at declaration time —
  /// evaluating this inside `setUp` doesn't work because Dart resolves
  /// `skip:` at test-declaration, not test-execution.
  static String? skipReasonFor(String type) {
    final fx = HomeFixture.load();
    for (final i in fx.allIndicesOfType(type)) {
      if (HomeFixture.rootHasNoLpKeys(fx.rootTrackingMetaAt(i))) return null;
    }
    return 'no clean $type in fixture — capture a homepage response that '
        'ships one with unprefixed trackingMeta';
  }

  /// Build harness + tracker + pick a clean component of [type] from the
  /// fixture. Caller must have gated on [skipReasonFor] returning null.
  static Future<HomeAnalyticsHarness> setUp(String type) async {
    final fx = HomeFixture.load();
    final index = fx.randomIndexOfTypeMatching(
      type,
      HomeFixture.rootHasNoLpKeys,
    );
    if (index < 0) {
      throw StateError(
        'HomeAnalyticsHarness.setUp($type) called but no clean component '
        'exists — gate with `skipReasonFor($type)` at file top level.',
      );
    }

    final h = await AnalyticsTestHarness.build();
    final tracker = HomeTrackAnalyticManager(
      analytics: h.analytics,
      orderAttribution: h.orderAttribution,
      lpAttribution: h.lpAttribution,
      journeyWorker: JourneyWorker(h.analytics),
    );
    tracker.extraData = const ExtraData(fromHomePage: true);
    tracker.sortBarName = AnalyticsDefaults.sortBarAll;
    tracker.pageComponents = fx.components;

    h.orderAttribution.setFunnel(Funnel.discover);
    h.orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);

    final component = fx.components[index];
    printOnFailure(
      'picked $type at index=$index, position=${component.position}',
    );

    return HomeAnalyticsHarness._(
      h: h,
      tracker: tracker,
      fx: fx,
      component: component,
      componentIndex: index,
    );
  }

  void tearDown() => h.tearDown();

  /// Trigger the standard "component became visible → flush" sequence.
  Future<void> makeVisibleAndFlush() async {
    tracker.notifyVisible(componentIndex);
    await tracker.flushJourney();
  }

  /// Hero-specific "user swiped through every tile → flush" sequence.
  /// Hero doesn't emit at component level anymore (that would count tiles
  /// the user never saw). This helper records every tile as visible, which
  /// mirrors what would happen after the user cycles through the whole
  /// carousel. Component tests that need "one banner_impression per tile"
  /// (the old exhaustive-emission behaviour) call this.
  Future<void> makeAllHeroTilesVisibleAndFlush() async {
    tracker.notifyVisible(componentIndex);
    final tiles = component.data?['tiles'] as List?;
    if (tiles != null) {
      for (var i = 0; i < tiles.length; i++) {
        tracker.notifyHeroTileVisible(componentIndex, i);
      }
    }
    await tracker.flushJourney();
  }

  /// Assert `tile_impression` is NEVER fired for this component. The event
  /// was retired in favour of `banner_impression`-per-tile (Hero) or
  /// -per-component (others). Every component test asserts this — keeping
  /// it as a helper prevents drift.
  Future<void> expectTileImpressionRetired() async {
    await makeVisibleAndFlush();
    expect(h.hasEvent(AnalyticsEvents.tileImpression), isFalse,
        reason: 'tile_impression was retired — component must not emit it');
  }
}
