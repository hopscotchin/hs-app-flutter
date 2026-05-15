import '../../domain/entities/filter_section_entity.dart';
import 'filter_model.dart';

class FilterSectionModel extends FilterSectionEntity {
  const FilterSectionModel({
    super.name,
    super.isSelected,
    super.hasSelected,
    super.isMultiSelect,
    super.showSearch,
    super.searchBarLabel,
    super.uiType,
    super.filterList,
  });

  factory FilterSectionModel.fromJson(Map<String, dynamic> json) {
    return FilterSectionModel(
      name: json['name'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
      hasSelected: json['hasSelected'] as bool? ?? false,
      isMultiSelect: json['isMultiSelect'] as bool? ?? false,
      showSearch: json['showSearch'] as bool? ?? false,
      searchBarLabel: json['searchBarLabel'] as String?,
      uiType: json['uiType'] as String?,
      filterList:
          (json['filterList'] as List<dynamic>?)
              ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
