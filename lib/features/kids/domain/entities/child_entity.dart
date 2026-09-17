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
    DateTime? dob,
    String? imageUrl,
    @Default(false) bool consent,
  }) = _ChildEntity;
}

extension ChildEntityX on ChildEntity {
  bool get isNew => id == 0;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ]; // ignore: prefer_const_declarations

  /// Ready-to-display date, e.g. "15 May 2019".
  ///
  /// Computed client-side today because the live backend only returns
  /// year/month/day parts, not a display string. Once the backend ships the
  /// direct `dob`/`age` strings proposed in PROFILE_KIDS_API_CONTRACT.md,
  /// this whole extension goes away and the entity just carries the string
  /// straight through.
  String get dobDisplay {
    final d = dob;
    if (d == null) return '';
    return '${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  /// Raw `"{year}-{month}-{day}"` (unpadded), matching what Android's
  /// `ChildProfileAnalyticsHelper` sends as `child_profile_dob` — a plain
  /// string concat of the year/month/day fields, not the display format.
  String get dobWireValue {
    final d = dob;
    if (d == null) return '';
    return '${d.year}-${d.month}-${d.day}';
  }

  /// Whole months between [dob] and today — mirrors Android's
  /// `Utils.calculateAge`, floored at 0. Backing value for [ageDisplay] and
  /// the cohort classification in [cohortKey].
  int get ageInMonths {
    final d = dob;
    if (d == null) return 0;
    final now = DateTime.now();
    var months = (now.year - d.year) * 12 + (now.month - d.month);
    if (now.day < d.day) months -= 1;
    return months < 0 ? 0 : months;
  }

  /// Ready-to-display age, e.g. "5 Y 3 M". Temporary client-side computation
  /// (see [dobDisplay]) until the backend precomputes it.
  String get ageDisplay {
    if (dob == null) return '';
    final months = ageInMonths;
    final years = months ~/ 12;
    final remMonths = months % 12;
    if (years == 0) return '$remMonths M';
    if (remMonths == 0) return '$years Y';
    return '$years Y $remMonths M';
  }

  /// Age-gender cohort bucket, mirroring Android's
  /// `Utils.getChildCohortCategory` boundaries (<=12mo infant, 13-72mo
  /// toddler, >72mo child) and the exact `ChildProfileCohort` codes
  /// (`B_I`/`B_T`/`B_C`/`G_I`/`G_T`/`G_C`) it sends as both the
  /// `child_age_gender_cohort` event property and the cohort-count trait
  /// keys — do not swap in a friendlier string, dashboards key on these
  /// exact codes.
  String get cohortKey {
    final months = ageInMonths;
    final bucket = months <= 12
        ? 'I'
        : months <= 72
        ? 'T'
        : 'C';
    final genderCode = gender == ChildGender.boy ? 'B' : 'G';
    return '${genderCode}_$bucket';
  }
}
