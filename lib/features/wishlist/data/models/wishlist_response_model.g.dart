// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistResponseModel _$WishlistResponseModelFromJson(
  Map<String, dynamic> json,
) => WishlistResponseModel(
  action: json['action'] as String?,
  message: json['message'] as String?,
  wishlistItemId: parseToStringOrNull(json['wishlistItemId']),
);
