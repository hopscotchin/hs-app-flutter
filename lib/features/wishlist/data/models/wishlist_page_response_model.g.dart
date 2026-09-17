// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistPageResponseModel _$WishlistPageResponseModelFromJson(
  Map<String, dynamic> json,
) => WishlistPageResponseModel(
  pageMeta: json['pageMeta'] == null
      ? null
      : PageMetaModel.fromJson(json['pageMeta'] as Map<String, dynamic>),
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => WishlistProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  trackingMeta: json['trackingMeta'] == null
      ? const <String, dynamic>{}
      : _parseTrackingMeta(json['trackingMeta']),
);
