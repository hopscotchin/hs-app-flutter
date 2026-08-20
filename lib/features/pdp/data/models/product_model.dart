import 'package:json_annotation/json_annotation.dart';

import '../../../../core/models/visual_cue_model.dart';
import '../../../../features/plp/data/models/product_price_model.dart';
import '../../../../features/plp/data/models/wishlist_info_model.dart';
import '../../../../features/plp/domain/entities/wishlist_info_entity.dart';
import '../../domain/entities/product_entity.dart';
import 'color_variants_model.dart';
import 'detail_model.dart';
import 'edd_info_model.dart';
import 'media_model.dart';
import 'service_guarantee_model.dart';
import 'sku_model.dart';

part 'product_model.g.dart';

@JsonSerializable(createToJson: false)
class ProductModel {
  const ProductModel({
    this.id,
    this.name,
    this.priceInfo,
    this.soldOut = false,
    this.wishlistInfo,
    this.media = const [],
    this.skus = const [],
    this.colorVariants = const [],
    this.details = const [],
    this.eddInfo,
    this.hasSizeChart,
    this.isServiceable,
    this.isEddDifferentForSKUs,
    this.isReturnInfoDifferentForSKUs,
    this.serviceGuarantee = const [],
    this.visualCue,
    this.isGift = false,
    this.trackingMeta,
  });

  @JsonKey(defaultValue: null)
  final int? id;
  @JsonKey(defaultValue: null)
  final String? name;
  @JsonKey(defaultValue: null, fromJson: _priceFromJson)
  final ProductPriceModel? priceInfo;
  @JsonKey(defaultValue: false)
  final bool soldOut;
  @JsonKey(defaultValue: null, fromJson: _wishlistFromJson)
  final WishlistInfoModel? wishlistInfo;
  @JsonKey(defaultValue: [])
  final List<MediaModel> media;
  @JsonKey(defaultValue: [])
  final List<SkuModel> skus;
  @JsonKey(defaultValue: [], fromJson: _colorVariantsFromJson)
  final List<ColorVariantModel> colorVariants;
  @JsonKey(defaultValue: [])
  final List<DetailModel> details;
  @JsonKey(defaultValue: null, fromJson: _eddInfoFromJson)
  final EddInfoModel? eddInfo;
  @JsonKey(defaultValue: null)
  final bool? hasSizeChart;
  @JsonKey(defaultValue: null)
  final bool? isServiceable;
  @JsonKey(defaultValue: null)
  final bool? isEddDifferentForSKUs;
  @JsonKey(defaultValue: null)
  final bool? isReturnInfoDifferentForSKUs;
  @JsonKey(defaultValue: [])
  final List<ServiceGuaranteeModel> serviceGuarantee;

  /// Raw visualCue map from JSON. Parsed lazily via [VisualCueModel].
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? visualCue;
  @JsonKey(defaultValue: false)
  final bool isGift;

  /// Raw `trackingMeta` map, forwarded to the entity unchanged.
  ///
  /// Not modelled: the analytics layer reads it through `PdpTrackingMeta`, and
  /// keeping it a map is what lets the backend add a tracking field without an
  /// app release.
  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? trackingMeta;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

/// Handles both array shape `[...]` and object shape `{"variants": [...], ...}`.
List<ColorVariantModel> _colorVariantsFromJson(Object? json) {
  if (json is List) {
    return json
        .whereType<Map<String, dynamic>>()
        .map(ColorVariantModel.fromJson)
        .toList();
  }
  if (json is Map<String, dynamic>) {
    final variants = json['variants'];
    if (variants is List) {
      return variants
          .whereType<Map<String, dynamic>>()
          .map(ColorVariantModel.fromJson)
          .toList();
    }
  }
  return [];
}

ProductPriceModel? _priceFromJson(Object? json) =>
    json is Map<String, dynamic> ? ProductPriceModel.fromJson(json) : null;

WishlistInfoModel? _wishlistFromJson(Object? json) =>
    json is Map<String, dynamic> ? WishlistInfoModel.fromJson(json) : null;

EddInfoModel? _eddInfoFromJson(Object? json) =>
    json is Map<String, dynamic> ? EddInfoModel.fromJson(json) : null;

extension ProductModelX on ProductModel {
  ProductEntity toEntity() {
    final cue = (visualCue == null || visualCue!.isEmpty)
        ? null
        : VisualCueModel.fromJson(visualCue!);

    return ProductEntity(
      id: id,
      name: name,
      priceInfo: priceInfo?.toEntity(),
      soldOut: soldOut,
      wishlistInfo: wishlistInfo == null
          ? null
          : WishlistInfoEntity(
              id: wishlistInfo!.id,
              isWishlisted: wishlistInfo!.isWishlisted,
              canWishlist: wishlistInfo!.canWishlist,
            ),
      media: media.map((m) => m.toEntity()).toList(),
      skus: skus.map((s) => s.toEntity()).toList(),
      colorVariants: colorVariants.map((c) => c.toEntity()).toList(),
      details: details.map((d) => d.toEntity()).toList(),
      eddInfo: eddInfo?.toEntity(),
      hasSizeChart: hasSizeChart,
      isServiceable: isServiceable,
      isEddDifferentForSKUs: isEddDifferentForSKUs,
      isReturnInfoDifferentForSKUs: isReturnInfoDifferentForSKUs,
      serviceGuarantee: serviceGuarantee.map((s) => s.toEntity()).toList(),
      visualCue: cue,
      isGift: isGift,
      trackingMeta: (trackingMeta == null || trackingMeta!.isEmpty)
          ? null
          : trackingMeta,
    );
  }
}
