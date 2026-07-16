import 'package:flutter/material.dart';

import '../../../../components/atoms/price_summary_widget.dart';
import '../../../../core/entities/order_summary_entity.dart';

class CartPriceSummary extends StatelessWidget {
  final OrderSummaryEntity summary;

  const CartPriceSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return PriceSummaryWidget(summary: summary);
  }
}
