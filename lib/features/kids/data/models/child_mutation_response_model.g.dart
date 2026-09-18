// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_mutation_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildMutationResponseModel _$ChildMutationResponseModelFromJson(
  Map<String, dynamic> json,
) => ChildMutationResponseModel(
  action: json['action'] as String?,
  message: json['message'] as String?,
  child: json['child'] == null
      ? null
      : ChildModel.fromJson(json['child'] as Map<String, dynamic>),
  errorType: json['errorType'] as String?,
);
