// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrdersPageResponseModel _$OrdersPageResponseModelFromJson(
  Map<String, dynamic> json,
) => _OrdersPageResponseModel(
  totalRecords: json['totalRecords'] == null
      ? 0
      : parseToInt(json['totalRecords']),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderInfoModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderInfoModel>[],
);

Map<String, dynamic> _$OrdersPageResponseModelToJson(
  _OrdersPageResponseModel instance,
) => <String, dynamic>{
  'totalRecords': instance.totalRecords,
  'items': instance.items,
};
