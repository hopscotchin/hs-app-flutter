import 'package:equatable/equatable.dart';

import 'filter_entity.dart';

class FilterSectionEntity extends Equatable {
  final String? name;
  final bool isSelected;
  final bool hasSelected;
  final bool isMultiSelect;
  final bool showSearch;
  final String? searchBarLabel;
  final String? uiType;
  final List<FilterEntity> filterList;

  const FilterSectionEntity({
    this.name,
    this.isSelected = false,
    this.hasSelected = false,
    this.isMultiSelect = false,
    this.showSearch = false,
    this.searchBarLabel,
    this.uiType,
    this.filterList = const [],
  });

  @override
  List<Object?> get props => [
    name,
    isSelected,
    hasSelected,
    isMultiSelect,
    showSearch,
    searchBarLabel,
    uiType,
    filterList,
  ];
}
