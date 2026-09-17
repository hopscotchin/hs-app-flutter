import 'dart:convert';

import '../../../../features/kids/domain/entities/child_entity.dart';
import '../../constants/analytics_events.dart';
import '../../constants/analytics_properties.dart';
import '../analytics_helper.dart';

/// My Kids (child profile) events — property keys and event names are
/// unchanged from Android (see PROFILE_KIDS_MIGRATION.md §7), already ported
/// into `AnalyticsEvents`/`AnalyticsProperties` ahead of this feature
/// existing. This module is what finally wires them up.
extension KidsEvents on AnalyticsHelper {
  Future<void> logChildProfileAdded(ChildEntity child) async {
    await _adjustChildCohort(child, delta: 1);
    await logEvent(AnalyticsEvents.childProfileAdded, _childProps(child));
  }

  Future<void> logChildProfileEdited(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileEdited, _childProps(child));

  Future<void> logChildProfileDeleted(ChildEntity child) async {
    await _adjustChildCohort(child, delta: -1);
    await logEvent(AnalyticsEvents.childProfileDeleted, _childProps(child));
  }

  Map<String, Object?> _childProps(ChildEntity child) => <String, Object?>{
    AnalyticsProperties.childProfileName: child.name,
    AnalyticsProperties.childProfileGender: child.gender.displayLabel,
    if (child.dob != null) ...{
      AnalyticsProperties.childProfileDob: child.dobWireValue,
      AnalyticsProperties.childProfileAge: child.ageInMonths,
      AnalyticsProperties.childProfileCohort: child.cohortKey,
    },
  };

  /// Increments (add) or decrements/removes (delete) this child's cohort
  /// bucket in the persisted counter cache and re-identifies the full
  /// snapshot. Mirrors Android `ChildProfileAnalyticsHelper.getChildCohortsMap`
  /// exactly: counts are adjusted incrementally off a local cache
  /// (`PrefManager.childCohorts`, Android's `PrefUtils.childCohorts`), never
  /// recomputed from the full children list, and an edit does **not** adjust
  /// counts even though the edited child's own cohort may have changed —
  /// that is a known, preserved Android gap, not something to fix here.
  ///
  /// A delete decrements the bucket recorded in `PrefManager.childCohortAssignments`
  /// at add time, not `child.cohortKey` recomputed now — the child's age (and
  /// so its cohort) can have advanced past a bucket boundary in the time
  /// between add and delete, which would otherwise inflate the add-time
  /// bucket forever and under-count the one the child aged into. Falls back
  /// to the live `cohortKey` only for a child added before this assignment
  /// tracking existed (no recorded assignment to look up).
  Future<void> _adjustChildCohort(ChildEntity child, {required int delta}) async {
    if (child.dob == null) return;
    final raw = prefs.childCohorts;
    final counts = raw == null
        ? <String, int>{}
        : (jsonDecode(raw) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as int),
          );
    final rawAssignments = prefs.childCohortAssignments;
    final assignments = rawAssignments == null
        ? <String, String>{}
        : (jsonDecode(rawAssignments) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as String),
          );
    final childId = child.id.toString();
    final key = delta > 0 ? child.cohortKey : (assignments[childId] ?? child.cohortKey);
    if (delta > 0) {
      counts[key] = (counts[key] ?? 0) + 1;
      assignments[childId] = key;
    } else {
      final current = counts[key];
      if (current != null && current > 1) {
        counts[key] = current - 1;
      } else {
        counts.remove(key);
      }
      assignments.remove(childId);
    }
    await prefs.setChildCohorts(jsonEncode(counts));
    await prefs.setChildCohortAssignments(jsonEncode(assignments));
    await identifyForChildCohorts(counts);
  }
}
