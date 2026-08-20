import '../entities/order_summary_entity.dart';
import 'order_total_summary_model.dart';
import 'pricing_item_model.dart';

class OrderSummaryModel extends OrderSummaryEntity {
  const OrderSummaryModel({
    super.sectionTitle,
    super.subText,
    super.pricingData,
    super.totalOrderAmount,
    super.totalOrderSummary,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    final totalOrderJson = json['totalOrderAmount'] as Map<String, dynamic>?;
    final totalOrderSummaryJson = json['totalOrderSummary'] as Map<String, dynamic>?;
    return OrderSummaryModel(
      sectionTitle: json['sectionTitle'] as String?,
      subText: json['subText'] as String?,
      pricingData:
          (json['pricingData'] as List<dynamic>?)
              ?.map((e) => PricingItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalOrderAmount: totalOrderJson != null ? PricingItemModel.fromJson(totalOrderJson) : null,
      totalOrderSummary: totalOrderSummaryJson != null
          ? OrderTotalSummaryModel.fromJson(totalOrderSummaryJson)
          : null,
    );
  }
}
