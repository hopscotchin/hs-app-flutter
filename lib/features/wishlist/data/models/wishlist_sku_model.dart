import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
import '../../../pdp/data/models/edd_info_model.dart';
import '../../../pdp/data/models/warning_model.dart';
import '../../../pdp/domain/entities/sku_entity.dart';
import '../../../plp/data/models/product_price_model.dart';

part 'wishlist_sku_model.g.dart';

ProductPriceModel? _priceFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductPriceModel.fromJson(json) : null;

WarningModel? _warningFromJson(Object? json) =>
    json is Map<String, dynamic> ? WarningModel.fromJson(json) : null;

EddInfoModel? _eddInfoFromJson(Object? json) =>
    json is Map<String, dynamic> ? EddInfoModel.fromJson(json) : null;

/// One entry in `records[].skus[]`. Drives availability (sold-out), the
/// fallback move-to-bag SKU when the item carries no `wishlistedSku`, and the
/// size chips in the move-to-bag sheet.
@JsonSerializable(createToJson: false)
class WishlistSkuModel {
  const WishlistSkuModel({
    required this.skuId,
    this.availableQuantity = 0,
    this.enable = false,
    this.title,
    this.subTitle,
    this.priceInfo,
    this.info,
    this.eddInfo,
    this.trackingMeta,
  });

  @JsonKey(fromJson: parseToString)
  final String skuId;
  @JsonKey(fromJson: parseToInt)
  final int availableQuantity;
  @JsonKey(fromJson: parseToBool)
  final bool enable;

  /// Size label shown on the chip (e.g. "3-6Y").
  @JsonKey(fromJson: parseToStringOrNull)
  final String? title;

  /// Secondary chip line (e.g. "Waist : 32cm").
  @JsonKey(fromJson: parseToStringOrNull)
  final String? subTitle;

  @JsonKey(fromJson: _priceFromJson)
  final ProductPriceModel? priceInfo;

  /// Stock nudge under the chip (e.g. "Only 2 left").
  @JsonKey(fromJson: _warningFromJson)
  final WarningModel? info;

  /// Delivery estimate for this SKU (e.g. "Get it in 4-5 days"), shown in the
  /// green bar of the move-to-bag sheet.
  @JsonKey(fromJson: _eddInfoFromJson)
  final EddInfoModel? eddInfo;

  /// Opaque analytics blob for this SKU — forwarded verbatim onto the
  /// move-to-bag event. Never read a key out of it.
  final Map<String, dynamic>? trackingMeta;

  factory WishlistSkuModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistSkuModelFromJson(json);
}

extension WishlistSkuModelX on WishlistSkuModel {
  bool get isAvailable => enable && availableQuantity > 0;

  /// Mapped to the PDP [SkuEntity] so the shared size-selection sheet can be
  /// reused as-is. `enable` folds in stock: the sheet only needs to know
  /// whether the chip is selectable.
  SkuEntity toEntity() => SkuEntity(
    skuId: skuId,
    title: title,
    subTitle: subTitle,
    priceInfo: priceInfo?.toEntity(),
    enable: isAvailable,
    info: info?.toEntity(),
    eddInfo: eddInfo?.toEntity(),
    trackingMeta: trackingMeta,
  );
}
