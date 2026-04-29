import '../entities/order_summary_entity.dart';
import 'pricing_item_model.dart';

class OrderSummaryModel extends OrderSummaryEntity {
  const OrderSummaryModel({
    super.sectionTitle,
    super.subText,
    super.pricingData,
    super.totalOrderAmount,
    super.totalAmount,
    super.itemCount,
  });

  factory OrderSummaryModel.fromJson(
    Map<String, dynamic> json, {
    int? itemCount,
    int? totalAmount,
  }) {
    final totalOrderJson =
        json['totalOrderAmount'] as Map<String, dynamic>?;
    return OrderSummaryModel(
      sectionTitle: json['sectionTitle'] as String?,
      subText: json['subText'] as String?,
      pricingData: (json['pricingData'] as List<dynamic>?)
              ?.map((e) =>
                  PricingItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalOrderAmount: totalOrderJson != null
          ? PricingItemModel.fromJson(totalOrderJson)
          : null,
      totalAmount: totalAmount ??
          json['totalAmount'] as int? ??
          json['grandTotal'] as int? ??
          json['total'] as int?,
      itemCount: itemCount ??
          json['itemCount'] as int? ??
          json['totalItems'] as int?,
    );
  }
}
