import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/sorting_option_entity.dart';

part 'sorting_option_model.g.dart';

@JsonSerializable(createToJson: false)
class SortingOptionModel {
  const SortingOptionModel({this.label, this.orderRule = 0, this.isSelected = false});

  final String? label;
  @JsonKey(defaultValue: 0) final int orderRule;
  @JsonKey(defaultValue: false) final bool isSelected;

  factory SortingOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SortingOptionModelFromJson(json);

  SortingOptionEntity toEntity() => SortingOptionEntity(
    label: label,
    orderRule: orderRule,
    isSelected: isSelected,
  );
}
