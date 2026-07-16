import '../../domain/entities/shipping_fee_info_entity.dart';

class ShippingFeeInfoModel extends ShippingFeeInfoEntity {
  const ShippingFeeInfoModel({
    super.message,
    super.shippingMinimum,
    super.action,
    super.actionLabel,
    super.freeShippingThreshold,
  });

  factory ShippingFeeInfoModel.fromJson(Map<String, dynamic> json) {
    return ShippingFeeInfoModel(
      message: json['message'] as String?,
      shippingMinimum: (json['shippingMinimum'] as num?)?.toDouble(),
      action: json['action'] as String?,
      actionLabel: json['actionLabel'] as String?,
      freeShippingThreshold: json['freeShippingThreshold'] as int?,
    );
  }
}
