// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPriceModel _$ProductPriceModelFromJson(Map<String, dynamic> json) =>
    ProductPriceModel(
      sellingPrice: parseToStringOrNull(json['sellingPrice']),
      mrp: parseToStringOrNull(json['mrp']),
      discount: parseToStringOrNull(json['discount']),
      absoluteValue: parseToNumOrNull(json['absoluteValue']),
      callout: parseToStringOrNull(json['callout']),
    );
