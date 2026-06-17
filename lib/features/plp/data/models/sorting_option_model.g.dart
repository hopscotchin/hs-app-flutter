// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortingOptionModel _$SortingOptionModelFromJson(Map<String, dynamic> json) =>
    SortingOptionModel(
      label: json['label'] as String?,
      orderRule: (json['orderRule'] as num?)?.toInt() ?? 0,
      isSelected: json['isSelected'] as bool? ?? false,
    );
