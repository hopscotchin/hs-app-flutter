import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/child_entity.dart';

part 'child_model.g.dart';

/// Maps the live backend's `ChildInfoDTO` shape (`v2/questionnaire/list`,
/// `v3/questionnaire/save-and-update`) onto the clean [ChildEntity].
///
/// A couple of real quirks, confirmed against both endpoints' actual QA
/// responses, are absorbed by the `fromJson:` helpers below rather than in
/// generated code:
///  - `gender` arrives title-case (`"Boy"/"Girl"`) on both endpoints, parsed
///    case-insensitively by [ChildGenderX.fromWire] as cheap defense against
///    a casing change.
///  - `dob` arrives as a `"D MMM YYYY"` display string (e.g. `"10 Sep
///    2025"`) on both endpoints' *responses* — a different format from the
///    `"DD-MM-YYYY"` string the save endpoint's *request* body sends (see
///    [ChildEntityRequestX.toRequestJson]); the two are never the same shape.
///  - the photo URL key is `imageUrl` on both the way in and the way out.
///
/// `age` and `trackingMeta.{ageInMonths, cohort}` also arrive precomputed on
/// both endpoints' responses — carried straight through to [ChildEntity]
/// rather than recomputed client-side from [dob].
@JsonSerializable(createToJson: false)
class ChildModel {
  const ChildModel({
    required this.id,
    required this.name,
    required this.gender,
    this.dob,
    this.imageUrl,
    this.consent = false,
    this.age,
    this.trackingMeta,
  });

  @JsonKey(fromJson: parseToInt) final int id;
  @JsonKey(defaultValue: '') final String name;
  @JsonKey(fromJson: ChildGenderX.fromWire) final ChildGender gender;
  @JsonKey(fromJson: _dobFromJson) final DateTime? dob;
  final String? imageUrl;
  @JsonKey(defaultValue: false) final bool consent;
  final String? age;

  /// Raw `{"cohort": "G_I", "ageInMonths": 12, "gender": "Girl"}` blob —
  /// `cohort`/`ageInMonths` are extracted by key in [toEntity]; `gender` here
  /// duplicates the top-level `gender` field and is otherwise unused.
  final Map<String, dynamic>? trackingMeta;

  factory ChildModel.fromJson(Map<String, dynamic> json) => _$ChildModelFromJson(json);
}

const _months = [
  'jan', 'feb', 'mar', 'apr', 'may', 'jun',
  'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
]; // ignore: prefer_const_declarations

/// Parses the `"10 Sep 2025"` display-string format both `v2/list` and the
/// `v3/save-and-update` response return for a child's `dob`.
DateTime? _dobFromJson(Object? value) {
  if (value is! String) return null;
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.length != 3) return null;
  final d = int.tryParse(parts[0]);
  final m = _months.indexOf(parts[1].toLowerCase());
  final y = int.tryParse(parts[2]);
  if (d == null || m == -1 || y == null) return null;
  return DateTime(y, m + 1, d);
}

extension ChildModelX on ChildModel {
  ChildEntity toEntity() => ChildEntity(
    id: id,
    name: name,
    gender: gender,
    dob: dob,
    imageUrl: imageUrl,
    consent: consent,
    age: age,
    ageInMonths: trackingMeta?['ageInMonths'] as int?,
    cohortKey: trackingMeta?['cohort'] as String?,
  );
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
