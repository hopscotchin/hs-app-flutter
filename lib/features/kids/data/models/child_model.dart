import '../../domain/entities/child_entity.dart';

/// Maps the live backend's `ChildInfoDTO` shape (`v2/questionnaire/list`,
/// `v3/questionnaire/save-and-update`) onto the clean [ChildEntity].
///
/// Hand-written (not `json_serializable`) because the live API has real
/// quirks to absorb right here, once, per PROFILE_KIDS_MIGRATION.md §2 /
/// PROFILE_KIDS_API_CONTRACT.md:
///  - `gender` may arrive as lowercase `"boy"/"girl"` (legacy path) or
///    title-case `"Boy"/"Girl"` (the v3 save endpoint) — parsed
///    case-insensitively either way.
///  - `dob` arrives either as split `year`/`month`/`day` fields (legacy
///    path, loosely typed) or as a single `"DD-MM-YYYY"` string (v3) —
///    both are parsed defensively.
///  - the photo URL key is `imageUrl` on both the way in and the way out
///    (the v3 save endpoint's request body, built separately in the
///    datasource, writes the same key) — v2 renamed the legacy `imgUrl`
///    response key to `imageUrl` per PROFILE_KIDS_API_CONTRACT.md §1.
class ChildModel {
  const ChildModel({
    required this.id,
    required this.name,
    required this.gender,
    this.dob,
    this.imageUrl,
    this.consent = false,
  });

  final int id;
  final String name;
  final ChildGender gender;
  final DateTime? dob;
  final String? imageUrl;
  final bool consent;

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] as String?) ?? '',
      gender: ChildGenderX.fromWire(json['gender'] as String?),
      dob:
          _parseDob(json['year'], json['month'], json['day']) ??
          _parseDobDashString(json['dob'] as String?) ??
          _parseDobDisplayString(json['dob'] as String?),
      imageUrl: json['imageUrl'] as String?,
      consent: json['consent'] as bool? ?? false,
    );
  }

  ChildEntity toEntity() =>
      ChildEntity(id: id, name: name, gender: gender, dob: dob, imageUrl: imageUrl, consent: consent);

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _parseDob(Object? year, Object? month, Object? day) {
    final y = _asInt(year);
    final m = _asInt(month);
    final d = _asInt(day);
    if (y == null || m == null || d == null || y == 0 || m == 0 || d == 0) return null;
    return DateTime(y, m, d);
  }

  /// Parses the `"DD-MM-YYYY"` string format used by the save-and-update
  /// request, as a fallback when the split year/month/day fields aren't present.
  static DateTime? _parseDobDashString(String? value) {
    if (value == null) return null;
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  static const _months = [
    'jan', 'feb', 'mar', 'apr', 'may', 'jun',
    'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
  ]; // ignore: prefer_const_declarations

  /// Parses the `"13 Aug 2025"` display-string format the v3 save-and-update
  /// response returns for the saved child's `dob`.
  static DateTime? _parseDobDisplayString(String? value) {
    if (value == null) return null;
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = _months.indexOf(parts[1].toLowerCase());
    final y = int.tryParse(parts[2]);
    if (d == null || m == -1 || y == null) return null;
    return DateTime(y, m + 1, d);
  }
}

extension ChildEntityRequestX on ChildEntity {
  /// Outgoing save/update body, matching the v3 `save-and-update` contract —
  /// title-case gender, `dob` as a single `"DD-MM-YYYY"` string, `imageUrl`
  /// (not `imgUrl`) for the photo. `id` is only included when editing.
  Map<String, dynamic> toRequestJson() {
    final d = dob;
    return {
      if (!isNew) 'id': id,
      'name': name,
      'gender': gender.displayLabel,
      if (d != null) 'dob': '${_pad(d.day)}-${_pad(d.month)}-${d.year}',
      if (imageUrl != null) 'imageUrl': imageUrl,
      'consent': consent,
    };
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
