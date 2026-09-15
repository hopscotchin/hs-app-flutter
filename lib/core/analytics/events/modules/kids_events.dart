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

  Future<void> logChildProfileSelected(ChildEntity child) =>
      logEvent(AnalyticsEvents.childProfileSelected, _childProps(child));

  Map<String, Object?> _childProps(ChildEntity child) => <String, Object?>{
    AnalyticsProperties.childProfileName: child.name,
    AnalyticsProperties.childProfileGender: child.gender.displayLabel,
    if (child.dob != null)
      AnalyticsProperties.childProfileDob: child.dobWireValue,
    if (child.dob != null) AnalyticsProperties.childProfileAge: child.ageInMonths,
    if (child.dob != null) AnalyticsProperties.childProfileCohort: child.cohortKey,
  };

  /// Increments (add) or decrements/removes (delete) this child's cohort
  /// bucket in the persisted counter cache and re-identifies the full
  /// snapshot. Mirrors Android `ChildProfileAnalyticsHelper.getChildCohortsMap`
  /// exactly: counts are adjusted incrementally off a local cache
  /// (`PrefManager.childCohorts`, Android's `PrefUtils.childCohorts`), never
  /// recomputed from the full children list, and an edit does **not** adjust
  /// counts even though the edited child's own cohort may have changed —
  /// that is a known, preserved Android gap, not something to fix here.
  Future<void> _adjustChildCohort(ChildEntity child, {required int delta}) async {
    if (child.dob == null) return;
    final raw = prefs.childCohorts;
    final counts = raw == null
        ? <String, int>{}
        : (jsonDecode(raw) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as int),
          );
    final key = child.cohortKey;
    if (delta > 0) {
      counts[key] = (counts[key] ?? 0) + 1;
    } else {
      final current = counts[key];
      if (current != null && current > 1) {
        counts[key] = current - 1;
      } else {
        counts.remove(key);
      }
    }
    await prefs.setChildCohorts(jsonEncode(counts));
    await identifyForChildCohorts(counts);
  }
}
