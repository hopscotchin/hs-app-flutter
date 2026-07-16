// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationsModel _$RecommendationsModelFromJson(
  Map<String, dynamic> json,
) => RecommendationsModel(
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => ListingProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pageMeta: _pageMetaFromJson(json['pageMeta']),
);
