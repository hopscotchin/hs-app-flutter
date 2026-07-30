import '../../constants/analytics_defaults.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Landing-page events. Mirrors Android's Java path
/// `SearchResultsShowingBoutiquesActivity.java:836-841`:
///   • `logAppLaunchedEvent(FromScreens.SPECIAL_PAGE)` — kicks the cold-start
///     chain when the LP is the first viewable screen.
///   • `logEvent(SPECIAL_PAGE_VIEWED, props, attribution: true, universal: true)`
///     — Flutter's helper doesn't expose the `universal` flag today; we still
///     merge `attribution: true` so the preceding tile click's funnel keys
///     travel onto this event.
///
/// Property shape:
///   • `id`   — `pageMeta.pageId` of the landing page response.
///   • `name` — `pageMeta.pageName` of the landing page response.
///
/// `from_screen` / `from_section` are stamped by a separate nav tracker
/// (owned by the caller) — this helper stays scoped to the LP-response
/// context it can compute locally.
extension LandingPageEvents on AnalyticsHelper {
  Future<void> logSpecialPageViewed({
    required int id,
    required String name,
  }) async {
    // Kick the lifecycle chain — LaunchTimer self-guards so home → LP
    // navigation doesn't re-fire app_launched / application_opened.
    await logAppLaunched(FromScreens.specialPage);

    final props = <String, Object?>{
      AnalyticsProperties.id: id,
      AnalyticsProperties.name: name,
    };
    await logEvent(
      AnalyticsEvents.specialPageViewed,
      props,
      attribution: true,
    );
  }
}
