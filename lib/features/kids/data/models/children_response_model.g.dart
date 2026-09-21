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
  emptyState: json['emptyState'] == null
      ? null
      : EmptyStateModel.fromJson(json['emptyState'] as Map<String, dynamic>),
  addChildContainer: json['addChildContainer'] == null
      ? null
      : AddChildContainerModel.fromJson(
          json['addChildContainer'] as Map<String, dynamic>,
        ),
  messageBar: json['messageBar'] == null
      ? null
      : MessageBarModel.fromJson(json['messageBar'] as Map<String, dynamic>),
);
