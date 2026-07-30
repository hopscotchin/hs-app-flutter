import 'package:json_annotation/json_annotation.dart';

import '../../../../features/plp/data/models/product_price_model.dart';
import '../../domain/entities/sku_entity.dart';
import 'edd_info_model.dart';
import 'warning_model.dart';

part 'sku_model.g.dart';

@JsonSerializable(createToJson: false)
class SkuModel {
  const SkuModel({
    this.skuId,
    this.title,
    this.subTitle,
    this.priceInfo,
    this.enable,
    this.eddInfo,
    this.info,
    this.skuAttributes,
  });

  @JsonKey(defaultValue: null)
  final String? skuId;
  @JsonKey(defaultValue: null)
  final String? title;
  @JsonKey(defaultValue: null)
  final String? subTitle;
  @JsonKey(defaultValue: null, fromJson: _priceFromJson)
  final ProductPriceModel? priceInfo;
  @JsonKey(defaultValue: null)
  final bool? enable;
  @JsonKey(defaultValue: null, fromJson: _eddInfoFromJson)
  final EddInfoModel? eddInfo;
  @JsonKey(defaultValue: null, fromJson: _warningFromJson)
  final WarningModel? info;

  /// Flat key→value attributes (e.g. {"skuMrp": "₹1,149"}).
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? skuAttributes;

  factory SkuModel.fromJson(Map<String, dynamic> json) =>
      _$SkuModelFromJson(json);
}

ProductPriceModel? _priceFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductPriceModel.fromJson(json) : null;

EddInfoModel? _eddInfoFromJson(Object? json) =>
    json is Map<String, dynamic> ? EddInfoModel.fromJson(json) : null;

WarningModel? _warningFromJson(Object? json) =>
    json is Map<String, dynamic> ? WarningModel.fromJson(json) : null;

extension SkuModelX on SkuModel {
  SkuEntity toEntity() => SkuEntity(
    skuId: skuId,
    title: title,
    subTitle: subTitle,
    priceInfo: priceInfo?.toEntity(),
    enable: enable,
    eddInfo: eddInfo?.toEntity(),
    info: info?.toEntity(),
    skuAttributes: skuAttributes,
  );
}
