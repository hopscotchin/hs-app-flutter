import 'package:equatable/equatable.dart';

class FilterEntity extends Equatable {
  final String? id;
  final int? count;
  final String? name;
  final String? param;
  final bool isSelected;
  final bool isMultiSelect;
  final String? type;
  final List<FilterEntity> filter;
  final String? value;
  final String? ovalImgUrl;
  final bool isSection;

  const FilterEntity({
    this.id,
    this.count,
    this.name,
    this.param,
    this.isSelected = false,
    this.isMultiSelect = false,
    this.type,
    this.filter = const [],
    this.value,
    this.ovalImgUrl,
    this.isSection = false,
  });

  @override
  List<Object?> get props => [
    id,
    count,
    name,
    param,
    isSelected,
    isMultiSelect,
    type,
    filter,
    value,
    ovalImgUrl,
    isSection,
  ];
}
