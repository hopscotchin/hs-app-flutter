import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/logger/my_logger.dart';

part 'child_entity.freezed.dart';

enum ChildGender { boy, girl }

extension ChildGenderX on ChildGender {
  /// Wire value the live backend expects — uppercase, matching the one
  /// consistent path (the "new"/v2 Kids save endpoint). See
  /// PROFILE_KIDS_MIGRATION.md §2 inconsistency #1 for why lowercase also
  /// exists on the legacy path — this app only ever sends the modern casing.
  String get wireValue => this == ChildGender.boy ? 'BOY' : 'GIRL';

  String get displayLabel => this == ChildGender.boy ? 'Boy' : 'Girl';

  /// Defaults to [ChildGender.boy] on anything unrecognized (including
  /// `null`), since [ChildEntity.gender] is non-nullable — but logs first,
  /// so a backend typo/omission shows up instead of silently miscategorizing
  /// a child in cohort analytics.
  static ChildGender fromWire(String? value) {
    final upper = value?.toUpperCase();
    if (upper == 'GIRL') return ChildGender.girl;
    if (upper != 'BOY') {
      logger.w('Unrecognized child gender from wire: $value — defaulting to boy');
    }
    return ChildGender.boy;
  }
}

@freezed
abstract class ChildEntity with _$ChildEntity {
  const factory ChildEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default(ChildGender.boy) ChildGender gender,
    // Server-formatted `"D MMM YYYY"` (e.g. "15 May 2019") — carried
    // straight through for the My Kids list row. Not the same field as
    // [ManageKidState.dob] (a `DateTime`, the Add/Edit form's own live
    // picker session value): this is read-only backend display copy, never
    // parsed into a `DateTime` anywhere.
    String? dob,
    // Server-formatted `"DD - MM - YYYY"` — used to pre-fill the read-only
    // dob field for an existing child. Also the source `ManageKidBloc`
    // resolves the outgoing save request's `dob` from (spaces stripped)
    // when the field wasn't re-picked; null for a not-yet-saved child.
    String? displayDob,
    String? imageUrl,
    @Default(false) bool consent,
    // The three fields below arrive straight from the backend's `age` /
    // `trackingMeta` (confirmed live on both `v2/list` and
    // `v3/save-and-update`'s response) — null only for a not-yet-saved
    // child built locally from form input, which has no backend-computed
    // values yet.
    String? age,
    int? ageInMonths,
    String? cohortKey,
  }) = _ChildEntity;
}

extension ChildEntityX on ChildEntity {
  bool get isNew => id == 0;

  /// Raw `"{year}-{month}-{day}"` (unpadded), matching what Android's
  /// `ChildProfileAnalyticsHelper` sends as `child_profile_dob`. Derived
  /// from [displayDob]'s `"DD - MM - YYYY"` by reordering its three
  /// dash-separated components — not date parsing in the sense of
  /// interpreting a calendar format, just splitting and reordering a
  /// string whose shape is fixed and confirmed live.
  String get dobWireValue {
    final parts = displayDob?.split('-').map((p) => p.trim()).toList();
    if (parts == null || parts.length != 3) return '';
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return '';
    return '$year-$month-$day';
  }
}
