import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import '../support/analytics_test_harness.dart';

/// Guards the home page's signed-off `tile_clicked` payload: the blob the
/// backend supplies reaches the wire untouched, and the client adds no keys of
/// its own. `section` and `funnel_section` are deprecated and never written,
/// even though Android composes both at click time.
void main() {
  late AnalyticsTestHarness h;
  late HomeTrackAnalyticManager tracker;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    tracker = sl<HomeTrackAnalyticManager>()
      ..extraData = const ExtraData(fromHomePage: true);
  });
  tearDown(() => h.tearDown());

  const blob = {
    AnalyticsProperties.funnelTile: 'CT1441',
    AnalyticsProperties.bannerName: 'Boutique',
    AnalyticsProperties.sliceId: '01_01',
  };

  test('the blob reaches the wire unaltered', () async {
    await tracker.logTileClick(trackingMetaChain: const [blob]);
    final e = h.singleEvent(AnalyticsEvents.tileClicked);

    expect(e[AnalyticsProperties.funnelTile], 'CT1441');
    expect(e[AnalyticsProperties.bannerName], 'Boutique');
    expect(e[AnalyticsProperties.sliceId], '01_01');
  });

  test('no deprecated attribution keys are composed', () async {
    // Android writes section / funnel_section here
    // (`PageCarouselViewHolder:81`, `ProductViewHolder:71`); both are
    // deprecated, so nothing client-side fills them.
    await tracker.logTileClick(trackingMetaChain: const [blob]);
    final e = h.singleEvent(AnalyticsEvents.tileClicked);

    expect(e.containsKey(AnalyticsProperties.section), isFalse);
    expect(e.containsKey(AnalyticsProperties.funnelSection), isFalse);
    expect(e.containsKey(AnalyticsProperties.subSection), isFalse);
  });
}
