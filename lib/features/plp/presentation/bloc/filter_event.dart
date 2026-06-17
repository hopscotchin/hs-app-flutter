part of 'filter_bloc.dart';

@freezed
sealed class FilterEvent with _$FilterEvent {
  const factory FilterEvent.initialize({
    required PlpFilterEntity plpFilter,
    required Map<String, String> appliedFilters,
    required Map<String, dynamic> baseQueryParams,
  }) = InitializeFilter;

  const factory FilterEvent.toggleFilterItem({
    required String param,
    required String value,
    required bool isMultiSelect,
  }) = ToggleFilterItem;

  const factory FilterEvent.selectTreeItem({
    required String param,
    required String value,
    required int level,
  }) = SelectTreeItem;

  const factory FilterEvent.switchSection({required int sectionIndex}) = SwitchSection;

  const factory FilterEvent.clearAllPendingFilters() = ClearAllPendingFilters;

  const factory FilterEvent.navigateTreeBack() = NavigateTreeBack;

  const factory FilterEvent.popTreeToLevel({required int level}) = PopTreeToLevel;

  const factory FilterEvent.verifyPincode({required String pincode}) = VerifyPincode;

  const factory FilterEvent.clearPincodeError() = ClearPincodeError;
}
