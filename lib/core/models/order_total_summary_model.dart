import '../entities/order_total_summary_entity.dart';
import '../utils/json_parsers.dart';

class OrderTotalSummaryModel extends OrderTotalSummaryEntity {
  const OrderTotalSummaryModel({
    super.itemCountText,
    super.totalPrice,
    super.orderSavings,
  });

  factory OrderTotalSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderTotalSummaryModel(
      itemCountText: parseToStringOrNull(json['itemCount']),
      totalPrice: parseToStringOrNull(json['totalPrice']),
      orderSavings: json['orderSavings'] as String?,
    );
  }
}
