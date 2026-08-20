import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/cart_item_price_info_entity.dart';

class CartItemPriceInfoModel extends CartItemPriceInfoEntity {
  const CartItemPriceInfoModel({
    super.sellingPrice,
    super.mrp,
    super.discount,
    super.absoluteValue,
    super.callout,
  });

  factory CartItemPriceInfoModel.fromJson(Map<String, dynamic> json) {
    return CartItemPriceInfoModel(
      sellingPrice: parseToStringOrNull(json['sellingPrice']),
      mrp: parseToStringOrNull(json['mrp']),
      discount: parseToStringOrNull(json['discount']),
      absoluteValue: parseToIntOrNull(json['absoluteValue']),
      callout: parseToStringOrNull(json['callout']),
    );
  }
}
