import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../features/plp/domain/entities/product_price_entity.dart';
import 'edd_info_entity.dart';
import 'warning_entity.dart';

part 'sku_entity.freezed.dart';

@freezed
abstract class SkuEntity with _$SkuEntity {
  const factory SkuEntity({
    String? skuId,
    String? title,
    String? subTitle,
    ProductPriceEntity? priceInfo,
    bool? enable,
    EddInfoEntity? eddInfo,
    WarningEntity? info,
    @Default(false) bool isSelected,
    @Default(false) bool isAddedToBag,
    /// Raw key→value map from API (e.g. {"skuMrp": "₹1,149"}).
    /// Used to resolve `skuValue` type detail items via fieldPath.
    Map<String, dynamic>? skuAttributes,
  }) = _SkuEntity;
}
