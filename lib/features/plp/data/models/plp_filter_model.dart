import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/plp_filter_entity.dart';
import '../../domain/entities/selected_filter_entity.dart';
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
  });

  @JsonKey(defaultValue: [])
  final List<QuickFilterModel> quickFilters;
  final PlpSortingOptionsModel? sortingOptions;
  @JsonKey(defaultValue: [])
  final List<FilterSectionModel> filterSections;
  @JsonKey(defaultValue: [])
  final List<SelectedFilterModel> selectedFilters;

  factory PlpFilterModel.fromJson(Map<String, dynamic> json) => _$PlpFilterModelFromJson(json);

  PlpFilterEntity toEntity() => PlpFilterEntity(
    quickFilters: quickFilters.map((q) => q.toEntity()).toList(),
    sortingOptions: sortingOptions?.toEntity(),
    filterSections: filterSections.map((s) => s.toEntity()).toList(),
    selectedFilters: _expandSelectedFilters(selectedFilters),
  );

  static List<SelectedFilterEntity> _expandSelectedFilters(List<SelectedFilterModel> selected) {
    final out = <SelectedFilterEntity>[];
    for (final sf in selected) {
      final values = sf.filterValue?.split(',') ?? const <String>[];
      final names = sf.selectedFilterName?.split(',') ?? const <String>[];

      if (values.length <= 1) {
        out.add(sf.toEntity());
        continue;
      }

      for (var i = 0; i < values.length; i++) {
        out.add(
          SelectedFilterEntity(
            filterKey: sf.filterKey,
            filterValue: values[i],
            selectedFilterName: i < names.length ? names[i] : values[i],
            showOnUi: sf.showOnUi,
          ),
        );
      }
    }
    return out;
  }
}
