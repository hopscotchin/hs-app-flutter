import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/models/visual_cue_model.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/filter_entity.dart';

part 'filter_model.g.dart';

@JsonSerializable(createToJson: false)
class FilterModel {
  const FilterModel({
    this.filterKey,
    this.filterValue,
    this.count,
    this.label,
    this.isSelected = false,
    this.isMultiSelect = false,
    this.type,
    this.filters = const [],
    this.colorHex,
    this.ovalImgUrl,
    this.isSection = false,
    this.pincode,
    this.visualCue,
  });

  @JsonKey(fromJson: parseToStringOrNull)
  final String? filterKey;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? filterValue;
  // Raw API key is `productCount` — remapping here keeps the domain entity
  // field as `count` (used throughout the UI for the trailing "(870)" label)
  // and lets us drop the response transformer.
  @JsonKey(name: 'productCount', fromJson: parseToIntOrNull)
  final int? count;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? label;
  @JsonKey(fromJson: parseToBool)
  final bool isSelected;
  @JsonKey(fromJson: parseToBool)
  final bool isMultiSelect;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? type;
  @JsonKey(defaultValue: [])
  final List<FilterModel> filters;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? colorHex;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? ovalImgUrl;
  @JsonKey(fromJson: parseToBool)
  final bool isSection;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? pincode;

  @JsonKey(name: 'visualCue')
  final Map<String, dynamic>? visualCue;

  factory FilterModel.fromJson(Map<String, dynamic> json) => _$FilterModelFromJson(json);

  FilterEntity toEntity() => FilterEntity(
    filterKey: filterKey,
    filterValue: filterValue,
    count: count,
    label: label,
    isSelected: isSelected,
    isMultiSelect: isMultiSelect,
    type: type,
    filters: filters.map((f) => f.toEntity()).toList(),
    colorHex: colorHex,
    ovalImgUrl: ovalImgUrl,
    isSection: isSection,
    pincode: pincode,
    visualCue: _parseVisualCue(visualCue),
  );

  static VisualCueEntity? _parseVisualCue(Map<String, dynamic>? raw) {
    if (raw == null || raw.isEmpty) return null;
    return VisualCueModel.fromJson(raw);
  }
}
