import '../../domain/entities/selected_filter_entity.dart';

class SelectedFilterModel extends SelectedFilterEntity {
  const SelectedFilterModel({
    super.key,
    super.param,
    super.selectedFilterName,
    super.showOnUi,
  });

  factory SelectedFilterModel.fromJson(Map<String, dynamic> json) {
    return SelectedFilterModel(
      key: json['key'] as String?,
      param: json['param'] as String?,
      selectedFilterName: json['selectedFilterName'] as String?,
      showOnUi: json['showOnUi'] as bool? ?? true,
    );
  }
}
