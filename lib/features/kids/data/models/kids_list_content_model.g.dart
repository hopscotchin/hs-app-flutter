// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kids_list_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KidsListContentModel _$KidsListContentModelFromJson(
  Map<String, dynamic> json,
) => KidsListContentModel(
  emptyStateTitle: json['emptyStateTitle'] as String?,
  emptyStateSubtitle: json['emptyStateSubtitle'] as String?,
  bannerTitle: json['bannerTitle'] as String?,
  bannerSubtitle: json['bannerSubtitle'] as String?,
  addChildLabel: json['addChildLabel'] as String?,
  addAnotherChildLabel: json['addAnotherChildLabel'] as String?,
  addChildSubtitle: json['addChildSubtitle'] as String?,
  footerAvatars: (json['footerAvatars'] as List<dynamic>?)
      ?.map((e) => e as String?)
      .toList(),
);
