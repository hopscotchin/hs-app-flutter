// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkuModel _$SkuModelFromJson(Map<String, dynamic> json) => SkuModel(
  skuId: json['skuId'] as String?,
  title: json['title'] as String?,
  subTitle: json['subTitle'] as String?,
  priceInfo: _priceFromJson(json['priceInfo']),
  enable: json['enable'] as bool?,
  eddInfo: _eddInfoFromJson(json['eddInfo']),
  info: _warningFromJson(json['info']),
  skuAttributes: json['skuAttributes'] as Map<String, dynamic>?,
  trackingMeta: json['trackingMeta'] as Map<String, dynamic>?,
);
