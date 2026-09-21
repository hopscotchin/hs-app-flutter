import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_parsers.dart';
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
    this.isSelected,
    this.skuAttributes,
    this.trackingMeta,
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

  /// Which size arrives pre-selected, when the backend has an opinion.
  ///
  /// Optional and nullable: PDP sends nothing here — the customer has chosen
  /// no size yet — so absent means "no opinion", not "not selected". The
  /// orders flows do have one: the exchange nudge already sends
  /// `chipItems[].isSelected`, and the exchange size screen echoes whichever
  /// size the nudge chose.
  ///
  /// Read through [parseToBool] because that nudge sends it as a JSON bool
  /// today and the orders wire has a history of sending bools as strings.
  @JsonKey(defaultValue: null, fromJson: _boolOrNull)
  final bool? isSelected;

  /// Flat key→value attributes (e.g. {"skuMrp": "₹1,149"}).
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? skuAttributes;

  /// Per-SKU analytics block from the backend. Untyped so a new backend key does
  /// not need a release.
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? trackingMeta;

  factory SkuModel.fromJson(Map<String, dynamic> json) =>
      _$SkuModelFromJson(json);
}

ProductPriceModel? _priceFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductPriceModel.fromJson(json) : null;

EddInfoModel? _eddInfoFromJson(Object? json) =>
    json is Map<String, dynamic> ? EddInfoModel.fromJson(json) : null;

WarningModel? _warningFromJson(Object? json) =>
    json is Map<String, dynamic> ? WarningModel.fromJson(json) : null;

/// Null when the key is absent, so "no opinion" stays distinguishable from
/// "not selected".
bool? _boolOrNull(Object? json) => json == null ? null : parseToBool(json);

extension SkuModelX on SkuModel {
  SkuEntity toEntity() => SkuEntity(
    skuId: skuId,
    title: title,
    subTitle: subTitle,
    priceInfo: priceInfo?.toEntity(),
    enable: enable,
    eddInfo: eddInfo?.toEntity(),
    info: info?.toEntity(),
    isSelected: isSelected ?? false,
    skuAttributes: skuAttributes,
    trackingMeta: trackingMeta,
  );
}
