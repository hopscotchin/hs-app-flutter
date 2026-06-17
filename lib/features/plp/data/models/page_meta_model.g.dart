// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageMetaModel _$PageMetaModelFromJson(Map<String, dynamic> json) =>
    PageMetaModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      pageTitle: json['pageTitle'] as String?,
      pageSubtitle: json['pageSubtitle'] as String?,
      plpId: (json['plpId'] as num?)?.toInt(),
      orderRule: (json['orderRule'] as num?)?.toInt() ?? -1,
    );
