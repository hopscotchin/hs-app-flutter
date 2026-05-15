import 'package:equatable/equatable.dart';

class SelectedFilterEntity extends Equatable {
  final String? key;
  final String? param;
  final String? selectedFilterName;
  final bool showOnUi;

  const SelectedFilterEntity({
    this.key,
    this.param,
    this.selectedFilterName,
    this.showOnUi = true,
  });

  @override
  List<Object?> get props => [key, param, selectedFilterName, showOnUi];
}
