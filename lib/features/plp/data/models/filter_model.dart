import 'package:json_annotation/json_annotation.dart';

import '../../../../core/entities/visual_cue_entity.dart';
import '../../../../core/models/visual_cue_model.dart';
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

  final String? filterKey;
  final String? filterValue;
  // Raw API key is `productCount` — remapping here keeps the domain entity
  // field as `count` (used throughout the UI for the trailing "(870)" label)
  // and lets us drop the response transformer.
  @JsonKey(name: 'productCount')
  final int? count;
  final String? label;
  @JsonKey(defaultValue: false)
  final bool isSelected;
  @JsonKey(defaultValue: false)
  final bool isMultiSelect;
  final String? type;
  @JsonKey(defaultValue: [])
  final List<FilterModel> filters;
  final String? colorHex;
  final String? ovalImgUrl;
  @JsonKey(defaultValue: false)
  final bool isSection;
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
