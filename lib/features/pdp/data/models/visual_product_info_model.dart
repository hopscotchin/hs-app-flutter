import '../../domain/entities/visual_product_info_entity.dart';

class VisualProductInfoModel extends VisualProductInfoEntity {
  const VisualProductInfoModel({super.groupName, super.items, super.title});

  factory VisualProductInfoModel.fromJson(Map<String, dynamic> json) {
    return VisualProductInfoModel(
      groupName: json['groupName'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    VisualProductItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      title: json['title'] as String?,
    );
  }
}

class VisualProductItemModel extends VisualProductItemEntity {
  const VisualProductItemModel({super.id, super.name, super.type, super.url});

  factory VisualProductItemModel.fromJson(Map<String, dynamic> json) {
    return VisualProductItemModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      url: json['url'] as String?,
    );
  }
}
