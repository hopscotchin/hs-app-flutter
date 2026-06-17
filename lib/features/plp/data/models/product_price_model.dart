import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product_price_entity.dart';

part 'product_price_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductPriceModel {
  const ProductPriceModel({
    this.sellingPrice,
    this.mrp,
    this.discount,
    this.absoluteValue,
    this.callout,
  });

  final String? sellingPrice;
  final String? mrp;

  final String? discount;

  final num? absoluteValue;

  final String? callout;

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPriceModelFromJson(json);

  ProductPriceEntity toEntity() => ProductPriceEntity(
    sellingPrice: sellingPrice,
    mrp: mrp,
    discountLabel: discount,
    absoluteValue: absoluteValue?.toDouble(),
    callout: callout,
  );
}
