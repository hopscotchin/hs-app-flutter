import '../../domain/entities/sku_entity.dart';
import 'edd_info_model.dart';
import 'price_model.dart';
import 'warning_model.dart';

class SkuModel extends SkuEntity {
  const SkuModel({
    super.skuId,
    super.size,
    super.price,
    super.enable,
    super.availableQuantity,
    super.eddInfo,
    super.warning,
    super.isSelected,
    super.isAddedToBag,
  });

  factory SkuModel.fromJson(Map<String, dynamic> json) {
    return SkuModel(
      skuId: json['skuId'] as String?,
      size: json['size'] as String?,
      price: json['price'] != null
          ? PriceModel.fromJson(json['price'] as Map<String, dynamic>)
          : null,
      enable: json['enable'] as bool?,
      availableQuantity: json['availableQuantity'] as int?,
      eddInfo: json['eddInfo'] != null
          ? EddInfoModel.fromJson(json['eddInfo'] as Map<String, dynamic>)
          : null,
      warning: json['warning'] != null
          ? WarningModel.fromJson(json['warning'] as Map<String, dynamic>)
          : null,
    );
  }
}
