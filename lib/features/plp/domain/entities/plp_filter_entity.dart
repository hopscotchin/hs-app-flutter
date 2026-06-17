import 'package:freezed_annotation/freezed_annotation.dart';

import 'filter_section_entity.dart';
import 'plp_sorting_options_entity.dart';
import 'quick_filter_entity.dart';
import 'selected_filter_entity.dart';

part 'plp_filter_entity.freezed.dart';

@freezed
abstract class PlpFilterEntity with _$PlpFilterEntity {
  const factory PlpFilterEntity({
    @Default([]) List<QuickFilterEntity> quickFilters,
    PlpSortingOptionsEntity? sortingOptions,
    @Default([]) List<FilterSectionEntity> filterSections,
    @Default([]) List<SelectedFilterEntity> selectedFilters,
  }) = _PlpFilterEntity;
}
