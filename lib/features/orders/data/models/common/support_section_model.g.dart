// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportSectionModel _$SupportSectionModelFromJson(Map<String, dynamic> json) =>
    SupportSectionModel(
      title: parseToStringOrNull(json['title']),
      ctaActions: json['ctaActions'] == null
          ? const []
          : _actionsFromJson(json['ctaActions']),
    );
