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

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ]; // ignore: prefer_const_declarations

  /// Ready-to-display date, e.g. "15 May 2019" — reformatted from the
  /// parsed [dob] rather than carrying the backend's own display string
  /// straight through, since [dob] is also needed as a real `DateTime` for
  /// the edit-mode date picker and the outgoing save request.
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
}
