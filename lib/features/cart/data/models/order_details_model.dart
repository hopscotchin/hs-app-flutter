import '../../domain/entities/order_details_entity.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    super.payAmount,
    super.shipping,
    super.totalCredit,
    super.totalAmount,
    super.productAmount,
    super.discount,
    super.platformFee,
    super.discountPercentage,
    super.itemCount,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    // Read through `num` rather than casting: the backend sends these as
    // whole numbers when they have no paise (`"shipping": 50`), which decodes
    // as int and would throw on a direct `as double`.
    double? amount(String key) => (json[key] as num?)?.toDouble();
    int? count(String key) => (json[key] as num?)?.toInt();

    return OrderDetailsModel(
      payAmount: amount('payAmount'),
      shipping: amount('shipping'),
      totalCredit: amount('totalCredit'),
      totalAmount: amount('totalAmount'),
      productAmount: amount('productAmount'),
      discount: amount('discount'),
      platformFee: amount('platformFee'),
      discountPercentage: count('discountPercentage'),
      itemCount: count('itemCount'),
    );
  }
}
