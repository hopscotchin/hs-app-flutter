import 'package:equatable/equatable.dart';

import 'filter_section_entity.dart';
import 'selected_filter_entity.dart';

class PlpFilterEntity extends Equatable {
  final List<SelectedFilterEntity> selectedFilters;
  final List<FilterSectionEntity> filterSection;

  const PlpFilterEntity({
    this.selectedFilters = const [],
    this.filterSection = const [],
  });

  @override
  List<Object?> get props => [selectedFilters, filterSection];
}
