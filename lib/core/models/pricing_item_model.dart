import '../entities/pricing_item_entity.dart';
import 'backend_action_model.dart';

class PricingItemModel extends PricingItemEntity {
  const PricingItemModel({
    super.label,
    super.value,
    super.textColor,
    super.subText,
    super.subTextColor,
    super.action,
    super.originalValue,
    super.originalColor,
  });

  factory PricingItemModel.fromJson(Map<String, dynamic> json) {
    return PricingItemModel(
      label: json['priceType'] as String? ?? json['label'] as String?,
      value: json['displayValue'] as String?,
      // Most rows key the value's color as `displayColor`, but the shipping-fee
      // row sends `displayValueColor` (the green on a "FREE" value) — accept
      // either, otherwise that row silently renders in the default color.
      textColor:
          json['displayColor'] as String? ?? json['displayValueColor'] as String?,
      subText: json['subText'] as String?,
      subTextColor: json['subTextColor'] as String?,
      action: BackendActionModel.fromJsonOrNull(
        json['action'] as Map<String, dynamic>?,
      ),
      originalValue: json['originalValue'] as String?,
      // Sent as `originalValueColor` (e.g. the grey on a struck-through "₹50").
      originalColor:
          json['originalValueColor'] as String? ?? json['originalColor'] as String?,
    );
  }
}
