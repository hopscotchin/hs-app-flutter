import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/selected_filter_entity.dart';

part 'selected_filter_model.g.dart';

@JsonSerializable(createToJson: false)
class SelectedFilterModel {
  const SelectedFilterModel({
    this.filterKey,
    this.filterValue,
    this.selectedFilterName,
    this.showOnUi = true,
  });

  final String? filterKey;
  final String? filterValue;
  final String? selectedFilterName;
  @JsonKey(defaultValue: true) final bool showOnUi;

  factory SelectedFilterModel.fromJson(Map<String, dynamic> json) =>
      _$SelectedFilterModelFromJson(json);

  SelectedFilterEntity toEntity() => SelectedFilterEntity(
    filterKey: filterKey,
    filterValue: filterValue,
    selectedFilterName: selectedFilterName,
    showOnUi: showOnUi,
  );
}
