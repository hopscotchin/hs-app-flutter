// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_listing_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersListingResponseModel _$OrdersListingResponseModelFromJson(
  Map<String, dynamic> json,
) => OrdersListingResponseModel(
  action: parseToStringOrNull(json['action']),
  message: parseToStringOrNull(json['message']),
  pageMeta: _pageMetaFromJson(json['pageMeta']),
  emptyState: _emptyStateFromJson(json['emptyState']),
  notificationNudge: _nudgeFromJson(json['notificationNudge']),
  support: _supportFromJson(json['support']),
  trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
  records:
      (json['records'] as List<dynamic>?)
          ?.map(
            (e) => OrderListingRecordModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);
