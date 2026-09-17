// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_sku_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistSkuModel _$WishlistSkuModelFromJson(Map<String, dynamic> json) =>
    WishlistSkuModel(
      skuId: parseToString(json['skuId']),
      availableQuantity: json['availableQuantity'] == null
          ? 0
          : parseToInt(json['availableQuantity']),
      enable: json['enable'] == null ? false : parseToBool(json['enable']),
      title: parseToStringOrNull(json['title']),
      subTitle: parseToStringOrNull(json['subTitle']),
      priceInfo: _priceFromJson(json['priceInfo']),
      info: _warningFromJson(json['info']),
      eddInfo: _eddInfoFromJson(json['eddInfo']),
      trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
    );
