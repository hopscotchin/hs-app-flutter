import '../entities/pricing_item_entity.dart';

class PricingItemModel extends PricingItemEntity {
  const PricingItemModel({
    super.label,
    super.value,
    super.type,
    super.textColor,
    super.subText,
    super.actionTextToolTip,
    super.hasInfoIcon,
  });

  factory PricingItemModel.fromJson(Map<String, dynamic> json) {
    return PricingItemModel(
      label: json['priceType'] as String? ?? json['label'] as String?,
      value: json['value'] as String?,
      type: json['priceColorType'] as String? ?? json['type'] as String?,
      textColor: json['textColor'] as String?,
      subText: json['subText'] as String?,
      actionTextToolTip: json['actionTextToolTip'] as String?,
      hasInfoIcon: json['action'] != null,
    );
  }
}
