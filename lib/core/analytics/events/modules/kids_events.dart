import '../../../../features/kids/domain/entities/child_entity.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// My Kids (child profile) events — property keys and event names are
/// unchanged from Android (see PROFILE_KIDS_MIGRATION.md §7), already ported
/// into `AnalyticsEvents`/`AnalyticsProperties` ahead of this feature
/// existing. This module is what finally wires them up.
extension KidsEvents on AnalyticsHelper {
  Future<void> logChildProfileAdded(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileAdded, _childProps(child));

  Future<void> logChildProfileEdited(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileEdited, _childProps(child));

  Future<void> logChildProfileDeleted(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileDeleted, _childProps(child));

  Future<void> logChildProfileSelected(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileSelected, _childProps(child));

  Map<String, Object?> _childProps(ChildEntity child) => <String, Object?>{
    AnalyticsProperties.childProfileName: child.name,
    AnalyticsProperties.childProfileGender: child.gender.wireValue,
    if (child.dob != null)
      AnalyticsProperties.childProfileDob: child.dobDisplay,
    if (child.dob != null) AnalyticsProperties.childProfileAge: child.ageInMonths,
    if (child.dob != null) AnalyticsProperties.childProfileCohort: child.cohortKey,
  };

  /// Recomputes the full cohort-count snapshot from the current children
  /// list and identifies it — call this after any successful list load, not
  /// per add/edit/delete, so cohort counts are always derived fresh from the
  /// source of truth rather than incrementally tracked (avoiding Android's
  /// two-writer disagreement risk documented in PROFILE_KIDS_MIGRATION.md §2).
  Future<void> identifyChildCohorts(List<ChildEntity> children) {
    final counts = <String, int>{};
    for (final child in children) {
      if (child.dob == null) continue;
      counts[child.cohortKey] = (counts[child.cohortKey] ?? 0) + 1;
    }
    return identifyForChildCohorts(counts);
  }
}
