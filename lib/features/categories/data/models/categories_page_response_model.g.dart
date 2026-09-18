// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesPageResponseModel _$CategoriesPageResponseModelFromJson(
  Map<String, dynamic> json,
) => CategoriesPageResponseModel(
  action: json['action'] as String?,
  pageMeta: parsePageMetaJson(json['pageMeta']),
  searchPlaceHolder: json['searchPlaceHolder'] as String?,
  pageComponents: json['pageComponents'] == null
      ? const []
      : _parseComponents(json['pageComponents']),
);
