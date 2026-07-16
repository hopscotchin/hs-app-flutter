import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/detail_entity.dart';

part 'detail_model.g.dart';

@JsonSerializable(createToJson: false)
class DetailModel {
  const DetailModel({this.tabName, this.items = const []});

  @JsonKey(defaultValue: null)
  final String? tabName;

  @JsonKey(defaultValue: [])
  final List<DetailItemModel> items;

  factory DetailModel.fromJson(Map<String, dynamic> json) =>
      _$DetailModelFromJson(json);
}

extension DetailModelX on DetailModel {
  DetailEntity toEntity() => DetailEntity(
    tabName: tabName,
    items: items.map((e) => e.toEntity()).toList(),
  );
}

@JsonSerializable(createToJson: false)
class DetailItemModel {
  const DetailItemModel({
    this.type,
    this.span,
    this.displayKey,
    this.values = const [],
    this.displayStyle,
    this.showBullet,
    this.showDivider,
    this.fieldPath,
  });

  @JsonKey(defaultValue: null) final String? type;
  @JsonKey(defaultValue: null) final int? span;
  @JsonKey(defaultValue: null) final String? displayKey;
  @JsonKey(defaultValue: []) final List<String> values;
  @JsonKey(defaultValue: null) final String? displayStyle;
  @JsonKey(defaultValue: null) final bool? showBullet;
  @JsonKey(defaultValue: null) final bool? showDivider;
  @JsonKey(defaultValue: null) final String? fieldPath;

  factory DetailItemModel.fromJson(Map<String, dynamic> json) =>
      _$DetailItemModelFromJson(json);
}

extension DetailItemModelX on DetailItemModel {
  DetailItemEntity toEntity() => DetailItemEntity(
    type: type,
    span: span,
    displayKey: displayKey,
    values: values,
    displayStyle: displayStyle,
    showBullet: showBullet,
    showDivider: showDivider,
    fieldPath: fieldPath,
  );
}
