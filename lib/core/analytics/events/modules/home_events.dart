import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../../constants/funnel.dart';
import '../analytics_helper.dart';

/// Home / Discover events. `logHomePageViewed` drives the cold-start chain
/// (`app_launched` → `application_opened` → `homepage_viewed`).
extension HomeEvents on AnalyticsHelper {
  Future<void> logHomePageViewed({
    required String fromScreen,
    String? fromLocation,
  }) async {
    // Kick the lifecycle chain first — LaunchTimer self-guards so re-loads
    // don't re-fire app_launched / application_opened.
    await logAppLaunched(FromScreens.discover);

    // Seed funnel + sortbar so the attribution merge picks them up.
    orderAttribution.setFunnel(Funnel.discover);
    orderAttribution.setSortBar(AnalyticsDefaults.sortBarAll);

    final props = <String, Object?>{
      if (fromLocation != null && fromLocation.isNotEmpty)
        AnalyticsProperties.fromLocation: fromLocation,
      if (fromScreen.isNotEmpty) AnalyticsProperties.fromScreen: fromScreen,
      AnalyticsProperties.skin: prefs.homePageSkin ?? AnalyticsDefaults.none,
    };
    await logEvent(AnalyticsEvents.homePageViewed, props, attribution: true);
    await logSortbarChanged(sortBar: AnalyticsDefaults.sortBarAll);
  }

  /// Fires when the user changes the Discover top-tab (sortbar). Caller must
  /// have already updated `orderAttribution.setSortBar(sortBar)` so the
  /// attribution merge on this event picks up the new value.
  Future<void> logSortbarChanged({required String sortBar}) {
    return logEvent(AnalyticsEvents.sortbarChanged, <String, Object?>{
      AnalyticsProperties.sortbar: sortBar,
    }, attribution: true);
  }
}
