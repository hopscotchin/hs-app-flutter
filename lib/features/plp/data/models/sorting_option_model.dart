import '../../domain/entities/sorting_option_entity.dart';

class SortingOptionModel extends SortingOptionEntity {
  const SortingOptionModel({super.sortName, super.orderRule, super.isSelected});

  factory SortingOptionModel.fromJson(Map<String, dynamic> json) {
    return SortingOptionModel(
      sortName: json['sortName'] as String?,
      orderRule: (json['orderRule'] as num?)?.toInt() ?? 0,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }
}
