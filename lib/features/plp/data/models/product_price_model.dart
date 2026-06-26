import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
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

  @JsonKey(fromJson: parseToStringOrNull)
  final String? sellingPrice;
  @JsonKey(fromJson: parseToStringOrNull)
  final String? mrp;

  @JsonKey(fromJson: parseToStringOrNull)
  final String? discount;

  @JsonKey(fromJson: parseToNumOrNull)
  final num? absoluteValue;

  @JsonKey(fromJson: parseToStringOrNull)
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
