// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageResponseModel _$HomePageResponseModelFromJson(
  Map<String, dynamic> json,
) => HomePageResponseModel(
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _parseMessageBars(json['messageBars']),
  pageMeta: _parsePageMeta(json['pageMeta']),
  sortingOptions: json['sortingOptions'] == null
      ? const []
      : _parseSortingOptions(json['sortingOptions']),
  pageComponents: json['pageComponents'] == null
      ? const []
      : _parseComponents(json['pageComponents']),
);
