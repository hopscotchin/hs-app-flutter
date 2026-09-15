import 'package:json_annotation/json_annotation.dart';

import '../../../plp/data/models/listing_product_model.dart';
import '../../domain/entities/tile_entity.dart';

part 'tile_model.g.dart';

/// A rail tile: the product plus the tile-level tracking block.
///
/// Both rails use this shape, so one chain builder serves recently-viewed and
/// recommendations. See `docs/analytics/pdp/contract/passthrough-spec.md`.
@JsonSerializable(createToJson: false)
class TileModel {
  const TileModel({this.product, this.trackingMeta});

  @JsonKey(defaultValue: null, fromJson: _productFromJson)
  final ListingProductModel? product;

  @JsonKey(defaultValue: null)
  final Map<String, dynamic>? trackingMeta;

  factory TileModel.fromJson(Map<String, dynamic> json) => _$TileModelFromJson(json);
}

ListingProductModel? _productFromJson(Object? json) =>
    json is Map<String, dynamic> ? ListingProductModel.fromJson(json) : null;

extension TileModelX on TileModel {
  /// Null when the tile carries no product — such a tile has nothing to render
  /// and nothing to attribute, so callers drop it.
  TileEntity? toEntity() {
    final p = product;
    if (p == null) return null;
    return TileEntity(product: p.toEntity(), trackingMeta: trackingMeta);
  }
}
