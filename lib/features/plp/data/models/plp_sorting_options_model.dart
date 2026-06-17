import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/plp_sorting_options_entity.dart';
import 'sorting_option_model.dart';

part 'plp_sorting_options_model.g.dart';

@JsonSerializable(createToJson: false)
class PlpSortingOptionsModel {
  const PlpSortingOptionsModel({this.label = 'Sort By', this.options = const []});

  @JsonKey(defaultValue: 'Sort By') final String label;
  @JsonKey(defaultValue: []) final List<SortingOptionModel> options;

  factory PlpSortingOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$PlpSortingOptionsModelFromJson(json);

  PlpSortingOptionsEntity toEntity() => PlpSortingOptionsEntity(
    label: label,
    options: options.map((o) => o.toEntity()).toList(),
  );
}
