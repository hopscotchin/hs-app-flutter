import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/selected_filter_entity.dart';

part 'selected_filter_model.g.dart';

// showOnUi defaults to true when absent (unlike most bools), so it can't use
// the plain false-defaulting parser.
bool _parseShowOnUi(dynamic value) => value == null ? true : parseToBool(value);

@JsonSerializable(createToJson: false)
class SelectedFilterModel {
  const SelectedFilterModel({
    this.filterKey,
    this.filterValue,
    this.selectedFilterName,
    this.showOnUi = true,
  });

  @JsonKey(fromJson: parseToStringOrNull) final String? filterKey;
  @JsonKey(fromJson: parseToStringOrNull) final String? filterValue;
  @JsonKey(fromJson: parseToStringOrNull) final String? selectedFilterName;
  @JsonKey(fromJson: _parseShowOnUi) final bool showOnUi;

  factory SelectedFilterModel.fromJson(Map<String, dynamic> json) =>
      _$SelectedFilterModelFromJson(json);

  SelectedFilterEntity toEntity() => SelectedFilterEntity(
    filterKey: filterKey,
    filterValue: filterValue,
    selectedFilterName: selectedFilterName,
    showOnUi: showOnUi,
  );
}
