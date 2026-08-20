import 'package:equatable/equatable.dart';

import 'order_total_summary_entity.dart';
import 'pricing_item_entity.dart';

class OrderSummaryEntity extends Equatable {
  final String? sectionTitle;
  final String? subText;
  final List<PricingItemEntity> pricingData;

  /// Legacy single-row total (checkout/order-confirmation shape) — a plain
  /// label+value pricing row.
  final PricingItemEntity? totalOrderAmount;

  /// Cart shape — a dedicated object with its own preformatted item-count,
  /// total-price, and savings-banner strings straight from the backend.
  final OrderTotalSummaryEntity? totalOrderSummary;

  const OrderSummaryEntity({
    this.sectionTitle,
    this.subText,
    this.pricingData = const [],
    this.totalOrderAmount,
    this.totalOrderSummary,
  });

  @override
  List<Object?> get props => [
    sectionTitle,
    subText,
    pricingData,
    totalOrderAmount,
    totalOrderSummary,
  ];
}

extension OrderSummaryEntityX on OrderSummaryEntity {
  /// Preformatted "You saved ₹X on this order" banner text from the backend,
  /// when present.
  String? get savingsMessage {
    final message = totalOrderSummary?.orderSavings;
    return (message != null && message.isNotEmpty) ? message : null;
  }

  /// Sum of discount-flagged pricing rows (negative value, e.g. "-₹1066") —
  /// fallback used only when the backend doesn't send [savingsMessage].
  int get totalSavings {
    var total = 0;
    for (final item in pricingData) {
      final value = item.value;
      if (value == null || !value.contains('-')) continue;
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      total += int.tryParse(digits) ?? 0;
    }
    return total;
  }
}
