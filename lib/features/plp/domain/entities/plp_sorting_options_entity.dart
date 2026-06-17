import 'package:freezed_annotation/freezed_annotation.dart';

import 'sorting_option_entity.dart';

part 'plp_sorting_options_entity.freezed.dart';

@freezed
abstract class PlpSortingOptionsEntity with _$PlpSortingOptionsEntity {
  const factory PlpSortingOptionsEntity({
    @Default('Sort By') String label,
    @Default([]) List<SortingOptionEntity> options,
  }) = _PlpSortingOptionsEntity;
}
