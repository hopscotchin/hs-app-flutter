// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistInfoModel _$WishlistInfoModelFromJson(Map<String, dynamic> json) =>
    WishlistInfoModel(
      id: (json['id'] as num?)?.toInt(),
      isWishlisted: json['isWishlisted'] as bool? ?? false,
      canWishlist: json['canWishlist'] as bool? ?? false,
    );
