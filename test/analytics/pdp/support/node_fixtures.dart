import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

/// The tile-level click block a rail tile carries under the passthrough
/// contract, derived from the tile's own product block.
///
/// Backend builds this; the tests build it the same way so a fixture written
/// against the product block still exercises the real chain. See
/// `docs/analytics/pdp/contract/passthrough-spec.md`.
Map<String, dynamic> tileClickMeta(ListingProductEntity product) {
  final meta = product.trackingMeta ?? const <String, dynamic>{};
  return <String, dynamic>{
    'clicked_product_pid': meta['product_id'] ?? product.id.toString(),
    'clicked_product_type': meta['product_type_name'],
    'clicked_product_category': meta['category_name'],
    'clicked_product_subcategory': meta['subcategory_name'],
  }..removeWhere((_, v) => v == null);
}
