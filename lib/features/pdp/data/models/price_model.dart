import '../../domain/entities/price_entity.dart';

class PriceModel extends PriceEntity {
  const PriceModel({
    super.callout,
    super.discount,
    super.mrp,
    super.type,
    super.displayValue,
    super.absoluteValue,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      callout: json['callout'] as String?,
      discount: json['discount'] as String?,
      mrp: json['mrp'] as String?,
      type: json['type'] as String?,
      displayValue: json['displayValue'] as String?,
      absoluteValue: (json['absoluteValue'] as num?)?.toDouble(),
    );
  }
}
