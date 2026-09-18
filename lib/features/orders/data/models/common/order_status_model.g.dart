// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderStatusModel _$OrderStatusModelFromJson(Map<String, dynamic> json) =>
    OrderStatusModel(
      icon: parseToStringOrNull(json['icon']),
      title: parseToStringOrNull(json['title']),
      subtitle: parseToStringOrNull(json['subtitle']),
      action: _actionFromJson(json['action']),
    );
