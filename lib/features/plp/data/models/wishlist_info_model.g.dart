// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistInfoModel _$WishlistInfoModelFromJson(Map<String, dynamic> json) =>
    WishlistInfoModel(
      id: parseToIntOrNull(json['id']),
      isWishlisted: json['isWishlisted'] == null
          ? false
          : parseToBool(json['isWishlisted']),
      canWishlist: json['canWishlist'] == null
          ? false
          : parseToBool(json['canWishlist']),
    );
