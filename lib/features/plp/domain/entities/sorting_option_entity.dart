import 'package:equatable/equatable.dart';

class SortingOptionEntity extends Equatable {
  final String? sortName;
  final int orderRule;
  final bool isSelected;

  const SortingOptionEntity({
    this.sortName,
    this.orderRule = 0,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [sortName, orderRule, isSelected];
}
