import '../../domain/entities/filter_entity.dart';

class FilterModel extends FilterEntity {
  const FilterModel({
    super.id,
    super.count,
    super.name,
    super.param,
    super.isSelected,
    super.isMultiSelect,
    super.type,
    super.filter,
    super.value,
    super.ovalImgUrl,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: json['id']?.toString(),
      count: (json['count'] as num?)?.toInt(),
      name: json['name'] as String?,
      param: json['param'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
      isMultiSelect: json['isMultiSelect'] as bool? ?? false,
      type: json['type'] as String?,
      filter:
          (json['filter'] as List<dynamic>?)
              ?.map((e) => FilterModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      value: json['value'] as String?,
      ovalImgUrl: json['ovalImgUrl'] as String?,
    );
  }
}
