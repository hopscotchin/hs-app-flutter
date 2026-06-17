import '../../domain/entities/detail_entity.dart';

class DetailModel extends DetailEntity {
  const DetailModel({super.description, super.tabData, super.tabName});

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      description: json['description'] as String?,
      tabData: json['tabData'] != null
          ? TabDataModel.fromJson(json['tabData'] as Map<String, dynamic>)
          : null,
      tabName: json['tabName'] as String?,
    );
  }
}

class TabDataModel extends TabDataEntity {
  const TabDataModel({
    super.data,
    super.layout,
    super.showBullets,
    super.showDividers,
  });

  factory TabDataModel.fromJson(Map<String, dynamic> json) {
    return TabDataModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProductInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      layout: json['layout'] as String?,
      showBullets: json['showBullets'] as bool?,
      showDividers: json['showDividers'] as bool?,
    );
  }
}

class ProductInfoModel extends ProductInfoEntity {
  const ProductInfoModel({super.key, super.values});

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) {
    return ProductInfoModel(
      key: json['key'] as String?,
      values:
          (json['values'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}
