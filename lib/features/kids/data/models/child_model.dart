import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/child_entity.dart';

part 'child_model.g.dart';

/// Maps the live backend's `ChildInfoDTO` shape (`v2/questionnaire/list`,
/// `v3/questionnaire/save-and-update`) onto the clean [ChildEntity].
///
/// `dob`, `displayDob`, `age` and `trackingMeta.{ageInMonths, cohort}` all
/// arrive server-formatted, ready to use — carried straight through to
/// [ChildEntity] with no client-side date parsing at all. `gender` arrives
/// title-case (`"Boy"/"Girl"`) on both endpoints, parsed case-insensitively
/// by [ChildGenderX.fromWire] as cheap defense against a casing change.
@JsonSerializable(createToJson: false)
class ChildModel {
  const ChildModel({
    required this.id,
    required this.name,
    required this.gender,
    this.dob,
    this.displayDob,
    this.imageUrl,
    this.consent = false,
    this.age,
    this.trackingMeta,
  });

  @JsonKey(fromJson: parseToInt) final int id;
  @JsonKey(defaultValue: '') final String name;
  @JsonKey(fromJson: ChildGenderX.fromWire) final ChildGender gender;

  /// `"D MMM YYYY"` (e.g. `"10 Sep 2025"`) — server-formatted, ready to
  /// display verbatim on the My Kids list row. `v2/questionnaire/list` sends
  /// this as `dobReadable`; read via [_readDob] with a fallback to the older
  /// `dob` key in case `v3/save-and-update` hasn't picked up the rename yet.
  @JsonKey(readValue: _readDob) final String? dob;

  /// `"DD - MM - YYYY"` (spaced dashes) — server-formatted specifically for
  /// the Add/Edit screen's read-only dob field, a different shape from
  /// [dob]'s display string. `v2/questionnaire/list` sends this as
  /// `dobForDate`; read via [_readDisplayDob] with the same old-key fallback.
  @JsonKey(readValue: _readDisplayDob) final String? displayDob;
  final String? imageUrl;
  @JsonKey(defaultValue: false) final bool consent;
  final String? age;

  /// Raw `{"cohort": "G_I", "ageInMonths": 12, "gender": "Girl"}` blob —
  /// `cohort`/`ageInMonths` are extracted by key in [toEntity]; `gender` here
  /// duplicates the top-level `gender` field and is otherwise unused.
  final Map<String, dynamic>? trackingMeta;

  factory ChildModel.fromJson(Map<String, dynamic> json) => _$ChildModelFromJson(json);
}

Object? _readDob(Map json, String key) => json['dobReadable'] ?? json['dob'];

Object? _readDisplayDob(Map json, String key) => json['dobForDate'] ?? json['displayDob'];

extension ChildModelX on ChildModel {
  ChildEntity toEntity() => ChildEntity(
    id: id,
    name: name,
    gender: gender,
    dob: dob,
    displayDob: displayDob,
    imageUrl: imageUrl,
    consent: consent,
    age: age,
    ageInMonths: trackingMeta?['ageInMonths'] as int?,
    cohortKey: trackingMeta?['cohort'] as String?,
  );
}

extension ChildEntityRequestX on ChildEntity {
  /// Outgoing save/update body, matching the v3 `save-and-update` contract —
  /// title-case gender, `dob` as a single `"DD-MM-YYYY"` string. `id` is
  /// only included when editing; `consent` only when creating (captured
  /// once at creation, never resent on edit); image upload isn't part of
  /// this request at all.
  ///
  /// `dob` here is expected to already be in `"DD-MM-YYYY"` form —
  /// `ManageKidBloc._onSubmit` resolves it (from a freshly-picked date, or
  /// from the existing child's own `displayDob` with its spaces stripped
  /// when dob wasn't re-picked) before building this entity, so no parsing
  /// happens on this side either.
  Map<String, dynamic> toRequestJson() => {
    if (!isNew) 'id': id,
    'name': name,
    'gender': gender.displayLabel,
    if (displayDob != null) 'dob': displayDob,
    if (isNew) 'consent': consent,
  };
}
