// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageMetaModel _$PageMetaModelFromJson(Map<String, dynamic> json) =>
    PageMetaModel(
      page: json['page'] == null ? 1 : parseToInt(json['page']),
      pageSize: json['pageSize'] == null ? 20 : parseToInt(json['pageSize']),
      totalCount: json['totalCount'] == null
          ? 0
          : parseToInt(json['totalCount']),
      hasNextPage: json['hasNextPage'] == null
          ? false
          : parseToBool(json['hasNextPage']),
      pageTitle: parseToStringOrNull(json['pageTitle']),
      pageSubtitle: parseToStringOrNull(json['pageSubtitle']),
      plpId: parseToIntOrNull(json['plpId']),
      orderRule: json['orderRule'] == null
          ? -1
          : _parseOrderRule(json['orderRule']),
    );
