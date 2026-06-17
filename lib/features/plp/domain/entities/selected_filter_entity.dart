import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_filter_entity.freezed.dart';

@freezed
abstract class SelectedFilterEntity with _$SelectedFilterEntity {
  const factory SelectedFilterEntity({
    String? filterKey,
    String? filterValue,
    String? selectedFilterName,
    @Default(true) bool showOnUi,
  }) = _SelectedFilterEntity;
}
