import 'package:json_annotation/json_annotation.dart';

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

  final String? filterKey;
  final String? filterValue;
  final String? label;
  final String? chipType;
  final String? textColor;
  @JsonKey(name: 'bgColor') final String? backgroundColor;
  final String? imageUrl;
  @JsonKey(defaultValue: false) final bool isSelected;

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
    this.chips = const [],
  });

  final String? title;
  final String? chipType;
  final int? position;
  final int? tileWidth;
  final int? tileHeight;
  @JsonKey(defaultValue: []) final List<FloatingFilterChipModel> chips;

  factory FloatingFilterSectionModel.fromJson(Map<String, dynamic> json) =>
      _$FloatingFilterSectionModelFromJson(json);

  FloatingFilterSectionEntity toEntity() => FloatingFilterSectionEntity(
    title: title,
    chipType: chipType,
    position: position,
    tileWidth: tileWidth,
    tileHeight: tileHeight,
    chips: chips.map((c) => c.toEntity()).toList(),
  );
}

@JsonSerializable(createToJson: false)
class FloatingFilterModel {
  const FloatingFilterModel({this.type, this.sections = const []});

  final String? type;
  @JsonKey(defaultValue: []) final List<FloatingFilterSectionModel> sections;

  factory FloatingFilterModel.fromJson(Map<String, dynamic> json) =>
      _$FloatingFilterModelFromJson(json);

  FloatingFilterEntity toEntity() => FloatingFilterEntity(
    type: type,
    sections: sections.map((s) => s.toEntity()).toList(),
  );
}
