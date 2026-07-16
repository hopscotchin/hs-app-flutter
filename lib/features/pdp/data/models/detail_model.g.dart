// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailModel _$DetailModelFromJson(Map<String, dynamic> json) => DetailModel(
  tabName: json['tabName'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => DetailItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

DetailItemModel _$DetailItemModelFromJson(Map<String, dynamic> json) =>
    DetailItemModel(
      type: json['type'] as String?,
      span: (json['span'] as num?)?.toInt(),
      displayKey: json['displayKey'] as String?,
      values:
          (json['values'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      displayStyle: json['displayStyle'] as String?,
      showBullet: json['showBullet'] as bool?,
      showDivider: json['showDivider'] as bool?,
      fieldPath: json['fieldPath'] as String?,
    );
