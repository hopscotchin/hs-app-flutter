// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageResponseModel _$HomePageResponseModelFromJson(
  Map<String, dynamic> json,
) => HomePageResponseModel(
  pageName: json['pageName'] as String?,
  pageBackgroundColor: json['pageBackgroundColor'] as String?,
  headerBgImageUrl: json['headerBgImageUrl'] as String?,
  totalCollections: (json['totalCollections'] as num?)?.toInt() ?? 0,
  totalSections: (json['totalSections'] as num?)?.toInt() ?? 0,
  pageComponents: json['pageComponents'] == null
      ? const []
      : _parseComponents(json['pageComponents']),
  action: json['action'] as String?,
  popUpMessage: json['popUpMessage'] as String?,
  messageBars: json['messageBars'] == null
      ? const []
      : _parseMessageBars(json['messageBars']),
);
