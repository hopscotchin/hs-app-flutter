import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/visual_product_info_entity.dart';

part 'visual_product_info_model.g.dart';

@JsonSerializable(createToJson: false)
class VisualProductInfoModel {
  const VisualProductInfoModel({
    this.groupName,
    this.items = const [],
    this.title,
  });

  @JsonKey(defaultValue: null) final String? groupName;
  @JsonKey(defaultValue: []) final List<VisualProductItemModel> items;
  @JsonKey(defaultValue: null) final String? title;

  factory VisualProductInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VisualProductInfoModelFromJson(json);
}

extension VisualProductInfoModelX on VisualProductInfoModel {
  VisualProductInfoEntity toEntity() => VisualProductInfoEntity(
    groupName: groupName,
    items: items.map((i) => i.toEntity()).toList(),
    title: title,
  );
}

@JsonSerializable(createToJson: false)
class VisualProductItemModel {
  const VisualProductItemModel({this.id, this.name, this.type, this.url});

  @JsonKey(defaultValue: null) final String? id;
  @JsonKey(defaultValue: null) final String? name;
  @JsonKey(defaultValue: null) final String? type;
  @JsonKey(defaultValue: null) final String? url;

  factory VisualProductItemModel.fromJson(Map<String, dynamic> json) =>
      _$VisualProductItemModelFromJson(json);
}

extension VisualProductItemModelX on VisualProductItemModel {
  VisualProductItemEntity toEntity() =>
      VisualProductItemEntity(id: id, name: name, type: type, url: url);
}
