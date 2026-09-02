import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_entity.freezed.dart';

enum ChildGender { boy, girl }

extension ChildGenderX on ChildGender {
  /// Wire value the live backend expects — uppercase, matching the one
  /// consistent path (the "new"/v2 Kids save endpoint). See
  /// PROFILE_KIDS_MIGRATION.md §2 inconsistency #1 for why lowercase also
  /// exists on the legacy path — this app only ever sends the modern casing.
  String get wireValue => this == ChildGender.boy ? 'BOY' : 'GIRL';

  String get displayLabel => this == ChildGender.boy ? 'Boy' : 'Girl';

  static ChildGender fromWire(String? value) =>
      value?.toUpperCase() == 'GIRL' ? ChildGender.girl : ChildGender.boy;
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
  /// toddler, >72mo child) and the exact trait-key naming already ported
  /// into `AnalyticsHelper.identifyForChildCohorts` (`boy_infant`, etc).
  String get cohortKey {
    final months = ageInMonths;
    final bucket = months <= 12
        ? 'infant'
        : months <= 72
        ? 'toddler'
        : 'child';
    final genderKey = gender == ChildGender.boy ? 'boy' : 'girl';
    return '${genderKey}_$bucket';
  }
}
