// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visual_product_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisualProductInfoModel _$VisualProductInfoModelFromJson(
  Map<String, dynamic> json,
) => VisualProductInfoModel(
  groupName: json['groupName'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => VisualProductItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  title: json['title'] as String?,
);

VisualProductItemModel _$VisualProductItemModelFromJson(
  Map<String, dynamic> json,
) => VisualProductItemModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  type: json['type'] as String?,
  url: json['url'] as String?,
);
