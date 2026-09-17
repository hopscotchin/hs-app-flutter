import '../../domain/entities/child_entity.dart';

/// Maps the live backend's `ChildInfoDTO` shape (`v2/questionnaire/list`,
/// `v3/questionnaire/save-and-update`) onto the clean [ChildEntity].
///
/// Hand-written (not `json_serializable`) because of a couple of real quirks,
/// confirmed against both endpoints' actual QA responses:
///  - `gender` arrives title-case (`"Boy"/"Girl"`) on both endpoints, parsed
///    case-insensitively as cheap defense against a casing change.
///  - `dob` arrives as a `"D MMM YYYY"` display string (e.g. `"10 Sep
///    2025"`) on both endpoints' *responses* — a different format from the
///    `"DD-MM-YYYY"` string the save endpoint's *request* body sends (see
///    [ChildEntityRequestX.toRequestJson]); the two are never the same shape.
///  - the photo URL key is `imageUrl` on both the way in and the way out.
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
      dob: _parseDobDisplayString(json['dob'] as String?),
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

  static const _months = [
    'jan', 'feb', 'mar', 'apr', 'may', 'jun',
    'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
  ]; // ignore: prefer_const_declarations

  /// Parses the `"10 Sep 2025"` display-string format both `v2/list` and the
  /// `v3/save-and-update` response return for a child's `dob`.
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
