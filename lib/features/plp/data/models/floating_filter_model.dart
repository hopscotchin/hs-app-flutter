import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/floating_filter_entity.dart';

part 'floating_filter_model.g.dart';

@JsonSerializable(createToJson: false)
class FloatingFilterChipModel {
  const FloatingFilterChipModel({
    this.filterKey,
    this.filterValue,
    this.label,
    this.chipType,
    this.textColor,
    this.backgroundColor,
    this.imageUrl,
    this.isSelected = false,
  });

  @JsonKey(fromJson: parseToStringOrNull) final String? filterKey;
  @JsonKey(fromJson: parseToStringOrNull) final String? filterValue;
  @JsonKey(fromJson: parseToStringOrNull) final String? label;
  @JsonKey(fromJson: parseToStringOrNull) final String? chipType;
  @JsonKey(fromJson: parseToStringOrNull) final String? textColor;
  @JsonKey(name: 'bgColor', fromJson: parseToStringOrNull) final String? backgroundColor;
  @JsonKey(fromJson: parseToStringOrNull) final String? imageUrl;
  @JsonKey(fromJson: parseToBool) final bool isSelected;

  factory FloatingFilterChipModel.fromJson(Map<String, dynamic> json) =>
      _$FloatingFilterChipModelFromJson(json);

  FloatingFilterChipEntity toEntity() => FloatingFilterChipEntity(
    filterKey: filterKey,
    filterValue: filterValue,
    label: label,
    chipType: chipType,
    textColor: textColor,
    backgroundColor: backgroundColor,
    imageUrl: imageUrl,
    isSelected: isSelected,
  );
}

@JsonSerializable(createToJson: false)
class FloatingFilterSectionModel {
  const FloatingFilterSectionModel({
    this.title,
    this.chipType,
    this.position,
    this.tileWidth,
    this.tileHeight,
    this.isMultiSelect = true,
    this.chips = const [],
  });

  @JsonKey(fromJson: parseToStringOrNull) final String? title;
  @JsonKey(fromJson: parseToStringOrNull) final String? chipType;
  @JsonKey(fromJson: parseToIntOrNull) final int? position;
  @JsonKey(fromJson: parseToIntOrNull) final int? tileWidth;
  @JsonKey(fromJson: parseToIntOrNull) final int? tileHeight;
  @JsonKey(fromJson: parseToBool, defaultValue: true) final bool isMultiSelect;
  @JsonKey(defaultValue: []) final List<FloatingFilterChipModel> chips;

  factory FloatingFilterSectionModel.fromJson(Map<String, dynamic> json) =>
      _$FloatingFilterSectionModelFromJson(json);

  FloatingFilterSectionEntity toEntity() => FloatingFilterSectionEntity(
    title: title,
    chipType: chipType,
    position: position,
    tileWidth: tileWidth,
    tileHeight: tileHeight,
    isMultiSelect: isMultiSelect,
    chips: chips.map((c) => c.toEntity()).toList(),
  );
}

@JsonSerializable(createToJson: false)
class FloatingFilterModel {
  const FloatingFilterModel({this.type, this.sections = const []});

  @JsonKey(fromJson: parseToStringOrNull) final String? type;
  @JsonKey(defaultValue: []) final List<FloatingFilterSectionModel> sections;

  factory FloatingFilterModel.fromJson(Map<String, dynamic> json) =>
      _$FloatingFilterModelFromJson(json);

  FloatingFilterEntity toEntity() => FloatingFilterEntity(
    type: type,
    sections: sections.map((s) => s.toEntity()).toList(),
  );
}
