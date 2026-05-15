import '../../domain/entities/plp_filter_entity.dart';
import 'filter_section_model.dart';
import 'selected_filter_model.dart';

class PlpFilterModel extends PlpFilterEntity {
  const PlpFilterModel({super.selectedFilters, super.filterSection});

  factory PlpFilterModel.fromJson(Map<String, dynamic> json) {
    return PlpFilterModel(
      selectedFilters:
          (json['selectedFilters'] as List<dynamic>?)
              ?.map(
                (e) => SelectedFilterModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      filterSection:
          (json['filterSection'] as List<dynamic>?)
              ?.map(
                (e) => FilterSectionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}
