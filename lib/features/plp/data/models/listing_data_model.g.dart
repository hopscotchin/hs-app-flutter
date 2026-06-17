// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingDataModel _$ListingDataModelFromJson(
  Map<String, dynamic> json,
) => ListingDataModel(
  pageMeta: json['pageMeta'] == null
      ? null
      : PageMetaModel.fromJson(json['pageMeta'] as Map<String, dynamic>),
  trackingMeta: json['trackingMeta'] == null
      ? null
      : TrackingMetaModel.fromJson(
          json['trackingMeta'] as Map<String, dynamic>,
        ),
  notificationNudge: json['notificationNudge'] == null
      ? null
      : NotificationNudgeModel.fromJson(
          json['notificationNudge'] as Map<String, dynamic>,
        ),
  banners: json['banners'] == null
      ? null
      : BannersWrapperModel.fromJson(json['banners'] as Map<String, dynamic>),
  floatingFilter: json['floatingFilter'] == null
      ? null
      : FloatingFilterModel.fromJson(
          json['floatingFilter'] as Map<String, dynamic>,
        ),
  filters: json['filters'] == null
      ? null
      : PlpFilterModel.fromJson(json['filters'] as Map<String, dynamic>),
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => ListingProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  queryCorrection: json['queryCorrection'] == null
      ? null
      : QueryCorrectionModel.fromJson(
          json['queryCorrection'] as Map<String, dynamic>,
        ),
  messageBars: json['messageBars'] == null
      ? const []
      : _parseMessageBars(json['messageBars']),
);
