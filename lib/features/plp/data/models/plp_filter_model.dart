import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/plp_filter_entity.dart';
import 'filter_section_model.dart';
import 'plp_sorting_options_model.dart';
import 'quick_filter_model.dart';
import 'selected_filter_model.dart';

part 'plp_filter_model.g.dart';

@JsonSerializable(createToJson: false)
class PlpFilterModel {
  const PlpFilterModel({
    this.quickFilters = const [],
    this.sortingOptions,
    this.filterSections = const [],
    this.selectedFilters = const [],
    this.action,
    this.message,
  });

  @JsonKey(defaultValue: [])
  final List<QuickFilterModel> quickFilters;
  final PlpSortingOptionsModel? sortingOptions;
  @JsonKey(defaultValue: [])
  final List<FilterSectionModel> filterSections;
  @JsonKey(defaultValue: [])
  final List<SelectedFilterModel> selectedFilters;

  /// `"success"` | `"failure"` — the /v2/filter endpoint returns HTTP 200 even
  /// for logical failures, signalling the error via this field.
  @JsonKey(fromJson: parseToStringOrNull)
  final String? action;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? message;

  bool get isFailure => action?.toLowerCase() == 'failure';

  factory PlpFilterModel.fromJson(Map<String, dynamic> json) => _$PlpFilterModelFromJson(json);

  PlpFilterEntity toEntity() => PlpFilterEntity(
    quickFilters: quickFilters.map((q) => q.toEntity()).toList(),
    sortingOptions: sortingOptions?.toEntity(),
    filterSections: filterSections.map((s) => s.toEntity()).toList(),
    // Kept raw (one entry per key, comma-joined value + labels). The applied-
    // filters strip splits these into per-label chips at the display layer; the
    // full value here is what re-seeds the BE query, so no selected value is
    // lost. Mirrors Android's FilterManager.addSelectedFilters.
    selectedFilters: selectedFilters.map((sf) => sf.toEntity()).toList(),
  );
}
