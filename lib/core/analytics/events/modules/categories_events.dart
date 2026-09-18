import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// Categories tab events. `category_tree_viewed` mirrors Android's
/// `AnalyticsHelper.logCategoryTreeViewedEvent` — fired once, on a
/// successful page load (see SEARCH_CATEGORIES_MIGRATION.md §7.1 #3).
extension CategoriesEvents on AnalyticsHelper {
  Future<void> logCategoryTreeViewed({String? departmentName}) => logEvent(
    AnalyticsEvents.categoryTreeViewed,
    <String, Object?>{
      if (departmentName != null && departmentName.isNotEmpty)
        AnalyticsProperties.departmentName: departmentName,
    },
  );
}
