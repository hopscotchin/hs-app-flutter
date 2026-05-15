import 'package:equatable/equatable.dart';

import 'pricing_item_entity.dart';

class OrderSummaryEntity extends Equatable {
  final String? sectionTitle;
  final String? subText;
  final List<PricingItemEntity> pricingData;
  final PricingItemEntity? totalOrderAmount;
  final int? totalAmount;
  final int? itemCount;

  const OrderSummaryEntity({
    this.sectionTitle,
    this.subText,
    this.pricingData = const [],
    this.totalOrderAmount,
    this.totalAmount,
    this.itemCount,
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    subText,
    pricingData,
    totalOrderAmount,
    totalAmount,
    itemCount,
  ];
}
