import '../../domain/entities/child_entity.dart';

/// Maps the live backend's `ChildInfoDTO` shape (`questionnaire/list`,
/// `v2/questionnaire/save-and-update`) onto the clean [ChildEntity].
///
/// Hand-written (not `json_serializable`) because the live API has real
/// quirks to absorb right here, once, per PROFILE_KIDS_MIGRATION.md §2 /
/// PROFILE_KIDS_API_CONTRACT.md:
///  - `gender` may arrive as lowercase `"boy"/"girl"` (legacy path) or
///    uppercase `"BOY"/"GIRL"` (the only path this app's save endpoint
///    actually uses) — parsed case-insensitively either way.
///  - `year`/`month`/`day` arrive as loosely-typed values (String or int
///    depending on which backend path produced them) — parsed defensively.
///  - the photo URL key flips between `imgUrl` (response) and `imageUrl`
///    (request) — this model reads `imgUrl` on the way in and the request
///    body (built separately in the datasource) writes `imageUrl`.
class ChildModel {
  const ChildModel({required this.id, required this.name, required this.gender, this.dob, this.imageUrl});

  final int id;
  final String name;
  final ChildGender gender;
  final DateTime? dob;
  final String? imageUrl;

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] as String?) ?? '',
      gender: ChildGenderX.fromWire(json['gender'] as String?),
      dob: _parseDob(json['year'], json['month'], json['day']),
      imageUrl: json['imgUrl'] as String?,
    );
  }

  ChildEntity toEntity() => ChildEntity(id: id, name: name, gender: gender, dob: dob, imageUrl: imageUrl);

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
}

extension ChildEntityRequestX on ChildEntity {
  /// Outgoing save/update body, matching the live `ChildRequest` shape —
  /// uppercase gender, `year` as String, `month`/`day` as Int, `imageUrl`
  /// (not `imgUrl`) for the photo. `id` is only included when editing.
  Map<String, dynamic> toRequestJson() {
    final d = dob;
    return {
      if (!isNew) 'id': id,
      'collectFrom': 'Flutter',
      'gender': gender.wireValue,
      'name': name,
      if (d != null) 'year': '${d.year}',
      if (d != null) 'month': d.month,
      if (d != null) 'day': d.day,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
