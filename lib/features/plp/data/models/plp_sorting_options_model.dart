import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/plp_sorting_options_entity.dart';
import 'sorting_option_model.dart';

part 'plp_sorting_options_model.g.dart';

// Non-null label that defaults to 'Sort By' when absent, but tolerates a
// non-string value from the backend.
String _parseSortLabel(dynamic value) => value?.toString() ?? 'Sort By';

@JsonSerializable(createToJson: false)
class PlpSortingOptionsModel {
  const PlpSortingOptionsModel({this.label = 'Sort By', this.options = const []});

  @JsonKey(fromJson: _parseSortLabel) final String label;
  @JsonKey(defaultValue: []) final List<SortingOptionModel> options;

  factory PlpSortingOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$PlpSortingOptionsModelFromJson(json);

  PlpSortingOptionsEntity toEntity() => PlpSortingOptionsEntity(
    label: label,
    options: options.map((o) => o.toEntity()).toList(),
  );
}
