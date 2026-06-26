// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortingOptionModel _$SortingOptionModelFromJson(Map<String, dynamic> json) =>
    SortingOptionModel(
      label: parseToStringOrNull(json['label']),
      orderRule: json['orderRule'] == null ? 0 : parseToInt(json['orderRule']),
      isSelected: json['isSelected'] == null
          ? false
          : parseToBool(json['isSelected']),
    );
