// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenResponseModel _$ChildrenResponseModelFromJson(
  Map<String, dynamic> json,
) => ChildrenResponseModel(
  action: json['action'] as String?,
  message: json['message'] as String?,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ChildModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  content: json['content'] == null
      ? null
      : KidsListContentModel.fromJson(json['content'] as Map<String, dynamic>),
);
