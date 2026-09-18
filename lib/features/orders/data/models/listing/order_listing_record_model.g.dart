// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_listing_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListingRecordModel _$OrderListingRecordModelFromJson(
  Map<String, dynamic> json,
) => OrderListingRecordModel(
  orderId: parseToStringOrNull(json['orderId']),
  orderItemId: parseToStringOrNull(json['orderItemId']),
  actionUri: parseToStringOrNull(json['actionUri']),
  actionUriWeb: parseToStringOrNull(json['actionUriWeb']),
  media: _mediaFromJson(json['media']),
  title: parseToStringOrNull(json['title']),
  priceInfo: _priceFromJson(json['priceInfo']),
  quantity: parseToIntOrNull(json['quantity']),
  size: parseToStringOrNull(json['size']),
  itemDetails: _detailFromJson(json['itemDetails']),
  status: _statusFromJson(json['status']),
);
